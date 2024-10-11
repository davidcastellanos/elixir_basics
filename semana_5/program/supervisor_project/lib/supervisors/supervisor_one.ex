defmodule MySupervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      # Child specification for MyWorker
      %{
        id: MyWorker,        # Unique identifier for this child process
        start: {MyWorker, :start_link, [:ok]},  # Module, function, and args to start the process
        restart: :permanent, # Always restart the child if it terminates
        shutdown: 5000,      # Time (in ms) allowed for clean shutdown
        type: :worker        # Indicates this is a worker, not a supervisor
      },
      %{
        id: GCalc,
        start: {GCalc, :start_link, []}
      }
      # You can add more child processes here
    ]

    # Use :one_for_one strategy: if a child process terminates, only that process is restarted
    Supervisor.init(children, strategy: :one_for_one)
  end
end
