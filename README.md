# MeshArrays.jl

[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliaclimate.github.io/MeshArrays.jl/dev)
[![codecov](https://codecov.io/gh/juliaclimate/MeshArrays.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/juliaclimate/MeshArrays.jl)
[![CI](https://github.com/juliaclimate/MeshArrays.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/juliaclimate/MeshArrays.jl/actions/workflows/ci.yml)

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/JuliaClimate/MeshArrays.jl/master)
[![DOI](https://zenodo.org/badge/143987632.svg)](https://zenodo.org/badge/latestdoi/143987632)


**MeshArrays.jl** defines the `MeshArray` data structure (or type) that can contain, distribute, etc., collections of inter-connected arrays as generally done in climate models. This provides a simple yet efficient and general way to e.g. analyze climate system simulations and manipulate their output.

See the [Docs](https://juliaclimate.github.io/MeshArrays.jl/dev/) and [Tutorials](https://juliaclimate.github.io/MeshArrays.jl/dev/tutorials/) for more detailed information.

```
struct gcmarray{T, N} <: AbstractMeshArray{T, N}
   grid::gcmgrid
   meta::varmeta
   f::Array{Array{T,2},N}
   fSize::Array{NTuple{2, Int}}
   fIndex::Array{Int,1}
   version::String
end
```

Some features and related packages:

- interpolate to geographic coordinates and visualize as maps
- accurately derive planetary scale transports on a global ocean model [C-grid](https://en.wikipedia.org/wiki/Arakawa_grids)
- efficiently compute trajectories of ocean plastic, plankton, etc over any supported C-grid configuration using `MeshArrays.jl` along with [IndividualDisplacements.jl](https://github.com/JuliaClimate/IndividualDisplacements.jl)
- reading and writing files in [Netcdf](https://en.wikipedia.org/wiki/NetCDF) ([CF-compliant](http://cfconventions.org)), CSV, or binary formats often used in climate sciences. [NCTiles.jl](https://gaelforget.github.io/NCTiles.jl/stable/) readily supports domain decomposition with `MeshArray.jl`
- support for the analysis of [MITgcm](https://mitgcm.readthedocs.io/en/latest/) model ouput and optimized, [state estimate](https://doi.org/10.5194/gmd-8-3071-2015) solutions are provided via [MITgcmTools.jl](https://github.com/gaelforget/MITgcmTools.jl) and [OceanStateEstimation.jl](https://github.com/gaelforget/OceanStateEstimation.jl), with interfaces in `MeshArray.jl`

`MeshArrays.jl` was first introduced as as _gcmfaces.jl_ in [this presentation](https://youtu.be/RDxAy_zSUvg) at JuliaCon 2018.

| | | |
|:-------------------------------------:|:-------------------------------------:|:-------------------------------------:|
| <img src="https://user-images.githubusercontent.com/20276764/84893715-abe42180-b06d-11ea-92d3-173b678a701e.png" width="200" height="120"> | <img src="https://user-images.githubusercontent.com/20276764/137231635-fdd12de0-29fe-45d4-9045-60621668e353.png" width="200" height="120"> | <img src="https://user-images.githubusercontent.com/20276764/144332405-ed8d163f-04b9-408a-8fd0-08d91e9be91b.png" width="200" height="120"> |
| <img src="https://user-images.githubusercontent.com/20276764/144249899-4d94980a-87aa-4bfb-a6d6-6145f9f0324f.png" width="150" height="120"> | <img src="https://user-images.githubusercontent.com/20276764/144878637-1412679c-f1e6-4491-a8f1-43d729aa224d.png" width="150" height="120"> | <img src="https://user-images.githubusercontent.com/20276764/144878668-5b681d5e-79b1-45e0-99d0-f80d2afeba8c.png" width="150" height="120">


