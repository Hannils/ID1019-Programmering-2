defmodule Env do

    def new() do
        {}
    end

    def add(id, str, env) do
        env = [{id, str} | env]
    end

    def lookup(id, env) do
        case Keyword.get(env, id, nil) do
            nil -> nil
            _ -> {id, res}
        end
    end

    def remove(ids, env) do
        Keyword.drop(env, ids)
    end
end

defmodule Eager do
    def eval_expr({:atm, id}, _) do {:ok, id} end
    def eval_expr({:var, id}, env) do
        case Env.lookup(id, env) do
            nil -> {:error}
            {id, str} -> {:ok, str}
        end
    end
    def eval_expr({:cons, x, y}, env) do
        case eval_expr(x, env) do
            {:error} -> {:error}
            {:ok, str} -> 
                case eval_expr(y, env) do
                    {:error} -> {:error}
                    {:ok, ts} -> {:ok, {str, ts}}
                end
        end
    end

    def eval_match(:ignore, _, env) do
        {:ok, env}
    end
    def eval_match({:atm, id}, id, env) do
        {:ok, env}
    end

    def eval_match({:var, id}, str, env) do
        case Env.lookup(id, env) do
            nil -> {:ok, Env.add(id, str, env)}
            {^id, ^str} -> {:ok, env}
            {_, _} -> :fail
        end
    end

    def eval_match({:cons, hp, tp}, {str1, str2}, env) do
        case eval_match(hp, str1, env) do
        :fail -> :fail
        {:ok, env} -> eval_match(tp, str2, env)
        end
    end


    def eval_match(_, _, _) do
        :fail
    end



    def eval_scope(pattern, env) do
        Env.remove(extract_vars(pattern), env)
    end
    def eval_seq([exp], env) do
        eval_expr(..., ...)
    end
    def eval_seq([{:match, ..., ...} | ...], ...) do
        case eval_expr(..., ...) do
            ... ->
            ...
            ... ->
            ... = eval_scope(..., ...)
            case eval_match(..., ..., ...) do
                :fail -> :error
                {:ok, env} -> eval_seq(..., ...)
            end
        end
    end

    def extract_vars(pattern) do
        extract_vars(pattern, [])
    end
    def extract_vars({:atm, _}, vars) do vars end
    def extract_vars(:ignore, vars) do vars end
    def extract_vars({:var, var}, vars) do
        [var | vars]
    end
    def extract_vars({:cons, head, tail}, vars) do
        extract_vars(tail, extract_vars(head, vars))
    end
end