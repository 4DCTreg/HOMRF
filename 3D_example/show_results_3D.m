function show_results_3D(regis_Mov)
[r,c,l]=size(regis_Mov);
hl=floor(l/2);
hr=floor(r/2);
hc=floor(c/2);
regis_Mov(regis_Mov==0)=NaN;
[x,y,z]=meshgrid(1:r,1:c,1:l);%建立需要的填充实体，其实是一个正方体

xslice=1:r;%X轴切片向量
yslice=1:c;%Y...
zslice=1:l;%Z...
h=slice(x,y,z,regis_Mov,[],[],[xslice]);%将球体按需要的方向切
set(h,'LineStyle','none');%填充
view(-60,30);%观看视角
axis equal;%坐标轴等长显示
alpha(0.5);%设置透明度
end