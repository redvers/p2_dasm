defmodule P2Dasm.Sandbox do
  def decode_instr(function, <<0b00000000000000000000000000000000::size(32)>>),do: function.(:NOP)
  def decode_instr(function, <<0b00000000000000010000000000000000::size(32)>>),do: function.(:YIKES)

  def dis_instr(:NOP),   do: "NOP"
  def dis_instr(:YIKES), do: "YIKES" 

  def exe_instr(:NOP, cogstate),   do: Map.put(cogstate, :pc, cogstate.pc+1)
  def exe_instr(:YIKES, cogstate), do: cogstate

  

end

