```@example 2
using Plots
using DelimitedFiles
using ClusteringToMaTo
```

[Link to download the two datasets (spiral and toy) on GitHub](https://github.com/MathieuCarriere/sklearn-tda/blob/master/example/inputs/spiral_w_o_density.txt)

```@example 2
Sp = readdlm(joinpath("spiral_w_o_density.txt"))

options = (ms=3,aspect_ratio=:equal, markerstrokewidth=0.1)
scatter(Sp[:,1],Sp[:,2]; options...)
```

```@example 2
S = data2clust(Sp, 2, 87, 87, 7.5*10.0^(-7))

s1, s2 = getindex.(S, 2)

scatter(Sp[s1,1], Sp[s1,2]; options...)
scatter!(Sp[s2,1], Sp[s2,2]; options...)
```

```@example 2
toy = readdlm(joinpath("toy_example_w_o_density.txt"))

options = (ms=3,aspect_ratio=:equal, markerstrokewidth=0.1)
scatter(toy[:,1],toy[:,2]; options...)
```

```@example 2
sol = data2clust(toy, 2, 2, 30, 0.005)

p = plot()
for s in getindex.(sol,2)
    scatter!(p, toy[s,1],toy[s,2]; options... )
end
display(p)
```