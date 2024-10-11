defmodule Writer do
  @moduledoc """
  Este módulo proporciona funciones para escribir datos de Employee en un archivo JSON.
  """

  alias Empresa.Employee
  alias Reader

  @doc """
  Actualiza un empleado existente en el archivo JSON.

  ## Parámetros
    - `id`: Integer, el ID del empleado a actualizar
    - `updates`: Keyword list con los campos a actualizar
    - `filename`: String, el nombre del archivo JSON (opcional, por defecto: "employees.json")

  ## Retornos
    - `:ok` si la operación es exitosa
    - `{:error, reason}` si ocurre un error

  ## Ejemplos
      iex> Writer.update_employee(1, [email: "nuevo_email@mail.com"])
      :ok
  """
  @spec update_employee(integer(), Keyword.t(), String.t()) :: :ok | {:error, String.t()}
  def update_employee(id, updates, filename \\ "employees.json") do
    employees = Reader.read_all_employees(filename)

    case Enum.find(employees, &(&1.id == id)) do
      nil ->
        {:error, "Empleado con ID #{id} no encontrado"}

      employee ->
        updated_employee = Map.merge(employee, Enum.into(updates, %{}))
        updated_employees = Enum.map(employees, fn
          %Employee{id: ^id} -> updated_employee
          emp -> emp
        end)

        write_employees(updated_employees, filename)
    end
  end

  @doc """
  Elimina un empleado existente del archivo JSON.

  ## Parámetros
    - `id`: Integer, el ID del empleado a eliminar
    - `filename`: String, el nombre del archivo JSON (opcional, por defecto: "employees.json")

  ## Retornos
    - `:ok` si la operación es exitosa
    - `{:error, reason}` si ocurre un error

  ## Ejemplos
      iex> Writer.delete_employee(2)
      :ok
  """
  @spec delete_employee(integer(), String.t()) :: :ok | {:error, String.t()}
  def delete_employee(id, filename \\ "employees.json") do
    employees = Reader.read_all_employees(filename)

    if Enum.any?(employees, &(&1.id == id)) do
      updated_employees = Enum.reject(employees, &(&1.id == id))
      write_employees(updated_employees, filename)
    else
      {:error, "Empleado con ID #{id} no encontrado"}
    end
  end

  @doc """
  Escribe la lista completa de empleados en el archivo JSON.

  ## Parámetros
    - `employees`: Lista de structs Employee
    - `filename`: String, el nombre del archivo JSON

  ## Retornos
    - `:ok` si la operación es exitosa
    - `{:error, term()}` si ocurre un error

  ## Ejemplos
      iex> Writer.write_employees([%Empresa.Employee{name: "Nuevo"}], "employees.json")
      :ok
  """
  @spec write_employees([Employee.t()], String.t()) :: :ok | {:error, term()}
  def write_employees(employees, filename) do
    json_data = Jason.encode!(employees, pretty: true)
    File.write(filename, json_data)
  end
end
