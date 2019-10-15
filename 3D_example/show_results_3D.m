function show_results_3D(regis_Mov)
[r,c,l]=size(regis_Mov);
hl=floor(l/2);
hr=floor(r/2);
hc=floor(c/2);
regis_Mov(regis_Mov==0)=NaN;
[x,y,z]=meshgrid(1:r,1:c,1:l);%������Ҫ�����ʵ�壬��ʵ��һ��������

xslice=1:r;%X����Ƭ����
yslice=1:c;%Y...
zslice=1:l;%Z...
h=slice(x,y,z,regis_Mov,[],[],[xslice]);%�����尴��Ҫ�ķ�����
set(h,'LineStyle','none');%���
view(-60,30);%�ۿ��ӽ�
axis equal;%������ȳ���ʾ
alpha(0.5);%����͸����
end