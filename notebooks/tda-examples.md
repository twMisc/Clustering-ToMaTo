---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.14.7
  kernelspec:
    display_name: Julia 1.9
    language: julia
    name: julia-1.9
---

```julia
using Plots
using DelimitedFiles
using ClusteringToMaTo
gr(fmt = :png) # useful to plot a large size of scatter points
options = (ms=1, aspect_ratio=1, markerstrokewidth=0)
```

```julia
download("https://raw.githubusercontent.com/MathieuCarriere/sklearn-tda/master/example/inputs/spiral_w_o_density.txt", 
"spiral_w_o_density.txt")
spiral = collect(transpose(readdlm(joinpath("spiral_w_o_density.txt"))))
```

```julia
download("https://raw.githubusercontent.com/MathieuCarriere/sklearn-tda/master/example/inputs/toy_example_w_o_density.txt",
"toy_example_w_o_density.txt") 
toy = collect(transpose(readdlm(joinpath("toy_example_w_o_density.txt"))))
```

```julia
@time labels = data2clust(spiral, 2, 87, 87, 7.5*10.0^(-7))

scatter(spiral[1, :], spiral[2, :], c = labels; options...)
```

```julia
@time labels = data2clust(toy, 2, 2.0, 30, 0.005)
scatter(view(toy,1, :), view(toy,2,:), c = labels; options... )
```

```julia

```

```julia

```
