defmodule NewAsyncApp.Supervisor do
  @moduledoc """
  Supervisor para manejar los procesos de la aplicación.
  """

  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      {NewAsyncApp.Worker, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end