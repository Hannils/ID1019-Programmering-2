defmodule Brot do
  alias Cmplx

  def mandelbrot(c, m) do
    z0 = Cmplx.new(0, 0)
    i = 0
    test(i, z0, c, m)
  end

  def test(i, z, c, m) do
    cond do
      m == i -> 0
      Cmplx.abs(z) > 2 -> i
      true -> test(i+1, Cmplx.add(Cmplx.sqr(z), c), c, m)
    end
  end
end
