# TDA examples

```@example demo2
using Plots
using DelimitedFiles
using ClusteringToMaTo
gr(fmt = :png) # useful to plot a large size of scatter points
options = (ms=1, aspect_ratio=1, markerstrokewidth=0)
```

```@example demo2
download("https://raw.githubusercontent.com/MathieuCarriere/sklearn-tda/master/example/inputs/spiral_w_o_density.txt", 
"spiral_w_o_density.txt")

points = collect(transpose(readdlm(joinpath("spiral_w_o_density.txt"))))
```

```@example demo2
@time labels = data2clust(points, 2, 87, 87, 7.5*10.0^(-7))

scatter(points[1, :], points[2, :], c = labels; options...)
```

```@example demo2
download("https://raw.githubusercontent.com/MathieuCarriere/sklearn-tda/master/example/inputs/toy_example_w_o_density.txt",
"toy_example_w_o_density.txt") 
toy = collect(transpose(readdlm(joinpath("toy_example_w_o_density.txt"))))
```

```@example demo2
@time labels = data2clust(toy, 2, 2, 30, 0.005)

scatter(view(toy,1, :), view(toy,2,:), c = labels; options... )
```
