# InlineExports.jl
Decentralizing exports in Julia

## Usage

`InlineExports` provides the convenience macro, `@export`, for
exporting names in a module at the location of definition, as an
alternative to the convention of exporting names at the top of the
module.  `@export` analyses an expression for definitions of
variables, functions or types, and inserts an appropriate `export`
statement above.  This is illustrated by the following example:

```julia
module M

using InlineExports

@export struct T{...}
    ...
end

function f(x)
    ...
end

@export function g(x)
    ...
end

end
```

The module above will export the names `T` and `g`.  Alternatively,
definitions can be wrapped inside a block.  The example below will
export both `a`, `b` and `c`:

```julia
module M

using InlineExports

@export begin
    a = 1
    const b = 2
    c = 3
end

end
```

## Limitations

`@export` does not currently work with attaching docstrings to a
function.  The following will throw an error by the documentation
system:
```julia
"""
...
"""
@export f() = nothing
```
