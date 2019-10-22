defmodule Sof do
  @moduledoc """
  Documentation for Sof.
  """

  @db "data.json"

  def update_db(filename) do
    db = read_or_create_db()
    epgp_list = read_epgp(filename)
    cat = String.trim_trailing(filename, ".csv")

    new_db =
      Enum.reduce(epgp_list, db, fn {name, ep, gp}, acc ->
        case Map.get(acc, name) do
          nil ->
            Map.put(acc, name, %{
              "ep" => [ep],
              "gp" => [gp],
              "pr" => [Float.round(ep / gp, 3)],
              "categories" => [cat]
            })

          history ->
            new_history = update_history(history, ep, gp, cat)
            Map.put(acc, name, new_history)
        end
      end)
      |> Jason.encode!()

    File.write(Path.join("../data/", @db), new_db)
  end

  def read_or_create_db do
    case File.read(Path.join("../data/", @db)) do
      {:error, :enoent} -> %{}
      {:ok, content} -> Jason.decode!(content)
    end
  end

  def read_epgp(filename) do
    ["Name,EP,GP" | epgp_list] =
      "../data/"
      |> Path.join(filename)
      |> File.read!()
      |> String.split("\n")

    epgp_list
    |> Enum.map(fn item ->
      case String.split(item, ",") do
        [name, ep, gp] -> {name, String.to_integer(ep), String.to_integer(gp)}
        _ -> nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  def read_name_list() do
    "../resources/name_list"
    |> File.read!()
    |> String.split("\n")
    |> MapSet.new()
  end

  defp update_history(
         %{"ep" => eps, "gp" => gps, "pr" => prs, "categories" => cat},
         ep,
         gp,
         filename
       ) do
    %{
      "ep" => eps ++ [ep],
      "gp" => gps ++ [gp],
      "pr" => prs ++ [Float.round(ep / gp, 3)],
      "categories" => cat ++ [filename]
    }
  end
end
