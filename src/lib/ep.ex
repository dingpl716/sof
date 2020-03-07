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
end
