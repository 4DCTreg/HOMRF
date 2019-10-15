
clear;

% Read two greyscale images 
I1=im2double(imread('E:\pape_code\fang.png')); 
I2=im2double(imread('E:\pape_code\yuan.png'));
I1=imresize(I1,[128,128],'nearest');
I2=imresize(I2,[128,128],'nearest');

% Preprocessing two image
Mov_or=I1.*50;
Fix_or=I2.*50;

% Show difference of the image
diff_befor=Mov_or-Fix_or;
% figure,
% imshow(diff_befor,[-25,25]);

% Get the size of original image
[r_or, c_or]=size(I1);

% Set the levels and the size of labels
x_tot=91;
y_tot=91;
nlevel=2;
slh_or=15;
dist=Get_Smooth_tot_2D(x_tot,y_tot);
space=[128,128;256,256];
useTop=1;

% Multi-level processing
for k=nlevel:-1:2
    scale=2^-(k-1);

    dim_r=space(3-k,1);
    dim_c=space(3-k,2);

    slh=slh_or-(2-k);
    sl=slh*2+1;
    grid_space=[1,1;1,1];
    if k~=1
        quant=[1,1];
    else
        quant=[1,1];
    end
    
    labels=Process_labels([sl,sl]);
    
    % Control grid dimensions (in the image)
    griddim=[dim_r dim_c];
    
    % Make the Initial registration control grid
    [O_trans_X,O_trans_Y]=make_init_grid_xp(griddim,size(Mov_or));
    
    if k==nlevel
        Knots_n=zeros(griddim(1),griddim(2),2);
        previous=zeros(griddim(1)*griddim(2),2);
    else
        Knots_n = refine_spline_grid_2D_nl(Knots_n, O_trans_X_or,O_trans_Y_or, O_trans_X,O_trans_Y);
        previous=get_previous_displacement_2D(Knots_n,griddim);
    end
    previous=round(previous);
    O_trans_X_or=O_trans_X;O_trans_Y_or=O_trans_Y;
    labelstot=get_labels_2D(previous,x_tot,y_tot);

    % Get the unary term  
    unary=Get_Data_Term_2D_SAD(Mov_or,Fix_or,griddim,O_trans_X,O_trans_Y,labels,previous,quant);

    % Using the MCMC Method 
%     [Ln]=ICM_2D(griddim,unary,labels,previous,quant,x_tot,y_tot,dist,labelstot,grid_space,k,useTop);
    
    if useTop==0
        [Ln]=MCMC_Smooth(griddim,unary,labels,previous,quant,x_tot,y_tot,dist,labelstot);
    else
        [Ln]=MCMC_Topology(griddim,unary,labels,previous,quant,x_tot,y_tot,dist,labelstot);
    end

    Knots_min=Knots_Displacement_2D_Multi_forwards(Ln,labels.sx,labels.sy,griddim,quant);  
    Knots_n=Knots_n+Knots_min;
    Knots_n_tot = refine_spline_grid_2d(Knots_n,[1,1], size(I1), O_trans_X,O_trans_Y);

end

%%
% Show deformation
Tx_or=Knots_n_tot(:,:,1);
Ty_or=Knots_n_tot(:,:,2);
Iout=movepixels_2d_double(Mov_or,Tx_or,Ty_or,1);

diff=Iout-Fix_or;
figure
subplot(2,2,1), imshow(Mov_or,[1,50]); title('moving image');
subplot(2,2,2), imshow(Fix_or,[1,50]); title('fixed image');
subplot(2,2,3), imshow(Iout,[1,50]); title('registration image');
subplot(2,2,4), imshow(diff,[-25,25]); title('the difference of after');
show_deformation(Knots_n_tot,Mov_or);


