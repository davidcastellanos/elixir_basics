defmodule ExampleTask do
  def run do
    task = Task.async(fn -> perform_heavy_computation() end)
    result = Task.await(task)
    IO.puts("Result: #{result}")
  end

  defp perform_heavy_computation do
    # Simulate a heavy computation
    :timer.sleep(2000)
    42
  end
end

# ExampleTask.run()
