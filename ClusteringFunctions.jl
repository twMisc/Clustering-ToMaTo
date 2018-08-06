function createGraph(X::Array,k::Integer)
    G=LightGraphs.SimpleGraphs.SimpleGraph{Int64}(size(X,1))
    for i=1:size(X,1)
        L=[(euclidean(X[i,:],X[j,:]),j) for j=1:size(X,1)]
        sort!(L,by = x -> x[1])
        for m=2:k+1
            add_edge!(G, i, L[m][2])
        end
    end
    return G
end

function createGraph2(X::Array,d::Number)
    G=LightGraphs.SimpleGraphs.SimpleGraph{Int64}(size(X,1))
    for i=1:size(X,1)
        L=[euclidean(X[i,:],X[j,:]) for j=1:size(X,1)]
        for m=1:size(X,1) 
            if L[m]<d && m!=i
                add_edge!(G, i, m)
            end
        end
    end
    return G
end

function densityf(data::Array,h::Number=std(data)*(4/3/size(data,1))^(1/5);)
    #h= std(data)*(4/3/size(data,1))^(1/5);
    tpdf(x) =phi(x+10)/2+phi(x-10)/2;
    phi(x) = exp.(-.5*x.^2)/sqrt(2*pi)
    kernel(x) = mean(phi((x-data)/h)/h)
    kpdf(x) = kernel.(x)
    dnorm=zeros(size(data,1))
    for j=1:size(data,2)
        dnorm = dnorm .+ data[:,j].^2
    end
    return kpdf(sqrt.(dnorm))
end

function Clustering(G::LightGraphs.SimpleGraphs.SimpleGraph{Int64},f::Array,tao::Number)
    n=length(f)
    g=zeros(n);
    r=[i for i in 1:n]
    v = 1:length(f)
    pair = [v f];
    pair = sortrows(pair,rev=true,by=x->x[2]);
    dictpair=Dict(zip(v,f));
    u=IntDisjointSets(n);
    for i in Int.(pair[:,1])
        nG=neighbors(G,i);
        nGi=[j for j in nG if j<i];
        if length(nGi)==0
            #vertex is a peak of f within G
            r[i]=i;
        else
            ff(i)=dictpair[i];
            g[i]=nGi[indmax(ff.(nGi))]
            ei = find_root(u, Int.(g[i]))
            union!(u,ei,i);
            eiV=[i for i=1:n if in_same_set(u,ei,i)];
            for j in nGi
                e=find_root(u,j)
                eV=[i for i=1:n if in_same_set(u,e,i)];
                if e!=ei && min(minimum(f[r[eV]]),minimum(f[r[eiV]]))<f[i] + tao
                    root_union!(u,e,ei)
                    e2=[eV;eiV];
                    r[e2]=e2[indmax(ff.(e2))];
                    eiV=e2
                    ei=e;
                end
            end
        end
    end
    return [Set([find_root(u,i) for i=1:n]),Set([find_root(u,i) for i=1:n if f[r[find_root(u,i)]]>=tao]),u]
end
                                                                
function PlotClustering(X::Array,S::Set,u::DataStructures.IntDisjointSets)
    S2=[s for s in S]
    Xs=[]
    for j=1:length(S2)
        Xs=push!(Xs,[i for i=1:size(X,1) if in_same_set(u,S2[j],i)])
    end
    plt=scatter();
    j=1;
    for arr in Xs
        plt=scatter!(X[arr,1],X[arr,2],label=S2[j])
        j=j+1
    end
    points=0
    for arr in Xs
        points=points+length(arr)
    end
    return points,plt
end