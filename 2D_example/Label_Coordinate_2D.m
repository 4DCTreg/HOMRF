function [x_index,y_index]=Label_Coordinate_2D(labels)
x_index=zeros(labels.nlabels,1);
y_index=zeros(labels.nlabels,1);

for num=1:labels.nlabels

    intermediate=mod((num-1),labels.sx);

          x_index(num)=intermediate-labels.hx;

     y_index(num)=floor((num-0.5)/labels.sx)-labels.hy;

end
