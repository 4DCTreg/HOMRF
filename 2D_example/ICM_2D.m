% This function is used to get a good result of recover image

function [Ln]=ICM_2D(griddim,unary,labels,previous,quant,x_tot,y_tot,dist,labelstot,grid_space,k,useTop)
Tcoe_n=0.01;
cur_grid_space_x=grid_space(3-k,1);
cur_grid_space_y=grid_space(3-k,2);

num_neighbor=8;

sample_space_x=quant(1);
sample_space_y=quant(2);
x_h=fix(x_tot/2)+1;
y_h=fix(y_tot/2)+1;
% Processing the inputs
nlabels=size(unary,2);
sl=sqrt(nlabels);
slh=floor(sl/2);
r=griddim(1);
c=griddim(2);
[x_index_tot,y_index_tot]=Label_Coordinate_2D_tot(x_tot,y_tot);
labelindex=1:x_tot*y_tot;
labelindex=reshape(labelindex,[x_tot,y_tot]);

[x_index,y_index]=Label_Coordinate_2D(labels);
x_index=x_index*sample_space_x;
y_index=y_index*sample_space_y;



dist=dist./60;

     
% 8 neighbor  up down left right upleft upright left-bottom right-bottom
%              5  1  6
%               \ | /
%           3   ¡ª  ¡ª 4                  
%               / | \
%              7  2  8
neighborlabel=zeros(r*c+1,8);

numberlabel=reshape(1:r*c,r,c);

extra_point=r*c+1;

for nodenum=1:r*c
    j=floor((nodenum-0.5)/r)+1;
    i=mod((nodenum-1),r)+1;
    if i==1&&j==1
        neighbor=[extra_point,numberlabel(i+1,j),extra_point,numberlabel(i,j+1),extra_point,extra_point,extra_point,numberlabel(i+1,j+1)];
    else
        if i==1&&j==c
            neighbor=[extra_point,numberlabel(i+1,j),numberlabel(i,j-1),extra_point,extra_point,extra_point,numberlabel(i+1,j-1),extra_point];
        else
            if i==r&&j==1
                neighbor=[numberlabel(i-1,j),extra_point,extra_point,numberlabel(i,j+1),extra_point,numberlabel(i-1,j+1),extra_point,extra_point];
            else
                if i==r&&j==c
                    neighbor=[numberlabel(i-1,j),extra_point,numberlabel(i,j-1),extra_point,numberlabel(i-1,j-1),extra_point,extra_point,extra_point];
                else
                    if i==1
                        neighbor=[extra_point,numberlabel(i+1,j),numberlabel(i,j-1),numberlabel(i,j+1),extra_point,extra_point,numberlabel(i+1,j-1),numberlabel(i+1,j+1)];
                    else
                        if i==r
                            neighbor=[numberlabel(i-1,j),extra_point,numberlabel(i,j-1),numberlabel(i,j+1),numberlabel(i-1,j-1),numberlabel(i-1,j+1),extra_point,extra_point];
                        else 
                            if j==1
                            neighbor=[numberlabel(i-1,j),numberlabel(i+1,j),extra_point,numberlabel(i,j+1),extra_point,numberlabel(i-1,j+1),extra_point,numberlabel(i+1,j+1)];
                            else
                                if j==c
                                 neighbor=[numberlabel(i-1,j),numberlabel(i+1,j),numberlabel(i,j-1),extra_point,numberlabel(i-1,j-1),extra_point,numberlabel(i+1,j-1),extra_point];
                                else
                                  neighbor=[numberlabel(i-1,j),numberlabel(i+1,j),numberlabel(i,j-1),numberlabel(i,j+1),numberlabel(i-1,j-1),numberlabel(i-1,j+1),numberlabel(i+1,j-1),numberlabel(i+1,j+1)];
                                end
                             end
                        end
                    end
                 end
            end
        end
    end
    neighborlabel(nodenum,:)=neighbor;
end


% Topology neighbor
neighborlabeltp=neighborlabel;

neighborlabeltp(r*c+1,:)=(r*c+1)*ones(1,8);
nneighbor=size(neighborlabeltp,2);



% Used for data term
node_label=zeros(r*c+1,1)+floor(nlabels/2)+1;
labelstot_1=zeros(r*c+1,1)+floor(x_tot*y_tot/2)+1;
labelstot_1(1:r*c)=labelstot;
labelstot=labelstot_1;

% Main function
maxIter=100;



nodePot=unary;
[nNodes,maxStates] = size(nodePot);

nStates = maxStates;
y=node_label;
done = 0;
iter=1;
while ~done&&(iter<maxIter)
    done = 1;
	y2 = y;
    for n = 1:nNodes
        
        x_mov_or_add=x_index+previous(n,1)+x_h;
        y_mov_or_add=y_index+previous(n,2)+y_h;

        totlabel=zeros(1,nStates);
        for idx=1:nStates 
            totlabel(idx)=labelindex(x_mov_or_add(idx),y_mov_or_add(idx));
        end
    


        
        % Compute Node Potential
        pot = nodePot(n,1:nStates);

        % Find Neighbors
        edges=neighborlabeltp(n,:);
        if num_neighbor==8
            up_point=edges(4);
            down_point=edges(6);
            left_point=edges(2);
            right_point=edges(7);

        else
            if num_neighbor==18
                up_point=edges(3);
                down_point=edges(16);
                left_point=edges(7);
                right_point=edges(12);
                anter_point=edges(9);
                poster_point=edges(10);
            end
        end
                
        

            smooth_cur=zeros(nStates,2);
            x_index_nstate=x_index_tot(totlabel);
            y_index_nstate=y_index_tot(totlabel);

            smooth_cur(:,1)=x_index_nstate;
            smooth_cur(:,2)=y_index_nstate;

            for e=1:nneighbor
                if isempty(dist)
                ecurr=labelstot(edges(e));
                ecurr_x=x_index_tot_spc(ecurr);
                ecurr_y=y_index_tot_spc(ecurr);
                ecurr_z=z_index_tot_spc(ecurr);
                smooth_e=repmat([ecurr_x,ecurr_y,ecurr_z],nStates,1);
                

                ep=sqrt(sum((smooth_cur-smooth_e).^2,2));
                ep=ep./dist_co*smooth_co;
                ep=ep';

                pot=pot+ep;

                else
                    ecurr=labelstot(edges(e));
                    ep=dist(ecurr,totlabel);
                    pot = pot +ep;
                end
             end


        % Multiply Edge Potentials

        etp=zeros(1,nStates);

        if useTop==1
            for tpidx=1:nStates
                ortotlabel=totlabel(tpidx);
                tporpx=y_index_tot(ortotlabel);
                tporpy=x_index_tot(ortotlabel);

    
                or_p_up_x=y_index_tot(labelstot(up_point));
                or_p_up_y=x_index_tot(labelstot(up_point));


                or_p_up_y=(or_p_up_y+cur_grid_space_y);
             

                or_p_down_x=y_index_tot(labelstot(down_point));
                or_p_down_y=x_index_tot(labelstot(down_point));
 

                or_p_down_y=(or_p_down_y-cur_grid_space_y);
        

                or_p_left_x=y_index_tot(labelstot(left_point));
                or_p_left_y=x_index_tot(labelstot(left_point));


                or_p_left_x=(or_p_left_x-cur_grid_space_x);
        
                or_p_right_x=y_index_tot(labelstot(right_point));
                or_p_right_y=x_index_tot(labelstot(right_point));

         
                or_p_right_x=or_p_right_x+cur_grid_space_x;
        


        
                %one point 1 3
        Jaco_1=(tporpx-or_p_left_x)*(or_p_up_y-tporpy)-(tporpy-or_p_left_y)*(or_p_up_x-tporpx);
        %Jaco_1=(orpx-p_left_x)*(p_up_y-orpy)-(p_up_x-orpx)*(p_left_y-orpy);
        %orthird_1=exp(-Jaco_1*2);
        %orthird_1=-Jaco_1;
        
        if Jaco_1>=0
            orthird_1=0;
        else
%             orthird_1=5;
            orthird_1=log(-Jaco_1+1)*Tcoe_n;
        end
        
        %two point 1 4

        %Jaco_2=(p_right_x-orpx)*(p_up_y-orpy)-(p_up_x-orpx)*(p_right_y-orpy);
        Jaco_2=(or_p_right_x-tporpx)*(or_p_up_y-tporpy)-(or_p_right_y-tporpy)*(or_p_up_x-tporpx);
        %orthird_2=exp(-Jaco_2*2);
        %orthird_2=-Jaco_2;
        
        if Jaco_2>=0
            orthird_2=0;
        else
%             orthird_2=5;
            orthird_2=log(-Jaco_2+1)*Tcoe_n;
        end
        
        %three point 2 3
        %Jaco_3=(orpx-p_left_x)*(orpy-p_down_y)-(orpx-p_down_x)*(orpy-p_left_y);
        Jaco_3=(tporpx-or_p_left_x)*(tporpy-or_p_down_y)-(tporpy-or_p_left_y)*(tporpx-or_p_down_x);
        %orthird_3=exp(-Jaco_3*2);
        %orthird_3=-Jaco_3;
        
        if Jaco_3>=0
            orthird_3=0;
        else
%             orthird_3=5;
            orthird_3=log(-Jaco_3+1)*Tcoe_n;
        end
        
        % four point 2 4
        %Jaco_4=(p_right_x-orpx)*(orpy-p_down_y)-(orpx-p_down_x)*(p_right_y-orpy);
        Jaco_4=(or_p_right_x-tporpx)*(tporpy-or_p_down_y)-(or_p_right_y-tporpy)*(tporpx-or_p_down_x);
        %orthird_4=exp(-Jaco_4*2);
        %orthird_4=-Jaco_4;
        
        if Jaco_4>=0
            orthird_4=0;
        else
%             orthird_4=5;
            orthird_4=log(-Jaco_4+1)*Tcoe_n;
        end
                
                etp(tpidx)=orthird_1+orthird_2+orthird_3+orthird_4;
        
            end
        end
        

        pot=pot+etp;
        % Assign to Maximum State
        [junk newY] = min(pot);
        if newY ~= y(n)
            y(n) = newY;
            labelstot(n)=totlabel(newY);
%             done = 0;
        end
    end
   iter=iter+1;
   changes=sum(y2~=y);
   if changes~=0
       done=0;
   else
       done=1;
   end

   fprintf('changes = %d, iter = %d\n',sum(y2~=y), iter);
%             fprintf('changes = %d\n',sum(y2~=y));
 end


Ln=y(1:nNodes);
end





