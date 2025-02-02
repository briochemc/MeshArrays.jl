
## gradient methods

"""
    gradient(inFLD::MeshArray,Γ::NamedTuple)

Compute spatial derivatives. Other methods:
```
gradient(inFLD::MeshArray,Γ::NamedTuple,doDIV::Bool)
gradient(inFLD::MeshArray,iDXC::MeshArray,iDYC::MeshArray)
```
"""
function gradient(inFLD::MeshArray,Γ::NamedTuple)
(dFLDdx, dFLDdy)=gradient(inFLD,Γ,true)
return dFLDdx, dFLDdy
end

function gradient(inFLD::MeshArray,Γ::NamedTuple,doDIV::Bool)

exFLD=exchange(inFLD,1)
dFLDdx=similar(inFLD)
dFLDdy=similar(inFLD)

for a=1:inFLD.grid.nFaces
  (s1,s2)=size(exFLD.f[a])
  tmpA=view(exFLD.f[a],2:s1-1,2:s2-1)
  tmpB=tmpA-view(exFLD.f[a],1:s1-2,2:s2-1)
  tmpC=tmpA-view(exFLD.f[a],2:s1-1,1:s2-2)
  if doDIV
    dFLDdx.f[a]=tmpB./Γ.DXC.f[a]
    dFLDdy.f[a]=tmpC./Γ.DYC.f[a]
  else
    dFLDdx.f[a]=tmpB
    dFLDdy.f[a]=tmpC
  end
end

return dFLDdx, dFLDdy
end

function gradient(inFLD::MeshArray,iDXC::MeshArray,iDYC::MeshArray)

exFLD=exchange(inFLD,1)
dFLDdx=similar(inFLD)
dFLDdy=similar(inFLD)

for a=1:inFLD.grid.nFaces
  (s1,s2)=size(exFLD.f[a])
  tmpA=view(exFLD.f[a],2:s1-1,2:s2-1)
  tmpB=tmpA-view(exFLD.f[a],1:s1-2,2:s2-1)
  tmpC=tmpA-view(exFLD.f[a],2:s1-1,1:s2-2)
  dFLDdx.f[a]=tmpB.*iDXC.f[a]
  dFLDdy.f[a]=tmpC.*iDYC.f[a]
end

return dFLDdx, dFLDdy
end

##

"""
    curl(u::MeshArray,v::MeshArray,Γ::NamedTuple)

Compute curl of a velocity field.
"""
function curl(u::MeshArray,v::MeshArray,Γ::NamedTuple)

	uvcurl=similar(Γ.XC)
	fac=exchange(1.0 ./Γ.RAZ,1)
	(U,V)=exchange(u,v,1)
    (DXC,DYC)=exchange(Γ.DXC,Γ.DYC,1)
	[DXC[i].=abs.(DXC[i]) for i in eachindex(U)]
	[DYC[i].=abs.(DYC[i]) for i in eachindex(V)]

	for i in eachindex(U)
    ucur=U[i][2:end,:]
    vcur=V[i][:,2:end]        
    tmpcurl=ucur[:,1:end-1]-ucur[:,2:end]
    tmpcurl=tmpcurl-(vcur[1:end-1,:]-vcur[2:end,:])
    tmpcurl=tmpcurl.*fac[i][1:end-1,1:end-1]

		##still needed:
		##- deal with corners
		##- if putCurlOnTpoints

		tmpcurl=1/4*(tmpcurl[1:end-1,2:end]+tmpcurl[1:end-1,1:end-1]+
					tmpcurl[2:end,2:end]+tmpcurl[2:end,1:end-1])

		uvcurl[i]=tmpcurl
	end
	
	return uvcurl
end

## mask methods

function mask(fld::MeshArray)
fldmsk=mask(fld,NaN)
return fldmsk
end

"""
    mask(fld::MeshArray, val::Number)

Replace non finite values with val. Other methods:
```
mask(fld::MeshArray)
mask(fld::MeshArray, val::Number, noval::Number)
```
"""
function mask(fld::MeshArray, val::Number)
  fldmsk=similar(fld)
  for a=1:fld.grid.nFaces
    tmp1=copy(fld.f[a])
    replace!(x -> !isfinite(x) ? val : x, tmp1 )
    fldmsk.f[a]=tmp1
  end
  return fldmsk
end

function mask(fld::MeshArray, val::Number, noval::Number)
  fldmsk=similar(fld)
  for a=1:fld.grid.nFaces
    tmp1=copy(fld.f[a])
    replace!(x -> x==noval ? val : x, tmp1  )
    fldmsk.f[a]=tmp1
  end
  return fldmsk
end

## convergence methods

"""
    convergence(uFLD::MeshArray,vFLD::MeshArray)

Compute convergence of a vector field
"""
function convergence(uFLD::MeshArray,vFLD::MeshArray)

#important note:
#  Normally uFLD, vFLD should not contain any NaN;
#  if otherwise then something this may be needed:
#  uFLD=mask(uFLD,0.0); vFLD=mask(vFLD,0.0);

CONV=similar(uFLD)

(tmpU,tmpV)=exch_UV(uFLD,vFLD)
for a=1:tmpU.grid.nFaces
  (s1,s2)=size(uFLD.f[a])
  tmpU1=view(tmpU.f[a],1:s1,1:s2)
  tmpU2=view(tmpU.f[a],2:s1+1,1:s2)
  tmpV1=view(tmpV.f[a],1:s1,1:s2)
  tmpV2=view(tmpV.f[a],1:s1,2:s2+1)
  CONV.f[a]=tmpU1-tmpU2+tmpV1-tmpV2
end

return CONV
end

## smooth function

"""
    smooth(FLD::MeshArray,DXCsm::MeshArray,DYCsm::MeshArray,Γ::NamedTuple)

Smooth out scales below DXCsm / DYCsm via diffusion
"""
function smooth(FLD::MeshArray,DXCsm::MeshArray,DYCsm::MeshArray,Γ::NamedTuple)

#important note:
#input FLD should be land masked (NaN/1) by caller if needed

#get land masks (NaN/1):
mskC=fill(1.0,FLD) + 0.0 * mask(FLD)
(mskW,mskS)=gradient(FLD,Γ,false)
mskW=fill(1.0,FLD) + 0.0 * mask(mskW)
mskS=fill(1.0,FLD) + 0.0 * mask(mskS)

#replace NaN with 0. in FLD and land masks:
FLD=mask(FLD,0.0)
mskC=mask(mskC,0.0)
mskW=mask(mskW,0.0)
mskS=mask(mskS,0.0)

#get inverse grid spacing:
iDXC=similar(FLD)
iDYC=similar(FLD)
for a=1:FLD.grid.nFaces
  iDXC.f[a]=1.0./Γ.DXC.f[a]
  iDYC.f[a]=1.0./Γ.DYC.f[a]
end

#Before scaling the diffusive operator ...
tmp0=DXCsm*iDXC*mskW;
tmp00=maximum(tmp0);
tmp0=DYCsm*iDYC*mskS;
tmp00=max(tmp00,maximum(tmp0));

#... determine a suitable time period:
nbt=ceil(1.1*2*tmp00^2);
dt=1.;
T=nbt*dt;
#println("nbt="*"$nbt")

#diffusion operator times DYG / DXG
KuxFac=mskW*DXCsm*DXCsm/T/2.0*Γ.DYG
KvyFac=mskS*DYCsm*DYCsm/T/2.0*Γ.DXG

#time steping factor:
dtFac=dt*mskC/Γ.RAC

#loop:
for it=1:nbt
  (dTdxAtU,dTdyAtV)=gradient(FLD,iDXC,iDYC);
  tmpU=similar(FLD)
  tmpV=similar(FLD)
  for a=1:FLD.grid.nFaces
      tmpU.f[a]=dTdxAtU.f[a].*KuxFac.f[a];
      tmpV.f[a]=dTdyAtV.f[a].*KvyFac.f[a];
  end
  tmpC=convergence(tmpU,tmpV);
  for a=1:FLD.grid.nFaces
      FLD.f[a]=FLD.f[a]-dtFac.f[a].*tmpC.f[a];
  end
end

#Apply land mask (NaN/1) to end result:
mskC=mask(mskC,NaN,0.0)
FLD=mskC*FLD

return FLD

end

## ThroughFlow function

"""
    ThroughFlow(VectorField,IntegralPath,Γ::NamedTuple)

Compute transport through an integration path
"""
function ThroughFlow(VectorField,IntegralPath,Γ::NamedTuple)

    #Note: vertical intergration is not always wanted; left for user to do outside

    U=VectorField["U"]
    V=VectorField["V"]

    nd=ndims(U)
    #println("nd=$nd and d=$d")

    n=fill(1,4)
    tmp=size(U)
    n[1:nd].=tmp[1:nd]

    haskey(VectorField,"factors") ? f=VectorField["factors"] : f=Array{String,1}(undef,0)
    haskey(VectorField,"dimensions") ? d=VectorField["dimensions"] : d=Array{String,1}(undef,nd)

    #a bit of a hack to distinguish gcmfaces v gcmarray indexing:
    isdefined(U,:fIndex) ? ndoffset=1 : ndoffset=0
    length(d)!=nd+ndoffset ? error("inconsistent specification of dims") : nothing

    trsp=Array{Float64}(undef,1,n[3],n[4])
    do_dz=sum(f.=="dz")
    do_dxory=sum(f.=="dxory")

    for i3=1:n[3]
        #method 1: quite slow
        #mskW=IntegralPath.mskW
        #do_dxory==1 ? mskW=mskW*Γ.DYG : nothing
        #do_dz==1 ? mskW=Γ.DRF[i3]*mskW : nothing
        #mskS=IntegralPath.mskS
        #do_dxory==1 ? mskS=mskS*Γ.DXG : nothing
        #do_dz==1 ? mskS=Γ.DRF[i3]*mskS : nothing
        #
        #method 2: less slow
        tabW=IntegralPath.tabW
        tabS=IntegralPath.tabS
        for i4=1:n[4]
            #method 1: quite slow
            #trsp[1,i3,i4]=sum(mskW*U[:,:,i3,i4])+sum(mskS*V[:,:,i3,i4])
            #
            #method 2: less slow
            trsp[1,i3,i4]=0.0
            for k=1:size(tabW,1)
                (a,i1,i2,w)=tabW[k,:]
                do_dxory==1 ? w=w*Γ.DYG.f[a][i1,i2] : nothing
                do_dz==1 ? w=w*Γ.DRF[i3] : nothing
                isdefined(U,:fIndex) ? u=U.f[a,i3,i4][i1,i2] : u=U.f[a][i1,i2,i3,i4]
                trsp[1,i3,i4]=trsp[1,i3,i4]+w*u
            end
            for k=1:size(tabS,1)
                (a,i1,i2,w)=tabS[k,:]
                do_dxory==1 ? w=w*Γ.DXG.f[a][i1,i2] : nothing
                do_dz==1 ? w=w*Γ.DRF[i3] : nothing
                isdefined(V,:fIndex) ? v=V.f[a,i3,i4][i1,i2] : v=V.f[a][i1,i2,i3,i4]
                trsp[1,i3,i4]=trsp[1,i3,i4]+w*v
            end
        end
    end

    nd+ndoffset<4 ? trsp=dropdims(trsp,dims=3) : nothing
    nd+ndoffset<3 ? trsp=dropdims(trsp,dims=2) : nothing
    nd+ndoffset==2 ? trsp=trsp[1] : nothing

    return trsp
end

## LatitudeCircles function

"""
    LatitudeCircles(LatValues,Γ::NamedTuple)

Compute integration paths that follow latitude circles
"""
function LatitudeCircles(LatValues,Γ::NamedTuple)
    LatitudeCircles=Array{NamedTuple}(undef,length(LatValues))
    for j=1:length(LatValues)
        mskCint=1*(Γ.YC .>= LatValues[j])
        mskC,mskW,mskS=edge_mask(mskCint)
        LatitudeCircles[j]=(lat=LatValues[j],
        tabC=MskToTab(mskC),tabW=MskToTab(mskW),tabS=MskToTab(mskS))
    end
    return LatitudeCircles
end

function MskToTab(msk::MeshArray)
  n=Int(sum(msk .!= 0)); k=0
  tab=Array{Int,2}(undef,n,4)
  for i in eachindex(msk)
    a=msk[i]
    b=findall( a .!= 0)
    for ii in eachindex(b)
      k += 1
      tab[k,:]=[i,b[ii][1],b[ii][2],a[b[ii]]]
    end
  end
  return tab
end

"""
    edge_mask(mskCint::MeshArray)

Compute edge mask (mskC,mskW,mskS) from domain interior mask (mskCint). 
This is used in `LatitudeCircles` and `Transect`.
"""
function edge_mask(mskCint::MeshArray)
  mskCint=1.0*mskCint

  #treat the case of blank tiles:
  #mskCint[findall(RAC.==0)].=NaN
  
  mskC=similar(mskCint)
  mskW=similar(mskCint)
  mskS=similar(mskCint)

  mskCint=exchange(mskCint,1)

  for i in eachindex(mskCint)
      tmp1=mskCint[i]
      # tracer mask:
      tmp2=tmp1[2:end-1,1:end-2]+tmp1[2:end-1,3:end]+
      tmp1[1:end-2,2:end-1]+tmp1[3:end,2:end-1]
      mskC[i]=1((tmp2.>0).&(tmp1[2:end-1,2:end-1].==0))
      # velocity masks:
      mskW[i]=tmp1[2:end-1,2:end-1] - tmp1[1:end-2,2:end-1]
      mskS[i]=tmp1[2:end-1,2:end-1] - tmp1[2:end-1,1:end-2]
  end

  #treat the case of blank tiles:
  #mskC[findall(isnan.(mskC))].=0.0
  #mskW[findall(isnan.(mskW))].=0.0
  #mskS[findall(isnan.(mskS))].=0.0

  return mskC,mskW,mskS
end

##

"""
    Transect(name,lons,lats,Γ)

Compute integration paths that follow a great circle between two geolocations give by `lons`, `lats`.
"""
function Transect(name,lons,lats,Γ)
  x0,y0,z0,R=rotate_points(lons,lats)
  x,y,z=rotate_XCYC(Γ,R)
  mskCint=1.0*(z.>0)
  mskCedge,mskWedge,mskSedge=edge_mask(mskCint)
  mskCedge,mskWedge,mskSedge=shorter_paths!((x,y,z),(x0,y0,z0),(mskCedge,mskWedge,mskSedge))
  tabC=MskToTab(mskCedge)
  tabW=MskToTab(mskWedge)
  tabS=MskToTab(mskSedge)
  return (name=name,tabC=tabC,tabW=tabW,tabS=tabS)
end

##

nanmean(x) = mean(filter(!isnan,x))
nanmean(x,y) = mapslices(nanmean,x,dims=y)

"""
    UVtoUEVN(u,v,G::NamedTuple)

1. Interpolate to grid cell centers (uC,vC)
2. Convert to `Eastward/Northward` components (uE,vN)
"""
function UVtoUEVN(u::MeshArray,v::MeshArray,G::NamedTuple)
    u[findall(G.hFacW[:,1].==0)].=NaN
    v[findall(G.hFacS[:,1].==0)].=NaN

    (u,v)=exch_UV(u,v); uC=similar(u); vC=similar(v)
    for iF=1:u.grid.nFaces
        tmp1=u[iF][1:end-1,:]; tmp2=u[iF][2:end,:]
        uC[iF]=reshape(nanmean([tmp1[:] tmp2[:]],2),size(tmp1))
        tmp1=v[iF][:,1:end-1]; tmp2=v[iF][:,2:end]
        vC[iF]=reshape(nanmean([tmp1[:] tmp2[:]],2),size(tmp1))
    end

    return uC.*G.AngleCS-vC.*G.AngleSN, uC.*G.AngleSN+vC.*G.AngleCS
end

"""
    UVtoTransport(U,V,G::NamedTuple)

Convert e.g. velocity (m/s) to transport (m^3/s) by multiplying by `DRF` and `DXG`,`DYG`.
"""
function UVtoTransport(U::MeshArray,V::MeshArray,G::NamedTuple)
  uTr=deepcopy(U)
  vTr=deepcopy(V)
  for i in eachindex(U)
      tmp1=U[i]; tmp1[(!isfinite).(tmp1)] .= 0.0
      tmp1=V[i]; tmp1[(!isfinite).(tmp1)] .= 0.0
      uTr[i]=G.DRF[i[2]]*U[i].*G.DYG[i[1]]
      vTr[i]=G.DRF[i[2]]*V[i].*G.DXG[i[1]]
  end
  return uTr,vTr
end
