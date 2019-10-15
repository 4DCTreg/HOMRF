function dist=Get_Smooth_tot_2D(sx,sy)

nlabels=sx*sy;
dist=zeros(nlabels,nlabels);

slh=fix(sx/2);
for i=1:nlabels
    for j=1:nlabels
        xi=-fix((i-1)/sx)+slh;
        yi=mod((i-1),sx)-slh;
        
        
        xj=-fix((j-1)/sx)+slh; 
        yj=mod((j-1),sx)-slh;
   
        dist(i,j)=sqrt((xi-xj)^2+(yi-yj)^2);
    end
end
end