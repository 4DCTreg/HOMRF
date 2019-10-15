
function unary=Get_Data_Term_2D_SAD(Mov,Fix,griddim,O_trans_X,O_trans_Y,labels,previous,quant)

[r,c]=size(Mov);
sample_space_x=quant(1);
sample_space_y=quant(2);

min_max=[min(previous,[],1)',max(previous,[],1)'];
min_max=abs(round(min_max));
shx_or=max(min_max(1,:));
shy_or=max(min_max(2,:));

sx_or=max(min_max(1,:))*2+1;
sy_or=max(min_max(2,:))*2+1;

add_hx=shx_or+labels.hx*sample_space_x;
add_hy=shy_or+labels.hy*sample_space_y;

size_orig=[r+(add_hx)*2+1,c+(add_hy)*2+1];
crop_v=[1+add_hx,r+add_hx;
        1+add_hy,c+add_hy;];
weight=100;
volmovl= uncrop_data_xp_2d(Mov, crop_v, size_orig,weight);
volfixl= uncrop_data_xp_2d(Fix, crop_v, size_orig,weight);
    
labels_or.sx=sx_or;
labels_or.sy=sy_or;


labels_or.nlabels=sx_or*sy_or;
labels_or.hx=fix(sx_or/2);
labels_or.hy=fix(sy_or/2);

labels_or_index=trans_labels_2D(previous,sx_or,sy_or);

dim_r=griddim(1);
dim_c=griddim(2);

[x_index,y_index]=Label_Coordinate_2D(labels);
[x_index_or,y_index_or]=Label_Coordinate_2D(labels_or);
%  index_xp=(1:100:sx_or*sy_or*sz_or);
%  index_tot=cell(1,1000);
% parpool;
unary=cell(dim_r*dim_c,1);
for num=1:dim_r*dim_c
    unary_cur=zeros(1,labels.nlabels);
    previous_label=labels_or_index(num);
    [i,j]=ind2sub([dim_r,dim_c],num);
    i_1=O_trans_X(i,j,1)+add_hx;
    i_2=O_trans_X(i,j,2)+add_hx;
    j_1=O_trans_Y(i,j,1)+add_hy;
    j_2=O_trans_Y(i,j,2)+add_hy;

    x_width=i_2-i_1+1;
    y_length=j_2-j_1+1;

    v_zone=x_width*y_length;
    for nlb=1:labels.nlabels
        x_mov=x_index(nlb)*sample_space_x+x_index_or(previous_label);
        y_mov=y_index(nlb)*sample_space_y+y_index_or(previous_label);

        M=volmovl(i_1+x_mov:i_2+x_mov,j_1+y_mov:j_2+y_mov);
        F=volfixl(i_1:i_2,j_1:j_2);
%         lcc=(1-lcc_3d(M,F))*50;
        sad=abs(M-F);
        lcc=sum(sad(:))/v_zone;
        unary_cur(nlb)=lcc;
            
    end
    unary{num}=unary_cur;
end
   unary=cell2mat(unary);
end


