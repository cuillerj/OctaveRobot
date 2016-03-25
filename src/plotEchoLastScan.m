function [] = plotEchoLastScan(robot,plotOn)
createMatrixLastScan(robot) % creat matrix
load ('analyseMat.mat'); % load the created matrix
% rec correspond a la combinaison case angle

 angle=linspace(1,181,181); % 
 if plotOn==true
	col=['r','g','b','m','c']; % graph color 
	figure();
	title (0);
	hold on;
endif
 Z=reshape(analyseMat(1,:),2,181);  % reshape matrix (1 362) > (2 181)
	dX=Z(1,:);
	dY=Z(2,:);
	angleR=angle*pi()/180;
	X=dX.*cos(angleR);
	Y=dX.*sin(angleR);
if plotOn==true
	plot (X,Y,col(3));
endif
	X=-dY.*cos(angleR);
	Y=-dY.*sin(angleR);
if plotOn==true
	plot (X,Y,col(3));
	hold off;
endif