# Nueva Aplicación Asíncrona en Elixir

Esta aplicación demuestra el uso de procesos asíncronos y la comunicación mediante mensajes en Elixir.

## Estructura

- `lib/new_async_app/worker.ex`: Módulo Worker que maneja la ejecución de tareas asíncronas.
- `lib/new_async_app/supervisor.ex`: Supervisor que supervisa los procesos de la aplicación.
- `lib/new_async_app/application.ex`: Punto de entrada de la aplicación.
- `lib/new_async_app.ex`: Módulo principal para interactuar con la aplicación.
- `test/new_async_app_test.exs`: Pruebas unitarias para la aplicación.

## Uso

1. Navega al directorio de la aplicación:

    ```bash
    cd semana_4/new_async_app
    ```

2. Compila la aplicación:

    ```bash
    mix compile
    ```

3. Inicia la consola interactiva de Elixir:

    ```bash
    iex -S mix
    ```

4. Ejecuta la aplicación:

    ```elixir
    NewAsyncApp.start()
    ```

## Descripción

- **Worker**: Utiliza `GenServer` para manejar tareas asíncronas. Las tareas se ejecutan en procesos separados y envían mensajes de vuelta al `GenServer` cuando se completan.
- **Comunicación mediante `receive`**: El módulo principal `NewAsyncApp` utiliza la macro `receive` para manejar mensajes que no están gestionados por el `GenServer`, permitiendo una comunicación más flexible.
- **Supervisor**: Asegura que los procesos críticos se reinicien en caso de fallo, siguiendo las mejores prácticas de supervisión en Elixir.

## Pruebas

Ejecuta las pruebas con:
mix test

