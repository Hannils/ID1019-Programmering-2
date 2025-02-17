defmodule Derivates do 

    def test1() do
        e = {:add, 
            {:mul, {:num, 2}, {:var, :x}},
            {:num, 4}}
        d = deriv(e, :x)
        c = calc(d, :x, 5)
        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivate: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
        IO.write("calculated: #{pprint(simplify(c))}\n")
        :ok
    end

    def test2() do
        e = {:exp, {:mul, {:var, :x}, {:num, 4}}, {:num, 3}}
        d = deriv(e, :x)
        c = calc(d, :x, 4)

        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivate: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
        IO.write("calculated: #{pprint(simplify(c))}\n")
        :ok
    end

    def test3() do
        e = {:add, {:add,
                {:ln, {:var, :x}},
                {:var, :x}
            },
                {:mul, {:var, :x}, {:num, 3}}
            }
            
        d = deriv(e, :x)
        c = calc(d, :x, 4)

        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivate: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
        IO.write("calculated: #{pprint(simplify(c))}\n")
        :ok
    end

    def test4() do
        e = {:div, {:num, 1}, {:var, :x}}
        d = deriv(e, :x)
        c = calc(d, :x, 4)

        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivate: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
        IO.write("calculated: #{pprint(simplify(c))}\n")
        :ok
    end

    def test5() do
        e = {:exp, {:var, :x}, {:num, 1/2}}
        d = deriv(e, :x)
        c = calc(d, :x, 4)

        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivate: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
        IO.write("calculated: #{pprint(simplify(c))}\n")
        :ok
    end

    def test6() do
        e = {:sin, {:var, :x}}
        d = deriv(e, :x)

        IO.write("expression: #{pprint(e)}\n")
        IO.write("derivate: #{pprint(d)}\n")
        IO.write("simplified: #{pprint(simplify(d))}\n")
        :ok
    end

    @type literal() :: {:num, number()}
    | {:var, atom()}

    @type expr() :: 
    literal()
    | {:mul, expr(), expr()}
    | {:div, expr(), expr()}
    | {:add, expr(), expr()}
    | {:exp, expr(), literal()}
    | {:ln, expr()}
    | {:sin, expr()}
    | {:cos, expr()}


    def deriv({:num, _}, _) do {:num,0} end
    def deriv({:var, v}, v) do {:num,1} end
    def deriv({:var, _}, _) do {:num,0} end
    def deriv({:mul, e1, e2}, v) do 
        {:add,
        {:mul, deriv(e1,v), e2},
        {:mul, e1, deriv(e2,v)}}
    end
    def deriv({:add, e1, e2}, v) do
        {:add, deriv(e1, v), deriv(e2, v)}
    end
    def deriv({:exp, x, {:num, n}}, v) do
        {:mul,
            {:mul, {:num, n}, {:exp, x, {:num, n-1}}},
            deriv(x, v)}     
    end
    def deriv({:div, e1, e2}, v) do
        {:div,
            {:add,
                {:mul, deriv(e1, v), e2}, 
                {:mul,
                    {:mul, e1, deriv(e2, v)},
                    {:num, -1} 
                }
            },
            {:exp, e2, {:num, 2}}
        }
    end
    def deriv({:ln, e}, v) do
        {:div, deriv(e, v), e}  
    end
    def deriv({:sin, e}, v) do
        {:mul, deriv(e,v), {:cos,e}}
    end



    def calc({:num, n}, _, _) do {:num, n} end
    def calc({:var, v}, v, n) do {:num, n} end
    def calc({:var, v}, _, _) do {:var, v} end
    def calc({:add, e1, e2}, v, n) do 
        {:add, calc(e1, v, n), calc(e2, v, n)} 
    end
    def calc({:mul, e1, e2}, v, n) do 
        {:mul, calc(e1, v, n), calc(e2, v, n)} 
    end
    def calc({:exp, e1, e2}, v, n) do 
        {:exp, calc(e1, v, n), calc(e2, v, n)} 
    end
    def calc({:div, e1, e2}, v, n) do
        {:div, calc(e1, v, n), calc(e2, v, n)}
    end



    def simplify({:add, e1, e2}) do
        simplify_add(simplify(e1), simplify(e2))
    end
    def simplify({:mul, e1, e2}) do
        simplify_mul(simplify(e1), simplify(e2))
    end
    def simplify({:exp, e1, e2}) do
        simplify_exp(simplify(e1), simplify(e2))
    end
    def simplify({:div, e1, e2}) do 
        simplify_div(simplify(e1), simplify(e2))
    end
    def simplify({:cos, e}) do 
        simplify_cos(simplify(e))
    end
    def simplify(e) do e end

    def simplify_add({:num, 0}, e2) do e2 end
    def simplify_add(e1, {:num, 0})  do e1 end
    def simplify_add({:num, e1}, {:num, e2}) do {:num, e1+e2} end
    def simplify_add(e1, e2) do {:add, e1, e2} end

    def simplify_mul({:num, 0}, _) do {:num, 0} end
    def simplify_mul(_, {:num, 0}) do {:num, 0} end
    def simplify_mul({:num, 1}, e2) do e2 end
    def simplify_mul(e1, {:num, 1}) do e1 end
    def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
    def simplify_mul(e1, e2) do {:mul, e1, e2} end

    def simplify_div({:num, 0}, _) do {:num, 0} end
    def simplify_div(e1, {:num, 1}) do e1 end
    def simplify_div({:num, n1}, {:num, n2}) do {:num, n1/n2} end
    def simplify_div(e1,e2) do {:div, e1, e2} end

    def simplify_exp(_, {:num, 0}) do {:num, 1} end
    def simplify_exp(e1, {:num, 1}) do e1 end
    def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1, n2)} end
    def simplify_exp(e1, e2) do {:exp, e1, e2} end


    def simplify_cos({:num, n}) do {:num, :math.cos(n)} end
    def simplify_cos(e1) do {:cos, e1} end



    def pprint({:num,n}) do "#{n}" end
    def pprint({:var,v}) do "#{v}" end
    def pprint({:add,e1,e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
    def pprint({:mul,e1,e2}) do "(#{pprint(e1)} * #{pprint(e2)})" end
    def pprint({:exp,e1,e2}) do "((#{pprint(e1)}) ^ (#{pprint(e2)}))" end
    def pprint({:div, e1, e2}) do "(#{pprint(e1)}) / (#{pprint(e2)})" end
    def pprint({:ln, e}) do "ln (#{pprint(e)})" end
    def pprint({:sin, e}) do "sin(#{pprint(e)})" end
    def pprint({:cos, e}) do "cos(#{pprint(e)})" end


end