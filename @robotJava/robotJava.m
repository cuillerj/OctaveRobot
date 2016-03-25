## -*- texinfo -*-
## @robotJava ()
## Create an object representing the apRobot
## @example
## robot = robotJava    create the object and name it robot
## javamethods(robot)   list the object methods
## @end example
## @end robotJava

function obj = robotJava ()
javaaddpath ('C:\Users\jean\Documents\Donnees\eclipse\RobotServer\bin\robot.jar');
  obj = struct();

  obj = class (obj, "robotJava");
obj=javaObject("RobotMainServer")
%javamethods(obj)
endfunction
