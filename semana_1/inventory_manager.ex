defmodule InventoryManager do
  def run do
    loop([], [])
  end

  defp loop(inventory, cart) do
    display_menu()
    choice = get_user_input("Elige una opción: ")

    case choice do
      "1" ->
        {name, price, stock} = get_product_details()
        new_inventory = add_product(inventory, name, price, stock)
        IO.puts("Producto agregado exitosamente.")
        loop(new_inventory, cart)
      "2" ->
        list_products(inventory)
        loop(inventory, cart)
      "3" ->
        {id, quantity} = get_id_and_quantity("aumentar el stock")
        case increase_stock(inventory, id, quantity) do
          {:ok, new_inventory} ->
            IO.puts("Stock aumentado exitosamente.")
            loop(new_inventory, cart)
          {:error, message} ->
            IO.puts(message)
            loop(inventory, cart)
        end
      "4" ->
        {id, quantity} = get_id_and_quantity("vender")
        case sell_product(inventory, id, quantity) do
          {:ok, new_inventory, new_cart} ->
            IO.puts("Producto agregado al carrito.")
            loop(new_inventory, new_cart)
          {:error, message} ->
            IO.puts(message)
            loop(inventory, cart)
        end
      "5" ->
        view_cart(inventory, cart)
        loop(inventory, cart)
      "6" ->
        case checkout(inventory, cart) do
          {:ok, new_inventory, total} ->
            IO.puts("Compra realizada. Total: $#{:erlang.float_to_binary(total, [decimals: 2])}")
            loop(new_inventory, [])
          {:error, message} ->
            IO.puts(message)
            loop(inventory, cart)
        end
      "7" ->
        IO.puts("¡Gracias por usar el Gestor de Inventario!")
      _ ->
        IO.puts("Opción no válida. Por favor, intenta de nuevo.")
        loop(inventory, cart)
    end
  end

  defp display_menu do
    IO.puts("\n--- Gestor de Inventario ---")
    IO.puts("1. Agregar producto")
    IO.puts("2. Listar productos")
    IO.puts("3. Aumentar stock")
    IO.puts("4. Vender producto")
    IO.puts("5. Ver carrito")
    IO.puts("6. Realizar checkout")
    IO.puts("7. Salir")
  end

  defp get_user_input(prompt) do
    IO.gets(prompt) |> String.trim()
  end

  defp get_product_details do
    name = get_user_input("Nombre del producto: ")
    price = get_float_input("Precio del producto: ")
    stock = get_integer_input("Stock inicial: ")
    {name, price, stock}
  end

  defp get_id_and_quantity(action) do
    id = get_integer_input("ID del producto a #{action}: ")
    quantity = get_integer_input("Cantidad: ")
    {id, quantity}
  end

  defp get_float_input(prompt) do
    input = get_user_input(prompt)
    case Float.parse(input) do
      {number, _} -> number
      :error ->
        IO.puts("Entrada inválida. Por favor, ingresa un número válido.")
        get_float_input(prompt)
    end
  end

  defp get_integer_input(prompt) do
    input = get_user_input(prompt)
    case Integer.parse(input) do
      {number, _} -> number
      :error ->
        IO.puts("Entrada inválida. Por favor, ingresa un número entero.")
        get_integer_input(prompt)
    end
  end

  def add_product(inventory, name, price, stock) do
    new_id = length(inventory) + 1
    new_product = %{id: new_id, name: name, price: price, stock: stock}
    inventory ++ [new_product]
  end

  def list_products(inventory) do
    if Enum.empty?(inventory) do
      IO.puts("No hay productos en el inventario.")
    else
      Enum.each(inventory, fn product ->
        IO.puts("ID: #{product.id}, Nombre: #{product.name}, Precio: $#{:erlang.float_to_binary(product.price, [decimals: 2])}, Stock: #{product.stock}")
      end)
    end
  end

  def increase_stock(inventory, id, quantity) do
    case Enum.find_index(inventory, fn product -> product.id == id end) do
      nil ->
        {:error, "Producto no encontrado."}
      index ->
        updated_inventory = List.update_at(inventory, index, fn product ->
          %{product | stock: product.stock + quantity}
        end)
        {:ok, updated_inventory}
    end
  end

  def sell_product(inventory, id, quantity) do
    case Enum.find_index(inventory, fn product -> product.id == id end) do
      nil ->
        {:error, "Producto no encontrado."}
      index ->
        product = Enum.at(inventory, index)
        if product.stock >= quantity do
          updated_inventory = List.update_at(inventory, index, fn p ->
            %{p | stock: p.stock - quantity}
          end)
          updated_cart = [{id, quantity}]
          {:ok, updated_inventory, updated_cart}
        else
          {:error, "Stock insuficiente."}
        end
    end
  end

  def view_cart(inventory, cart) do
    if Enum.empty?(cart) do
      IO.puts("El carrito está vacío.")
    else
      total = Enum.reduce(cart, 0, fn {id, quantity}, acc ->
        product = Enum.find(inventory, fn p -> p.id == id end)
        IO.puts("#{product.name} - Cantidad: #{quantity} - Subtotal: $#{:erlang.float_to_binary(product.price * quantity, [decimals: 2])}")
        acc + product.price * quantity
      end)
      IO.puts("Total: $#{:erlang.float_to_binary(total, [decimals: 2])}")
    end
  end

  def checkout(inventory, cart) do
    if Enum.empty?(cart) do
      {:error, "El carrito está vacío."}
    else
      total = Enum.reduce(cart, 0, fn {id, quantity}, acc ->
        product = Enum.find(inventory, fn p -> p.id == id end)
        acc + product.price * quantity
      end)
      {:ok, inventory, total}
    end
  end
end
