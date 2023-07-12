module ClusteringToMaTo

using DataStructures
using NearestNeighbors

export data2clust

function density_function( dists, dim, k)

    n = length(dists)
    f = zeros(n)
    
    if dim == 2
        for i = 1:n
            f[i] = k * (k + 1) / (2π * n * sum(dists[i] .^ 2))
        end
    elseif dim == 3
        for i = 1:n
            f[i] = k * (k + 1) / (2π * n * (4 / 3) * sum(dists[i] .^ 3))
        end
    elseif dim == 1
        for i = 1:n
            f[i] = k * (k + 1) / (2 * n * sum(dists[i]))
        end
    end

    return f

end

function data2clust(points::Array, graph = 1, k1 = 4, k2 = 4, τ = 0.01)

    @assert graph in (1,2) "The variable `graph` should be 1 or 2"

    dim, n  = size(points)
    kdtree = KDTree(points)
    k = k2 + 1
    idxs, dists = knn(kdtree, points, k)

    f = density_function(dists, dim, k)

    if graph == 1
        idxs, dists = knn(kdtree, points, k1+1)
    elseif graph == 2
        idxs = inrange(kdtree, points, k1)
    end

    g = zeros(Int, n)
    v = collect(1:n)
    pair = [f v idxs]
    pairs = sortslices(pair, dims = 1, rev = true, by = x -> x[1])
    vertices_corr_inv = Dict(zip(pairs[:, 2], 1:n))
    C = [[vertices_corr_inv[i] for i in subset] for subset in pairs[:, 3]]
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
                if e != ei && minimum([pairs[e, 1]; pairs[ei, 1]]) < pairs[i, 1] + τ
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
    S = unique([find_root(u, i) for i = 1:n if pairs[find_root(u, i), 1] >= τ])
    labels = zeros(Int, n)
    for j = eachindex(S)
        cluster = [pairs[i, 2] for i = 1:n if in_same_set(u, S[j], i)]
        labels[cluster] .= j
    end

    return labels

end

end
