% This function is used to get a good result of recover image

function [Ln]=MCMC_Smooth(griddim,unary,labels,previous,quant,x_tot,y_tot,dist,labelstot)
nlevel=5;

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



dist=fix(dist)./15;

     
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
      



        originalnum=node_label(num);
        x_mov_or=x_index(originalnum);
        y_mov_or=y_index(originalnum);
        x_mov_or_add=x_mov_or+previous(num,1)+x_h;
        y_mov_or_add=y_mov_or+previous(num,2)+y_h;
        ortotlabel=labelindex(x_mov_or_add,y_mov_or_add);
        
        

        % Get the original moving node's neighbor
        neighborlabel_or=neighborlabeltp(num,:);

   
       % Choosing the new label   
%         newnum=newlabelindex((k-1)*r*c+num);
        newnum=unidrnd(nlabels);
        x_mov_newnum=x_index(newnum);
        y_mov_newnum=y_index(newnum);

        x_mov_new_add=x_mov_newnum+previous(num,1)+x_h;
        y_mov_new_add=y_mov_newnum+previous(num,2)+y_h;


    
        newtotlabel=labelindex(x_mov_new_add,y_mov_new_add);



        orbenergy=sum(dist(ortotlabel,labelstot(label_neighbor)));
        newbenergy=sum(dist(newtotlabel,labelstot(label_neighbor)));
        % Get the data term
        unaryweight=unary(num,:); 
         
        orenergy=unaryweight(originalnum)+orbenergy;
         
%          orenergy=unaryweight(originalnum);
         
         exp_orenergy=exp(-orenergy/T);
         
         newenergy=unaryweight(newnum)+newbenergy;

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
