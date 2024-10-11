defmodule MyWorker do
  use GenServer

  # Client API

  @doc """
  Starts the worker process.
  """
  def start_link(arg) do
    IO.puts("[MyWorker] starting the worker!")
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @doc """
  Simulates a crash in the worker.
  """
  def crash do
    GenServer.call(__MODULE__, :crash)
  end

  @doc """
  Performs some work.
  """
  def do_work do
    GenServer.cast(__MODULE__, :work)
  end

  # Server Callbacks

  @impl true
  def init(arg) do
    # Initialize the worker's state
    {:ok, %{count: 0, arg: arg}}
  end

  @impl true
  def handle_call(:crash, _from, state) do
    # Return parameters:
    # :stop - Tells the GenServer to stop
    # :normal - Reason for stopping (normal termination)
    # state - Current state, returned to the caller
    # The last 'state' is the final state of the server before stopping

    # Simulate a crash
    {:stop, :normal, state}
  end

  @impl true
  def handle_cast(:work, state) do
    # Simulate some work
    Process.sleep(1000)
    new_count = state.count + 1
    IO.puts("Worker completed task #{new_count}")
    {:noreply, %{state | count: new_count}}
  end
end

# children = [
#   %{
#     id: MyWorker,
#     start: {MyWorker, :start_link, [[]]}
#   },
#   %{
#     id: GCalc,
#     start: {GCalc, :start_link, []}
#   }
# ]

# supervisor_opts = [strategy: :one_for_one, name: MySupervisor]
# {:ok, sup_pid} = Supervisor.start_link(children, supervisor_opts)


# MyWorker.do_work()
# MyWorker.crash()
