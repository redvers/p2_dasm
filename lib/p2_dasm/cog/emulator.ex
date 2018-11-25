require Logger

defmodule P2Dasm.Cog.Emulator do
  def exe_instr(:NOP, cogstate),   do: Map.put(cogstate, :pc, cogstate.pc+1)
  def exe_instr(%{instr: :JMP, r: 1, a: a}, cogstate), do: Map.put(cogstate, :pc, (cogstate.pc+(div(a,4)+1)))
  def exe_instr(%{instr: :HUBSET,  l: 1, d: d}, cogstate), do: Map.put(cogstate, :pc, cogstate.pc+1)
  def exe_instr(%{instr: :AUGS, con: con, n: n}, cogstate), do: Map.put(cogstate, :augs, n) |> Map.put(:pc, cogstate.pc+1)

  def exe_instr(%{instr: :WRPIN, con: con, l: 0, i: 1, d: d, s: s}, cogstate) do
    ## D/# = %AAAA_BBBB_FFF_PPPPPPPPPPPPP_TT_MMMM_0
    <<endian::little-size(32)>> = P2Dasm.Cog.Worker.cmem(cogstate, d)
    <<a::size(4), b::size(4), f::size(3), p::size(13), t::size(2), m::size(5), 0::size(1)>> = <<endian::size(32)>>
    "AAAA_BBBB_FFF_PPPPPPPPPPPPP_TT_MMMMM_0" |> Logger.debug
    ExPrintf.sprintf("%04b %04b %03b %013b %02b %05b %01b", [a,b,f,p,t,m,0]) |> Logger.debug

    {:ok, smartpinpid} = GenServer.call(cogstate.hubpid, {:smartpinstart, [a,b,f,p,t,m,0], s})
    Logger.debug("Smartpin PID for pin #{s} -> #{inspect(smartpinpid)}")

    newstate = Map.put(cogstate, :pc, (cogstate.pc+1))
  end

  def exe_instr(%{instr: :WXPIN, con: con, l: 0, i: 1, d: d, s: s}, cogstate) do
    <<endian::little-size(32)>> = P2Dasm.Cog.Worker.cmem(cogstate, d)
    <<_ignoreBaudRate::size(27), bitsMinusOne::size(5)>> = <<endian::size(32)>>

    # X[31:16] establishes the number of clocks in a bit period, and in case X[31:26] is zero,
    # X[15:10] establishes the number of fractional clocks in a bit period.
    # The X bit period value can be simply computed as: (clocks * $1_0000) & $FFFFFC00.
    # For example, 7.5 clocks would be $00078000, and 33.33 clocks would be $00215400.

    #X[4:0] sets the number of bits, minus 1. For example, a value of 7 will set the word size to 8 bits.

    GenServer.call(cogstate.hubpid, {:smartpin_wxpin_asynctx, %{bitsize: bitsMinusOne+1}, s})

    newstate = Map.put(cogstate, :pc, (cogstate.pc+1))
  end









end

