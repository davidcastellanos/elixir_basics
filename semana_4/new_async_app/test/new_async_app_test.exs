defmodule NewAsyncAppTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest NewAsyncApp

  test "ejecuta tareas asíncronas correctamente" do
    output = capture_io(fn ->
      task = Task.async(fn -> NewAsyncApp.start() end)
      # Esperar más tiempo para que las tareas asíncronas se completen
      :timer.sleep(5000)
      Task.await(task)
    end)
    assert output =~ "Recibido mensaje manual: Hola desde el proceso principal"
    assert output =~ "Recibido mensaje manual: Hola desde el proceso principal"
    assert output =~ "Worker: Tarea completada con resultado: \"Tarea 1 completada\""
    assert output =~ "Worker: Tarea completada con resultado: \"Tarea 2 completada\""
  end


end