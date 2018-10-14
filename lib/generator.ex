defmodule Scheduler.Generator do
  @moduledoc """
  """

  @doc """
  """
  def generator(num_procs) do
    1..num_procs
    |> Enum.map(fn item -> gen_proc(item) end)
  end

  @doc """
  """
  def gen_proc(index) do
    value = rand_between(0, 5)
    arrival_time = rand_between(0, 5)
    burst_time = rand_between(0, 5) + arrival_time

    %Scheduler.Proc{value: value, index: index, arrival_time: arrival_time, burst_time: burst_time}
  end

  @doc """
  """
  def rand_between(start, final) do
    :rand.uniform(final - start) + start
  end
end
