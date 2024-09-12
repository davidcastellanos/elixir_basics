defmodule TaskManager do
  def run do
    loop([])
  end

  defp loop(tasks) do
    display_menu()
    choice = get_user_input("Elige una opción: ")

    case choice do
      "1" -> 
        description = get_user_input("Ingresa la descripción de la tarea: ")
        new_tasks = add_task(tasks, description)
        IO.puts("Tarea agregada exitosamente.")
        loop(new_tasks)
      "2" -> 
        list_tasks(tasks)
        loop(tasks)
      "3" -> 
        id = get_user_input("Ingresa el ID de la tarea a completar: ")
        {result, new_tasks} = complete_task(tasks, String.to_integer(id))
        case result do
          :ok -> IO.puts("Tarea marcada como completada.")
          :error -> IO.puts("No se encontró la tarea con ese ID.")
        end
        loop(new_tasks)
      "4" -> 
        IO.puts("¡Gracias por usar el Gestor de Tareas!")
      _ -> 
        IO.puts("Opción no válida. Por favor, intenta de nuevo.")
        loop(tasks)
    end
  end

  defp display_menu do
    IO.puts("\n--- Gestor de Tareas ---")
    IO.puts("1. Agregar tarea")
    IO.puts("2. Listar tareas")
    IO.puts("3. Completar tarea")
    IO.puts("4. Salir")
  end

  defp get_user_input(prompt) do
    IO.gets(prompt) |> String.trim()
  end

  def add_task(tasks, description) do
    new_id = length(tasks) + 1
    new_task = %{id: new_id, description: description, completed: false}
    tasks ++ [new_task]
  end

  def list_tasks(tasks) do
    if Enum.empty?(tasks) do
      IO.puts("No hay tareas.")
    else
      Enum.each(tasks, fn task ->
        status = if task.completed, do: "Completada", else: "Pendiente"
        IO.puts("#{task.id}. #{task.description} - #{status}")
      end)
    end
  end

  def complete_task(tasks, id) do
    case Enum.find_index(tasks, fn task -> task.id == id end) do
      nil -> 
        {:error, tasks}
      index ->
        updated_tasks = List.update_at(tasks, index, fn task ->
          %{task | completed: true}
        end)
        {:ok, updated_tasks}
    end
  end
end