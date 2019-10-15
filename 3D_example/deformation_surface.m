% show the deformation (slice)
clear;
load('Tn_to.mat');
Tx_1=Tx(:,:,8:10);
Ty_1=Ty(:,:,8:10);
Tz_1=-Tz(:,:,8:10);
xp=Tz_1(:,:,2);
xp(find(xp==3))=4;
Tz_1(:,:,2)=xp;
xp=Tz_1(:,:,3);
xp(find(xp==4))=5;
Tz_1(:,:,3)=xp;
Hsmooth=fspecial('gaussian',[5,5],3);
Tx_1(:,:,1)=imfilter(Tx_1(:,:,1),Hsmooth);
Tx_1(:,:,2)=imfilter(Tx_1(:,:,2),Hsmooth);
Tx_1(:,:,3)=imfilter(Tx_1(:,:,3),Hsmooth);

Ty_1(:,:,1)=imfilter(Ty_1(:,:,1),Hsmooth);
Ty_1(:,:,2)=imfilter(Ty_1(:,:,2),Hsmooth);
Ty_1(:,:,3)=imfilter(Ty_1(:,:,3),Hsmooth);

Tz_1(:,:,1)=imfilter(Tz_1(:,:,1),Hsmooth);
Tz_1(:,:,2)=imfilter(Tz_1(:,:,2),Hsmooth);
Tz_1(:,:,3)=imfilter(Tz_1(:,:,3),Hsmooth);

dim_r=33;dim_c=33;
dim_s=3;
[X,Y,Z]=ndgrid(0:(dim_r-1),0:(dim_c-1),0:(dim_s-1));
Z(:,:,1)=Z(:,:,1)+3;
Z(:,:,2)=Z(:,:,2)+1;
Z(:,:,3)=Z(:,:,3)-1;
X=X+Tx_1;
Y=Y+Ty_1;
Z=Z+Tz_1;


% the first slice
x=X(:,:,1);
x_1=x;
y=Y(:,:,1);
y_1=y;
z=Z(:,:,1);
z_1=z;
cdata=cat(3,0.52941*ones(size(x_1)),0.80784*ones(size(y_1)),1*ones(size(y_1)));%color
% cdata=cat(3,0.59608*ones(size(x_1)),0.98431*ones(size(y_1)),0.59608*ones(size(y_1)));%color
surf(x_1,y_1,z_1,cdata);
hold on

% the second slice
x2=X(:,:,2);
x_1=x2;
y2=Y(:,:,2);
y_1=y2;
z2=Z(:,:,2);
z_1=z2;
cdata=cat(3,0.80392*ones(size(x_1)),0.54902*ones(size(y_1)),0.58431*ones(size(y_1)));%color
% cdata=cat(3,0*ones(size(x_1)),0.74902*ones(size(y_1)),1*ones(size(y_1)));%color
surf(x_1,y_1,z_1,cdata);
hold on

% the third slice
x_1=X(:,:,3);
y_1=Y(:,:,3);
z_1=Z(:,:,3);
% cdata=cat(3,1*ones(size(x_1)),0.75686*ones(size(y_1)),0.1451*ones(size(y_1)));%color
cdata=cat(3,0.87843*ones(size(x_1)),1*ones(size(y_1)),1*ones(size(y_1)));
surf(x_1,y_1,z_1,cdata);

axis([0 33 0 33 0 7]);
axis off
view([-61,45]);
% shading flat
% shading interp