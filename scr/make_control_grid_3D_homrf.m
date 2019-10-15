
function [O_trans_X,O_trans_Y,O_trans_Z,dx,dy,dz]=make_control_grid_3D_homrf(sizeG,sizeI)

  
if(length(sizeG)==2)
    % Determine grid spacing
    dx=sizeI(1)/sizeG(1);
    dy=sizeI(2)/sizeG(2);

    % Calculate te grid coordinates (make the grid)
    [X_1,Y_1]=ndgrid(1:dx:sizeI(1),1:dy:sizeI(2));
    X_1=fix(X_1);
    Y_1=fix(Y_1);
    [X_2,Y_2]=ndgrid(dx:dx:sizeI(1),dy:dy:sizeI(2));
    X_2=ceil(X_2);
    Y_2=ceil(Y_2);

     O_trans_X(:,:,1)=X_1;
     O_trans_X(:,:,2)=X_2;
     O_trans_Y(:,:,1)=Y_1;
     O_trans_Y(:,:,2)=Y_2;
else
    % Determine grid spacing
%     dx=ceil(sizeI(1)/sizeG(1));
%     dy=ceil(sizeI(2)/sizeG(2));
%     dz=ceil(sizeI(3)/sizeG(3));
    dx=sizeG(1);
    dy=sizeG(2);
    dz=sizeG(3);
    x_1=(1:dx:sizeI(1));
    y_1=(1:dy:sizeI(2));
    z_1=(1:dz:sizeI(3));
    x_2=(dx:dx:sizeI(1));
    y_2=(dy:dy:sizeI(2));
    z_2=(dz:dz:sizeI(3));
        if length(x_1)~=length(x_2)
            x_2(length(x_1))=sizeI(1);
        end
      if length(y_1)~=length(y_2)
            y_2(length(y_1))=sizeI(2);
      end
      if length(z_1)~=length(z_2)
            z_2(length(z_1))=sizeI(3);
      end

    % Calculate te grid coordinates (make the grid)
    [X_1,Y_1,Z_1]=ndgrid(x_1,y_1,z_1);
    X_1=fix(X_1);
    Y_1=fix(Y_1);
    Z_1=fix(Z_1);

    
    [X_2,Y_2,Z_2]=ndgrid(x_2,y_2,z_2);
    X_2=ceil(X_2);
    Y_2=ceil(Y_2);
    Z_2=fix(Z_2);


    O_trans_X(:,:,:,1)=X_1;
    O_trans_X(:,:,:,2)=X_2;
    O_trans_Y(:,:,:,1)=Y_1;
    O_trans_Y(:,:,:,2)=Y_2;
    O_trans_Z(:,:,:,1)=Z_1;
    O_trans_Z(:,:,:,2)=Z_2;
end
end