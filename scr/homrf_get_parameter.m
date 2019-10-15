function parameter=homrf_get_parameter(idx,useTop,spc)
switch idx
    case 1
%         parameter.nlevel=6;
%         parameter.k_down=0.8;
%         parameter.quant=[1 1 1;1 1 1; 1 1 1; 1 1 1; 1 1 1; 1 1 2];
%         parameter.useTop=useTop;
%         parameter.grid_space=[2 2 2;4 4 4;6 6 6;6 6 6;8 8 8; 10 10 10];
%         parameter.x_tot=33;
%         parameter.y_tot=33;
%         parameter.z_tot=33;
%         parameter.metric='MIND';
%         parameter.labels=[3 3 3;3 3 3;3 3 3;7 7 7;7 7 9;9 9 9;];
%         parameter.presmooth=1;
%         parameter.spc=spc;
%         parameter.smooth_co=[1,10,7,2.8,10/8,10/10];
%         parameter.end=3;
%         parameter.top_co=[spc(1)*spc(2)*spc(3)/1^3   ,spc(1)*spc(2)*spc(3)/(10/2)^3,  spc(1)*spc(2)*spc(3)/(10/2)^3,    spc(1)*spc(2)*spc(3)/(10/6)^3,  spc(1)*spc(2)*spc(3)/(10/8)^3,    spc(1)*spc(2)*spc(3)/1^3;];
%         parameter.Tcoe_n=[20,0.05,0.05,0.05,0.05,0.01];
%         parameter.resize=0;
%         parameter.dist_co=30.76;
    case 2
        parameter.nlevel=6;
        parameter.k_down=0.8;
        parameter.quant=[1 1 1;1 1 1; 1 1 1; 1 1 1; 1 1 2; 1 1 2];
        parameter.useTop=useTop;
        parameter.grid_space=[2 2 2;2 2 2;4 4 4;6 6 6;8 8 8; 10 10 10];
        parameter.x_tot=33;
        parameter.y_tot=33;
        parameter.z_tot=33;
        parameter.metric='MIND';
        parameter.labels=[3 3 3;3 3 3;3 3 3;7 7 7;9 9 9;9 9 9;];
        parameter.presmooth=1;
        parameter.spc=spc;
        parameter.smooth_co=[1,20,5,10/6,10/8,10/10];
        parameter.Tcoe_n=[20,0.05,0.05,0.05,0.05,0.05];
        parameter.end=2;
        parameter.resize=0;
        parameter.top_co=[spc(1)*spc(2)*spc(3)/1^3 ,spc(1)*spc(2)*spc(3)/100,  spc(1)*spc(2)*spc(3)/64,  spc(1)*spc(2)*spc(3)/(10/6)^3,  spc(1)*spc(2)*spc(3)/(10/8)^3,  spc(1)*spc(2)*spc(3)/1^3;];
        parameter.dist_co=30.76;

end
end