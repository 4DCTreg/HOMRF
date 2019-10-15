function dist=Get_Smooth_Term(sx,sy,sz)
dis_max=floor(sqrt((sx-1)^2+(sy-1)^2+(sz-1)^2))-1;
dist=zeros(sx*sy*sz,sx*sy*sz);
for r=1:sx*sy*sz
    z1=-fix((r-1)/(sx*sy))+floor(sz/2);
    intermediate=mod(r,sx*sy);
    if intermediate==0
        intermediate=sx*sy;
    end
    x1=mod((intermediate-1),sy)-floor(sx/2);
    y1=floor((intermediate-0.5)/sx)-floor(sy/2);
    for c=1:sx*sy*sz
        z2=-fix((c-1)/(sx*sy))+floor(sz/2);
        intermediate=mod(c,sx*sy);
        if intermediate==0
           intermediate=sx*sy;
        end
        x2=mod((intermediate-1),sy)-floor(sx/2);
        y2=floor((intermediate-0.5)/sx)-floor(sy/2);
        dis_diff=sqrt((x1-x2)^2+(y1-y2)^2+(z1-z2)^2);
        if dis_diff>=dis_max
            dist(r,c)=dis_max;
        else
        
        dist(r,c)=sqrt((x1-x2)^2+(y1-y2)^2+(z1-z2)^2);
        end
        
    end
end
end