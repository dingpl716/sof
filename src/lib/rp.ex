defmodule Sof.Rp do
  @brackets %{
    14 => 12000,
    13 => 11000,
    12 => 10000,
    11 => 9000,
    10 => 8000,
    9 => 7000,
    8 => 6000,
    7 => 5000,
    6 => 4000,
    5 => 3000,
    4 => 2000,
    3 => 1000,
    2 => 400,
    1 => 0
  }

  @ranks %{
    2 => 2000,
    3 => 5000,
    4 => 10000,
    5 => 15000,
    6 => 20000,
    7 => 25000,
    8 => 30000,
    9 => 35000,
    10 => 40000,
    11 => 45000,
    12 => 50000,
    13 => 55000,
    14 => 60000
  }

  def cal(starting_rp, gaining_rp) do
    Enum.reduce(1..20, [], fn i, acc ->
      case acc do
        [] ->
          [{i, starting_rp}]

        acc ->
          {_, old_rp} = List.last(acc)
          new_rp = trunc(old_rp * 0.8) + gaining_rp
          acc ++ [{i, new_rp}]
      end
    end)
  end

  def gain(from_rank, from_percent, to_rank, to_percent) do
    from = @ranks[from_rank] + 5000 * from_percent
    to = @ranks[to_rank] + 5000 * to_percent
    to - from * 0.8
  end
end
