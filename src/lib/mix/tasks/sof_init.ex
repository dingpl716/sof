defmodule Mix.Tasks.Sof.Init do
  @moduledoc """
  Init database by specifying the file to read.

  ## Example:

      mix sof.init mc 2019-11-05.csv
  """
  use Mix.Task

  @shortdoc "Copy, update data and regenerate the index.html."

  def run([dungeon, file]) do
    Sof.update_db(dungeon, file)
    Sof.refresh_html(dungeon)
  end
end
