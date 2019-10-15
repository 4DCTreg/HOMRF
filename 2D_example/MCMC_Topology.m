% This function is used to get a good result of recover image

function [Ln]=MCMC_Topology(griddim,unary,labels,previous,quant,x_tot,y_tot,dist,labelstot)
nlevel=5;
Tcoe_n=0.7;
num_neighbor=8;
cur_grid_space_x=1;
cur_grid_space_y=1;
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



dist=fix(dist)./10;
% dist(find(dist>15))=14;
% Label transformation Diagonal label
% label_trans=zeros(nlabels,1);
% for nla=1:nlabels
%     y=fix((nla-1)/sl)-slh;
%     x=mod((nla-1),sl)-slh;
%     trans_y=-y;
%     trans_x=-x;
%     label_trans(nla)=(trans_y+slh)*sl+trans_x+slh+1;  
% end
     
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

% Initial variables
% newlabelindex=unidrnd(nlabels,nlabels*r*c*500,1);


% Used for data term
node_label=zeros(r*c+1,1)+floor(nlabels/2)+1;
labelstot_1=zeros(r*c+1,1)+floor(x_tot*y_tot/2)+1;
labelstot_1(1:r*c)=labelstot;
labelstot=labelstot_1;

% Main function

% Initial parameter
T=0.01;

totenergyend=zeros(5000,1);
max_iter=3000;
iter=max_iter/2^(-nlevel+6);
iter=1000;
for k=1:iter
    
    % Count the energy
    totenergy=0; 
    
  for num=1:r*c

      label_neighbor=neighborlabeltp(num,:);
      
%       % Get the node location
%       or_num_i=mod(num-1,r)+1;
%       or_num_j=fix((num-1)/c)+1;


        originalnum=node_label(num);
        x_mov_or=x_index(originalnum);
        y_mov_or=y_index(originalnum);
        x_mov_or_add=x_mov_or+previous(num,1)+x_h;
        y_mov_or_add=y_mov_or+previous(num,2)+y_h;
        ortotlabel=labelindex(x_mov_or_add,y_mov_or_add);
        
        edges=neighborlabeltp(num,:);
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

        % Get the original moving node's neighbor
%         neighborlabel_or=neighborlabeltp(num,:);

   
       % Choosing the new label   
%         newnum=newlabelindex((k-1)*r*c+num);
        newnum=unidrnd(nlabels);
        x_mov_newnum=x_index(newnum);
        y_mov_newnum=y_index(newnum);

        x_mov_new_add=x_mov_newnum+previous(num,1)+x_h;
        y_mov_new_add=y_mov_newnum+previous(num,2)+y_h;


    
        newtotlabel=labelindex(x_mov_new_add,y_mov_new_add);

        
        
        % Get the topology term 
        if k>=0
        orpx=y_index_tot(ortotlabel);
        orpy=x_index_tot(ortotlabel);
        
        p_up_x=y_index_tot(labelstot(up_point));
        p_up_y=x_index_tot(labelstot(up_point));
        p_up_y=(p_up_y+cur_grid_space_y);
             

        p_down_x=y_index_tot(labelstot(down_point));
        p_down_y=x_index_tot(labelstot(down_point));
 

        p_down_y=(p_down_y-cur_grid_space_y);
        

        p_left_x=y_index_tot(labelstot(left_point));
        p_left_y=x_index_tot(labelstot(left_point));
        p_left_x=(p_left_x-cur_grid_space_x);  
        
        p_right_x=y_index_tot(labelstot(right_point));
        p_right_y=x_index_tot(labelstot(right_point));
        p_right_x=p_right_x+cur_grid_space_x;
                
                
        
        
        
        %one point 1 3
        Jaco_1=(orpx-p_left_x)*(p_up_y-orpy)-(orpy-p_left_y)*(p_up_x-orpx);
        %Jaco_1=(orpx-p_left_x)*(p_up_y-orpy)-(p_up_x-orpx)*(p_left_y-orpy);
        %orthird_1=exp(-Jaco_1*2);
        %orthird_1=-Jaco_1;
        
        if Jaco_1>=0

            orthird_1=0;
        else
%             orthird_1=2;
%             orthird_1=exp(-Jaco_1*2);
            orthird_1=log(-Jaco_1+1)*Tcoe_n;
        end
        
        %two point 1 4

        %Jaco_2=(p_right_x-orpx)*(p_up_y-orpy)-(p_up_x-orpx)*(p_right_y-orpy);
        Jaco_2=(p_right_x-orpx)*(p_up_y-orpy)-(p_right_y-orpy)*(p_up_x-orpx);
        %orthird_2=exp(-Jaco_2*2);
        %orthird_2=-Jaco_2;
        
        if Jaco_2>=0
            orthird_2=0;
        else
%             orthird_2=2;
%             orthird_2=exp(-Jaco_2*2);
            orthird_2=log(-Jaco_2+1)*Tcoe_n;
        end
        
        %three point 2 3
        %Jaco_3=(orpx-p_left_x)*(orpy-p_down_y)-(orpx-p_down_x)*(orpy-p_left_y);
        Jaco_3=(orpx-p_left_x)*(orpy-p_down_y)-(orpy-p_left_y)*(orpx-p_down_x);
        %orthird_3=exp(-Jaco_3*2);
        %orthird_3=-Jaco_3;
        
        if Jaco_3>=0

            orthird_3=0;
        else
%             orthird_3=2;
%             orthird_3=exp(-Jaco_3*2);
            orthird_3=log(-Jaco_3+1)*Tcoe_n;
        end
        
        % four point 2 4
        %Jaco_4=(p_right_x-orpx)*(orpy-p_down_y)-(orpx-p_down_x)*(p_right_y-orpy);
        Jaco_4=(p_right_x-orpx)*(orpy-p_down_y)-(p_right_y-orpy)*(orpx-p_down_x);
        %orthird_4=exp(-Jaco_4*2);
        %orthird_4=-Jaco_4;
        
        if Jaco_4>=0

            orthird_4=0;
        else
%             orthird_4=2;
%             orthird_4=exp(-Jaco_4*2);
            orthird_4=log(-Jaco_4+1)*Tcoe_n;
        end
        
        
        orthirdtot=orthird_1+orthird_2+orthird_3+orthird_4;
        
        newpx=y_index_tot(newtotlabel);
        newpy=x_index_tot(newtotlabel);

        

        %one point 1 3
        %Jaco_1=(newpx-p_left_x)*(p_up_y-newpy)-(p_up_x-newpx)*(p_left_y-newpy);
        Jaco_1=(newpx-p_left_x)*(p_up_y-newpy)-(newpy-p_left_y)*(p_up_x-newpx);
        %newthird_1=exp(-Jaco_1*2);   %% QYP
        if Jaco_1>=0

             newthird_1=0;
        else
% %             newthird_1=2;
%             newthird_1=exp(-Jaco_1*2);
            newthird_1=log(-Jaco_1+1)*Tcoe_n;
        end
        
        %newthird_1=-Jaco_1;
        
        %two point 1 4

        %Jaco_2=(p_right_x-newpx)*(p_up_y-newpy)-(p_up_x-newpx)*(p_right_y-newpy);
        Jaco_2=(p_right_x-newpx)*(p_up_y-newpy)-(p_right_y-newpy)*(p_up_x-newpx);
        %newthird_2=exp(-Jaco_2*2);   %%QYP
        %newthird_2=-Jaco_2;
        
        if Jaco_2>=0

            newthird_2=0;
        else
%             newthird_2=exp(-Jaco_2*2);   %%QYP
            newthird_2=log(-Jaco_2+1)*Tcoe_n;
        end
        
        %three point 2 3
        %Jaco_3=(newpx-p_left_x)*(newpy-p_down_y)-(newpx-p_down_x)*(newpy-p_left_y);
         Jaco_3=(newpx-p_left_x)*(newpy-p_down_y)-(newpy-p_left_y)*(newpx-p_down_x);
        %newthird_3=exp(-Jaco_3*2);   %%QYP
        %newthird_3=-Jaco_3;
        
        
        if Jaco_3>=0

            newthird_3=0;
        else
%             newthird_3=2;
%             newthird_3=exp(Jaco_3*2);   %%QYP
            newthird_3=log(-Jaco_3+1)*Tcoe_n;
        end
        
        % four point 2 4
        %Jaco_4=(p_right_x-newpx)*(newpy-p_down_y)-(newpx-p_down_x)*(p_right_y-newpy);
        Jaco_4=(p_right_x-newpx)*(newpy-p_down_y)-(p_right_y-newpy)*(newpx-p_down_x);
        %newthird_4=exp(-Jaco_4*5);  %%QYP
        %newthird_4=-Jaco_4;
        
        if Jaco_4>=0

            newthird_4=0;
        else
%             newthird_4=2;
%             newthird_4=exp(-Jaco_4*2);  %%QYP
            newthird_4=log(-Jaco_4+1)*Tcoe_n;
        end
        newthirdtot=newthird_1+newthird_2+newthird_3+newthird_4;
        else
            orthirdtot=0;
            newthirdtot=0;
        end


        orbenergy=sum(dist(ortotlabel,labelstot(label_neighbor)));
        newbenergy=sum(dist(newtotlabel,labelstot(label_neighbor)));
        % Get the data term
        unaryweight=unary(num,:); 
         
        orenergy=unaryweight(originalnum)+orbenergy+orthirdtot;
         
%          orenergy=unaryweight(originalnum);
         
         exp_orenergy=exp(-orenergy/T);
         
         newenergy=unaryweight(newnum)+newbenergy+newthirdtot;

%          newenergy=unaryweight(newnum);
         
        exp_newenergy=exp(-newenergy/T);
       
        ratio=exp_newenergy/exp_orenergy;
       
          U=rand;
         if  (ratio > 1)
            node_label(num)=newnum;
            labelstot(num)=newtotlabel;
            totenergy=totenergy+newenergy;
         else
             if ratio==1
             node_label(num)=node_label(num);
             labelstot(num)=ortotlabel;
             totenergy=totenergy+orenergy;
             else
                 if ratio>U
                    node_label(num)=newnum;
                    labelstot(num)=newtotlabel;
                    totenergy=totenergy+orenergy;
                 else
                   node_label(num)=node_label(num);
                   labelstot(num)=ortotlabel;
                   totenergy=totenergy+orenergy;
                 end
             end
         end
         totenergyend(k)=totenergyend(k)+totenergy;
  end
end
Ln=node_label(1:r*c);
end
