defmodule Mix.Tasks.Sof.Update do
  @moduledoc """
  Copy, update data and regenerate the index.html.

  ## Example:

      mix sof.update ~/Downloads/epgp.csv ../data/2019-11-05.csv
  """
  use Mix.Task

  @shortdoc "Copy, update data and regenerate the index.html."

  def run([source, target]) do
    full_path = Path.expand(target)
    File.cp!(source, full_path)
    Sof.update_db(full_path)
    Sof.gen_html()
  end
end
