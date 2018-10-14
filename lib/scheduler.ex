defmodule Scheduler do
  @moduledoc """
  """

  # Scheduler.main(:fifo, 3, 6000, 8000)

  @doc """
  """
  def main(type, num_procs) do
    Scheduler.Generator.generator(num_procs)
    |> scheduler(type)
  end

  @doc """
  """
  def scheduler(queue, type) do
    queue = Enum.sort(queue, &Scheduler.sort_by_arrival/2)

    case type do
      :fcfs -> fcfs(queue)
      :round_robin -> round_robin(queue, 2)
    end
  end

  @doc """
  """
  def fcfs(queue) do
    IO.puts("")
    Enum.each(queue, &Scheduler.resolve_fcfs/1)
    IO.puts("|>")
  end

  @doc """
  """
  def round_robin(queue, quantum) do
    IO.puts("")
    case length(queue) do
      0 -> IO.puts("|>")
      _ ->
        queue
        |> Enum.map(fn item -> step_run_proc(item, quantum) end)
        |> Enum.filter(&Scheduler.filter_by_finished/1)
        |> round_robin(quantum)
    end
  end

  @doc """
  """
  def step_run_proc(%Scheduler.Proc{burst_time: burst_time} = proc, quantum) do
    burst_left = max(0, burst_time - quantum)
    resolve_rr(proc, burst_time - burst_left)

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

    IO.puts("|#{pid}#{computation}#{count_time}>")
  end

  @doc """
  """
  def resolve_rr(%Scheduler.Proc{value: value, index: index, arrival_time: arrival_time, burst_time: burst_time}, running_time) do
    pid = "P#{index}"
    computation = "(value: #{value}, process: #{process(value)}, arrival: #{arrival_time}, burst: #{burst_time}, running: #{running_time})"
    count_time = String.duplicate("-", running_time)

    IO.puts("|#{pid}#{computation}#{count_time}>")
  end

  @doc """
  """
  def sort_by_arrival(%Scheduler.Proc{arrival_time: arrival_time1}, %Scheduler.Proc{arrival_time: arrival_time2}) do
    arrival_time1 <= arrival_time2
  end

  @doc """
  """
  def process(value) do
    value * 131
  end
end
