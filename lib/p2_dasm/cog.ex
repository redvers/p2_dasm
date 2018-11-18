defmodule P2Dasm.Cog do
  def decode_instr(function, <<0b00000000000000000000000000000000::size(32)>>),do: function.(:NOP)

  ##                           EEEE            1101100           R          AAAAAAAAAAAAAAAAAAAA (Relative JMP)
  def decode_instr(function, <<con::size(4), 0b1101100::size(7), 1::size(1), a::signed-size(20)>>),do: function.(%{instr: :JMP, r: 1, a: a})
end

