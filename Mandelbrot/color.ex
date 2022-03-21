defmodule Color do
  def convert(depth, max) do
    if depth == 0 do
      {:rgb, 0, 0, 0}
    else

      a = (4*(depth/max))
      x = trunc(a)
      y = trunc(100 * (a - x))
      case x do
        0 -> {:rgb, 0, 5, y + 40}
        1 -> {:rgb, 51, 153, 100 + y}
        2 -> {:rgb, 153, 100, 120 + y}
        3 -> {:rgb, 20, 100 - y, 100}
        4 -> {:rgb, 30 - y, 20, 20}
      end
    end
  end
end
