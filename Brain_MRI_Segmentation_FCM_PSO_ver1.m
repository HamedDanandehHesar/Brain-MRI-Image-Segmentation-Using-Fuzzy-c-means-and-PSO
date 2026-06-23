clear                     % Remove all variables from workspace
close all                 % Close all open figure windows
warning off
% Load ECG data from MAT file
[file, path] = uigetfile('*.jpg','Select ECG mat file');
Img = imread([path '\' file]);
if size(Img,3)==1
Gray_Scale = Img;
else 
Gray_Scale = rgb2gray(Img)  ;
end
CS = Gray_Scale ;
Input_Img = CS ;
Inputs = Input_Img(:) ;
Inputs = double (Inputs) ;
data =Inputs ;
%% PSO FCM parameters
VarMin = 0 ;
VarMax = 255 ;
MaxIteration = 30 ;
number_of_Population = 12 ;
Number_of_Clusters = 4 ;
Fuzziness_q = 2 ;

[S1,S2] = size(Img);

[OutPut,Cost] = Discrete_FCM_PSO_ver2(data,VarMin,VarMax,MaxIteration,number_of_Population,Number_of_Clusters,Fuzziness_q) ;

ClusterCenters = OutPut.Centers ;

U = OutPut.Position ;
[ClusterCenters,ind] = sort(ClusterCenters,'ascend');

U1 = zeros(size(U));
U1 = U(ind,:);
U = U1;

maxU = max(U) ;
U1 = U(1,:) ; ind1 = find(U1==maxU) ;
U2 = U(2,:) ; ind2 = find(U2==maxU) ;
U3 = U(3,:) ; ind3 = find(U3==maxU) ;
U4 = U(4,:) ; ind4 = find(U4==maxU) ;

Label = zeros(length(data),1) ;
Label(ind1) = 1 ; N_Label1 = numel(find(Label==1)) ;
Label(ind2) = 2 ; N_Label2 = numel(find(Label==2)) ;
Label(ind3) = 3 ; N_Label3 = numel(find(Label==3)) ;
Label(ind4) = 4 ; N_Label4 = numel(find(Label==4)) ;
% All_Num_Labels = [N_Label1 N_Label2 N_Label3 N_Label4] ;
% [~,Ind_Ventricle] = min (All_Num_Labels) ;
Label = reshape(Label,[S1,S2]) ;
  
CSF_binary = Label==2;
CSF = (uint8(CSF_binary)).*Img;
% figure,imshow(CSF);
WM_binary = Label==4;
% figure,imshow(WM_binary)
WM = (uint8(WM_binary)).*Img;
% figure,imshow(WM)
GM_binary = Label==3;
% figure,imshow(GM_binary)
GM = uint8(GM_binary).*Img;
% figure,imshow(GM)

figure,subplot(2,2,1),imshow(Img),title(file)
subplot(2,2,2),imshow(CSF_binary),title('CSF Binary')
subplot(2,2,3),imshow(GM_binary),title('Gray Matter Binary')
subplot(2,2,4),imshow(WM_binary),title('White Matter Binary')

Colored_output = zeros(S1,S2,3);
Colored_output(:,:,1) = uint8(255*CSF_binary);
Colored_output(:,:,2) = uint8(255*WM_binary);
Colored_output(:,:,3) = uint8(255*GM_binary);

figure,subplot(1,2,1),imshow(Img),title(file)
subplot(1,2,2),imshow(Colored_output)




%% Functions


function [OutPut,BestCost] = Discrete_FCM_PSO_ver2(Inputs,VarMin,VarMax,MaxIt,nPop,ClusterNumber,q)
% Example:
% I = imread() ;
%[S1,S1] = size(I) ;
% data = I(:) ;
% VarMin = 0 ; VarMax = 1 ; nPop = 12 ; ClusterNumber = 4 ;
% U = OutPut.Position ;
% maxU = max(U) ; 
% U1 = U(1,:) ; ind1 = find(U1==maxU) ;
% U2 = U(2,:) ; ind2 = find(U2==maxU) ;
% U3 = U(3,:) ; ind3 = find(U3==maxU) ;
% U4 = U(4,:) ; ind4 = find(U4==maxU) ;
% Lab = zeros(length(data),1) ;
% Lab(ind1) = 1 ;
% Lab(ind2) = 2 ;
% Lab(ind3) = 3 ;
% Lab(ind4) = 4 ;
% Lab = reshape(Lab,[S1,S2]) ;
% figure ; imagesc(Lab) ;

[nData,~] = size(Inputs) ;
VarSize = [ClusterNumber,nData] ;
empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Out=[];
empty_particle.Velocity=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.Out=[];

particle=repmat(empty_particle,nPop,1);

BestSol.Cost=inf;

for i=1:nPop
    % Initialize Position
    particle(i).Position = initfcm(ClusterNumber,nData);
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    % Evaluation
	[particle(i).Position,particle(i).Centers, particle(i).Cost] = stepfcm(Inputs, particle(i).Position, ClusterNumber, q);
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Out=particle(i).Out;
    % Update Global Best
    if particle(i).Best.Cost<BestSol.Cost
        BestSol=particle(i).Best;   
    end
end
BestCost=zeros(MaxIt,1);

%% PSO Main Loop
% Constriction Coefficients of PSO
phi1=2.05;
phi2=2.05;
phi=phi1+phi2;
chi=2/(phi-2+sqrt(phi^2-4*phi));
w=chi;          % Inertia Weight
wdamp=1;        % Inertia Weight Damping Ratio
c1=chi*phi1;    % Personal Learning Coefficient
c2=chi*phi2;    % Global Learning Coefficient
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;

for it=1:MaxIt
    for i=1:nPop
        % Update Velocity
        particle(i).Velocity = w*(particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(BestSol.Position-particle(i).Position));
        % Apply Velocity Limits
        particle(i).Velocity(particle(i).Velocity>VelMax) = VelMax ;
        particle(i).Velocity(particle(i).Velocity<VelMin) = VelMin ;
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        % Apply Position Limits
          particle(i).Position(particle(i).Position>VarMax) = VarMax ;
          particle(i).Position(particle(i).Position<VarMin) = VarMin ;
        % Evaluation
        [particle(i).Position, particle(i).Centers, particle(i).Cost] = stepfcm(Inputs, particle(i).Position, ClusterNumber, q);
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            particle(i).Best=particle(i);
%             particle(i).Best.Cost=particle(i).Cost;
%             particle(i).Best.Out=particle(i).Out;
            % Update Global Best
            if particle(i).Best.Cost<BestSol.Cost
                BestSol=particle(i).Best;   
            end  
        end   
    end
    BestCost(it)=BestSol.Cost;
%     disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    w=w*wdamp;  
end
OutPut = BestSol ;
%% Results

% figure;
% plot(BestCost,'LineWidth',2);
% xlabel('Iteration');
% ylabel('Best Cost');

end