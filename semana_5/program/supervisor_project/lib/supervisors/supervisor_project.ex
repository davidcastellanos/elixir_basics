defmodule MyApp do
  use Application

  # Using `use Application` implies that this module is the entry point of an OTP application.
  # It requires implementing the `start/2` callback, which is called when the application starts.
  # This allows the module to set up the application's supervision tree and any other
  # initialization needed for the application to run.

  def start(_type, _args) do
    # Start the top-level supervisor
    MySupervisor.start_link(:ok)
  end

  def simulate_scenarios do
    # Scenario 1: Normal operation
    MyWorker.do_work()
    MyWorker.do_work()

    # Scenario 2: Crash and restart
    MyWorker.crash()
    Process.sleep(1000)  # Give time for the supervisor to restart the worker
    MyWorker.do_work()

    # Scenario 3: Multiple operations after restart
    MyWorker.do_work()
    MyWorker.do_work()
  end
end
