
## read_bin function with full list of argument

"""
    read_bin(fil::String,kt,kk,prec::DataType)

Read model output from binary file and convert to gcmfaces structure. Other methods:

```
read_bin(fil::String,prec::DataType)
read_bin(fil::String)
```
"""
function read_bin(fil::String,kt,kk,prec::DataType)

  if ~isempty(kt);
    error("non-empty kt option not implemented yet");
  end;

  if ~isempty(kk);
    error("non-empty kk option not implemented yet");
  end;

  mygrid=gcmgrid(MeshArrays.grDir, MeshArrays.grTopo, MeshArrays.nFaces,
                 MeshArrays.facesSize, MeshArrays.ioSize, MeshArrays.ioPrec,
                 x -> missing)

  (n1,n2)=mygrid.ioSize

  if prec==Float64;
    reclen=8;
  else;
    reclen=4;
  end;
  tmp1=stat(fil);
  n3=Int64(tmp1.size/n1/n2/reclen);

  fid = open(fil);
  fld = Array{prec,1}(undef,(n1*n2*n3));
  read!(fid,fld);
  fld = hton.(fld);

  n3>1 ? s=(n1,n2,n3) : s=(n1,n2)
  v0=reshape(fld,s);

  convert2gcmfaces(v0,mygrid)

end

## read_bin function with reduced list of argument

function read_bin(fil::String,prec::DataType)
  read_bin(fil,[],[],prec)
end

## read_bin function with reduced list of argument

function read_bin(fil::String)
  read_bin(fil,[],[],Float32)
end
