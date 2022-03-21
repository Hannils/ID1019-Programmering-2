defmodule Test do
  def demo() do
    small(-2.0, 1.0, 0.07)
  end

  def small(x0, y0, xn) do
    width = 1920
    height = 1080
    depth = 256
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("small.ppm", image)
  end
end
