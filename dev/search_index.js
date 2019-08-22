var documenterSearchIndex = {"docs":
[{"location":"detail/#Additional-Detail-1","page":"Detail","title":"Additional Detail","text":"","category":"section"},{"location":"detail/#","page":"Detail","title":"Detail","text":"Functions like GCMGridSpec(\"LLC90\") return a gcmgrid struct that contains the basic specification of a global grid. This is not the grid itself – just a few parameters, ranges, and possibly a path to grid files. A gcmgrid is embeded in each MeshArray instance for which it provides a blueprint. It specifies how an array collection forms a global mesh and allows e.g. the exchange function to dispatch to the appropriate method. ","category":"page"},{"location":"detail/#","page":"Detail","title":"Detail","text":"Various configurations that are commonly used in Earth System Models are readily implemented using the concrete type called MeshArray. This type is in fact an alias for more specific types that can be used interchangeably via MeshArray (initially: gcmfaces or gcmarray).","category":"page"},{"location":"detail/#","page":"Detail","title":"Detail","text":"Within a MeshArray, a whole Earth System Model grid can be represented as an array of elementary arrays. Each one of these typically corresponds to a subdomain mesh. For example, a gcmarray represents one Earth map x as a column array x.f of 2D arrays of varying sizes. MeshArrays.demo1 illustrates how one easily operates MeshArray structs via standard and specialized functions. In brief, a MeshArray should be used just like a basic Array.","category":"page"},{"location":"detail/#","page":"Detail","title":"Detail","text":"Background: MeshArrays.jl is rooted in a previous Matlab / Octave package, gcmfaces introduced in Forget et al., 2015 (doi:10.5194/gmd-8-3071-2015). GCM is an acronym for General Circulation Model, or Global Climate Model, and faces can mean meshes, arrays, facets, or subdomains (i.e., the elements of x.f in a MeshArray instance x).","category":"page"},{"location":"main/#Main-Features-1","page":"Main","title":"Main Features","text":"","category":"section"},{"location":"main/#","page":"Main","title":"Main","text":"The JuliaCon-2018 presentation relied on two Jupyter notebooks available in this other repo which correspond to MeshArrays.demo1 and MeshArrays.demo2. Additional demo functions are provided within MeshArrays and as notebooks (e.g., demo3 & demo_trsp.ipynb).","category":"page"},{"location":"main/#","page":"Main","title":"Main","text":"MeshArrays.jl composite array types contain array as elements. Elementary arrays in a MeshArray are typically inter-connected at their edges according to a user-specified gcmgrid specification. exchange methods transfer data between neighboring arrays to extend their computational domains, as often needed to derive e.g. planetary transports in the climate system.","category":"page"},{"location":"main/#","page":"Main","title":"Main","text":"The current default for MeshArray is gcmfaces. Instead, a gcmarray instance H is depicted below. This example is based on a grid, known as LLC90, where each global map is associated with 5 subdomain arrays. These are the elements of H.f which can be of size (90, 270), (90, 90), or (270, 90). H.f is a 5x50 array in this example where H is a gridded ocean variable on 50 depth levels.","category":"page"},{"location":"main/#","page":"Main","title":"Main","text":"julia> show(H)\n gcmarray \n  grid type   = llc\n  array size  = (5, 50)\n  data type   = Float64\n  face sizes  = (90, 270)\n                (90, 270)\n                (90, 90)\n                (270, 90)\n                (270, 90)","category":"page"},{"location":"main/#","page":"Main","title":"Main","text":"The underlying, MeshArray, data structure is:","category":"page"},{"location":"main/#","page":"Main","title":"Main","text":"struct gcmarray{T, N} <: AbstractMeshArray{T, N}\n   grid::gcmgrid\n   f::Array{Array{T,2},N}\n   fSize::Array{NTuple{2, Int}}\n   fIndex::Array{Int,1}\nend","category":"page"},{"location":"main/#","page":"Main","title":"Main","text":"And the embedded gcmgrid specification is constructed as: ","category":"page"},{"location":"main/#","page":"Main","title":"Main","text":"gcmgrid(path::String, class::String, nFaces::Int,\n        fSize::Array{NTuple{2, Int},1}, ioSize::Array{Int64,2},\n        ioPrec::Type, read::Function, write::Function)","category":"page"},{"location":"#MeshArrays.jl-documentation-1","page":"Home","title":"MeshArrays.jl documentation","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"MeshArrays.jl is a Julia package. It defines an Array type for collections of inter-connected arrays, and extends standard methods to readily operate on these MeshArrays. Its exchange methods transfer data between connected subdomains of the overall mesh. The internals of a MeshArray instance are regulated by index ranges, array sizes, and inter-connections that are encoded as a gcmgrid struct.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Such computational frameworks are commonly used in Earth System Modeling. MeshArrays.jl aims to provide a simple but versatile and powerful solution to this end. It was first introduced in this JuliaCon-2018 presentation as gcmfaces.jl (see this other repo for notebooks).","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Contents:","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Pages = [\"index.md\",\"main.md\",\"detail.md\",\"API.md\"]\nDepth = 3","category":"page"},{"location":"#","page":"Home","title":"Home","text":"note: Note\nMeshArrays.jl is registered, documented, archived, and routinely tested, but also still regarded as a preliminary implementation.","category":"page"},{"location":"#Install-and-Test-1","page":"Home","title":"Install & Test","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"using Pkg\nPkg.add(\"MeshArrays\")\nPkg.test(\"MeshArrays\")","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Julia's package manager is documented here within docs.julialang.org.","category":"page"},{"location":"#Use-Examples-1","page":"Home","title":"Use Examples","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"using MeshArrays\nGridVariables=GCMGridOnes(\"cs\",6,100)\n(Rini,Rend,DXCsm,DYCsm)= MeshArrays.demo2(GridVariables);","category":"page"},{"location":"#","page":"Home","title":"Home","text":"The above will run an application which integrates lateral diffusion over a simplified global grid generated by GCMGridOnes. Alternatively,","category":"page"},{"location":"#","page":"Home","title":"Home","text":"git clone https://github.com/gaelforget/GRID_LLC90\nGridVariables=GCMGridLoad(GCMGridSpec(\"LLC90\"))","category":"page"},{"location":"#","page":"Home","title":"Home","text":"would download and use a pre-defined global ocean grid, from the MITgcm community, to run the same example with a proper representation of scale factors and continents. For directions to plot results, see the help section of demo2 (?MeshArrays.demo2).","category":"page"},{"location":"API/#API-Guide-1","page":"API","title":"API Guide","text":"","category":"section"},{"location":"API/#","page":"API","title":"API","text":"","category":"page"},{"location":"API/#","page":"API","title":"API","text":"Modules = [MeshArrays]\nOrder   = [:type,:function]","category":"page"},{"location":"API/#MeshArrays.AbstractMeshArray","page":"API","title":"MeshArrays.AbstractMeshArray","text":"AbstractMeshArray{T, N}\n\nSubtype of AbstractArray{T, N}\n\n\n\n\n\n","category":"type"},{"location":"API/#MeshArrays.gcmgrid","page":"API","title":"MeshArrays.gcmgrid","text":"gcmgrid\n\ngcmgrid data structure. Available constructors:\n\ngcmgrid(path::String, class::String, nFaces::Int,\n        fSize::Array{NTuple{2, Int},1}, ioSize::Array{Int64,2},\n        ioPrec::Type, read::Function, write::Function)\n\n\n\n\n\n","category":"type"},{"location":"API/#MeshArrays.GCMGridLoad-Tuple{gcmgrid}","page":"API","title":"MeshArrays.GCMGridLoad","text":"GCMGridLoad(mygrid::gcmgrid)\n\nReturn a Dict of grid variables read from files located in mygrid.path (see ?GCMGridSpec).\n\nBased on the MITgcm naming convention, grid variables are:\n\nXC, XG, YC, YG, AngleCS, AngleSN, hFacC, hFacS, hFacW, Depth.\nRAC, RAW, RAS, RAZ, DXC, DXG, DYC, DYG.\nDRC, DRF, RC, RF (one-dimensional)\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.GCMGridOnes-Tuple{Any,Any,Any}","page":"API","title":"MeshArrays.GCMGridOnes","text":"GCMGridOnes(grTp,nF,nP)\n\nDefine all-ones grid variables instead of using GCMGridSpec & GCMGridLoad.\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.GCMGridSpec","page":"API","title":"MeshArrays.GCMGridSpec","text":"GCMGridSpec(gridName)\n\nReturn a gmcgrid specification that provides grid files path, class, nFaces, ioSize, facesSize, ioPrec, & a read function (not yet) using hard-coded values for \"LLC90\", \"CS32\", \"LL360\" (for now).\n\n\n\n\n\n","category":"function"},{"location":"API/#MeshArrays.LatitudeCircles-Tuple{Any,Dict}","page":"API","title":"MeshArrays.LatitudeCircles","text":"LatitudeCircles(LatValues,GridVariables::Dict)\n\nCompute integration paths that follow latitude circles\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.ThroughFlow-Tuple{Any,Any,Dict}","page":"API","title":"MeshArrays.ThroughFlow","text":"ThroughFlow(VectorField,IntegralPath,GridVariables::Dict)\n\nCompute transport through an integration path\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.convergence-Tuple{MeshArrays.gcmfaces,MeshArrays.gcmfaces}","page":"API","title":"MeshArrays.convergence","text":"convergence(uFLD::MeshArray,vFLD::MeshArray)\n\nCompute convergence of a vector field\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.exchange-Tuple{MeshArrays.gcmfaces}","page":"API","title":"MeshArrays.exchange","text":"exchange(fld::MeshArray)\n\nExchange / transfer data between neighboring arrays. Other methods are\n\nexchange(fld::MeshArray,N::Integer)\nexchange(u::MeshArray,v::MeshArray)\nexchange(u::MeshArray,v::MeshArray,N::Integer)\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.fijind-Tuple{MeshArrays.gcmfaces,Int64}","page":"API","title":"MeshArrays.fijind","text":"fijind(A::gcmfaces,ij::Int)\n\nCompute face and local indices (f,j,k) from global index (ij).\n\n(needed in other types?)\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.findtiles","page":"API","title":"MeshArrays.findtiles","text":"findtiles(ni,nj,grid=\"llc90\")\n\nReturn a MeshArray map of tile indices for tile size ni,nj\n\n\n\n\n\n","category":"function"},{"location":"API/#MeshArrays.gradient-Tuple{MeshArrays.gcmfaces,Dict}","page":"API","title":"MeshArrays.gradient","text":"gradient(inFLD::MeshArray,GridVariables::Dict)\n\nCompute spatial derivatives. Other methods:\n\ngradient(inFLD::MeshArray,GridVariables::Dict,doDIV::Bool)\ngradient(inFLD::MeshArray,iDXC::MeshArray,iDYC::MeshArray)\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.mask-Tuple{MeshArrays.gcmfaces,Number}","page":"API","title":"MeshArrays.mask","text":"mask(fld::MeshArray, val::Number)\n\nReplace non finite values with val. Other methods:\n\nmask(fld::MeshArray)\nmask(fld::MeshArray, val::Number, noval::Number)\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.nFacesEtc-Tuple{MeshArrays.gcmarray}","page":"API","title":"MeshArrays.nFacesEtc","text":"nFacesEtc(a::gcmarray)\n\nReturn nFaces, n3 (1 in 2D case; >1 otherwise)\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.smooth-Tuple{MeshArrays.gcmfaces,MeshArrays.gcmfaces,MeshArrays.gcmfaces,Dict}","page":"API","title":"MeshArrays.smooth","text":"smooth(FLD::MeshArray,DXCsm::MeshArray,DYCsm::MeshArray,GridVariables::Dict)\n\nSmooth out scales below DXCsm / DYCsm via diffusion\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.gcmarray","page":"API","title":"MeshArrays.gcmarray","text":"gcmarray{T, N}\n\ngcmarray data structure. Available constructors:\n\ngcmarray{T,N}(grid::gcmgrid,f::Array{Array{T,N},1},\n         fSize::Array{NTuple{N, Int}},fIndex::Array{Int,1})\ngcmarray(grid::gcmgrid,\n         fSize::Array{NTuple{N, Int}},fIndex::Array{Int,1})\n\ngcmarray(grid::gcmgrid,::Type{T})\ngcmarray(grid::gcmgrid,::Type{T},n3::Int)\n\n\n\n\n\n","category":"type"},{"location":"API/#MeshArrays.gcmfaces","page":"API","title":"MeshArrays.gcmfaces","text":"gcmfaces{T, N}\n\ngcmfaces data structure. Available constructors:\n\ngcmfaces{T,N}(grid::gcmgrid,f::Array{Array{T,N},1},\n         fSize::Array{NTuple{N, Int}}, aSize::NTuple{N,Int})\ngcmfaces(grid::gcmgrid,v1::Array{Array{T,N},1}) where {T,N}\n\ngcmfaces(grid::gcmgrid,::Type{T},\n         fSize::Array{NTuple{N, Int}}, aSize::NTuple{N,Int}) where {T,N}\ngcmfaces(grid::gcmgrid)\ngcmfaces()\n\n\n\n\n\n","category":"type"},{"location":"API/#MeshArrays.gcmsubset","page":"API","title":"MeshArrays.gcmsubset","text":"gcmsubset{T, N}\n\ngcmsubset data structure for subsets of gcmfaces. Available constructors:\n\ngcmsubset{T,N}(grid::gcmgrid,f::Array{Array{T,N},1},\n               fSize::Array{NTuple{N, Int}},aSize::NTuple{N, Int},\n               i::Array{Array{T,N},1},iSize::Array{NTuple{N, Int}})\ngcmsubset(grid::gcmgrid,::Type{T},fSize::Array{NTuple{N, Int}},\n          aSize::NTuple{N,Int},dims::NTuple{N,Int}) where {T,N}\n\n\n\n\n\n","category":"type"},{"location":"API/#Base.read-Tuple{String,MeshArrays.gcmfaces}","page":"API","title":"Base.read","text":"read(fil::String,x::MeshArray)\n\nRead binary file to MeshArray. Other methods:\n\nread(xx::Array,x::MeshArray) #from Array\n\n\n\n\n\n","category":"method"},{"location":"API/#Base.write-Tuple{String,MeshArrays.gcmfaces}","page":"API","title":"Base.write","text":"write(fil::String,x::MeshArray)\n\nWrite MeshArray to binary file. Other methods:\n\nwrite(xx::Array,x::MeshArray) #to Array\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.demo1-Tuple{String}","page":"API","title":"MeshArrays.demo1","text":"demo1(gridChoice::String)\n\nDemonstrate basic functionalities (load grid, arithmetic, exchange, gradient, etc.). Call sequence:\n\n!isdir(\"GRID_LLC90\") ? error(\"missing files\") : nothing\n\n(D,Dexch,Darr,DD)=MeshArrays.demo1(\"LLC90\");\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.demo2-Tuple{}","page":"API","title":"MeshArrays.demo2","text":"demo2()\n\nDemonstrate higher level functions using smooth. Call sequence:\n\n(Rini,Rend,DXCsm,DYCsm)=MeshArrays.demo2();\n\ninclude(joinpath(dirname(pathof(MeshArrays)),\"gcmfaces_plot.jl\"))\nqwckplot(Rini,\"raw noise\")\nqwckplot(Rend,\"smoothed noise\")\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.demo3-Tuple{}","page":"API","title":"MeshArrays.demo3","text":"demo3()\n\nDemonstrate ocean transport computations. Call sequence:\n\n(UV,LC,Tr)=MeshArrays.demo3();\nusing Plots; plot(Tr/1e6,title=\"meridional transport\")\n\ninclude(joinpath(dirname(pathof(MeshArrays)),\"gcmfaces_plot.jl\"))\nqwckplot(UV[\"U\"][:,:,1,1],\"U component (note varying face orientations)\")\nqwckplot(UV[\"V\"][:,:,1,1],\"V component (note varying face orientations)\")\n\n\n\n\n\n","category":"method"},{"location":"API/#MeshArrays.getindexetc-Union{Tuple{N}, Tuple{T}, Tuple{gcmarray{T,N},Vararg{Union{Colon, Int64, AbstractUnitRange},N}}} where N where T","page":"API","title":"MeshArrays.getindexetc","text":"getindexetc(A::gcmarray, I::Vararg{_}) where {T,N}\n\nSame as getindex but also returns the face size and index\n\n(needed in other types?)\n\n\n\n\n\n","category":"method"}]
}
