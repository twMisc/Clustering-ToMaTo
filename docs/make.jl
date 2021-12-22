push!(LOAD_PATH,"../src/")

using Documenter
using ClusteringToMaTo
using Plots 

ENV["GKSwstype"] = "100"

makedocs(
         sitename = "ClusteringToMaTo.jl",
         modules = [ClusteringToMaTo],
         format=Documenter.HTML(;
         prettyurls=get(ENV, "CI", "false") == "true",
         mathengine = MathJax(Dict(
            :TeX => Dict(
                :equationNumbers => Dict(:autoNumber => "AMS"),
                :Macros => Dict()
            )
         )),
         canonical="https://pnavaro.github.io/ClusteringToMaTo.jl",
         assets=String[],
         ),
         doctest = false,
         pages = [
                  "Home" => "index.md",
                  "Demo 1" => "demo1.md",
                  "Demo 2" => "demo2.md" 
                 ])

deploydocs(;
    branch = "gh-pages",
    devbranch = "master",
    repo   = "github.com/pnavaro/ClusteringToMaTo.jl"
)
