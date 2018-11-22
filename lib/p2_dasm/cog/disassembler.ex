defmodule P2Dasm.Cog.Disassembler do
  def dis_instr(:NOP),   do: "NOP"
  def dis_instr(%{instr: :JMP, r: 1, a: a}), do: "JMP #$#{div(a,4)+1}"
  def dis_instr(%{instr: :HUBSET, l: 1, d: d}), do: "HUBSET  #$#{ExPrintf.sprintf("0x%03x", [d])}"
end

