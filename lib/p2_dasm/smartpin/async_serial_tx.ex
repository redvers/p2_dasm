require Logger
defmodule P2Dasm.Smartpin.AsyncSerialTx do
  use GenServer

  def start_link({:smartpinstart, machinename, [a,b,f,p,1,30,0], s}) do
    pinname = P2Dasm.Smartpin.registered_name(machinename, s)
    initialState = %{machinename: machinename, pin: s,
                     connectedTo: P2Dasm.Smartpin.connectedTo(machinename, pinname)}

    case pinname do
      nil -> GenServer.start_link(__MODULE__, initialState)
      named -> GenServer.start_link(__MODULE__, initialState, name: named)
    end
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:smartpin_wxpin_asynctx, %{bitsize: bitsize}, s}, _from, state) do
    Logger.debug("Setting TX bitlength to #{bitsize}")
    newstate = Map.put(state, :bitwidth, bitsize)
    {:reply, :ok, newstate}
  end




end
