defmodule P2Dasm.Hub.Worker do
  use GenServer

  def stepClock(pid) do
    send(pid, :tick)
  end

  def startClock(pid) do
    GenServer.cast(pid, :startClock)
  end

  def stopClock(pid) do
    GenServer.cast(pid, :stopClock)
  end



  def start_link([machinename, eepromfilename]) do
    GenServer.start(__MODULE__, %{id: machinename, eepromfilename: eepromfilename}, name: machinename)
  end

  def init(state = %{eepromfilename: eepromfilename}) do
    hubdata = read_eeprom(eepromfilename)
              |> defineHubRAM()

    copytocog = Enum.take(hubdata, 1024) # 512longs
                |> :erlang.list_to_binary

    {:ok, cog0pid} = P2Dasm.Cog.Worker.start_link(copytocog)
    cogs = %{"0": cog0pid}

    newstate =  state
             |> Map.put(:hubram, hubdata)
             |> Map.put(:cogs, cogs)
             |> Map.put(:cnt, 0)

    {:ok, newstate}
  end

  def read_eeprom(eepromfilename) do
    {:ok, filepid} = File.open(eepromfilename, [:binary, :read])

    eepromcontents =
    IO.binread(filepid, :all)
    |> :binary.bin_to_list

    eepromlength =
    Enum.count(eepromcontents)

    {eepromcontents, eepromlength}
  end

  def defineHubRAM({eepromcontents, eepromlength}) when eepromlength > 1024 do
    defineHubRAM({Enum.take(eepromcontents,1024),1024})
  end
  def defineHubRAM({eepromcontents, eepromlength}) do
    eepromcontents ++ List.duplicate(0, (512*1024)-eepromlength)
  end


  ## Runs inside the Hub.Worker process:
  def handle_info(:tick, state = %{cogs: cogs, cnt: cnt}) do
    Map.values(cogs) # All the Cog pids
    |> Enum.map(&(send(&1, {:tick, cnt}))) # Send tick to all

    newstate = Map.put(state, :cnt, cnt+1)
    {:noreply, newstate}
  end
  def handle_cast(:startClock, state) do
    # Set a re-occuring 1 second timer
    {:ok, timerref} = :timer.send_interval(1000, self(), :tick)

    newstate = Map.put(state, :clockTimerRef, timerref)
    {:noreply, newstate}
  end
  ## Runs inside the Hub.Worker process
  def handle_cast(:stopClock, state = %{clockTimerRef: timerref}) do
    :timer.cancel(timerref)

    newstate = Map.delete(state, :clockTimerRef)

    {:noreply, newstate}
  end

  def handle_call({:smartpinstart, [a,b,f,p,1,30,0], s}, _from, state) do
    {:ok, pid} = P2Dasm.Smartpin.AsyncSerialTx.start_link({:smartpinstart, state.id, [a,b,f,p,1,30,0], s})

    {:reply, {:ok, pid}, state}
  end




end

