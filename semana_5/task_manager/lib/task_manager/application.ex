defmodule TaskManager.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TaskManager.Server
    ]

    opts = [strategy: :one_for_one, name: TaskManager.Supervisor]
    Supervisor.start_link(children, opts)
  end
end