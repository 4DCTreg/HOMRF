%function Iout=Movepixels_3D(Ln,Mov,sx,sy,sz,useTop)
% This function movepixels, will translate the pixels of an 3D image
% 
% Inputs;
%   Ln:         The control point labels
%   Mov:        The original Moving image
%   sx:sy;sz;   The labels length of the labels
%   useTop:     save in different .mat files
%
% Outputs,
%   Iout : The transformed image
%
% Function is written by Peng.X ShanDong University (May 2018)

function Mov_next=Movepixel_3D(Ln,Mov,sx,sy,sz,useTop)


n_each_layer=sx*sy;
hz=floor(sz/2);
hx=floor(sx/2);
hy=floor(sy/2);


[r,c,l]=size(Mov);




regisMovnum=reshape(Ln,[r,c,l]);


Tx=zeros(r,c,l);Ty=zeros(r,c,l);Tz=zeros(r,c,l);
for j=1:c
    for i=1:r
        for k=1:l
            orpz=fix((regisMovnum(i,j,k)-1)/n_each_layer)-hz;
            intermediate=mod(regisMovnum(i,j,k),n_each_layer);
            if intermediate==0
              intermediate=n_each_layer;
            end
            orpy=floor((intermediate-0.5)/sx)-hy;
            orpx=mod((intermediate-1),sx)-hx;
            Tz(i,j,k)=orpz;
            Ty(i,j,k)=orpy;
            Tx(i,j,k)=orpx;
        end
    end
end

if useTop==1
    save Tn_to.mat Tx Ty Tz
else
    save Tn.mat Tx Ty Tz
end

Mov_next=zeros(r,c,l);
for i=1:r
    for j=1:c
        for k=1:l
        x_direction=Tx(i,j,k);
        y_direction=Ty(i,j,k);
        z_direction=Tz(i,j,k);
        Mov_next(i,j,k)=Mov(i+x_direction,j+y_direction,k+z_direction);
        end
    end
end
end


