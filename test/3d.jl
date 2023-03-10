using Test: @test, @testset, @inferred
using TensorFactorizations: als
using Statistics: cor
using Random: bitrand
using Tullio: @tullio

@testset "3-dimensional case" begin
    N, M, K = (7,5,9)
    rank = 1

    A, B, C = randn(rank, N), randn(rank, M), randn(rank, K)
    @tullio X[i,j,k] := A[r,i] * B[r,j] * C[r,k]
    X .+= randn(N, M, K) / 100

    (_A, _B, _C), errors = @inferred als(X; rank)
    @test abs(cor(vec(A), vec(_A))) > 0.99
    @test abs(cor(vec(B), vec(_B))) > 0.99
    @test abs(cor(vec(C), vec(_C))) > 0.99

    mask = ones(N,M,K)
    (_A, _B, _C), errors = @inferred als(X, mask; rank)
    @test abs(cor(vec(A), vec(_A))) > 0.99
    @test abs(cor(vec(B), vec(_B))) > 0.99
    @test abs(cor(vec(C), vec(_C))) > 0.99

    N, M, K = (23, 31, 17)
    A, B, C = randn(rank, N), randn(rank, M), randn(rank, K)
    @tullio X[i,j,k] := A[r,i] * B[r,j] * C[r,k]
    X .+= randn(N, M, K) / 1000
    mask = (rand(N,M,K) .< 0.9)
    X = ifelse.(mask, X, NaN)
    (_A, _B, _C), errors = @inferred als(X, mask; rank)
    @test abs(cor(vec(A), vec(_A))) > 0.9
    @test abs(cor(vec(B), vec(_B))) > 0.9
    @test abs(cor(vec(C), vec(_C))) > 0.9
end
