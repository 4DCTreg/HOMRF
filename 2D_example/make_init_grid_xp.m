
function [O_trans_X,O_trans_Y]=make_init_grid_xp(sizeG,sizeI)
% This function creates a uniform 2d or 3D b-spline control grid
% O=make_init_grid(sizeG,sizeI)
% 
%  inputs,
%    sizeG: vector with the size of the grid (the real grid output will
%           +2 larger than sizeG, because of grid outside the image)
%    sizeI: vector with the sizes of the image which will be transformed
%  
%  outputs,
%    O: Uniform control grid
%
%
%  Function is written by Peng.X ShanDong University (July 2018)
  
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
    dx=(sizeI(1)-1)/(sizeG(1)-1);
    dy=(sizeI(2)-1)/(sizeG(2)-1);
    dz=(sizeI(3)-1)/(sizeG(3)-1);
    
    % Calculate te grid coordinates (make the grid)
    [X,Y,Z]=ndgrid(-dx:dx:(sizeI(1)-1)+dx,-dy:dy:(sizeI(2)-1)+dy,-dz:dz:(sizeI(3)-1)+dz);
    O_trans=ones(sizeG(1)+2,sizeG(2)+2,sizeG(3)+2,2);
    O_trans(:,:,:,1)=X;
    O_trans(:,:,:,2)=Y;
    O_trans(:,:,:,3)=Z;
end
end