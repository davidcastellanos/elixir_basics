defmodule ParallelComputation do
  def run do
    # Define a list of tasks to perform in parallel
    tasks = [
      Task.async(fn -> perform_heavy_computation(1) end),
      Task.async(fn -> perform_heavy_computation(2) end),
      Task.async(fn -> perform_heavy_computation(3) end)
    ]

    # Await the results of all tasks
    results = Enum.map(tasks, fn task -> Task.await(task) end)

    # Aggregate the results
    total = Enum.sum(results)
    IO.puts("Total result: #{total}")
  end

  defp perform_heavy_computation(id) do
    # Simulate a heavy computation
    :timer.sleep(2000)
    IO.puts("Task #{id} completed")
    id * 10
  end
end

# ParallelComputation.run()
