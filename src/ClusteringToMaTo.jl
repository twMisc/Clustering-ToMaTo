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

    v = sortperm(f, rev = true)
    f .= f[v]
    vertices_corr_inv = Dict(zip(v, 1:n))
    clusters = [[vertices_corr_inv[i] for i in subset] for subset in idxs[v]]
    u = IntDisjointSets(n)
    for i = eachindex(v)
        nGi = [j for j in clusters[i] if j < i]
        if length(nGi) == 0
            #vertex is a peak of f within G
        else
            g = nGi[argmax(view(f, nGi))]
            ei = find_root!(u, g)
            union!(u, ei, i)
            for j in nGi
                e = find_root!(u, j)
                if e != ei && min(f[e], f[ei]) < f[i] + τ
                    if f[e] < f[ei]
                        union!(u, ei, e)
                    else
                        union!(u, e, ei)
                    end
                    e2 = find_root!(u, e)
                    ei = e2
                end
            end
        end
    end
    s = Int[]
    for i = 1:n
        g = find_root!(u, i)
        if f[g] >= τ && !(g in s)
           push!(s, g)
        end
    end
    labels = zeros(Int, n)
    for j = eachindex(s), i in 1:n
        if in_same_set(u, s[j], i)
            labels[v[i]] = j
        end
    end

    return labels

end

end
