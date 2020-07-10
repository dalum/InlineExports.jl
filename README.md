# InlineExports.jl

[![Build Status](https://travis-ci.org/dalum/InlineExports.jl.svg?branch=master)](https://travis-ci.org/dalum/InlineExports.jl)
[![codecov](https://codecov.io/gh/dalum/InlineExports.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/dalum/InlineExports.jl)

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

"""
    g(x)

...
"""
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

## Disabling inline exports

If you wish to disable all inline exports without removing all `@export` macro calls, `InlineExports` provides a convenience submodule, `InlineExports.NoExport`.  This submodule exports a definition of the `@export` macro which returns the expression untouched.  As an example, this module does not export the function `f(x)`:
```julia
module M

using InlineExports.NoExport

# Export statements have been disabled.  This function will not be exported
@export function f(x)
    ...
end

```
