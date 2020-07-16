defmodule Sof.Ep do
  def ep(point_per_week, decay, weeks) do
    Enum.reduce(1..weeks, [], fn _, acc ->
      last = List.last(acc) || 0
      new = trunc(last * (1 - decay) + point_per_week)
      acc ++ [new]
    end)
    |> Enum.zip(1..weeks)
    |> IO.inspect(limit: :infinity)

    :ok
  end

  def gp(base_gp, item_gp) do
    Enum.reduce(1..15, base_gp + item_gp, fn x, acc ->
      y = trunc(acc * 0.9)
      IO.inspect({y, x})
      y
    end)
  end
end
