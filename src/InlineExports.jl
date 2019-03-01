module InlineExports

import Base: @__doc__

export @export

quote
    """
        @export

    Return the expression with all bindings exported.

    ```
    julia> module M
               using InlineExports
               @export begin
                   const a = 2
                   abstract type S <: Number end
                   struct T <: S
                       val
                   end
               end
               @export f(x::TT) where {TT<:S} = x.val^2
           end
    M

    julia> using .M

    julia> f(T(a))
    4
    ```
    """
    macro $(Symbol("export"))(expr::Expr)
        r = handle(expr)
        if r isa Symbol
            return quote
                export $(esc(r))
                @__doc__ $(esc(expr))
            end
        else
            return quote
                export $(map(esc, r)...)
                @__doc__ $(esc(expr))
            end
        end
    end
end |> eval

handle(::Any) = nothing
handle(x::Symbol) = x
handle(expr::Expr) = handle(Val(expr.head), expr)

handle(::Val{:block}, expr) = filter(!isnothing, map(handle, expr.args))
handle(::Val{:const}, expr) = handle(expr.args[1])
handle(::Val{:(=)}, expr) = handle(expr.args[1])
handle(::Val{:function}, expr) = handle(expr.args[1])
handle(::Val{:where}, expr) = handle(expr.args[1])
handle(::Val{:macro}, expr) = Symbol("@", handle(expr.args[1]))
handle(::Val{:struct}, expr) = handle(expr.args[2])
handle(::Union{Val{:abstract}, Val{:primitive}}, expr) = handle(expr.args[1])

handle(::Val{:<:}, expr) = handle(expr.args[1])
handle(::Val{:curly}, expr) = handle(expr.args[1])
handle(::Val{:call}, expr) = handle(expr.args[1])
handle(::Val{:macrocall}, expr) = filter(!isnothing, map(handle, expr.args[3:end]))

end # module
