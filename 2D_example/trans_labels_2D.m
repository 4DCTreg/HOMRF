function labels_or=trans_labels_2D(previous,sx_or,sy_or)
labels_or=zeros(size(previous,1),1);
slh_x=fix(sx_or/2);
slh_y=fix(sy_or/2);

for i=1:size(previous,1)
    
    x_index=previous(i,1)+slh_x+1;
    y_index=previous(i,2)+slh_y+1;

    labels_or(i)=sub2ind([sx_or,sy_or],x_index,y_index);
end
end