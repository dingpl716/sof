defmodule Mix.Tasks.Sof.Gen do
  @moduledoc """
  Regenerates the index.html.

  ## Example:

      mix sof.gen
  """
  use Mix.Task

  @shortdoc "Regenerates the index.html."

  def run([]) do
    Sof.gen_html()
  end
end
