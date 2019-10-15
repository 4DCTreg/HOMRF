function [x_index,y_index]=Label_Coordinate_2D_tot(x_tot,y_tot)
x_index=zeros(x_tot*y_tot,1);
y_index=zeros(x_tot*y_tot,1);
hy=floor(y_tot/2);
hx=floor(x_tot/2);

for num=1:x_tot*y_tot


     y_index(num)=floor((num-0.5)/x_tot)-hy;
     inter=mod((num-1),x_tot);
     x_index(num)=inter-hx;


end
