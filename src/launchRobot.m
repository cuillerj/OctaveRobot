cd ..
javaaddpath ('C:\Users\jean\Documents\Donnees\eclipse\RobotServer\bin\robot.jar');
% create and start robot
% load matrix
shiftNorthXOrientation=268; % shift between north and X direction in degres
setupPath;
robot=robotJava;
robot.SetTraceFileOn(1);    % route console to trace file
robot.LaunchBatch();          % call java method to start batch
load all_theta;
nbLocPossibility=size(all_theta,1);
predLocMatrix=InitLocMatrix(all_theta);
% load "zonesXY.txt"
j=1;
issue=0;
targetReached=false;
ready=false;
nbPred=5;
plotOn=true;
printf("create particles. \n")
CreateParticles(1000,1,plotOn);
while (ready==false)
	ready=yes_or_no(" robot ready to go ?");
end
% compute target location
[targetX,targetY,targetAngle]=ComputeTargetLocation(robot);
printf("robot target is X:%d Y:%d orientation: %d. \n",targetX,targetY,targetAngle)

% loop till target reached
	% localize robot
printf("align robot:%d  \n",shiftNorthXOrientation)
robot.NorthAlign(shiftNorthXOrientation);
count=0;
aligned=false;
issue=false;
retCode=9;
idx=1;
while (retCode==9)
	retCode=robot.GetRetcode(6,1,2);
	if (mod(idx,5)==0)
		printf("robot retcode: %d. \n",retCode);
		idx++;
	endif
	sleep(1)
end
	if (retCode==0)
		aligned=true;
		else
		issue=true
	endif

while (issue==false && targetReached==false)

%	[echoX,echoY,echoAngle,echoProb]=EchoLocalizeRobot(robot,nbLocPossibility,nbPred);
	orientation=mod(robot.GetNorthOrientation+360-shiftNorthXOrientation,360);
	printf("robot localize orientation:%d . \n",orientation)
	[echoX,echoY,echoAngle,echoProb]=EchoLocalizeRobotWithRotation(robot,nbLocPossibility,nbPred,orientation);
	
	for i=1:nbPred
		printf("robot echo location is X:%d Y:%d orientation:%d with %d%% probability. \n",echoX(i),echoY(i),echoAngle(i),echoProb(i))
	endfor
	printf("find robot location. \n")
	[newX,newY,newAngle,newProb,predLocMatrix]=DetermineRobotLocation(robot,robot.GetHardPosX(),robot.GetHardPosY(),robot.GetHardAngle,echoX,echoY,echoAngle,echoProb,predLocMatrix,shiftNorthXOrientation);
%	DetermineRobotLocationWithParticles(newX,newY,newAngle,newProb);
	DetermineRobotLocationWithParticlesGaussian(newX,newY,newAngle,newProb,plotOn);
	printf("determined location is X:%d Y:%d orientation:%d with %d%% probability. \n",newX,newY,newAngle,newProb)
	robot.SetPosX(newX);
	robot.SetPosY(newY);
	robot.SetAlpha(newAngle);
	robot.SetCurrentLocProb(newProb);
	printf("update hard robot. \n")
	robot.UpdateHardRobotLocation();
	
	retCode=9;
	hardRobotUpToDate=false;
	while (retCode==9)
		retCode=robot.GetRetcode(8,1,2);
		printf("robot retcode: %d. \n",retCode);
		sleep(1)
	end
		if (retCode==0)
			hardRobotUpToDate=true
			else
			issue=true
		endif

		if (robot.GetHardPosX==newX && robot.GetHardPosY==newY && robot.GetHardAngle==floor(newAngle))
				if (abs(targetX-robot.GetHardPosX)<=10 && abs(targetY-robot.GetHardPosY)<=10)
					targetReached=true;
					% check target reached
				else 
					% compute trajectory step
					[nextX,nextY,nextAngle] = ComputeNextStepToTarget(targetX,targetY,targetAngle)
					% move
					ready=false;
	while (ready==false)
		printf("robot goto X:%d Y:%d . \n",nextX,nextY)
		ready=yes_or_no(" ok ?")
	end 
					[rotationToDo,lenToDo]=ComputeMoveToDo(robot.GetHardPosX,robot.GetHardPosY,robot.GetHardAngle,nextX,nextY);
					printf("robot move rotation:%d len:%d . \n",rotationToDo,lenToDo*10)
					retCode=9;
					robot.Move(rotationToDo,lenToDo*10);  % len sent in mm
					MoveParticles(rotationToDo,lenToDo,plotOn);
					while (retCode==9)
						retCode=robot.GetRetcode(4,1,2);
						printf("robot retcode: %d. \n",retCode);
						sleep(1)
					end
%					while (robot.GetRunningStatus()!=105)
%					sleep(1);
%					end
					robot.SetPosX(robot.GetHardPosX());
					robot.SetPosY(robot.GetHardPosY());
					robot.SetAlpha(robot.GetHardAngle());
				endif
		else
			printf("robot location inconsistency X:%d expected:%d Y:%d expected:%d orientation:%d expected:%d. \n",robot.GetHardPosX,newX,robot.GetHardPosY,newY,robot.GetHardAngle,newAngle)
			issue=1;
		endif
end

