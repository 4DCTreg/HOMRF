function [Tx_or,Ty_or]=get_deformation(I1,Tx,Ty,O_trans_X,O_trans_Y)
[r_or,c_or]=size(I1);


[r,c]=size(O_trans_X(:,:,1));

Tx_or=zeros(r_or,c_or);
Ty_or=zeros(r_or,c_or);


for i=1:r
    for j=1:c
        x_init=O_trans_X(i,j,1);
        x_end=O_trans_X(i,j,2);
        y_init=O_trans_Y(i,j,1);
        y_end=O_trans_Y(i,j,2);
        Tx_or(x_init:x_end,y_init:y_end)=Tx(i,j);
        Ty_or(x_init:x_end,y_init:y_end)=Ty(i,j);


    end
end

end