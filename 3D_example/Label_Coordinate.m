function [x_index,y_index,z_index]=Label_Coordinate(sx,sy,sz)
nlabels=sx*sy*sz;
n_each_layer=sx*sy;
hz=floor(sz/2);
hx=floor(sx/2);
hy=floor(sy/2);
x_index=zeros(nlabels,1);
y_index=zeros(nlabels,1);
z_index=zeros(nlabels,1);
for num=1:nlabels
    z_index(num)=fix((num-1)/n_each_layer)-hz;
    intermediate=mod(num,n_each_layer);
      if intermediate==0
          
          intermediate=n_each_layer;
      end
     y_index(num)=floor((intermediate-0.5)/sx)-hy;
     x_index(num)=mod((intermediate-1),sx)-hx;
end
