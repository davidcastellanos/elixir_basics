   defmodule NewAsyncApp do
     @moduledoc """
     Módulo principal para interactuar con la aplicación asíncrona.
     """

     @doc """
     Inicia la aplicación y ejecuta tareas asíncronas.

     ## Ejemplo

         iex> NewAsyncApp.start()
     """
def start do
  task1 = Task.async(fn ->
    NewAsyncApp.Worker.execute_task(fn ->
      :timer.sleep(2000)
      "Tarea 1 completada"
    end)
  end)

  task2 = Task.async(fn ->
    NewAsyncApp.Worker.execute_task(fn ->
      :timer.sleep(3000)
      "Tarea 2 completada"
    end)
  end)

  send(self(), {:manual_message, "Hola desde el proceso principal"})
  process_manual_message()

  Task.await(task1, 6000)
  Task.await(task2, 6000)

  # Esperar un poco más para asegurarnos de que los mensajes se procesen
  :timer.sleep(1000)

  if Application.get_env(:new_async_app, :run_loop, true) do
    spawn(fn -> loop() end)
  end
end

defp process_manual_message do
  receive do
    {:manual_message, msg} ->
      IO.puts("Recibido mensaje manual: #{msg}")
  after
    0 -> :ok
  end
end


     defp loop do
       receive do
         {:manual_message, msg} ->
           IO.puts("Recibido mensaje manual: #{msg}")
           loop()

         _ ->
           IO.puts("Mensaje desconocido recibido")
           loop()
       end
     end
   end