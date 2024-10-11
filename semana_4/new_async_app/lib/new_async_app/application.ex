defmodule NewAsyncApp.Application do
  @moduledoc """
  Aplicación principal para ejecutar procesos asíncronos y manejar mensajes.
  """

  use Application

  def start(_type, _args) do
    children = [
      {NewAsyncApp.Supervisor, []}
    ]

    opts = [strategy: :one_for_one, name: NewAsyncApp.MainSupervisor]
    Supervisor.start_link(children, opts)
  end
end