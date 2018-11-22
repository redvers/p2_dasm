defmodule P2Dasm.Smartpin.AsyncSerialTx do
  use GenServer

  def start_link({:smartpinstart, [a,b,f,p,1,30,0], s}) do
    GenServer.start_link(__MODULE__, %{pin: s})
  end

  def init(state) do
    {:ok, state}
  end
end
