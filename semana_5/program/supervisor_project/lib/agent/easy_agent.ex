defmodule ExampleAgent do
  def start do
    IO.puts("Startin the agent!")
    {:ok, agent} = Agent.start(fn -> 0 end)
    agent
  end

  def increment(agent) do
    IO.puts("Ingrementing using the agent!")
    Agent.update(agent, fn state -> state + 1 end)
  end

  def decrement(agent) do
    IO.puts("Decrementing using the agent!")
    Agent.update(agent, fn state -> state - 1 end)
  end

  def get_count(agent) do
    Agent.get(agent, fn state -> state end)
  end
end

# Usage
# agent = ExampleAgent.start()
# ExampleAgent.increment(agent)
# IO.puts("New count: #{ExampleAgent.get_count(agent)}")
# ExampleAgent.increment(agent)
# IO.puts("Current count: #{ExampleAgent.get_count(agent)}")
