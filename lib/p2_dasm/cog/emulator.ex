defmodule P2Dasm.Cog.Emulator do
  def exe_instr(:NOP, cogstate),   do: Map.put(cogstate, :pc, cogstate.pc+1)
  def exe_instr(%{instr: :JMP, r: 1, a: a}, cogstate), do: Map.put(cogstate, :pc, (cogstate.pc+(div(a,4)+1)))
end

