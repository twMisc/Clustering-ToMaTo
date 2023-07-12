```@example 1
using ClusteringToMaTo
using Plots
using DelimitedFiles

A = readdlm(joinpath("FCPS","01FCPSdata","TwoDiamonds.lrn"))
A = float.(A[5:end,2:3])

scatter(A[:,1],A[:,2],ms=4,aspect_ratio=:equal,markerstrokewidth=0.1,label="")
```

```@example 1
U, V = data2clust(A, 2, 0.5, 20, 0.2)

scatter(A[U[2],1], A[U[2], 2])
scatter!(A[V[2],1], A[V[2], 2])
```

```@example 1
B = readdlm(joinpath("FCPS","01FCPSdata","Lsun.lrn"))
B = float.(B[5:end,2:3]);

scatter(B[:,1],B[:,2],ms=2000/size(B,1),
    aspect_ratio=:equal,markerstrokewidth=0.1,label="")
```

```@example 1
S = data2clust(B,1,5,5,0.4)

s1, s2, s3 = getindex.(S, 2)

scatter(B[s1,1], B[s1, 2])
scatter!(B[s2,1], B[s2, 2])
scatter!(B[s3,1], B[s3, 2])
```

```@example 1
C = readdlm(joinpath("FCPS","01FCPSdata","Atom.lrn"))
C = float.(C[5:end,2:4]);

scatter(C[:,1],C[:,2],C[:,3],ms=2000/size(C,1),aspect_ratio=:equal)
```

```@example 1
S = data2clust(C,2,15,10,0.0000515)

s1, s2= getindex.(S, 2)

scatter(C[s1,1], C[s1, 2], C[s1, 3])
scatter!(C[s2,1], C[s2, 2], C[s2, 3])
```

```@example 1
D = readdlm(joinpath("FCPS","01FCPSdata","Chainlink.lrn"))

D = float.(D[5:end,2:4])

scatter(D[:,1],D[:,2],D[:,3],ms=4,aspect_ratio=:equal,
    markerstrokewidth=0.1,label="")
```

```@example 1
S = data2clust(D,1,10,100,0.2)

s1, s2 = getindex.(S, 2)

scatter(D[s1,1], D[s1, 2], D[s1, 3])
scatter!(D[s2,1], D[s2, 2], D[s2, 3])
```

```@example 1
E = readdlm(joinpath("FCPS","01FCPSdata","EngyTime.lrn"))
E = float.(E[5:end,2:3]);

scatter(E[:,1],E[:,2],ms=2.7,aspect_ratio=:equal,
    markerstrokewidth=0.1,label="")

S = data2clust(E,2,1,10,0.00000001)

s1, s2 = getindex.(S, 2)

scatter(E[s1,1], E[s1, 2])
scatter!(E[s2,1], E[s2, 2])
```
