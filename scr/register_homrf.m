function [Tptv_rsz]=register_homrf(parameter,volmov,volfix,crop_v,init_size,pts_fix,pts_mov)

nlevel=parameter.nlevel;
k_down=parameter.k_down;
x_tot=parameter.x_tot;
y_tot=parameter.y_tot;
z_tot=parameter.z_tot;

useTop=parameter.useTop;
grid_space=parameter.grid_space;
metric=parameter.metric;
labels_search=parameter.labels;
presmooth=parameter.presmooth;
quant=parameter.quant;
smooth_co=parameter.smooth_co;
endl=parameter.end;
Tcoe_n=parameter.Tcoe_n;
top_co=parameter.top_co;
spc=parameter.spc;
spc_orig = spc;
resize=parameter.resize;
dist_co=parameter.dist_co;
if resize==1
        bszv = size(volmov);
        spc_tmp = [1, 1, 1];
        volfix = volresize(volfix, round(bszv .* spc .* spc_tmp), 1);
        volmov = volresize(volmov, round(bszv .* spc .* spc_tmp), 1);
        spc = [1,1,1] ./ spc_tmp;
end
if presmooth==1
    dist=Get_Smooth_tot(x_tot,y_tot,z_tot,spc);

    if useTop==1
        dist=dist./dist_co;
    else
        dist=dist./dist_co;
    end
        
else
    dist=[];
end

    grid_sz=zeros(nlevel,3);
    count_jaco=zeros(nlevel,1);
    TRE_current=zeros(nlevel,1);
    STD_cur=zeros(nlevel,1);
for level=nlevel:-1:endl
    labels=DIR_Process_labels(labels_search,level);
        
    % Current Grid Size
    cur_grid_space=grid_space(level,:);

    % Make the registration control grid 
    [O_trans_X,O_trans_Y,O_trans_Z,dx,dy,dz]=make_control_grid_3D_homrf(cur_grid_space,size(volmov));
    % Control grid dimensions (in the image)
    griddim=[size(O_trans_X,1),size(O_trans_X,2),size(O_trans_X,3)];
    grid_sz(level,:)=griddim;
    
    if level==nlevel
        Knots_n=zeros(griddim(1),griddim(2),griddim(3),3);
        previous=zeros(griddim(1)*griddim(2)*griddim(3),3);
    else 
        Knots_n = refine_spline_grid_3D_nl(Knots_n, O_trans_X_or,O_trans_Y_or,O_trans_Z_or, O_trans_X,O_trans_Y,O_trans_Z);
        previous=get_previous_displacement(Knots_n,griddim);
            
    end
    previous=round(previous);
    labelstot=get_labels(previous,x_tot,y_tot,z_tot);
    O_trans_X_or=O_trans_X;O_trans_Y_or=O_trans_Y;O_trans_Z_or=O_trans_Z;
        
    % Get the neighbor
     neighbor=Get_Neighbor_18(griddim(1),griddim(2),griddim(3));
%      neighbor=Get_Neighbor_6(griddim(1),griddim(2),griddim(3));
    % Get the unary term
    unary=Get_Data_Term_3D(volmov,volfix,griddim,O_trans_X,O_trans_Y,O_trans_Z,labels,level,previous,quant,metric);

    [Ln,labelstot_Jaco]=MCMC_3D_Topology(labels,dist,dist_co,neighbor,griddim,unary,level,k_down,useTop,previous,x_tot,y_tot,z_tot,labelstot,grid_space,spc,quant,smooth_co,Tcoe_n,top_co);
%     [Ln,labelstot_Jaco] = UGM_Decode_ICM_3D(labels,dist,dist_co,neighbor,griddim,unary,level,k_down,useTop,previous,x_tot,y_tot,z_tot,labelstot,grid_space,spc,quant,smooth_co,Tcoe_n,top_co);
%     [Ln,labelstot_Jaco] = UGM_Decode_ICM_3D_cityblock(labels,dist,dist_co,neighbor,griddim,unary,level,k_down,useTop,previous,x_tot,y_tot,z_tot,labelstot,grid_space,spc,quant,smooth_co,Tcoe_n,top_co);

    Knots_min=Knots_Displacement_3D_Multi_forwards(Ln,labels.sx,labels.sy,labels.sz,griddim,level,quant);        
    Knots_n=Knots_n+Knots_min;
%     [count_Jaco,count1]=calculate_Jaco(neighbor,griddim,level,x_tot,y_tot,z_tot,labelstot_Jaco,grid_space,spc);
%     count_jaco(level)=count1;
    Knots_n_tot = refine_spline_grid_3d(Knots_n,[1,1,1], size(volmov), O_trans_X,O_trans_Y,O_trans_Z);
    if resize
       Tptv_rsz = cat(4, volresize(Knots_n_tot(:,:,:,1), bszv), volresize(Knots_n_tot(:,:,:,2), bszv), volresize(Knots_n_tot(:,:,:,3), bszv));  
       voldef = volresize(volmov, bszv);
    else 
        Tptv_rsz = Knots_n_tot; 
        voldef=volmov;
    end
    [~, Knots_n_rsz] = uncrop_data(voldef, Tptv_rsz, crop_v, init_size);
    [pt_errs_phys, pts_moved_pix, TRE_phys, TREstd_phys] = DIR_movepoints(pts_mov, pts_fix, Knots_n_rsz, spc_orig,resize, []);
    TRE_current(level)=TRE_phys;
    STD_cur(level)=TREstd_phys;

       
 end


end