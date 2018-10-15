defmodule Scheduler do
  @moduledoc """
  """

  @doc """
  """
  def main({type, options}, num_procs) do
    Scheduler.Generator.generator(num_procs)
    |> scheduler(type, options)
  end

  @doc """
  """
  def scheduler(queue, type, options) do
    queue = Enum.sort(queue, &Scheduler.sort_by_arrival/2)

    case type do
      :fcfs -> fcfs(queue, options)
      :round_robin -> round_robin(queue, options)
    end
  end

  @doc """
  """
  def fcfs(queue, _options) do
    ([""] ++ Enum.map(queue, &Scheduler.resolve_fcfs/1))
    |> Enum.concat(["|>"])
    |> Enum.each(&IO.puts/1)
  end

  @doc """
  """
  def round_robin(queue, [quantum: quantum] = options) do
    IO.puts("")
    case length(queue) do
      0 -> IO.puts("|>")
      _ ->
        queue
        |> Enum.map(fn item -> step_run_proc(item, quantum) end)
        |> Enum.filter(&Scheduler.filter_by_finished/1)
        |> round_robin(options)
    end
  end

  @doc """
  """
  def step_run_proc(%Scheduler.Proc{burst_time: burst_time} = proc, quantum) do
    burst_left = max(0, burst_time - quantum)

    resolve_rr(proc, burst_time - burst_left)
    |> IO.puts

    %Scheduler.Proc{proc | burst_time: burst_left}
  end

  @doc """
  """
  def filter_by_finished(%Scheduler.Proc{burst_time: burst_time}) do
    burst_time > 0
  end

  @doc """
  """
  def resolve_fcfs(%Scheduler.Proc{value: value, index: index, arrival_time: arrival_time, burst_time: burst_time}) do
    pid = "P#{index}"
    computation = "(value: #{value}, process: #{process(value)}, arrival: #{arrival_time}, burst: #{burst_time})"
    count_time = String.duplicate("-", burst_time)

    "|#{pid}#{computation}#{count_time}>"
  end

  @doc """
  """
  def resolve_rr(%Scheduler.Proc{value: value, index: index, arrival_time: arrival_time, burst_time: burst_time}, running_time) do
    pid = "P#{index}"
    computation = "(value: #{value}, process: #{process(value)}, arrival: #{arrival_time}, burst: #{burst_time}, running: #{running_time})"
    count_time = String.duplicate("-", running_time)

    "|#{pid}#{computation}#{count_time}>"
  end

  @doc """
  """
  def sort_by_arrival(%Scheduler.Proc{arrival_time: arrival_time1}, %Scheduler.Proc{arrival_time: arrival_time2}) do
    arrival_time1 <= arrival_time2
  end

  @doc """
  """
  def process(value) do
    value * 100
  end
end
