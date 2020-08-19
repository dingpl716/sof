defmodule Mix.Tasks.Sof.Update do
  @moduledoc """
  Copy, update data and regenerate the index.html.

  ## Example:

      mix sof.update ~/Downloads/epgp.csv ../data/2019-11-05.csv
  """
  use Mix.Task

  @shortdoc "Copy, update data and regenerate the index.html."

  def run([mc_file, bwl_file, taq_file]) do
    date = get_tuesday()
    run(["--date", date, mc_file, bwl_file, taq_file])
  end

  def run(["--date", date, "--mc", mc_file]) do
    do_run(date, "mc", mc_file)
  end

  def run(["--date", date, "--bwl", bwl_file]) do
    do_run(date, "bwl", bwl_file)
  end

  def run(["--date", date, "--taq", taq_file]) do
    do_run(date, "taq", taq_file)
  end

  def run(["--date", date, mc_file, bwl_file, taq_file]) do
    File.cp!(mc_file, "../data/mc/#{date}.csv")
    File.cp!(bwl_file, "../data/bwl/#{date}.csv")
    File.cp!(taq_file, "../data/taq/#{date}.csv")
    Sof.update_db("mc", "#{date}.csv")
    Sof.update_db("bwl", "#{date}.csv")
    Sof.update_db("taq", "#{date}.csv")
    Sof.refresh_html("mc")
    Sof.refresh_html("bwl")
    Sof.refresh_html("taq")
  end

  defp do_run(date, dungeon, data_file) do
    File.cp!(data_file, "../data/#{dungeon}/#{date}.csv")
    Sof.update_db("#{dungeon}", "#{date}.csv")
    Sof.refresh_html("#{dungeon}")
  end

  def get_tuesday() do
    today = System.system_time(:second) |> DateTime.from_unix!(:second) |> DateTime.to_date()

    get_tuesday(Date.day_of_week(today), today)
  end

  def get_tuesday(2, date) do
    Date.to_iso8601(date)
  end

  def get_tuesday(_, date) do
    yesterday = Date.add(date, -1)
    get_tuesday(Date.day_of_week(yesterday), yesterday)
  end
end
