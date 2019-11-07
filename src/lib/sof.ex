defmodule Sof do
  @moduledoc """
  Documentation for Sof.
  """

  @db "data.json"

  def gen_html() do
    name_list = read_name_list()

    members =
      read_or_create_db()
      |> Enum.to_list()
      |> Enum.filter(fn {name, _} -> MapSet.member?(name_list, name) end)
      |> Enum.sort(fn {name1, _}, {name2, _} -> name1 <= name2 end)
      |> Enum.with_index()

    template = File.read!("../template/index.html.eex")
    content = EEx.eval_string(template, members: members)
    File.write!("../index.html", content)
  end

  def update_db(full_path) do
    db = read_or_create_db()
    epgp_list = read_csv(full_path)
    new_cat = Path.basename(full_path, ".csv")

    new_db =
      Enum.reduce(epgp_list, db, fn {name, ep, gp}, acc ->
        case Map.get(acc, name) do
          nil ->
            Map.put(acc, name, %{
              "ep" => [ep],
              "gp" => [gp],
              "pr" => [Float.round(ep / gp, 3)],
              "categories" => [new_cat]
            })

          history ->
            new_history = update_history(history, ep, gp, new_cat)
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

  def read_csv(full_path) do
    ["Name,EP,GP" | epgp_list] =
      full_path
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
