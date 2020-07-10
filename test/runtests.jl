module TestInlineExports

using Test

module M1
using InlineExports
@export M1f() = nothing
end

using .M1

@testset "Simple function" begin
    @test M1f() === nothing
end

module M2
using InlineExports
@export begin
    M2f(a) = a^2
    M2a = 2
    const M2b = 3.0
    M2c = 7im
end

@export abstract type M2S{T} <: Number end
@export primitive type M2P <: Number 8 end
@export macro M2macro(expr)
    expr
end

@export struct M2TP{T} <: M2S{T}
    val::T
end

@export struct M2T <: M2S{Number}
    val::Number
end

@export @inline M2f(a::M2T) = M2f(a.val)

@export function M2g(a::M2TP{T}) where {T<:Number}
    return convert(T, M2f(a.val))
end

@export M2t = M2T(M2a)
@export M2tp = M2TP(M2c)

"""
    docstring
"""
@export function M2h end

end

using .M2

@testset "Advanced module" begin
    @test M2f(M2a) == 4
    @test M2f(M2b) == 9.0
    @test M2f(M2c) == -49
    @test M2f(M2t) == M2f(M2a)
    @test M2g(M2tp) == M2f(M2c)
end

module M3
using InlineExports.NoExport
@export M3f() = 42
end

using .M3

@testset "NoExport" begin
    @test_throws UndefVarError M3f()
    @test M3.M3f() === 42
end

end #module
