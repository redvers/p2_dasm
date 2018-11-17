defmodule P2Dasm.Hub.Worker do
  use GenServer

  def start_link(eepromfilename) do
    GenServer.start(__MODULE__, %{eepromfilename: eepromfilename})
  end

  def init(state = %{eepromfilename: eepromfilename}) do
    hubdata = read_eeprom(eepromfilename)
              |> defineHubRAM()

    copytocog = Enum.take(hubdata, 1024) # 512longs
                |> :erlang.list_to_binary

    {:ok, cog0pid} = P2Dasm.Cog.Worker.start_link(:cog0, copytocog)
    cogs = %{"0": cog0pid}

    newstate =  state
             |> Map.put(:hubram, hubdata)
             |> Map.put(:cogs, cogs)

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

end

