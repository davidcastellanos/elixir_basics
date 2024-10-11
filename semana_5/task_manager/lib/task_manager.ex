defmodule TaskManager do
  alias TaskManager.Server

  def add_task(description) do
    case Server.add_task(description) do
      {:ok, id} -> IO.puts("Tarea agregada con ID: #{id}")
      _ -> IO.puts("Error al agregar la tarea")
    end
  end

  def complete_task(id) do
    case Server.complete_task(id) do
      :ok -> IO.puts("Tarea #{id} marcada como completada")
      {:error, :task_not_found} -> IO.puts("Tarea no encontrada")
    end
  end

  def list_tasks do
    tasks = Server.list_tasks()
    IO.puts("Lista de tareas:")
    Enum.each(tasks, fn task ->
      status = if task.completed, do: "Completada", else: "Pendiente"
      IO.puts("ID: #{task.id}, Descripción: #{task.description}, Estado: #{status}")
    end)
  end
end