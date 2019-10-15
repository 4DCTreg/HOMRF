% Show deformation
function show_deformation(Knots_n_tot,Mov_or)
[rx,ry]=size(Mov_or);
Tx_or=Knots_n_tot(:,:,1);
Ty_or=Knots_n_tot(:,:,2);



Hsmooth=fspecial('gaussian',[5,5],5);
Tx=imfilter(Tx_or,Hsmooth);Ty=imfilter(Ty_or,Hsmooth);

[X,Y]=ndgrid(0:(rx-1),0:(ry-1));
X=X+Tx;
Y=Y+Ty;
% coordinate transformation: matlab to rectangular coordinate
X_rectangular=Y;
Y_rectangular=-X+rx-1;
figure,

for i=1:rx
   x=X_rectangular(i,:);
   y=Y_rectangular(i,:);
  values=spcrv([[x(1) x x(end)];[y(1) y y(end)]],3);
     plot(values(1,:),values(2,:));
     hold on;
end

 for j=1:ry
     
    x=X_rectangular(:,j)';
    y=Y_rectangular(:,j)';
     values=spcrv([[x(1) x x(end)];[y(1) y y(end)]],3);
    plot(values(1,:),values(2,:));
    hold on;
 end
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axis tight
end