# Demos

```@example 1
We use data from 

Ultsch, A.; Lötsch, J. The Fundamental Clustering and Projection Suite (FCPS): A Dataset Collection to Test the Performance of Clustering and Data Projection Algorithms. Data 2020, 5, 13. https://doi.org/10.3390/data5010013

```@example demo1
using ClusteringToMaTo
using Plots
using DelimitedFiles
import Clustering

function read_csv(filepath)
    data, columns = readdlm(filepath, ',',  header=true)
    return collect(data[:,2:end]'), Int.(data[:,1])
end
```

```@example demo1
points, true_labels = read_csv(joinpath("data", "TwoDiamonds.csv"))

p = plot(layout=(1,2))
scatter!(p[1,1], points[1,:], points[2,:], c = true_labels, 
ms=3, aspect_ratio=:equal, markerstrokewidth=0,label="")

@time labels = data2clust(points, 2, 0.25, 20, 0.2)
println(" NMI = $(Clustering.mutualinfo(true_labels, labels))")
scatter!(p[1,2], points[1,:], points[2, :], c = labels, 
      label="", ms=3, markerstrokewidth=0, aspect_ratio=1)
```

```@example demo1
points, true_labels = read_csv(joinpath("data", "Lsun.csv"))

p = plot(layout=(1,2))
scatter!(p[1,1], points[1,:], points[2,:], c = true_labels, 
ms=3, aspect_ratio=:equal, markerstrokewidth=0,label="")

@time labels = data2clust(points, 1, 5, 5, 0.4)
println(" NMI = $(Clustering.mutualinfo(true_labels, labels))")
scatter!(p[1,2], points[1,:], points[2, :], c = labels, 
      label="", ms=3, markerstrokewidth=0, aspect_ratio=1)
```

```@example demo1
points, true_labels = read_csv(joinpath("data", "Atom.csv"))

p = plot(layout=(1,2))
scatter!(p[1,1], points[1,:], points[2,:], points[3, :], c = true_labels, 
ms=3, aspect_ratio=:equal, markerstrokewidth=0,label="")

@time labels = data2clust(points, 2, 15, 10, 0.0000515)
println(" NMI = $(Clustering.mutualinfo(true_labels, labels))")
scatter!(p[1,2], points[1,:], points[2, :], points[3, :], c = labels, 
      label="", ms=3, markerstrokewidth=0, aspect_ratio=1)
```

```@example demo1
points, true_labels = read_csv(joinpath("data", "Chainlink.csv"))

p = plot(layout=(1,2))
scatter!(p[1,1], points[1,:], points[2,:], points[3, :], c = true_labels, 
ms=3, aspect_ratio=:equal, markerstrokewidth=0,label="")

@time labels = data2clust(points, 1, 10, 100, 0.2)
println(" NMI = $(Clustering.mutualinfo(true_labels, labels))")
scatter!(p[1,2], points[1,:], points[2, :], points[3, :], c = labels, 
      label="", ms=3, markerstrokewidth=0, aspect_ratio=1)
```

```@example demo1
points, true_labels = read_csv(joinpath("data", "Engytime.csv"))

p = plot(layout=(1,2))
scatter!(p[1,1], points[1,:], points[2,:], c = true_labels, 
ms=3, aspect_ratio=:equal, markerstrokewidth=0,label="")

@time labels = data2clust(points, 2, 1, 10, 0.00000001)
println(" NMI = $(Clustering.mutualinfo(true_labels, labels))")
scatter!(p[1,2], points[1,:], points[2, :], c = labels, 
      label="", ms=3, markerstrokewidth=0, aspect_ratio=1)
```
