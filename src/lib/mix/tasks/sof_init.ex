defmodule Mix.Tasks.Sof.Init do
  @moduledoc """
  Init database by specifying the file to read.

  ## Example:

      mix sof.init mc 2019-11-05.csv
  """
  use Mix.Task

  @shortdoc "Copy, update data and regenerate the index.html."

  def run([dungeon, file]) do
    full_path = "../data" |> Path.join(dungeon) |> Path.join(file) |> Path.expand()
    Sof.update_db(full_path, dungeon)
    Sof.refresh_html(dungeon)
  end
end
