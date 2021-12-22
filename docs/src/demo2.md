---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.13.4
  kernelspec:
    display_name: Julia 1.6.3
    language: julia
    name: julia-1.6
---

```julia
using Pkg
Pkg.activate(@__DIR__)
Pkg.update()
Pkg.instantiate()
```

```julia
using Plots
using DelimitedFiles
using Revise
```

```julia
using ClusteringToMaTo
```

[Link to download the two datasets (spiral and toy) on GitHub](https://github.com/MathieuCarriere/sklearn-tda/blob/master/example/inputs/spiral_w_o_density.txt)

```julia
Sp = readdlm(joinpath("spiral_w_o_density.txt"))
```

```julia
size(Sp,1)
```

```julia
options = (ms=3,aspect_ratio=:equal, markerstrokewidth=0.1)
scatter(Sp[:,1],Sp[:,2]; options...)
savefig("spiral.png") # Too much points so we save the plot as image
```

Display image saved above

![spiral](spiral.png)

```julia
@time S = data2clust(Sp, 2, 87, 87, 7.5*10.0^(-7))
```

```julia
s1, s2 = getindex.(S, 2)

scatter(Sp[s1,1], Sp[s1,2]; options...)
scatter!(Sp[s2,1], Sp[s2,2]; options...)
savefig("spiral_clusters.png") # Too much points so we save the plot as image
```

<!-- #region -->
Display image saved above


![spiral clusters](spiral_clusters.png)
<!-- #endregion -->

```julia
toy = readdlm(joinpath("toy_example_w_o_density.txt"))
```

```julia
options = (ms=3,aspect_ratio=:equal, markerstrokewidth=0.1)
scatter(toy[:,1],toy[:,2]; options...)
savefig("toy_example.png")
```

![toy](toy_example.png)

```julia
@time sol = data2clust(toy, 2, 2, 30, 0.005)
```

```julia
p = plot()
for s in getindex.(sol,2)
    scatter!(p, toy[s,1],toy[s,2]; options... )
end

savefig("toy_example_clusters.png")
```

![clusters](toy_example_clusters.png)
