%nbTrain=797
%nbMesurementByTrain=15;
%nbScanId=143
load ('extScanResultV500.mat');
extScanResult=extScanResultV500;
nbTrain=size(extScanResult,1)
pixelBF=zeros(2,181);
trainMat=zeros((nbTrain/15),362);
trainResult=zeros((nbTrain/15),1);
trainNumber=1;
j=1;
i=1;
while(j < nbTrain)
	trainNumber;
	pixelBF=zeros(2,181);
	idScan=extScanResult(j,1);
	trainResult(trainNumber)=extScanResult(j,5);
		while (extScanResult(j,1)<=idScan && j < nbTrain)
				extScanResult(j,2);
				angle=extScanResult(j,2);
				k=angle;
				pixelBF(1,k+1)=extScanResult(j,3);
				pixelBF(2,k+1)=extScanResult(j,4);

				if (j < nbTrain)
					angleNext=extScanResult(j+1,2);
					interval=1;
						while (k < angleNext )
							pixelBF(1,k+2)=extScanResult(j,3)+(extScanResult(j+1,3)-extScanResult(j,3))/(angleNext-angle)*interval; % +1 VS valeur angle
							pixelBF(2,k+2)=extScanResult(j,4)+(extScanResult(j+1,4)-extScanResult(j,4))/(angleNext-angle)*interval;
							if (extScanResult(j,3)==0 || extScanResult(j+1,3)==0)  % pas d extrapolation si 0
								pixelBF(1,k+2)=0;
							end
							if (extScanResult(j,4)==0 || extScanResult(j+1,4)==0)
								pixelBF(2,k+2)=0;
							end
							k=k+1;
							interval=interval+1;
						end
				end
				j=j+1  ;
		end
		pixelBF;
		trainMat(trainNumber,:)=reshape (pixelBF,1,[]);
%		j=j+1;
		i=i+1;
		trainNumber=trainNumber+1; 
%	trainMat(i,:)=reshape (x,1,[]);
end

trainMatV500=trainMat;
size(trainMatV500)
trainResultV500=trainResult;
save  ("-mat4-binary","trainMatV500.mat","trainMatV500")
save  ("-mat4-binary","trainResultV500.mat","trainResultV500")