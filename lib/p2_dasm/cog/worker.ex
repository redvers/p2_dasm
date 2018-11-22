defmodule P2Dasm.Cog.Worker do
  use GenServer

  def start_link(cogid, cogmem) do
    GenServer.start_link(__MODULE__, %{id: cogid, reg: cogmem, hubpid: self()}, name: cogid)
  end

  def init(state) do
    newstate =
    state
    |> Map.put(:lut, genmem())
    |> Map.put(:pc, 0)

    {:ok, newstate}
  end

  def genmem() do
    Range.new(1, 512*4)
    |> Enum.reduce([], fn(_,acc) -> [0 | acc] end)
    |> :binary.list_to_bin()
  end

  def fetch_instruction_word(cs=%{pc: pc}) when (pc < 0x200), do: read_cog_mem(cs)
  def fetch_instruction_word(cs=%{pc: pc}) when (pc > 0x3ff), do: read_hub_mem(cs)
  def fetch_instruction_word(cs),                             do: read_lut_mem(cs)

  def read_cog_mem(cs), do: :binary.part(cs.reg, {cs.pc*4, 4})
  def read_hub_mem(_),  do: false # Not Supported Yet, ** Crash Hard
  def read_lut_mem(cs), do: :binary.part(cs.lut, {(cs.pc - 0x200)*4, 4})

  def cmem(cs, addr) when (addr < 0x200), do: :binary.part(cs.reg, {(addr*4), 4})
  def cmem(cs, addr), do: :binary.part(cs.lut, {(addr*4), 4})

  def handle_info({:tick, cnt}, state) do
    newstate = Map.put(state, :cnt, cnt)
    {:noreply, fetch_execute(newstate)}
  end

  def fetch_execute(state) do
    <<instr_32bits::little-size(32)>> = fetch_instruction_word(state)

    # Get the textual version of ASM command and display with pc
    textinstr = P2Dasm.Cog.decode_instr(&P2Dasm.Cog.Disassembler.dis_instr/1, <<instr_32bits::size(32)>>)
    IO.puts("cnt: #{state.cnt}: pc: #{state.pc} -> #{textinstr}")

    function = fn(instr) -> P2Dasm.Cog.Emulator.exe_instr(instr, state) end
    P2Dasm.Cog.decode_instr(function, <<instr_32bits::size(32)>>)
  end

end
