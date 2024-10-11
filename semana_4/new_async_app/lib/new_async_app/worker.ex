defmodule NewAsyncApp.Worker do
  @moduledoc """
  Módulo Worker que ejecuta tareas asíncronas y maneja mensajes.
  """

  use GenServer

  # API

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def execute_task(task_fun) do
    IO.puts("Worker: Recibiendo solicitud para ejecutar una tarea.")
    GenServer.cast(__MODULE__, {:execute_task, task_fun})
  end

  def stop do
    GenServer.cast(__MODULE__, :stop)
  end

  # Callbacks

  def init(state) do
    IO.puts("Worker: Inicializado.")
    {:ok, state}
  end

def handle_cast({:execute_task, task_fun}, state) do
  IO.puts("Worker: Ejecutando tarea asincrónica.")
  worker_pid = self()
  Task.async(fn ->
    IO.inspect(worker_pid, label: "Worker PID en Task")
    result = task_fun.()
    IO.puts("Worker: Tarea completada, enviando mensaje.")
    send(worker_pid, {:task_completed, result})
  end)
  {:noreply, state}
end

  def handle_cast(:stop, state) do
    IO.puts("Worker: Recibiendo solicitud de detención.")
    {:stop, :normal, state}
  end

  def handle_info({:task_completed, result}, state) do
    IO.puts("Worker: Tarea completada con resultado: #{inspect(result)}")
    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.puts("Worker: Mensaje no manejado: #{inspect(msg)}")
    {:noreply, state}
  end

end