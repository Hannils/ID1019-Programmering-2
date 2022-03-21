defmodule Cmplx do
  def new(r, i) do
    {:cmplx, r, i}
  end

  def add({:cmplx, r1, i1}=a, {:cmplx, r2, i2}=b) do
    {:cmplx, r1+r2, i1+i2}
  end

  def sqr({:cmplx, r, i}=a) do
    {:cmplx, r*r - i*i, r*i + i*r}
  end

  def abs({:cmplx, r, i}) do
    :math.sqrt(r*r + i*i)
  end
end
