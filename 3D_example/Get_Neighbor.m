 
%to rich the neighors
%the matrix neighbos size is [64*64*24, 26]
%the  1 4 7     10 13 16      19 22 25
%     2 5 8     11 14 17      20 23 26
%     3 6 9     12 15 18      21 24 27
%the order is [1 2 3 4 5 6 7 8 9 10 11 12......]



function neighbors=Get_Neighbor(r,c,l)

extra_point=r*c*l+1;

nodenumber=reshape(1:r*c*l,[r,c,l]);


neighbors=zeros(r*c*l+1,27);
for num=1:r*c*l
    k=fix((num-1)/(r*c))+1;
    intermediate=mod(num,r*c);
    if intermediate==0
        intermediate=r*c;
    end
    i=mod((intermediate-1),r)+1;
    j=floor((intermediate-0.5)/r)+1;


% neighborlabel3d(:,:,1)=[neighborlabel(i-1,j-1,k-1),neighborlabel(i-1,j,k-1),neighborlabel(i-1,j+1,k-1);
%                         neighborlabel(i,j-1,k-1),neighborlabel(i,j,k-1),neighborlabel(i,j+1,k-1);
%                         neighborlabel(i+1,j-1,k-1),neighborlabel(i+1,j,k-1),neighborlabel(i+1,j+1,k-1);];
%                     
% neighborlabel3d(:,:,2)=[neighborlabel(i-1,j-1,k),neighborlabel(i-1,j,k),neighborlabel(i-1,j+1,k);
%                         neighborlabel(i,j-1,k),neighborlabel(i,j,k),neighborlabel(i,j+1,k);
%                         neighborlabel(i+1,j-1,k),neighborlabel(i+1,j,k),neighborlabel(i+1,j+1,k);];
% 
% neighborlabel3d(:,:,3)=[neighborlabel(i-1,j-1,k+1),neighborlabel(i-1,j,k+1),neighborlabel(i-1,j+1,k+1);
%                         neighborlabel(i,j-1,k+1),neighborlabel(i,j,k+1),neighborlabel(i,j+1,k+1);
%                         neighborlabel(i+1,j-1,k+1),neighborlabel(i+1,j,k+1),neighborlabel(i+1,j+1,k+1)];


    neighborlabel3d=zeros(3,3,3);
if i==1&&j==1&&k==1
        neighborlabel3d(:,:,1)=zeros(3,3)+extra_point;
        neighborlabel3d(:,:,2)=[extra_point,extra_point,extra_point;
                                extra_point,nodenumber(i,j,k),nodenumber(i,j+1,k);
                                extra_point,nodenumber(i+1,j,k),nodenumber(i+1,j+1,k);];

        neighborlabel3d(:,:,3)=[extra_point,extra_point,extra_point;
                                extra_point,nodenumber(i,j,k+1),nodenumber(i,j+1,k+1);
                                extra_point,nodenumber(i+1,j,k+1),nodenumber(i+1,j+1,k+1)];
    else
        if i==r&&j==1&&k==1
            neighborlabel3d(:,:,1)=zeros(3,3)+extra_point;
            neighborlabel3d(:,:,2)=[extra_point,nodenumber(i-1,j,k),nodenumber(i-1,j+1,k);
                                    extra_point,nodenumber(i,j,k),nodenumber(i,j+1,k);
                                    extra_point,extra_point,extra_point;];

            neighborlabel3d(:,:,3)=[extra_point,nodenumber(i-1,j,k+1),nodenumber(i-1,j+1,k+1);
                                    extra_point,nodenumber(i,j,k+1),nodenumber(i,j+1,k+1);
                                    extra_point,extra_point,extra_point];
        else
            if i==1&&j==c&&k==1
                neighborlabel3d(:,:,1)=zeros(3,3)+extra_point;
                neighborlabel3d(:,:,2)=[extra_point,extra_point,extra_point;
                                        nodenumber(i,j-1,k),nodenumber(i,j,k),extra_point;
                                        nodenumber(i+1,j-1,k),nodenumber(i+1,j,k),extra_point;];

                neighborlabel3d(:,:,3)=[extra_point,extra_point,extra_point;
                                        nodenumber(i,j-1,k+1),nodenumber(i,j,k+1),extra_point;
                                        nodenumber(i+1,j-1,k+1),nodenumber(i+1,j,k+1),extra_point];
            else
                if i==r&&j==c&&k==1
                    neighborlabel3d(:,:,1)=zeros(3,3)+extra_point;
                    neighborlabel3d(:,:,2)=[nodenumber(i-1,j-1,k),nodenumber(i-1,j,k),extra_point;
                                            nodenumber(i,j-1,k),nodenumber(i,j,k),extra_point;
                                            extra_point,extra_point,extra_point;];

                    neighborlabel3d(:,:,3)=[nodenumber(i-1,j-1,k+1),nodenumber(i-1,j,k+1),extra_point;
                                            nodenumber(i,j-1,k+1),nodenumber(i,j,k+1),extra_point;
                                            extra_point,extra_point,extra_point];
                else
                    if i==1&&j==c&&k==l  
                        neighborlabel3d(:,:,1)=[extra_point,extra_point,extra_point;
                                                nodenumber(i,j-1,k-1),nodenumber(i,j,k-1),extra_point;
                                                nodenumber(i+1,j-1,k-1),nodenumber(i+1,j,k-1),extra_point;];
                    
                        neighborlabel3d(:,:,2)=[extra_point,extra_point,extra_point;
                                                nodenumber(i,j-1,k),nodenumber(i,j,k),extra_point;
                                                nodenumber(i+1,j-1,k),nodenumber(i+1,j,k),extra_point;];

                        neighborlabel3d(:,:,3)=zeros(3,3)+extra_point;
                    else
                        if i==r&&j==1&&k==l
                            neighborlabel3d(:,:,1)=[extra_point,nodenumber(i-1,j,k-1),nodenumber(i-1,j+1,k-1);
                                                    extra_point,nodenumber(i,j,k-1),nodenumber(i,j+1,k-1);
                                                    extra_point,extra_point,extra_point;];
                    
                            neighborlabel3d(:,:,2)=[extra_point,nodenumber(i-1,j,k),nodenumber(i-1,j+1,k);
                                                   extra_point,nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                   extra_point,extra_point,extra_point;];
                            
                            neighborlabel3d(:,:,3)=zeros(3,3)+extra_point;
                        else
                            if i==1&&j==1&&k==l 
                                neighborlabel3d(:,:,1)=[extra_point,extra_point,extra_point;
                                                        extra_point,nodenumber(i,j,k-1),nodenumber(i,j+1,k-1);
                                                        extra_point,nodenumber(i+1,j,k-1),nodenumber(i+1,j+1,k-1);];
                    
                                neighborlabel3d(:,:,2)=[extra_point,extra_point,extra_point;
                                                        extra_point,nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                        extra_point,nodenumber(i+1,j,k),nodenumber(i+1,j+1,k);];
                                
                                
                                
                                neighborlabel3d(:,:,3)=zeros(3,3)+extra_point;
                            else
                                if i==r&&j==c&&k==l
                                    neighborlabel3d(:,:,1)=[nodenumber(i-1,j-1,k-1),nodenumber(i-1,j,k-1),extra_point;
                                                            nodenumber(i,j-1,k-1),nodenumber(i,j,k-1),extra_point;
                                                            extra_point,extra_point,extra_point;];
                    
                                    neighborlabel3d(:,:,2)=[nodenumber(i-1,j-1,k),nodenumber(i-1,j,k),extra_point;
                                                            nodenumber(i,j-1,k),nodenumber(i,j,k),extra_point;
                                                             extra_point,extra_point,extra_point;];
                                    
                                    
                                    neighborlabel3d(:,:,3)=zeros(3,3)+extra_point;
                                else
                                    if j==1&&k==1 
                                       neighborlabel3d(:,:,1)=zeros(3,3)+extra_point;
                    
                                       neighborlabel3d(:,:,2)=[extra_point,nodenumber(i-1,j,k),nodenumber(i-1,j+1,k);
                                                                extra_point,nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                extra_point,nodenumber(i+1,j,k),nodenumber(i+1,j+1,k);];

                                      neighborlabel3d(:,:,3)=[extra_point,nodenumber(i-1,j,k+1),nodenumber(i-1,j+1,k+1);
                                                              extra_point,nodenumber(i,j,k+1),nodenumber(i,j+1,k+1);
                                                              extra_point,nodenumber(i+1,j,k+1),nodenumber(i+1,j+1,k+1)];
                                    else
                                        if j==c&&k==1
                                            neighborlabel3d(:,:,1)=zeros(3,3)+extra_point;
                    
                                            neighborlabel3d(:,:,2)=[nodenumber(i-1,j-1,k),nodenumber(i-1,j,k),extra_point;
                                                                    nodenumber(i,j-1,k),nodenumber(i,j,k),extra_point;
                                                                    nodenumber(i+1,j-1,k),nodenumber(i+1,j,k),extra_point];

                                            neighborlabel3d(:,:,3)=[nodenumber(i-1,j-1,k+1),nodenumber(i-1,j,k+1),extra_point;
                                                                    nodenumber(i,j-1,k+1),nodenumber(i,j,k+1),extra_point;
                                                                    nodenumber(i+1,j-1,k+1),nodenumber(i+1,j,k+1),extra_point];
                                        else
                                            if i==1&&k==1
                                                neighborlabel3d(:,:,1)=zeros(3,3)+extra_point;
                    
                                                neighborlabel3d(:,:,2)=[extra_point,extra_point,extra_point;
                                                                        nodenumber(i,j-1,k),nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                        nodenumber(i+1,j-1,k),nodenumber(i+1,j,k),nodenumber(i+1,j+1,k);];

                                                neighborlabel3d(:,:,3)=[extra_point,extra_point,extra_point;
                                                                        nodenumber(i,j-1,k+1),nodenumber(i,j,k+1),nodenumber(i,j+1,k+1);
                                                                        nodenumber(i+1,j-1,k+1),nodenumber(i+1,j,k+1),nodenumber(i+1,j+1,k+1)];
                                            else
                                                if i==r&&k==1
                                                    neighborlabel3d(:,:,1)=zeros(3,3)+extra_point;
                    
                                                    neighborlabel3d(:,:,2)=[nodenumber(i-1,j-1,k),nodenumber(i-1,j,k),nodenumber(i-1,j+1,k);
                                                                            nodenumber(i,j-1,k),nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                            extra_point,extra_point,extra_point;];

                                                    neighborlabel3d(:,:,3)=[nodenumber(i-1,j-1,k+1),nodenumber(i-1,j,k+1),nodenumber(i-1,j+1,k+1);
                                                                            nodenumber(i,j-1,k+1),nodenumber(i,j,k+1),nodenumber(i,j+1,k+1);
                                                                            extra_point,extra_point,extra_point;];
                                                else 
                                                    if j==1&&k==l
                                                        neighborlabel3d(:,:,1)=[extra_point,nodenumber(i-1,j,k-1),nodenumber(i-1,j+1,k-1);
                                                                                extra_point,nodenumber(i,j,k-1),nodenumber(i,j+1,k-1);
                                                                                extra_point,nodenumber(i+1,j,k-1),nodenumber(i+1,j+1,k-1);];
                                                        neighborlabel3d(:,:,2)=[extra_point,nodenumber(i-1,j,k),nodenumber(i-1,j+1,k);
                                                                                extra_point,nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                                extra_point,nodenumber(i+1,j,k),nodenumber(i+1,j+1,k);];
                    
 
                                                        neighborlabel3d(:,:,3)=zeros(3,3)+extra_point;
                                                    else
                                                        if j==c&&k==l
                                                            neighborlabel3d(:,:,1)=[nodenumber(i-1,j-1,k-1),nodenumber(i-1,j,k-1),extra_point;
                                                                                    nodenumber(i,j-1,k-1),nodenumber(i,j,k-1),extra_point;
                                                                                    nodenumber(i+1,j-1,k-1),nodenumber(i+1,j,k-1),extra_point;];
                    
                                                            neighborlabel3d(:,:,2)=[nodenumber(i-1,j-1,k),nodenumber(i-1,j,k),extra_point;
                                                                                    nodenumber(i,j-1,k),nodenumber(i,j,k),extra_point;
                                                                                    nodenumber(i+1,j-1,k),nodenumber(i+1,j,k),extra_point;];

                                                            neighborlabel3d(:,:,3)=zeros(3,3)+extra_point;
                                                        else
                                                            if i==1&&k==l
                                                                neighborlabel3d(:,:,1)=[extra_point,extra_point,extra_point;
                                                                                        nodenumber(i,j-1,k-1),nodenumber(i,j,k-1),nodenumber(i,j+1,k-1);
                                                                                        nodenumber(i+1,j-1,k-1),nodenumber(i+1,j,k-1),nodenumber(i+1,j+1,k-1);];
                    
                                                                neighborlabel3d(:,:,2)=[extra_point,extra_point,extra_point;
                                                                                        nodenumber(i,j-1,k),nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                                        nodenumber(i+1,j-1,k),nodenumber(i+1,j,k),nodenumber(i+1,j+1,k);];

                                                                neighborlabel3d(:,:,3)=zeros(3,3)+extra_point;

                                                            else
                                                                if i==r&&k==l
                                                                    neighborlabel3d(:,:,1)=[nodenumber(i-1,j-1,k-1),nodenumber(i-1,j,k-1),nodenumber(i-1,j+1,k-1);
                                                                                            nodenumber(i,j-1,k-1),nodenumber(i,j,k-1),nodenumber(i,j+1,k-1);
                                                                                            extra_point,extra_point,extra_point;];
                    
                                                                    neighborlabel3d(:,:,2)=[nodenumber(i-1,j-1,k),nodenumber(i-1,j,k),nodenumber(i-1,j+1,k);
                                                                                            nodenumber(i,j-1,k),nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                                            extra_point,extra_point,extra_point;];

                                                                    neighborlabel3d(:,:,3)=zeros(3,3)+extra_point;

                                                                else
                                                                    if i==1&&j==1
                                                                        neighborlabel3d(:,:,1)=[extra_point,extra_point,extra_point;
                                                                                                extra_point,nodenumber(i,j,k-1),nodenumber(i,j+1,k-1);
                                                                                                extra_point,nodenumber(i+1,j,k-1),nodenumber(i+1,j+1,k-1);];
                    
                                                                        neighborlabel3d(:,:,2)=[extra_point,extra_point,extra_point;
                                                                                                extra_point,nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                                                extra_point,nodenumber(i+1,j,k),nodenumber(i+1,j+1,k);];

                                                                        neighborlabel3d(:,:,3)=[extra_point,extra_point,extra_point;
                                                                                                extra_point,nodenumber(i,j,k+1),nodenumber(i,j+1,k+1);
                                                                                                extra_point,nodenumber(i+1,j,k+1),nodenumber(i+1,j+1,k+1)];

                                                                    else
                                                                        if i==r&&j==1
                                                                            neighborlabel3d(:,:,1)=[extra_point,nodenumber(i-1,j,k-1),nodenumber(i-1,j+1,k-1);
                                                                                                    extra_point,nodenumber(i,j,k-1),nodenumber(i,j+1,k-1);
                                                                                                    extra_point,extra_point,extra_point;];
                    
                                                                            neighborlabel3d(:,:,2)=[extra_point,nodenumber(i-1,j,k),nodenumber(i-1,j+1,k);
                                                                                                    extra_point,nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                                                    extra_point,extra_point,extra_point;];

                                                                            neighborlabel3d(:,:,3)=[extra_point,nodenumber(i-1,j,k+1),nodenumber(i-1,j+1,k+1);
                                                                                                    extra_point,nodenumber(i,j,k+1),nodenumber(i,j+1,k+1);
                                                                                                    extra_point,extra_point,extra_point;];

                                                                        else
                                                                            if i==1&&j==c
                                                                                neighborlabel3d(:,:,1)=[extra_point,extra_point,extra_point;
                                                                                                        nodenumber(i,j-1,k-1),nodenumber(i,j,k-1),extra_point;
                                                                                                        nodenumber(i+1,j-1,k-1),nodenumber(i+1,j,k-1),extra_point;];
                    
                                                                                neighborlabel3d(:,:,2)=[extra_point,extra_point,extra_point;
                                                                                                        nodenumber(i,j-1,k),nodenumber(i,j,k),extra_point;
                                                                                                        nodenumber(i+1,j-1,k),nodenumber(i+1,j,k),extra_point;];

                                                                                neighborlabel3d(:,:,3)=[extra_point,extra_point,extra_point;
                                                                                                        nodenumber(i,j-1,k+1),nodenumber(i,j,k+1),extra_point;
                                                                                                        nodenumber(i+1,j-1,k+1),nodenumber(i+1,j,k+1),extra_point;];

                                                                            else
                                                                                if i==r&&j==c
                                                                                    neighborlabel3d(:,:,1)=[nodenumber(i-1,j-1,k-1),nodenumber(i-1,j,k-1),extra_point;
                                                                                                            nodenumber(i,j-1,k-1),nodenumber(i,j,k-1),extra_point;
                                                                                                            extra_point,extra_point,extra_point;];
                    
                                                                                    neighborlabel3d(:,:,2)=[nodenumber(i-1,j-1,k),nodenumber(i-1,j,k),extra_point;
                                                                                                            nodenumber(i,j-1,k),nodenumber(i,j,k),extra_point;
                                                                                                            extra_point,extra_point,extra_point;];

                                                                                    neighborlabel3d(:,:,3)=[nodenumber(i-1,j-1,k+1),nodenumber(i-1,j,k+1),extra_point;
                                                                                                            nodenumber(i,j-1,k+1),nodenumber(i,j,k+1),extra_point;
                                                                                                            extra_point,extra_point,extra_point;];

                                                                                else
                                                                                    if i==1
                                                                                        neighborlabel3d(:,:,1)=[extra_point,extra_point,extra_point;
                                                                                                                nodenumber(i,j-1,k-1),nodenumber(i,j,k-1),nodenumber(i,j+1,k-1);
                                                                                                                nodenumber(i+1,j-1,k-1),nodenumber(i+1,j,k-1),nodenumber(i+1,j+1,k-1);];
                    
                                                                                        neighborlabel3d(:,:,2)=[extra_point,extra_point,extra_point;
                                                                                                                nodenumber(i,j-1,k),nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                                                                nodenumber(i+1,j-1,k),nodenumber(i+1,j,k),nodenumber(i+1,j+1,k);];

                                                                                        neighborlabel3d(:,:,3)=[extra_point,extra_point,extra_point;
                                                                                                                nodenumber(i,j-1,k+1),nodenumber(i,j,k+1),nodenumber(i,j+1,k+1);
                                                                                                                nodenumber(i+1,j-1,k+1),nodenumber(i+1,j,k+1),nodenumber(i+1,j+1,k+1)];

                                                                                    else
                                                                                        if i==r
                                                                                            neighborlabel3d(:,:,1)=[nodenumber(i-1,j-1,k-1),nodenumber(i-1,j,k-1),nodenumber(i-1,j+1,k-1);
                                                                                                                    nodenumber(i,j-1,k-1),nodenumber(i,j,k-1),nodenumber(i,j+1,k-1);
                                                                                                                    extra_point,extra_point,extra_point;];
                    
                                                                                            neighborlabel3d(:,:,2)=[nodenumber(i-1,j-1,k),nodenumber(i-1,j,k),nodenumber(i-1,j+1,k);
                                                                                                                    nodenumber(i,j-1,k),nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                                                                    extra_point,extra_point,extra_point;];

                                                                                            neighborlabel3d(:,:,3)=[nodenumber(i-1,j-1,k+1),nodenumber(i-1,j,k+1),nodenumber(i-1,j+1,k+1);
                                                                                                                    nodenumber(i,j-1,k+1),nodenumber(i,j,k+1),nodenumber(i,j+1,k+1);
                                                                                                                    extra_point,extra_point,extra_point;];

                                                                                        else
                                                                                            if j==1
                                                                                                neighborlabel3d(:,:,1)=[extra_point,nodenumber(i-1,j,k-1),nodenumber(i-1,j+1,k-1);
                                                                                                                        extra_point,nodenumber(i,j,k-1),nodenumber(i,j+1,k-1);
                                                                                                                        extra_point,nodenumber(i+1,j,k-1),nodenumber(i+1,j+1,k-1);];
                    
                                                                                                neighborlabel3d(:,:,2)=[extra_point,nodenumber(i-1,j,k),nodenumber(i-1,j+1,k);
                                                                                                                        extra_point,nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                                                                        extra_point,nodenumber(i+1,j,k),nodenumber(i+1,j+1,k);];

                                                                                                neighborlabel3d(:,:,3)=[extra_point,nodenumber(i-1,j,k+1),nodenumber(i-1,j+1,k+1);
                                                                                                                        extra_point,nodenumber(i,j,k+1),nodenumber(i,j+1,k+1);
                                                                                                                        extra_point,nodenumber(i+1,j,k+1),nodenumber(i+1,j+1,k+1)];

                                                                                            else
                                                                                                if j==c
                                                                                                    neighborlabel3d(:,:,1)=[nodenumber(i-1,j-1,k-1),nodenumber(i-1,j,k-1),extra_point;
                                                                                                                            nodenumber(i,j-1,k-1),nodenumber(i,j,k-1),extra_point;
                                                                                                                            nodenumber(i+1,j-1,k-1),nodenumber(i+1,j,k-1),extra_point;];
                    
                                                                                                    neighborlabel3d(:,:,2)=[nodenumber(i-1,j-1,k),nodenumber(i-1,j,k),extra_point;
                                                                                                                            nodenumber(i,j-1,k),nodenumber(i,j,k),extra_point;
                                                                                                                            nodenumber(i+1,j-1,k),nodenumber(i+1,j,k),extra_point;];

                                                                                                    neighborlabel3d(:,:,3)=[nodenumber(i-1,j-1,k+1),nodenumber(i-1,j,k+1),extra_point;
                                                                                                                            nodenumber(i,j-1,k+1),nodenumber(i,j,k+1),extra_point;
                                                                                                                            nodenumber(i+1,j-1,k+1),nodenumber(i+1,j,k+1),extra_point;];

                                                                                                else
                                                                                                    if k==1
                                                                                                        neighborlabel3d(:,:,1)=zeros(3,3)+extra_point;
                    
                                                                                                        neighborlabel3d(:,:,2)=[nodenumber(i-1,j-1,k),nodenumber(i-1,j,k),nodenumber(i-1,j+1,k);
                                                                                                                                nodenumber(i,j-1,k),nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                                                                                nodenumber(i+1,j-1,k),nodenumber(i+1,j,k),nodenumber(i+1,j+1,k);];

                                                                                                        neighborlabel3d(:,:,3)=[nodenumber(i-1,j-1,k+1),nodenumber(i-1,j,k+1),nodenumber(i-1,j+1,k+1);
                                                                                                                                nodenumber(i,j-1,k+1),nodenumber(i,j,k+1),nodenumber(i,j+1,k+1);
                                                                                                                                nodenumber(i+1,j-1,k+1),nodenumber(i+1,j,k+1),nodenumber(i+1,j+1,k+1)];

                                                                                                    else
                                                                                                        if k==l
                                                                                                            neighborlabel3d(:,:,1)=[nodenumber(i-1,j-1,k-1),nodenumber(i-1,j,k-1),nodenumber(i-1,j+1,k-1);
                                                                                                                                    nodenumber(i,j-1,k-1),nodenumber(i,j,k-1),nodenumber(i,j+1,k-1);
                                                                                                                                    nodenumber(i+1,j-1,k-1),nodenumber(i+1,j,k-1),nodenumber(i+1,j+1,k-1);];
                    
                                                                                                            neighborlabel3d(:,:,2)=[nodenumber(i-1,j-1,k),nodenumber(i-1,j,k),nodenumber(i-1,j+1,k);
                                                                                                                                    nodenumber(i,j-1,k),nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                                                                                    nodenumber(i+1,j-1,k),nodenumber(i+1,j,k),nodenumber(i+1,j+1,k);];

                                                                                                            neighborlabel3d(:,:,3)=zeros(3,3)+extra_point;

                                                                                                        else
                                                                                                        neighborlabel3d(:,:,1)=[nodenumber(i-1,j-1,k-1),nodenumber(i-1,j,k-1),nodenumber(i-1,j+1,k-1);
                                                                                                                                nodenumber(i,j-1,k-1),nodenumber(i,j,k-1),nodenumber(i,j+1,k-1);
                                                                                                                                nodenumber(i+1,j-1,k-1),nodenumber(i+1,j,k-1),nodenumber(i+1,j+1,k-1);];
                    
                                                                                                        neighborlabel3d(:,:,2)=[nodenumber(i-1,j-1,k),nodenumber(i-1,j,k),nodenumber(i-1,j+1,k);
                                                                                                                                nodenumber(i,j-1,k),nodenumber(i,j,k),nodenumber(i,j+1,k);
                                                                                                                                nodenumber(i+1,j-1,k),nodenumber(i+1,j,k),nodenumber(i+1,j+1,k);];

                                                                                                        neighborlabel3d(:,:,3)=[nodenumber(i-1,j-1,k+1),nodenumber(i-1,j,k+1),nodenumber(i-1,j+1,k+1);
                                                                                                                                nodenumber(i,j-1,k+1),nodenumber(i,j,k+1),nodenumber(i,j+1,k+1);
                                                                                                                                nodenumber(i+1,j-1,k+1),nodenumber(i+1,j,k+1),nodenumber(i+1,j+1,k+1)];

                                                                                                        end
                                                                                                    end
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                   end
                                                                               end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end 
                                end                               
                            end                        
                        end
                    end               
                end           
            end
        end    
end
neighbors(num,:)=reshape(neighborlabel3d,[1,27]);
end
neighbors(:,14)=[];
neighbors(r*c*l+1,:)=ones(1,26)*(r*c*l+1);
end