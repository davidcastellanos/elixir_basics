defmodule TaskManager.Server do
  use GenServer

  # Cliente API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def add_task(task) do
    GenServer.call(__MODULE__, {:add_task, task})
  end

  def complete_task(task_id) do
    GenServer.call(__MODULE__, {:complete_task, task_id})
  end

  def list_tasks do
    GenServer.call(__MODULE__, :list_tasks)
  end

  # Callbacks del servidor

  @impl true
  def init(_args) do
    {:ok, %{tasks: %{}, next_id: 1}}
  end

  @impl true
  def handle_call({:add_task, task}, _from, %{tasks: tasks, next_id: id} = state) do
    new_task = %{id: id, description: task, completed: false}
    new_tasks = Map.put(tasks, id, new_task)
    new_state = %{state | tasks: new_tasks, next_id: id + 1}
    {:reply, {:ok, id}, new_state}
  end

  @impl true
  def handle_call({:complete_task, task_id}, _from, %{tasks: tasks} = state) do
    case Map.get(tasks, task_id) do
      nil ->
        {:reply, {:error, :task_not_found}, state}
      task ->
        updated_task = %{task | completed: true}
        new_tasks = Map.put(tasks, task_id, updated_task)
        new_state = %{state | tasks: new_tasks}
        {:reply, :ok, new_state}
    end
  end

  @impl true
  def handle_call(:list_tasks, _from, %{tasks: tasks} = state) do
    task_list = Map.values(tasks)
    {:reply, task_list, state}
  end
end