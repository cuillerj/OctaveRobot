function [] = CreateCartoImage(name)
% load carto en format txt et save au format matrice
strfin='.txt';
str=strcat(name,strfin)
X=load (str);
X=X';
%X=fliplr(X);
[x,y]=size(X);

carto1img=zeros(10*y,10*x);
for i=0:x-1
	for j=0:y-1
		init=X(i+1,j+1);
			for k=10*i+1:10*i+11
				for l=10*j+1:10*j+11
					carto1img(l,k)=init;
				endfor
			endfor
	endfor
endfor
strfin='.mat';
matrix=strcat(name,strfin);
name=carto1img;
save ("-mat4-binary","carto1img.mat","carto1img")
%save ("-mat4-binary",matrix,"name")
endfunction