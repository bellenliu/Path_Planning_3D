function [route] = Path_Scoring_3D(Main_Grid_3D,Eight_Direction_Flag)

[n1D, n2D ,n3D] = size(Main_Grid_3D);
start_node = find(Main_Grid_3D==5);
dest_node = find(Main_Grid_3D==6); % Initialize distance array
distanceFromStart = Inf(size(Main_Grid_3D));
distanceFromStart(start_node) = 0;
flagbreak = 0;

%%=== Initializing Gradient Map, Open List, Parent List %%%%%%%%%%%%%%%%%%%%%
[X, Y ,Z] = meshgrid (1:n1D, 1:n2D ,1:n3D);
[A, B, C] = ind2sub(size(Main_Grid_3D), dest_node);
H = abs(X - B) + abs(Y - A) + abs(Z - C);
H_weight = H + (H./100);
f = Inf(n1D,n2D,n3D);
f(start_node) = H(start_node);
parent_node = zeros(size(Main_Grid_3D));
loopcount = 0;

%%=== Main Loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while true
    
%     %%=== Force Stop Detection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     drawnow();
%     if strcmp(force_stop_flag.Enable, 'off');
%         flag = 7;
%         force_stop_flag.Enable = 'on';
%         start_node = []; dest_node = []; map = []; total_distance = [];
%         distanceFromStart = []; parent_node = []; time = []; route=[];
%         return;
%     end
    Main_Grid_3D(start_node) = 5;
    Main_Grid_3D(dest_node) = 6;
    
    
    %%=== Find the node with the minimum distance ( f = g+ h ) %%%%%%%%%%%%
%     if Algorithm_Selection == 3 %% for A* Heuristic
%         min_dist_value = min(f(:));
%         min_dist_candidate = find(f == min_dist_value); %%% ��map���ȳ̤p��candidate�� index
%         current_candidate = H(min_dist_candidate); %%% ���Heuristic����current�Կ諸�Ȫ��j�p
%         [~ , index] = min(current_candidate(:));
%         current = min_dist_candidate(index);
%     else
        [~, current] = min(f(:));
%     end
    
    min_dist = distanceFromStart(current);
    if ((current == dest_node) && ~isinf(min_dist))
        break;
    end;
    
    if isinf(f(current))
        flag = 8;
        start_node = []; dest_node = []; Main_Grid_3D = []; total_distance = [];
        distanceFromStart = []; parent_node = []; time = []; route=[];
        return;
    end
    
    %%=== Expand Map Cell Candidate &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    Main_Grid_3D(current) = 3;
%     [Xr,Yr,Zr] = ind2sub(size(Main_Grid_3D),current); 
%     set(handles.L3,'XData',[get(handles.L3,'XData') Xr],'YData',[get(handles.L3,'YData') Yr],'ZData',[get(handles.L3,'ZData') Zr]);
%     pause(0.01);
    
    f(current) = Inf;
    [i, j, k] = ind2sub(size(distanceFromStart), current);
    if Eight_Direction_Flag == 0
        neighbor = [i-1,j,k;... %%...�e
            i+1,j,k;... %%...��
            i,j-1,k;... %%...��
            i,j+1,k;... %%...�k
            i,j,k+1;... %%...�W�h
            i,j,k-1]; %%...�U�h  1
        direction = [1:6]';
        
    else
        neighbor = [i-1,j,k;... %%...�e 1
            i+1,j,k;... %%...�� 2
            i,j-1,k;... %%...�� 3
            i,j+1,k;... %%...�k 4
            i,j,k+1;... %%...�W�h 5
            i,j,k-1;... %%...�U�h  1   6
            
            i-1,j-1,k;... %%...���e 7
            i+1,j-1,k;... %%...���� 8
            i-1,j+1,k;... %%...�k�e 9
            i+1,j+1,k;... %%...�k�� 10
            i-1,j,k+1;... %%...�W�h�e 11
            i+1,j,k+1;... %%...�W�h�� 12 
            i,j-1,k+1;... %%...�W�h�� 13
            i,j+1,k+1;... %%...�W�h�k 14
            i-1,j,k-1;... %%...�U�h�e 15
            i+1,j,k-1;... %%...�U�h�� 16
            i,j-1,k-1;... %%...�U�h�� 17
            i,j+1,k-1;... %%...�U�h�k 1.41421   18
            
            
            i-1,j-1,k+1;... %%...�W�h���e 19
            i+1,j-1,k+1;... %%...�W�h���� 20
            i-1,j+1,k+1;... %%...�W�h�k�e 21
            i+1,j+1,k+1;... %%...�W�h�k�� 22
            i-1,j-1,k-1;... %%...�U�h���e 23
            i+1,j-1,k-1;... %%...�U�h���� 24
            i-1,j+1,k-1;... %%...�U�h�k�e 25
            i+1,j+1,k-1]; %%...�U�h�k��  1.73205    26
        
        direction = [1:26]';
            
    end
    
    %%=== To Check the Expand Candidate Make Sure in Range of Map %%%%%%%%%
    outRangetest = (neighbor(:,1)<1) + (neighbor(:,1)>n1D) +...
        (neighbor(:,2)<1) + (neighbor(:,2)>n2D ) + (neighbor(:,3)<1) + (neighbor(:,3)>n3D) ;
    
    locate = find(outRangetest>0);
    
    neighbor(locate,:)=[]; 
    direction(locate,:)=[];
    neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
    if loopcount==23
        ('asdf00');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     if(~isempty(find(direction==7))) %%%%% ���e
         if (Main_Grid_3D(neighborIndex(find(direction==7)))==1)
            neighbor(find(direction==19),:)=[];
            direction(find(direction==19),:)=[];
            neighbor(find(direction==23),:)=[];
            direction(find(direction==23),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
         end
     end
     
     if(~isempty(find(direction==8))) %%%%% ����
         if (Main_Grid_3D(neighborIndex(find(direction==8)))==1)
            neighbor(find(direction==20),:)=[];
            direction(find(direction==20),:)=[];
            neighbor(find(direction==24),:)=[];
            direction(find(direction==24),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
         end
     end
     
     if(~isempty(find(direction==9))) %%%%% �k�e
         if (Main_Grid_3D(neighborIndex(find(direction==9)))==1)
            neighbor(find(direction==21),:)=[];
            direction(find(direction==21),:)=[];
            neighbor(find(direction==25),:)=[];
            direction(find(direction==25),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
         end
     end
     
     if(~isempty(find(direction==10))) %%%%% �k�e
         if (Main_Grid_3D(neighborIndex(find(direction==10)))==1)
            neighbor(find(direction==22),:)=[];
            direction(find(direction==22),:)=[];
            neighbor(find(direction==26),:)=[];
            direction(find(direction==26),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
         end
     end
    
    
    if(~isempty(find(direction==1))) %%%%% �e
        if (Main_Grid_3D(neighborIndex(find(direction==1)))==1)
            neighbor(find(direction==11),:)=[];
            direction(find(direction==11),:)=[];
            neighbor(find(direction==15),:)=[];
            direction(find(direction==15),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==2))) %%%%% ��
        if (Main_Grid_3D(neighborIndex(find(direction==2)))==1)
            neighbor(find(direction==12),:)=[];
            direction(find(direction==12),:)=[];
            neighbor(find(direction==16),:)=[];
            direction(find(direction==16),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==3))) %%%%% ��
        if (Main_Grid_3D(neighborIndex(find(direction==3)))==1)
            neighbor(find(direction==13),:)=[];
            direction(find(direction==13),:)=[];
            neighbor(find(direction==17),:)=[];
            direction(find(direction==17),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==4))) %%%%% ��
        if (Main_Grid_3D(neighborIndex(find(direction==4)))==1)
            neighbor(find(direction==14),:)=[];
            direction(find(direction==14),:)=[];
            neighbor(find(direction==18),:)=[];
            direction(find(direction==18),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==5))) %%%%% �W
        if (Main_Grid_3D(neighborIndex(find(direction==5)))==1)
            neighbor(find(direction==11),:)=[];
            direction(find(direction==11),:)=[];
            neighbor(find(direction==12),:)=[];
            direction(find(direction==12),:)=[];
            neighbor(find(direction==13),:)=[];
            direction(find(direction==13),:)=[];
            neighbor(find(direction==14),:)=[];
            direction(find(direction==14),:)=[];
            neighbor(find(direction==19),:)=[];
            direction(find(direction==19),:)=[];
            neighbor(find(direction==20),:)=[];
            direction(find(direction==20),:)=[];
            neighbor(find(direction==21),:)=[];
            direction(find(direction==21),:)=[];
            neighbor(find(direction==22),:)=[];
            direction(find(direction==22),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    
     if(~isempty(find(direction==6))) %%%%% �U
        if (Main_Grid_3D(neighborIndex(find(direction==5)))==1)
            neighbor(find(direction==15),:)=[];
            direction(find(direction==15),:)=[];
            neighbor(find(direction==16),:)=[];
            direction(find(direction==16),:)=[];
            neighbor(find(direction==17),:)=[];
            direction(find(direction==17),:)=[];
            neighbor(find(direction==18),:)=[];
            direction(find(direction==18),:)=[];
            neighbor(find(direction==23),:)=[];
            direction(find(direction==23),:)=[];
            neighbor(find(direction==24),:)=[];
            direction(find(direction==24),:)=[];
            neighbor(find(direction==25),:)=[];
            direction(find(direction==25),:)=[];
            neighbor(find(direction==26),:)=[];
            direction(find(direction==26),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    
    
    
    
    if(~isempty(find(direction==1))&&~isempty(find(direction==3))) %%%%% ���e
        if(Main_Grid_3D(neighborIndex(find(direction==1)))==1) && (Main_Grid_3D(neighborIndex(find(direction==3)))==1)
            neighbor(find(direction==7),:)=[];
            direction(find(direction==7),:)=[];
            neighbor(find(direction==19),:)=[];
            direction(find(direction==19),:)=[];
            neighbor(find(direction==23),:)=[];
            direction(find(direction==23),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==1))&&~isempty(find(direction==4))) %%%%%% �k�e
        if(Main_Grid_3D(neighborIndex(find(direction==1)))==1) && (Main_Grid_3D(neighborIndex(find(direction==4)))==1)
            neighbor(find(direction==9),:)=[];
            direction(find(direction==9),:)=[];
            neighbor(find(direction==21),:)=[];
            direction(find(direction==21),:)=[];
            neighbor(find(direction==25),:)=[];
            direction(find(direction==25),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
            
    if(~isempty(find(direction==2))&&~isempty(find(direction==3))) %%%%%% ����
        if(Main_Grid_3D(neighborIndex(find(direction==2)))==1) && (Main_Grid_3D(neighborIndex(find(direction==3)))==1)
            neighbor(find(direction==8),:)=[];
            direction(find(direction==8),:)=[];
            neighbor(find(direction==20),:)=[];
            direction(find(direction==20),:)=[];
            neighbor(find(direction==24),:)=[];
            direction(find(direction==24),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
        
    if(~isempty(find(direction==2))&&~isempty(find(direction==4))) %%%%%% �k��
        if(Main_Grid_3D(neighborIndex(find(direction==2)))==1) && (Main_Grid_3D(neighborIndex(find(direction==4)))==1)
            neighbor(find(direction==10),:)=[];
            direction(find(direction==10),:)=[];
            neighbor(find(direction==22),:)=[];
            direction(find(direction==22),:)=[];
            neighbor(find(direction==26),:)=[];
            direction(find(direction==26),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==11))&&~isempty(find(direction==13))) %%%%%%% �W���e
        if(Main_Grid_3D(neighborIndex(find(direction==11)))==1) && (Main_Grid_3D(neighborIndex(find(direction==13)))==1)
            neighbor(find(direction==7),:)=[];
            direction(find(direction==7),:)=[];
            neighbor(find(direction==19),:)=[];
            direction(find(direction==19),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==11))&&~isempty(find(direction==14))) %%%%%%% �W�k�e
        if(Main_Grid_3D(neighborIndex(find(direction==11)))==1) && (Main_Grid_3D(neighborIndex(find(direction==14)))==1)
            neighbor(find(direction==9),:)=[];
            direction(find(direction==9),:)=[];
            neighbor(find(direction==21),:)=[];
            direction(find(direction==21),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==12))&&~isempty(find(direction==13))) %%%%%%% �W����
        if(Main_Grid_3D(neighborIndex(find(direction==12)))==1) && (Main_Grid_3D(neighborIndex(find(direction==13)))==1)
            neighbor(find(direction==8),:)=[];
            direction(find(direction==8),:)=[];
            neighbor(find(direction==20),:)=[];
            direction(find(direction==20),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==12))&&~isempty(find(direction==14))) %%%%%%% �W�k��
        if(Main_Grid_3D(neighborIndex(find(direction==12)))==1) && (Main_Grid_3D(neighborIndex(find(direction==14)))==1)
            neighbor(find(direction==10),:)=[];
            direction(find(direction==10),:)=[];
            neighbor(find(direction==22),:)=[];
            direction(find(direction==22),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==15))&&~isempty(find(direction==17))) %%%%%%% �U���e
        if(Main_Grid_3D(neighborIndex(find(direction==15)))==1) && (Main_Grid_3D(neighborIndex(find(direction==17)))==1)
            neighbor(find(direction==7),:)=[];
            direction(find(direction==7),:)=[];
            neighbor(find(direction==23),:)=[];
            direction(find(direction==23),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==15))&&~isempty(find(direction==18))) %%%%%%% �U�k��
        if(Main_Grid_3D(neighborIndex(find(direction==15)))==1) && (Main_Grid_3D(neighborIndex(find(direction==18)))==1)
            neighbor(find(direction==9),:)=[];
            direction(find(direction==9),:)=[];
            neighbor(find(direction==25),:)=[];
            direction(find(direction==25),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==16))&&~isempty(find(direction==17))) %%%%%%% �U����
        if(Main_Grid_3D(neighborIndex(find(direction==16)))==1) && (Main_Grid_3D(neighborIndex(find(direction==17)))==1)
            neighbor(find(direction==8),:)=[];
            direction(find(direction==8),:)=[];
            neighbor(find(direction==24),:)=[];
            direction(find(direction==24),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
    if(~isempty(find(direction==16))&&~isempty(find(direction==18))) %%%%%%% �U�k��
        if(Main_Grid_3D(neighborIndex(find(direction==16)))==1) && (Main_Grid_3D(neighborIndex(find(direction==18)))==1)
            neighbor(find(direction==10),:)=[];
            direction(find(direction==10),:)=[];
            neighbor(find(direction==26),:)=[];
            direction(find(direction==26),:)=[];
            neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
        end
    end
    
        
        
        
        
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     neighborIndex = sub2ind(size(Main_Grid_3D),neighbor(:,1),neighbor(:,2),neighbor(:,3));
    
    
    %%=== Fill Number Into Map Matrix and Update Distance Matrix, Parent Node, Open List Matrix
    for i=1:length(neighborIndex)
        if (Main_Grid_3D(neighborIndex(i))==6)
            
            if (direction(i) < 7) && (distanceFromStart(neighborIndex(i)) > min_dist + 1)
                distanceFromStart(neighborIndex(i)) = min_dist+1;
                parent_node(neighborIndex(i)) = current; %% �����̵u�Z�������|
            elseif (direction(i) >= 7) && (direction(i) < 19) && (distanceFromStart(neighborIndex(i)) > min_dist + 1.41421)
                distanceFromStart(neighborIndex(i)) = min_dist+1.41421;
                parent_node(neighborIndex(i)) = current; %% �����̵u�Z�������|
            elseif (direction(i) >= 19) && (distanceFromStart(neighborIndex(i)) > min_dist + 1.73205)
                distanceFromStart(neighborIndex(i)) = min_dist+1.73205;
                parent_node(neighborIndex(i)) = current; %% �����̵u�Z�������|
            end
            flagbreak=1;
            
        elseif ((Main_Grid_3D(neighborIndex(i))~=1) && (Main_Grid_3D(neighborIndex(i))~=3) && (Main_Grid_3D(neighborIndex(i))~= 5) && (Main_Grid_3D(neighborIndex(i))~=7) && (Main_Grid_3D(neighborIndex(i))~=8))
            Main_Grid_3D(neighborIndex(i)) = 4;
            
            if (direction(i) < 7) && (distanceFromStart(neighborIndex(i)) > min_dist + 1)
                distanceFromStart(neighborIndex(i)) = min_dist+1;
                parent_node(neighborIndex(i)) = current; %% �����̵u�Z�������|
            elseif (direction(i) >= 7) && (direction(i) < 19) && (distanceFromStart(neighborIndex(i)) > min_dist + 1.41421)
                distanceFromStart(neighborIndex(i)) = min_dist+1.41421;
                parent_node(neighborIndex(i)) = current; %% �����̵u�Z�������|
            elseif (direction(i) >= 19) && (distanceFromStart(neighborIndex(i)) > min_dist + 1.73205)
                distanceFromStart(neighborIndex(i)) = min_dist+1.73205;
                parent_node(neighborIndex(i)) = current; %% �����̵u�Z�������|
            end
            
%             switch Algorithm_Selection
%                 case 1 %%... Dijkstra
%                     f(neighborIndex(i)) = distanceFromStart(neighborIndex(i));
%                 case 2 %%... A*
%                     f(neighborIndex(i)) = H(neighborIndex(i))+distanceFromStart(neighborIndex(i));
%                 case 3 %%... A* Weight
%                     f(neighborIndex(i)) = H(neighborIndex(i))+distanceFromStart(neighborIndex(i));
%                 case 4 %%... Greedy Apporach
%                     f(neighborIndex(i)) = H(neighborIndex(i));
%                 case 5 %%... Heuristic Weight
                    f(neighborIndex(i)) = H_weight(neighborIndex(i)) +(1* distanceFromStart(neighborIndex(i)) ) ;
%             end
%             [Xpp,Ypp,Zpp] = ind2sub(size(Main_Grid_3D),neighborIndex(i)); 
%             set(handles.L4,'XData',[get(handles.L4,'XData') Xpp],'YData',[get(handles.L4,'YData') Ypp],'ZData',[get(handles.L4,'ZData') Zpp]);
%             set(handles.L4,'XData',[Xpp],'YData',[Ypp],'ZData',[Zpp]);
%             pause(0.001);
        end
        
        if flagbreak==1
            break;
        end
        
    end
    
    if flagbreak==1
        break;
    end
    loopcount = loopcount + 1;
    loopcount;
end



%%=== Foolproof and Get the Last Position of Destination %%%%%%%%%%%%%%%%%%
if (isinf(distanceFromStart(dest_node)))
    route = [];
else %% �������|
    route = [dest_node];
end

%%=== Construction the Optimize Path by Parent Node Matrix %%%%%%%%%%%%%%%%
while (parent_node(route(1)) ~= 0)
    route = [parent_node(route(1)), route];
end   %% �O���Ҧ����|


% %%=== Recolor the Optimize Path from Red to Green %%%%%%%%%%%%%%%%%%%%%%%%%
% for k = 2:length(route) - 1
%     map(route(k)) = 9; %% route color
% end

% toc;
% time = toc;
flag = [];
total_distance = distanceFromStart(dest_node);

end


