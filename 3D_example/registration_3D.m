clear;
% Generate the Moving and Fixed image
[x,y,z]=meshgrid(-16:1:16,-16:1:16,-16:1:16);
[t,p,r]=cart2sph(x,y,z);
Fix=zeros(size(x));
Fix(r<=10)=50;
Mov=zeros(size(x));
Mov(7:27,7:27,7:27)=50;

% Get the size of the data block
[r,c,l]=size(Mov);

% Define the search sapce(matlab coordinate)
sx=9;
sy=9;
sz=9;

% For the convenience of caculation
nlabels=sx*sy*sz;
hz=floor(sz/2);
hx=floor(sx/2);
hy=floor(sy/2);


% Get the smooth term
dist=Get_Smooth_Term(sx,sy,sz);
dist=dist./100;

% Get the neighbor
neighbor=Get_Neighbor(r,c,l);
num_neighbor=size(neighbor,2);

% Get the data term
nodePot=get_unary(Mov,Fix,sx,sy,sz);

% labels initialization
labelnum=zeros(r*c*l+1,1)+floor(nlabels/2)+1;
labelstot=labelnum;

% Topology preservation term
%  useTop=1 topology preservation
%  useTop=0 no topology preservation
useTop=1;

% Set loop conditions 
done=0;
iter=1;
maxIter=50;

nneighbor=size(neighbor,2);
Tcoe_n=5;
[nNodes,maxStates] = size(nodePot);
nStates = maxStates;
[x_index_tot,y_index_tot,z_index_tot]=Label_Coordinate(sx,sy,sz);

y=labelnum;
while ~done&&(iter<maxIter)
y2=y;
for num=1:r*c*l
    totlabel=1:nStates;
    pot = nodePot(num,1:nStates);
    edges=neighbor(num,:);
    if num_neighbor==6
            up_point=edges(1);
            down_point=edges(6);
            left_point=edges(2);
            right_point=edges(5);
            anter_point=edges(3);
            poster_point=edges(4);
     else
            if num_neighbor==26
                up_point=edges(5);
                down_point=edges(22);
                left_point=edges(11);
                right_point=edges(16);
                anter_point=edges(13);
                poster_point=edges(14);
            end
    end
    smooth_cur=zeros(nStates,3);
    x_index_nstate=x_index_tot(totlabel);
    y_index_nstate=y_index_tot(totlabel);
    z_index_nstate=z_index_tot(totlabel);
    smooth_cur(:,1)=x_index_nstate;
    smooth_cur(:,2)=y_index_nstate;
    smooth_cur(:,3)=z_index_nstate;
    for e=1:nneighbor
        if isempty(dist)
                ecurr=labelstot(edges(e));
                ecurr_x=x_index_tot(ecurr);
                ecurr_y=y_index_tot(ecurr);
                ecurr_z=z_index_tot(ecurr);
                smooth_e=repmat([ecurr_x,ecurr_y,ecurr_z],nStates,1);
                ep=sqrt(sum((smooth_cur-smooth_e).^2,2));
                ep(find(ep>=30))=30;
                ep=ep./dist_co*smooth_co;
                ep=ep';
                pot=pot+ep;

         else
                ecurr=labelstot(edges(e));
                ep=dist(ecurr,totlabel);
                pot = pot +ep;
        end
    end
    etp=zeros(1,nStates);
    if useTop==1
        for tpidx=1:nStates
            
            ortotlabel=totlabel(tpidx);
            orpx=x_index_tot(tpidx);
            orpy=y_index_tot(tpidx);
            orpz=z_index_tot(tpidx);
            
            or_p_up_x=x_index_tot(labelstot(up_point));
            or_p_up_y=y_index_tot(labelstot(up_point));
            or_p_up_z=z_index_tot(labelstot(up_point));
            or_p_up_z=or_p_up_z+1;
         
            or_p_down_x=x_index_tot(labelstot(down_point));
            or_p_down_y=y_index_tot(labelstot(down_point));
            or_p_down_z=z_index_tot(labelstot(down_point));
            or_p_down_z=or_p_down_z-1;
         
            or_p_left_x=x_index_tot(labelstot(left_point));
            or_p_left_y=y_index_tot(labelstot(left_point));
            or_p_left_z=z_index_tot(labelstot(left_point));
            or_p_left_y=or_p_left_y-1;
         
            or_p_right_x=x_index_tot(labelstot(right_point));
            or_p_right_y=y_index_tot(labelstot(right_point));
            or_p_right_z=z_index_tot(labelstot(right_point));
            or_p_right_y=or_p_right_y+1;
         
            or_p_anter_x=x_index_tot(labelstot(anter_point));
            or_p_anter_y=y_index_tot(labelstot(anter_point));
            or_p_anter_z=z_index_tot(labelstot(anter_point));
            or_p_anter_x=or_p_anter_x-1;
         
            or_p_poster_x=x_index_tot(labelstot(poster_point));
            or_p_poster_y=y_index_tot(labelstot(poster_point));
            or_p_poster_z=z_index_tot(labelstot(poster_point));
            or_p_poster_x=or_p_poster_x+1;
         
         %Jaco1 point 1 4 5
        %Jaco_1=(p_right_x-orpx)*(orpy-p_anter_y)*(p_up_z-orpz)+(orpx-p_anter_x)*(p_up_y-orpy)*(p_right_z-orpz)+(p_right_y-orpy)*(orpz-p_anter_z)*(p_up_x-orpx)-(p_right_z-orpz)*(orpy-p_anter_y)*(p_up_x-orpx)-(p_right_y-orpy)*(orpx-p_anter_x)*(p_up_z-orpz)-(orpz-p_anter_z)*(p_up_y-orpy)*(p_right_x-orpx);
            Jaco_1=(orpx-or_p_anter_x)*(or_p_right_y-orpy)*(or_p_up_z-orpz)+(orpy-or_p_anter_y)*(or_p_right_z-orpz)*(or_p_up_x-orpx)+(or_p_right_x-orpx)*(or_p_up_y-orpy)*(orpz-or_p_anter_z)-(orpz-or_p_anter_z)*(or_p_right_y-orpy)*(or_p_up_x-orpx)-(orpy-or_p_anter_y)*(or_p_right_x-orpx)*(or_p_up_z-orpz)-(or_p_right_z-orpz)*(or_p_up_y-orpy)*(orpx-or_p_anter_x);
        
            if Jaco_1>=0
                orthird_1=0;
            else
                orthird_1=log(-Jaco_1+1)*Tcoe_n;
            end
        
        %Jaco2 point 1 3 5
        %Jaco_2=(orpx-p_left_x)*(orpy-p_anter_y)*(p_up_z-orpz)+(orpx-p_anter_x)*(p_up_y-orpy)*(orpz-p_left_z)+(orpy-p_left_y)*(orpz-p_anter_z)*(p_up_x-orpx)-(orpz-p_left_z)*(orpy-p_anter_y)*(p_up_x-orpx)-(orpy-p_left_y)*(orpx-p_anter_x)*(p_up_z-orpz)-(orpz-p_anter_z)*(p_up_y-orpy)*(orpx-p_left_x);
            Jaco_2=(orpx-or_p_anter_x)*(orpy-or_p_left_y)*(or_p_up_z-orpz)+(orpy-or_p_anter_y)*(orpz-or_p_left_z)*(or_p_up_x-orpx)+(orpx-or_p_left_x)*(or_p_up_y-orpy)*(orpz-or_p_anter_z)-(orpz-or_p_anter_z)*(orpy-or_p_left_y)*(or_p_up_x-orpx)-(orpy-or_p_anter_y)*(orpx-or_p_left_x)*(or_p_up_z-orpz)-(orpz-or_p_left_z)*(or_p_up_y-orpy)*(orpx-or_p_anter_x);
            if Jaco_2>=0
                orthird_2=0;
            else
                orthird_2=log(-Jaco_2+1)*Tcoe_n;
            end
         
        %Jaco3 point 2 4 5
        %Jaco_3=(p_right_x-orpx)*(orpy-p_anter_y)*(orpz-p_down_z)+(orpx-p_anter_x)*(orpy-p_down_y)*(p_right_z-orpz)+(p_right_y-orpy)*(orpz-p_anter_z)*(orpx-p_down_x)-(p_right_z-orpz)*(orpy-p_anter_y)*(orpx-p_down_x)-(p_right_y-orpy)*(orpx-p_anter_x)*(orpz-p_down_z)-(orpz-p_anter_z)*(orpy-p_down_y)*(p_right_x-orpx);
            Jaco_3=(orpx-or_p_anter_x)*(or_p_right_y-orpy)*(orpz-or_p_down_z)+(orpy-or_p_anter_y)*(or_p_right_z-orpz)*(orpx-or_p_down_x)+(or_p_right_x-orpx)*(orpy-or_p_down_y)*(orpz-or_p_anter_z)-(orpz-or_p_anter_z)*(or_p_right_y-orpy)*(orpx-or_p_down_x)-(orpy-or_p_anter_y)*(or_p_right_x-orpx)*(orpz-or_p_down_z)-(or_p_right_z-orpz)*(orpy-or_p_down_y)*(orpx-or_p_anter_x); 
            if Jaco_3>=0 
                orthird_3=0;
            else
                orthird_3=log(-Jaco_3+1)*Tcoe_n;
            end
        
        
        %Jaco4 point 2 3 5
        %Jaco_4=(orpx-p_left_x)*(orpy-p_anter_y)*(orpz-p_down_z)+(orpx-p_anter_x)*(orpy-p_down_y)*(orpz-p_left_z)+(orpy-p_left_y)*(orpz-p_anter_z)*(orpx-p_down_x)-(orpz-p_left_z)*(orpy-p_anter_y)*(orpx-p_down_x)-(orpy-p_left_y)*(orpx-p_anter_x)*(orpz-p_down_z)-(orpz-p_anter_z)*(orpy-p_down_y)*(orpx-p_left_x);
            Jaco_4=(orpx-or_p_anter_x)*(orpy-or_p_left_y)*(orpz-or_p_down_z)+(orpy-or_p_anter_y)*(orpz-or_p_left_z)*(orpx-or_p_down_x)+(orpx-or_p_left_x)*(orpy-or_p_down_y)*(orpz-or_p_anter_z)-(orpz-or_p_anter_z)*(orpy-or_p_left_y)*(orpx-or_p_down_x)-(orpy-or_p_anter_y)*(orpx-or_p_left_x)*(orpz-or_p_down_z)-(orpz-or_p_left_z)*(orpy-or_p_down_y)*(orpx-or_p_anter_x);
            if Jaco_4>=0
                orthird_4=0;
            else
                orthird_4=log(-Jaco_4+1)*Tcoe_n;
            end
        
        
        %Jaco5 point 1 4 6 correct
        %Jaco_5=(p_right_x-orpx)*(p_poster_y-orpy)*(p_up_z-orpz)+(p_poster_x-orpx)*(p_up_y-orpy)*(p_right_z-orpz)+(p_right_y-orpy)*(p_poster_z-orpz)*(p_up_x-orpx)-(p_right_z-orpz)*(p_poster_y-orpy)*(p_up_x-orpx)-(p_right_y-orpy)*(p_poster_x-orpx)*(p_up_z-orpz)-(p_poster_z-orpz)*(p_up_y-orpy)*(p_right_x-orpx);
            Jaco_5=(or_p_poster_x-orpx)*(or_p_right_y-orpy)*(or_p_up_z-orpz)+(or_p_poster_y-orpy)*(or_p_right_z-orpz)*(or_p_up_x-orpx)+(or_p_right_x-orpx)*(or_p_up_y-orpy)*(or_p_poster_z-orpz)-(or_p_poster_z-orpz)*(or_p_right_y-orpy)*(or_p_up_x-orpx)-(or_p_poster_y-orpy)*(or_p_right_x-orpx)*(or_p_up_z-orpz)-(or_p_right_z-orpz)*(or_p_up_y-orpy)*(or_p_poster_x-orpx);
            if Jaco_5>=0
                orthird_5=0;
            else
                orthird_5=log(-Jaco_5+1)*Tcoe_n;
            end

        %Jaco6 point 2 3 6
        %Jaco_6=(orpx-p_left_x)*(p_poster_y-orpy)*(orpz-p_down_z)+(p_poster_x-orpx)*(orpy-p_down_y)*(orpz-p_left_z)+(orpy-p_left_y)*(p_poster_z-orpz)*(orpx-p_down_x)-(orpz-p_left_z)*(p_poster_y-orpy)*(orpx-p_down_x)-(orpy-p_left_y)*(p_poster_x-orpx)*(orpz-p_down_z)-(p_poster_z-orpz)*(orpy-p_down_y)*(orpx-p_left_x);
            Jaco_6=(or_p_poster_x-orpx)*(orpy-or_p_left_y)*(orpz-or_p_down_z)+(or_p_poster_y-orpy)*(orpz-or_p_left_z)*(orpx-or_p_down_x)+(orpx-or_p_left_x)*(orpy-or_p_down_y)*(or_p_poster_z-orpz)-(or_p_poster_z-orpz)*(orpy-or_p_left_y)*(orpx-or_p_down_x)-(or_p_poster_y-orpy)*(orpx-or_p_left_x)*(orpz-or_p_down_z)-(orpz-or_p_left_z)*(orpy-or_p_down_y)*(or_p_poster_x-orpx);
        
            if Jaco_6>=0
                orthird_6=0;
            else
                orthird_6=log(-Jaco_6+1)*Tcoe_n;
            end
        
        %Jaco7 point 2 4 6
        %Jaco_7=(p_right_x-orpx)*(p_poster_y-orpy)*(orpz-p_down_z)+(p_poster_x-orpx)*(orpy-p_down_y)*(p_right_z-orpz)+(p_right_y-orpy)*(p_poster_z-orpz)*(orpx-p_down_x)-(p_right_z-orpz)*(p_poster_y-orpy)*(orpx-p_down_x)-(p_right_y-orpy)*(p_poster_x-orpx)*(orpz-p_down_z)-(p_poster_z-orpz)*(orpy-p_down_y)*(-p_right_x-orpx);
            Jaco_7=(or_p_poster_x-orpx)*(or_p_right_y-orpy)*(orpz-or_p_down_z)+(or_p_poster_y-orpy)*(or_p_right_z-orpz)*(orpx-or_p_down_x)+(or_p_right_x-orpx)*(orpy-or_p_down_y)*(or_p_poster_z-orpz)-(or_p_poster_z-orpz)*(or_p_right_y-orpy)*(orpx-or_p_down_x)-(or_p_poster_y-orpy)*(or_p_right_x-orpx)*(orpz-or_p_down_z)-(or_p_right_z-orpz)*(orpy-or_p_down_y)*(or_p_poster_x-orpx);
            if Jaco_7>=0
                orthird_7=0;
            else
                orthird_7=log(-Jaco_7+1)*Tcoe_n;
            end
        
        %Jaco8 point 1 3 6
        %Jaco_8=(orpx-p_left_x)*(p_poster_y-orpy)*(p_up_z-orpz)+(p_poster_x-orpx)*(p_up_y-orpy)*(orpz-p_left_z)+(orpy-p_left_y)*(p_poster_z-orpz)*(p_up_x-orpx)-(orpz-p_left_z)*(p_poster_y-orpy)*(p_up_x-orpx)-(orpy-p_left_y)*(p_poster_x-orpx)*(p_up_z-orpz)-(p_poster_z-orpz)*(p_up_y-orpy)*(orpx-p_left_x);
            Jaco_8=(or_p_poster_x-orpx)*(orpy-or_p_left_y)*(or_p_up_z-orpz)+(or_p_poster_y-orpy)*(orpz-or_p_left_z)*(or_p_up_x-orpx)+(orpx-or_p_left_x)*(or_p_up_y-orpy)*(or_p_poster_z-orpz)-(or_p_poster_z-orpz)*(orpy-or_p_left_y)*(or_p_up_x-orpx)-(or_p_poster_y-orpy)*(orpx-or_p_left_x)*(or_p_up_z-orpz)-(orpz-or_p_left_z)*(or_p_up_y-orpy)*(or_p_poster_x-orpx);
            if Jaco_8>=0
                orthird_8=0;
            else
                orthird_8=log(-Jaco_8+1)*Tcoe_n;
            end
        
            etp(tpidx)=orthird_1+orthird_2+orthird_3+orthird_4+orthird_5+orthird_6+orthird_7+orthird_8;
        
        end
     end
         pot=pot+etp;

        [junk newY] = min(pot);
        if newY ~= y(num)
            y(num) = newY;
            labelstot(num)=totlabel(newY);

        end
end
        % Assign to Maximum State
   iter=iter+1;
   changes=sum(y2~=y);
   if changes~=0
       done=0;
   else
       done=1;
   end
%    fprintf('logPot = %f, changes = %d\n',UGM_ConfigurationPotential_correct_TP(y,nodePot,edgePot,edgeEnds,TP_energy,C_tp),sum(y2~=y));
   
   fprintf('changes = %d, iter = %d\n',sum(y2~=y), iter);
%             fprintf('changes = %d\n',sum(y2~=y));
end


Ln=y(1:r*c*l,1);
regis_Mov=Movepixel_3D(Ln,Mov,sx,sy,sz,useTop);
show_results_3D(regis_Mov);

