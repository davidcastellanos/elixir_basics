defmodule Calc do

  def suma(calculadoraPID, a,b) do
    IO.puts("Recibimos los parametros para sumar: #{a} y #{b}")
    send(calculadoraPID, {self(), :suma, a, b})
  end

  def resta(calculadoraPID, a,b) do
    IO.puts("Recibimos los parametros para restar: #{a} y #{b}")
    send(calculadoraPID, {self(), :sub, a, b})
  end

  def multiplicacion(calculadoraPID, a,b) do
    IO.puts("Recibimos los parametros para multiplicar: #{a} y #{b}")
    send(calculadoraPID, {self(), :mult, a, b})
  end

  def division(calculadoraPID, a,b) do
    IO.puts("Recibimos los parametros para dividir: #{a} y #{b}")
    send(calculadoraPID, {self(), :div, a, b})
  end

  def calculadora do
    receive do
      {pid, :suma, a, b} -> send(pid, a + b)
      {pid, :sub, a, b} -> send(pid,  a - b)
      {pid, :mult, a, b} -> send(pid,  a * b)
      {_pid, :div, _a, 0} -> exit(:division_by_zero)
      {pid, :div, a, b} -> send(pid,  a / b)
    end
    calculadora()
  end
end
