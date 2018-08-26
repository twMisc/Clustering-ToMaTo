__precompile__()
module ToMaTo
using Distances, Plots, DataStructures, NearestNeighbors
export createGraph, createGraph2, densityf, Clustering, PlotClustering, data2clust
include("ClusteringFunctions.jl")
end