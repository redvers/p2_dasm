defmodule P2Dasm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised

    children =
    listMachines()
    |> Enum.map(&machineToChild/1)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: P2Dasm.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def listMachines(), do: Application.get_env(:p2_dasm, :configured_machines)

  def machineToChild(machinename) do
    machinedata = Application.get_env(:p2_dasm, :p2one)
    %{id: machinename, start: {P2Dasm.Hub.Worker, :start_link, [[machinename, machinedata.firmware]]},
      restart: :temporary,
      shutdown: 1000,
      type: :worker}
  end

end

