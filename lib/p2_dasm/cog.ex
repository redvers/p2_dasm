require Logger
defmodule P2Dasm.Cog do
  def decode_instr(function, <<0b00000000000000000000000000000000::size(32)>>),do: function.(:NOP)

  ##                           EEEE            1101100           R          AAAAAAAAAAAAAAAAAAAA (Relative JMP)
  def decode_instr(function, <<con::size(4), 0b1101100::size(7), 1::size(1), a::signed-size(20)>>),do: function.(%{instr: :JMP, r: 1, a: a})
  
  ##                           EEEE            1101011             00           L           DDDDDDDDD     000000000 HUBSET {#}D
  def decode_instr(function, <<con::size(4), 0b1101011::size(7), 0b00::size(2), l::size(1), d::size(9), 0b000000000::size(9)>>), do: function.(%{instr: :HUBSET, con: con, l: l, d: d})

  ##                           EEEE            1100000             0           L           I           DDDDDDDDD   SSSSSSSSS    WRPIN {#}D,{#}S
  def decode_instr(function, <<con::size(4), 0b1100000::size(7), 0b0::size(1), l::size(1), i::size(1), d::size(9), s::size(9)>>), do: function.(%{instr: :WRPIN, con: con, l: l, i: i, d: d, s: s})

  ##                           EEEE            1100000             1           L           I           DDDDDDDDD   SSSSSSSSS    WXPIN {#}D, #{S}
  def decode_instr(function, <<con::size(4), 0b1100000::size(7), 0b1::size(1), l::size(1), i::size(1), d::size(9), s::size(9)>>), do: function.(%{instr: :WXPIN, con: con, l: l, i: i, d: d, s: s})

  ##                           EEEE            11110 NN NNN NNNNNNNNN NNNNNNNNN
  def decode_instr(function, <<con::size(4), 0b11110::size(5), n::size(23)>>), do: function.(%{instr: :AUGS, con: con, n: n})



  ### Unimplemented Instruction:
  def decode_instr(function, <<con::size(4), instr::size(7), czi::size(3), source::size(9), destination::size(9)>>) do
    ExPrintf.sprintf("IllegalInstr: %04b %07b %03b %09b %09b", [con, instr, czi, source, destination])
    |> Logger.error

    {:error, :illegal_instruction}
  end
end

