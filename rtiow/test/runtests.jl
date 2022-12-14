
include("../src/vector.jl")

using Main.vector
using Test
using LinearAlgebra

@testset "VectorTests" begin
    v1 = vec3(1.0, 2.0, 3.0)
    v2 = vec3(4.0, 5.0, 6.0)
    @test v1 + v2 == vec3(5.0, 7.0, 9.0)
    @test length(v1) == sqrt(14)
    @test dot(v1, v1) == 14
    @test x(v1) == 1.0
    @test y(v1) == 2.0
    @test z(v1) == 3.0
    @test v1 / 2.0 == vec3(0.5, 1.0, 1.5)
    @test v1 * 2.0 == vec3(2, 4, 6)
end