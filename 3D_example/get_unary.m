function unary=get_unary(Mov,Fix,sx,sy,sz)
[r,c,s]=size(Mov);
hz=floor(sz/2);
hx=floor(sx/2);
hy=floor(sy/2);

add_hx=hx;
add_hy=hy;
add_hz=hz;
size_orig=[r+(add_hx)*2+1,c+(add_hy)*2+1,s+(add_hz)*2+1];
crop_v=[1+add_hx,r+add_hx;
        1+add_hy,c+add_hy;
        1+add_hz,s+add_hz;];
    weight=100;
    volmovl= uncrop_data_xp_3d(Mov, crop_v, size_orig,weight);
    volfixl= uncrop_data_xp_3d(Fix, crop_v, size_orig,weight);
    
% labels_or.sx=sx_or;
% labels_or.sy=sy_or;
% labels_or.sz=sz_or;
% labels_or.n_each_layer=sx_or*sy_or;
% labels_or.nlabels=sx_or*sy_or*sz_or;
% labels_or.hx=fix(sx_or/2);
% labels_or.hy=fix(sy_or/2);
% labels_or.hz=fix(sz_or/2);
% labels_or_index=trans_labels(previous,sx_or,sy_or,sz_or);

dim_r=r;
dim_c=c;
dim_s=s;
nlabels=sx*sy*sz;
[x_index,y_index,z_index]=Label_Coordinate(sx,sy,sz);
% [x_index_or,y_index_or,z_index_or]=Label_Coordinate(labels_or);

unary=cell(dim_r*dim_c*dim_s,1);
for num=1:dim_r*dim_c*dim_s
    unary_cur=zeros(1,nlabels);

    [i,j,k]=ind2sub([dim_r,dim_c,dim_s],num);
    i=i+add_hx;
    j=j+add_hy;
    k=k+add_hz;
%     i_1=O_trans_X(i,j,k,1)+add_hx;
%     i_2=O_trans_X(i,j,k,2)+add_hx;
%     j_1=O_trans_Y(i,j,k,1)+add_hy;
%     j_2=O_trans_Y(i,j,k,2)+add_hy;
%     k_1=O_trans_Z(i,j,k,1)+add_hz;
%     k_2=O_trans_Z(i,j,k,2)+add_hz;
%     x_width=i_2-i_1+1;
%     y_length=j_2-j_1+1;
%     z_hight=k_2-k_1+1;
%     v_zone=x_width*y_length*z_hight;
    for nlb=1:nlabels
        x_mov=x_index(nlb);
        y_mov=y_index(nlb);
        z_mov=z_index(nlb);
        M=volmovl(i+x_mov,j+y_mov,k+z_mov);
        F=volfixl(i,j,k);
        sad=abs(M-F);
%         lcc=sum(sad(:));
        unary_cur(nlb)=sad;
            
    end
    unary{num}=unary_cur;
end
   unary=cell2mat(unary);
end