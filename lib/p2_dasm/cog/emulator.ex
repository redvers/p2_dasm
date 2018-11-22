require Logger

defmodule P2Dasm.Cog.Emulator do
  def exe_instr(:NOP, cogstate),   do: Map.put(cogstate, :pc, cogstate.pc+1)
  def exe_instr(%{instr: :JMP, r: 1, a: a}, cogstate), do: Map.put(cogstate, :pc, (cogstate.pc+(div(a,4)+1)))
  def exe_instr(%{instr: :HUBSET,  l: 1, d: d}, cogstate), do: Map.put(cogstate, :pc, cogstate.pc+1)

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










end

