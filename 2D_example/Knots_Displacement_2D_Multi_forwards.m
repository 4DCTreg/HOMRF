%function Iout=Movepixels_2D_xp(Ln,Mov_or,sl,O_trans_X,O_trans_Y)
% This function movepixels, will translate the pixels of an image
% 
%  Iout = Movepixels_2D_xp(Ln,Mov_or,sl,O_trans_X,O_trans_Y);
%
% Inputs;
%   Ln:        The control point labels
%   Mov_or:    The original Moving image
%   sl:        The labels length of the labels
%   O_trans_X 
%   O_trans_Y: The control grid intial position and end position
%
% Outputs,
%   Iout : The transformed image
%
% Function is written by Peng.X ShanDong University (May 2018)

function Knots=Knots_Displacement_2D_Multi_forwards(Ln,sx,sy,griddim,quant)
sample_space_x=quant(1);
sample_space_y=quant(2);




hx=floor(sx/2);
hy=floor(sy/2);



r=griddim(1);
c=griddim(2);



Knots=zeros(r,c,2);


regisMovnum=reshape(Ln,[r,c]);


Tx=zeros(r,c);Ty=zeros(r,c);
for j=1:c
    for i=1:r

%             intermediate=mod(regisMovnum(i,j),sx);
%             if intermediate==0
%               intermediate=sx;
%             end
            orpy=floor((regisMovnum(i,j)-0.5)/sx)-hy;
            orpx=mod((regisMovnum(i,j)-1),sx)-hx;
            lx=orpx*sample_space_x;
            ly=orpy*sample_space_y;

            

            Ty(i,j)=ly;
            Tx(i,j)=lx;

    end
end
Knots(:,:,1)=Tx;
Knots(:,:,2)=Ty;


end