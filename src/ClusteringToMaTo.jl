module ClusteringToMaTo

using DataStructures
using Distances
using NearestNeighbors

export createGraph, createGraph2, densityf, Clustering, PlotClustering, data2clust

function createGraph(X::Array, k::Integer)
    X = float.(X')
    k = k + 1
    kdtree = KDTree(X)
    idxs, dists = knn(kdtree, X, k)
    return idxs
end

function createGraph2(X::Array, d::Number)
    X = float.(X')
    kdtree = KDTree(X)
    idxs = inrange(kdtree, X, d)
    return idxs
end

function densityf(X::Array, k::Int64 = 35)
    k = k + 1
    n = size(X, 1)
    dim = size(X, 2)
    X = float.(X')
    kdtree = KDTree(X)
    idxs, dists = knn(kdtree, X, k)
    f = []
    if dim == 2
        for i = 1:n
            push!(f, k * (k + 1) / (2 * n * pi * sum(dists[i] .^ 2)))
        end
    elseif dim == 3
        for i = 1:n
            push!(f, k * (k + 1) / (2 * n * (4 / 3) * pi * sum(dists[i] .^ 3)))
        end
    elseif dim == 1
        for i = 1:n
            push!(f, k * (k + 1) / (2 * n * sum(dists[i])))
        end
    end
    return f
end

function clustering(G::Array{Array{Int64,1},1}, f::Array, tao::Number)
    n = length(f)
    g = zeros(n)
    v = [i for i = 1:n]
    pair = [f v G]
    pairs = sortslices(pair, dims = 1, rev = true, by = x -> x[1])
    vertices_corr_inv = Dict(zip(pairs[:, 2], 1:n))
    ver_invf(x) = vertices_corr_inv[x]
    C = []
    for subset in pairs[:, 3]
        push!(C, ver_invf.(subset))
    end
    pairs[:, 3] = C
    u = IntDisjointSets(n)
    for i = 1:n
        nGi = [j for j in pairs[i, 3] if j < i]
        if length(nGi) == 0
            #vertex is a peak of f within G
        else
            ff(i) = pairs[i, 1]
            g[i] = nGi[argmax(ff.(nGi))]
            ei = find_root(u, Int.(g[i]))
            union!(u, ei, i)
            for j in nGi
                e = find_root(u, j)
                if e != ei && minimum([pairs[e, 1]; pairs[ei, 1]]) < pairs[i, 1] + tao
                    if pairs[e, 1] < pairs[ei, 1]
                        union!(u, ei, e)
                    else
                        union!(u, e, ei)
                    end
                    e2 = find_root(u, e)
                    ei = e2
                end
            end
        end
    end
    S = Set([find_root(u, i) for i = 1:n if pairs[find_root(u, i), 1] >= tao])
    S2 = [s for s in S]
    Xs = []
    for j = 1:length(S2)
        Xs = push!(
            Xs,
            (pairs[S2[j], 2], [pairs[i, 2] for i = 1:n if in_same_set(u, S2[j], i)]),
        )
    end
    return Xs
end

function data2clust(data::Array, graph = 1, k1 = 4, k2 = 4, tao = 0.01)
    f = densityf(data, k2)
    if graph == 1
        return clustering(createGraph(data, k1), f, tao)
    elseif graph == 2
        return clustering(createGraph2(data, k1), f, tao)
    else
        println("The 2nd varaible should be 1 or 2")
        return 1
    end
end

end
