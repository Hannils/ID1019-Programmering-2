defmodule Morse do

  def morse() do
    {:node, :na,
      {:node, 116,
      {:node, 109,
        {:node, 111, {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
        {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
        {:node, 103, {:node, 113, nil, nil},
        {:node, 122, {:node, :na, {:node, 44, nil, nil}, nil}, {:node, 55, nil, nil}}}},
      {:node, 110, {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
        {:node, 100, {:node, 120, nil, nil}, {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
      {:node, 97,
        {:node, 119, {:node, 106, {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}}, nil},
        {:node, 112, {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}}, nil}},
        {:node, 114, {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
        {:node, 108, nil, nil}}},
      {:node, 105,
        {:node, 117, {:node, 32, {:node, 50, nil, nil}, {:node, :na, nil, {:node, 63, nil, nil}}},
        {:node, 102, nil, nil}},
        {:node, 115, {:node, 118, {:node, 51, nil, nil}, nil},
        {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  def test() do
    '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... '
  end

  def test2() do
    '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- '
  end


  def encoding_table() do
    codes(morse(), Tuple.duplicate(:nil, 128), '')
  end

  def codes({:node, :na, long, short}, tuple, code) do
    tuple = codes(long, tuple, '-' ++ code)
    codes(short, tuple, '.' ++ code)
  end

  def codes(nil, tuple, _) do tuple end
  def codes({:node, char, long, short}, tuple, code) do
    tuple = put_elem(tuple, char, code)
    tuple = codes(long, tuple, '-' ++ code)
    codes(short, tuple, '.' ++ code)
  end

  def encode(text) do
    table = encoding_table()
    List.foldr(text, [], fn (x, acc) -> Enum.reverse(elem(table, x)) ++ [32 | acc] end)
  end


  def decode(code) do
    tree = morse()
    {res, _ } = List.foldl(code, {[], []}, fn (x, {res, buffer}) ->
      case x do
        32 -> {[decode_buffer(buffer, tree) | res], []}
        _ -> {res, buffer ++ [x]}
      end
    end)
    Enum.reverse(res)
  end


    def decode_buffer([], {:node, char, _, _}) do
      char
    end
    def decode_buffer([h|t]=buffer, {:node, char, long, short}) do
      cond do
        h == 46 -> decode_buffer(t, short)
        h == 45 -> decode_buffer(t, long)
      end
    end

##########################


  #def bench(n) do
  #  table = encode_table()
  #  sample = sample()
  #  :timer.tc(fn -> Enum.each(1..n, fn(_) -> encode(sample, table) end ) end)
  #end

  #def encode(text) do
  #  encode(text, encode_table(), [])
  #end
#
  #def encode([], _, coded) do Enum.reverse(coded) end
  #def encode([char | text], table, sofar) do
  #  encode(text, table, encode_lookup(char,table) ++ [32] ++ sofar)
  #end
#
  #def encode_table() do
  #  codes = codes(morse(), [])
  #  Enum.reduce(codes, %{}, fn ({char, code}, acc) ->
  #    Map.put(acc, char, code)
  #  end)
  #end
  #def codes(:nil, _) do [] end
  #def codes({:node, :na, long, short}, code) do
  #  codes(long, [?- | code]) ++ codes(short, [?. | code])
  #end
#
  #def codes({:node, char, long, short}, code) do
  #  [{char, Enum.reverse(code)}] ++ codes(long, [?-|code]) ++ codes(short, [?.|code])
  #end
#
  #def encode_lookup(char, map) do Map.get(map, char) end
#
  ##def decode(signal) do
  ##  decode(signal, table)
  ##end
#
#
#
  ##Ej svansrekusriv, måste vara det för uppgiften
#
  #def decode_table() do
  #  morse()
  #end
##
  ##def decode([], _) do [] end
  ##def decode(signal, table) do
  ##  {char, rest} = decode_char(signal, table)
  ##  [char | decode(rest, table)]
  ##end
##
  ##  def decode_char([], {:node, char, _, _}) do
  ##  {char, []}
  ##end
##
  ##def decode_char(signal) do
  ##  table = decode_table()
  ##  decode_char(signal, table)
  ##end
##
##
##
  ##def decode_char([?- | signal], {:node, _, long, _}) do
  ##  decode_char(signal, long)
  ##end
##
  ##def decode_char([?. | signal], {:node, _, _, short}) do
  ##  decode_char(signal, short)
  ##end
##
  ##def decode_char([?\s | signal], {:node, :char, _, _}) do
  ##  {:char, signal}
  ##end
##
  ##def decode_char([?\s | signal], {:node, :na, _, _}) do
  ##  {?*, signal}
  ##end
#
  #def decode(signal) do
  #  table = decode_table()
  #  decode(signal, table)
  #end
#
  #def decode([], _) do  [] end
  #def decode(signal, table) do
  #  {char, rest} = decode_char(signal, table)
  #  [char | decode(rest, table)]
  #end
#
  #def decode_char([], {:node, char, _, _}), do: {char, []}
#
  #def decode_char([?- | signal], {:node, _, long, _}) do
  #  decode_char(signal, long)
  #end
  #def decode_char([?. | signal], {:node, _, _, short}) do
  #  decode_char(signal, short)
  #end
  #def decode_char([?\s | signal], {:node, :na, _, _}) do
  #  {?*, signal}
  #end
  #def decode_char([?\s | signal], {:node, char, _, _}) do
  #  {char, signal}
  #end

end
