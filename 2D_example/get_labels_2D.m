function labelstot=get_labels_2D(previous,x_tot,y_tot)
labelstot=zeros(size(previous,1),1);
x_h=fix(x_tot/2)+1;
y_h=fix(y_tot/2)+1;

for n=1:size(previous,1)
    x_index=x_h+previous(n,1);
    y_index=y_h+previous(n,2);

    labelstot(n)=sub2ind([x_tot,y_tot],x_index,y_index);
end
end