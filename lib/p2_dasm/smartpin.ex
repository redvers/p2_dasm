defmodule P2Dasm.Smartpin do
  ## Utility methods common for smartpins

  # Registration(!)
  def registered_name(machinename, s) do
    atom = String.to_atom("p#{s}") |> IO.inspect
    Application.get_env(:p2_dasm, :p2one).pins
    |> Map.get(atom, nil)
  end

  def connectedTo(machinename, pinname) do
    Application.get_env(:p2_dasm, :p2one).connections
    |> Map.get(pinname, [])
  end




end
