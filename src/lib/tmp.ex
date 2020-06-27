defmodule Tmp do
  @result %{
    "/21839579524/am-ios-article-huge-low-exp" => [2.25, 225, 2.25, 2.25, 1, 225, 100, 2.25, 2.25],
    "153277661752118_712564172490128" => [20, 20, 1000, 2000, 10],
    "130847287" => [1.7, 170, 1.7, 1.34, 1.7, 1.7, 170, 170, 1.7],
    "153277661752118_700093583737187" => [1.5, 150, 1.5, 1.5, 1, 150, 100, 1.5, 1.5],
    "/21839579524/am-android-article-inside-medium" => [6, 5.5, 5.5],
    "153277661752118_900038590409351" => [nil, nil],
    "/21839579524/am-ios-article-related-low" => [
      1,
      100,
      1,
      1.8,
      180,
      1.8,
      1.8,
      1,
      180,
      1.8,
      100,
      1,
      1.8
    ],
    "153277661752118_713152272431318" => [1, 100, 1, 1, 100, 1, 1.5, 1, 150, 1.5, 100, 1, 1.5],
    "/21839579524/am-android-article-inside-high" => [15, 12, 12],
    "153277661752118_765371607209384" => [1.7, 170, 1.7, 1.3, 1.7, 1.7, 170, 170, 1.7],
    "/21839579524/am-ios-foryou-large-low-exp" => [
      1.6,
      1.6,
      1.6,
      160,
      1.6,
      160,
      1.6,
      1.6,
      1.6,
      150,
      1.6,
      1.6,
      1.5,
      1.5,
      160
    ]
  }

  def run do
    root = "/Users/peiling/Projects/Particle/manhattan_config/"
    dirs = ["config/", "config/dev/", "config/lt/", "config/vip/"]

    dirs
    |> Enum.map(fn dir -> "#{root}#{dir}" end)
    |> Enum.reduce([], fn dir, acc ->
      dir |> File.ls!() |> Enum.map(fn file -> "#{dir}#{file}" end) |> Kernel.++(acc)
    end)
    |> Enum.filter(fn path -> !File.dir?(path) end)
    |> Enum.map(fn path -> path |> File.read!() |> Jason.decode!() end)
    |> Enum.reduce([], fn %{"ads" => ads}, acc -> acc ++ ads end)
    |> Enum.map(fn
      %{"placement_id" => id, "price" => price} -> {id, price}
      %{"placement_id" => id, "floor" => floor} -> {id, floor}
      %{"placement_id" => id} -> {id, nil}
    end)
    |> Enum.group_by(fn {key, _} -> key end, fn {_, value} -> value end)
    |> IO.inspect(limit: :infinity)
  end
end
