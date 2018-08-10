function createGraph(X::Array,k::Integer)
    k=k+1;
    kdtree = KDTree(X')
    idxs, dists = knn(kdtree, X', k)
    return idxs
end

function createGraph2(X::Array,d::Number)
    kdtree = KDTree(X')
    idxs=inrange(kdtree, X', d)
    return idxs
end

function densityf(X::Array,k::Int64=35)
    k=k+1;
    n=size(X,1)
    dim=size(X,2)
    kdtree = KDTree(X')
    idxs, dists = knn(kdtree, X', k)
    f=[]
    if dim==2
        for i=1:n
            push!(f,k*(k+1)/(2*n*pi*sum(dists[i].^2)))
        end
    elseif dim==3
        for i=1:n
            push!(f,k*(k+1)/(2*n*(4/3)*pi*sum(dists[i].^3)))
        end
    elseif dim==1
        for i=1:n
            push!(f,k*(k+1)/(2*n*sum(dists[i])))
        end
    end
    return f
end
    
#=
function densityf(data::Array,h::Number=std(data)*(4/3/size(data,1))^(1/5);)
    #h= std(data)*(4/3/size(data,1))^(1/5);
   phi(x) = @. exp(-0.5*x^2)/sqrt(2*pi)
    kernel(x) = mean(phi((x-data)/h)/h)
    kpdf(x) = kernel.(x)
    if size(data,2)==2
        dnorm = @. data[:,1]^2 + data[:,2]^2
    elseif size(data,2)==3
        dnorm = @. data[:,1]^2 + data[:,2]^2 + data[:,3]^2
    else
        dnorm=zeros(size(data,1))
        for i=1:size(data,2)
            dnorm = @. dnorm + data[:,i]
        end
    end
    return kpdf(sqrt.(dnorm))
end

function SortByDensity(X::Array,f::Array)
    pair=[X f]
    dox = size(X,2)
    pair = sortrows(pair,rev=true,by=x->x[dox+1])
    return [pair[:,1:end-1], pair[:,end]]
end
=#



#=
function Clustering(G::Array{Array{Int64,1},1},f::Array,tao::Number)
    n=length(f)
    g=zeros(n);
    
    #pair = sortrows(pair,rev=true,by=x->x[2]);
    #dictpair=Dict(zip(v,f));
    u=IntDisjointSets(n);
    for i=1:n
        nGi=[j for j in G[i][[k for k=1:length(G[i]) if k!=i]] if j<i]
        if length(nGi)==0
            #vertex is a peak of f within G
        else
            ff(i)=f[i];
            g[i]=nGi[indmax(ff.(nGi))]
            ei = find_root(u, Int.(g[i]))
            union!(u,ei,i);
            #eiV=[i for i=1:n if in_same_set(u,ei,i)];
            for j in nGi
                e=find_root(u,j)
                #eV=[i for i=1:n if in_same_set(u,e,i)];
                if e!=ei && minimum([f[e] ; f[ei]])<f[i] + tao
                    if f[e]<f[ei]
                        union!(u,ei,e)
                    else
                        union!(u,e,ei)
                    end
                    e2=find_root(u,e);
                    #u.parents[e2]=e2[indmax(ff.(e2))];
                    #eiV=e2;
                    ei=e2;
                end
            end
        end
    end
    return [Set([find_root(u,i) for i=1:n if f[find_root(u,i)]>=tao]),u]
end
=#

function Clustering(G::Array{Array{Int64,1},1},f::Array,tao::Number)
    n=length(f)
    g=zeros(n);
    v=[i for i in 1:n]
    pair = [f v G]
    pairs = sortrows(pair,rev=true,by=x->x[1]);
    #vertices_corr=Dict(zip(1:n,pairs[:,2]));
    #ver_f(x)=vertices_corr[x]
    vertices_corr_inv=Dict(zip(pairs[:,2],1:n));
    ver_invf(x)=vertices_corr_inv[x]
    C=[]
    for subset in pairs[:,3]
        push!(C,ver_invf.(subset))
    end
    pairs[:,3]=C;
    #dictpair=Dict(zip(v,f));
    u=IntDisjointSets(n);
    for i=1:n
        nGi=[j for j in pairs[i,3] if j<i]
        if length(nGi)==0
            #vertex is a peak of f within G
        else
            ff(i)=pairs[i,1];
            g[i]=nGi[indmax(ff.(nGi))]
            ei = find_root(u, Int.(g[i]))
            union!(u,ei,i);
            #eiV=[i for i=1:n if in_same_set(u,ei,i)];
            for j in nGi
                e=find_root(u,j)
                #eV=[i for i=1:n if in_same_set(u,e,i)];
                if e!=ei && minimum([pairs[e,1] ; pairs[ei,1]])< pairs[i,1] + tao
                    if pairs[e,1]<pairs[ei,1]
                        union!(u,ei,e)
                    else
                        union!(u,e,ei)
                    end
                    e2=find_root(u,e);
                    #u.parents[e2]=e2[indmax(ff.(e2))];
                    #eiV=e2;
                    ei=e2;
                end
            end
        end
    end
    S=Set([find_root(u,i) for i=1:n if pairs[find_root(u,i),1]>=tao])
    S2=[s for s in S]
    Xs=[]
    for j=1:length(S2)
        Xs=push!(Xs,(pairs[S2[j],2],[pairs[i,2] for i=1:n if in_same_set(u,S2[j],i)]))
    end
    return Xs
end

#=                                                    
function PlotClustering(X::Array,S::Set,u::DataStructures.IntDisjointSets,mark=2000/size(X,1))
    S2=[s for s in S]
    Xs=[]
    for j=1:length(S2)
        Xs=push!(Xs,[i for i=1:size(X,1) if in_same_set(u,S2[j],i)])
    end
    plt=scatter();
    j=1;
    if size(X,2)==2
        for arr in Xs
            plt=scatter!(X[arr,1],X[arr,2],label=S2[j],ms=mark,aspect_ratio=:equal)
            j=j+1
        end
    elseif size(X,2)==3
        for arr in Xs
            plt=scatter!(X[arr,1],X[arr,2],X[arr,3],label=S2[j],ms=mark)
            j=j+1
        end
    elseif size(X,1)==1
        for arr in Xs
            plt=scatter!(X[arr,1],label=S2[j],ms=mark)
        end
    end
    points=0
    for arr in Xs
        points=points+length(arr)
    end
    return points, plt
end
=#                                                    
                                                                                                            
function data2clust(data::Array,graph=1,k1=4,k2=4,tao=0.01)
   f=densityf(data,k2)
   if graph==1
        return Clustering(createGraph(data,k1),f,tao)
    elseif graph==2
        return Clustering(createGraph2(data,k1),f,tao)
    else
        println("The 2nd varaible should be 1 or 2")
        return 1
    end
end

function PlotClustering(X::Array,S,mark=2000/size(X,1))
    plt=scatter();
    if size(X,2)==2
        for pair in S
            plt=scatter!(X[pair[2],1],X[pair[2],2],label=pair[1],ms=mark,aspect_ratio=:equal)
        end
    elseif size(X,2)==3
        for pair in S
            plt=scatter!(X[pair[2],1],X[pair[2],2],X[pair[2],3],label=pair[1],ms=mark,aspect_ratio=:equal)
        end
    elseif size(X,1)==1
        for pair in S
            plt=scatter!(X[pair[2],1],label=pair[2],ms=mark,aspect_ratio=:equal)
        end
    end
    points=0
    for pair in S
        points=points+length(pair[2])
    end
    return points, plt
end