defmodule Sof do
  @moduledoc """
  Documentation for Sof.
  """

  @db "data.json"
  @root ".."
  @data_dir Path.join(@root, "data")
  @web_dir Path.join(@root, "web")

  def refresh_html(dungeon) do
    members =
      read_or_create_db(dungeon)
      |> Enum.to_list()
      |> Enum.filter(fn {_, %{"ep" => list}} -> Enum.max(list) > 0 end)
      |> Enum.sort(fn {name1, _}, {name2, _} -> name1 <= name2 end)
      |> Enum.with_index()

    template = @web_dir |> Path.join("template/index.html.eex") |> File.read!()
    content = EEx.eval_string(template, members: members)

    @web_dir |> Path.join("#{dungeon}.html") |> File.write!(content)
  end

  def update_db(dungeon, file) do
    db = read_or_create_db(dungeon)
    epgp_list = read_csv(dungeon, file)
    new_cat = Path.basename(file, ".csv")

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

    @data_dir |> Path.join(dungeon) |> Path.join(@db) |> File.write(new_db)
  end

  def read_or_create_db(dungeon) do
    case File.read(@data_dir |> Path.join(dungeon) |> Path.join(@db)) do
      {:error, :enoent} -> %{}
      {:ok, content} -> Jason.decode!(content)
    end
  end

  def read_csv(dungeon, file) do
    ["Name,EP,GP" | epgp_list] =
      @data_dir
      |> Path.join(dungeon)
      |> Path.join(file)
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
