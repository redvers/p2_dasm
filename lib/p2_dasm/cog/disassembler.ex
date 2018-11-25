defmodule P2Dasm.Cog.Disassembler do
  def dis_instr(:NOP),   do: "NOP"
  def dis_instr(%{instr: :JMP, r: 1, a: a}), do: "JMP #$#{div(a,4)+1}"
  def dis_instr(%{instr: :HUBSET, l: 1, d: d}), do: "HUBSET  #$#{ExPrintf.sprintf("0x%03x", [d])}"

  ## Immediate mode on pin, indirect mode on the mode
  def dis_instr(%{instr: :WRPIN, con: con, l: 0, i: 1, d: d, s: s}), do: "WRPIN 0x#{ExPrintf.sprintf("%03x", [d])}, #$#{ExPrintf.sprintf("%03x", [s])}" 
  def dis_instr(%{instr: :WXPIN, con: con, l: 0, i: 1, d: d, s: s}), do: "WRPIN 0x#{ExPrintf.sprintf("%03x", [d])}, #$#{ExPrintf.sprintf("%03x", [s])}" 
  def dis_instr(%{instr: :AUGS, con: con, n: n}), do: "AUGS #0x#{ExPrintf.sprintf("%x", [n])}" 
end

