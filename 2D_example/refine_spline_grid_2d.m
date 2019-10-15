function [Knots_n] = refine_spline_grid_2d(Knots, new_spacing, new_vsz, O_trans_X,O_trans_Y)
    %[Knots_n] = refine_linear_grid_3d(Knots, old_spacing, ds, volsz,
    %  {upsampling_type}
    
    ksz_new = ceil(new_vsz ./ new_spacing);
    Kn = zeros([ksz_new, 2]);
    [x1,y1]=meshgrid(1:1:new_vsz(2),1:1:new_vsz(1));
    x_or=O_trans_X(:,1,2)-O_trans_X(:,1,1);
    x_or=O_trans_X(:,1,1)+x_or./2;
    y_or=O_trans_Y(1,:,2)-O_trans_Y(1,:,1);
    y_or=O_trans_Y(1,:,1)+y_or./2;

    [x2,y2]=meshgrid(y_or,x_or);
    Kn(:,:,1)=interp2(x2,y2,Knots(:,:,1),x1,y1,'linear',0);
    Kn(:,:,2)=interp2(x2,y2,Knots(:,:,2),x1,y1,'linear',0);

    Knots_n=Kn;
    
    
%     Nd = size(Knots, 4);
%     
%     upsampling_type = 'sample_std';
%     if nargin >= 6
%         upsampling_type = varargin{1};
%     end
%     
%     ksz_new = ceil(new_vsz ./ new_spacing);
%     Kn = zeros([ksz_new, 3]);
%     interp_type = 0;
%     tmp = cat(4, volresize(Knots(:,:,:,1), ksz_new, interp_type), ...
%                  volresize(Knots(:,:,:,2), ksz_new, interp_type), ...
%                  volresize(Knots(:,:,:,3), ksz_new, interp_type));
%     Kn = tmp;
%     Knots_n = Kn;
%     if strcmp(upsampling_type, 'variation')
%         Tmin = linear_disp_3d(Knots, old_vsz, old_spacing);
%         Tmin_u = cat(4, volresize(Tmin(:,:,:, 1), new_vsz, 0), ...
%                         volresize(Tmin(:,:,:, 2), new_vsz, 0), ...
%                         volresize(Tmin(:,:,:, 3), new_vsz, 0));
%         objf = @(x) align_knots(x, Tmin_u, new_vsz, [ksz_new, 3], new_spacing);
%         uopt = []; 
%         uopt.method = 'lbfgs'; 
%         uopt.MaxIter = 30; 
%         uopt.method = 'cg'; 
%         uopt.MaxIter = 15; 
%         uopt.Corr=15; 
%         uopt.Display = 'off';
%         uopt.LS_type = 0; uopt.LS_init = 8;
%         K2 = minFunc(objf, Knots_n(:), uopt);
%         Knots_n = reshape(K2, [ksz_new, 3]);
%     end
% end
% 
% function [f, gr] = align_knots(K, T, szv, szk, grid_spacing)
%     K = reshape(K, szk);
%     Kx = linear_disp_3d(K, szv, grid_spacing);
%     df = Kx - T;
%     f = sum(df(:).^2)/2;
%     [gr1, gr2, gr3] = linear_partial_conv_3d(df(:,:,:, 1), df(:,:,:, 2), df(:,:,:, 3), ...
%                      size(K), grid_spacing); 
%     gr = [gr1(:); gr2(:); gr3(:)];
end
