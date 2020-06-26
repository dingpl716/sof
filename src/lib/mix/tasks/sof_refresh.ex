defmodule Mix.Tasks.Sof.Refresh do
  @moduledoc """
  Regenerates the index.html.

  ## Example:

      mix sof.refresh mc
  """
  use Mix.Task

  @shortdoc "Regenerates the index.html."

  def run([dungeon]) do
    Sof.refresh_html(dungeon)
  end
end
