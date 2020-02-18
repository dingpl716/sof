defmodule Sof.Roll do
  def avg(m) do
    for i <- 1..1_000_000 do
      one_round(m)
    end
    |> Enum.sum()
    |> Kernel./(1_000_000)
  end

  def one_round(m) do
    for i <- 1..m do
      :rand.uniform(100)
    end
    |> Enum.max()
  end
end
