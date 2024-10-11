defmodule GCalc do
  use GenServer

  def start_link do
    IO.puts("[GCalc] starting the worker!")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def suma(a, b) do
    GenServer.call(__MODULE__, {:suma, a, b})
  end


  def resta(a, b) do
    GenServer.call(__MODULE__, {:resta, a, b})
  end

  def multiplicacion(a, b) do
    GenServer.call(__MODULE__, {:multiplicacion, a, b})
  end

  def division(a, b) do
    GenServer.call(__MODULE__, {:division, a, b})
  end

 ## Server Callbacks

 @impl true
 def init(:ok) do
   {:ok, %{}}
 end

 @impl true
 def handle_call({:suma, a, b}, _from, state) do
   {:reply, a + b, state}
 end

 @impl true
 def handle_call({:resta, a, b}, _from, state) do
   {:reply, a - b, state}
 end

 @impl true
 def handle_call({:multiplicacion, a, b}, _from, state) do
   {:reply, a * b, state}
 end

 @impl true
 def handle_call({:division, _a, 0}, _from, state) do
    raise ArgumentError, message: "No se puede dividir por cero"
   {:reply, {:error, "No se puede dividir por cero"}, state}
 end

 @impl true
 def handle_call({:division, a, b}, _from, state) do
   {:reply, a / b, state}
 end

 @impl true
 def handle_info(msg, state) do
   IO.puts("Received message: #{inspect(msg)}")
   {:noreply, state}
 end


 @impl true
 def handle_cast({:suma, a, b, caller}, state) do
    Process.send_after(caller, {:result, a + b}, 2000)
    {:noreply, state}
  end


  @impl true
  def handle_cast({:resta, a, b, caller}, state) do
    Process.send_after(caller, {:result, a - b}, 2000)
    {:noreply, state}
  end


  @impl true
  def handle_cast({:multiplicacion, a, b, caller}, state) do
    Process.send_after(caller, {:result, a * b}, 2000)
    {:noreply, state}
  end


  @impl true
  def handle_cast({:division, _a, 0, caller}, state) do
    Process.send_after(caller, {:error, "No se puede dividir por cero"}, 2000)
    {:noreply, state}
  end


  @impl true
  def handle_cast({:division, a, b, caller}, state) do
    Process.send_after(caller, {:result, a / b}, 2000)
    {:noreply, state}
  end
end


# children = [
#   %{
#     id: MyWorker,
#     start: {MyWorker, :start_link, [[]]}
#   },
#   %{
#     id: GCalc,
#     start: {GCalc, :start_link, []}
#   }
# ]

# supervisor_opts = [strategy: :one_for_one, name: MySupervisor]
# {:ok, sup_pid} = Supervisor.start_link(children, supervisor_opts)

# GCalc.suma(5, 3)
# GCalc.resta(10, 4)
# GCalc.multiplicacion(6, 7)
# GCalc.division(20, 4)
