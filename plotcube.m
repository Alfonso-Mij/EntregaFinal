function plot_3d_cube() %%theta in radian
% Parameters
clc;
clear;
x_length = 20; y_length = 20; z_length = 20; cube_color = [0.75 0.75 0.75]; x_point = 50; y_point = 70;z_point = 0;theta = 35;

%H=[0+x_point ,1*x_length+x_point ,0+x_point ,1*x_length+x_point ,0+x_point ,1*x_length+x_point,0+x_point,1*x_length+x_point; 0+y_point,0+y_point,1*y_length+y_point,1*y_length+y_point,0+y_point,0+y_point,1*y_length+y_point,1*y_length+y_point; 0+z_point,0+z_point,0+z_point,0+z_point,1*z_length+z_point ,1*z_length+z_point,1*z_length+z_point, 1*z_length+z_point];
%H=[0 ,80 ,0 ,80 ,0 ,80 ,0 ,80; 0 ,0 ,20 ,20 ,0 ,0 ,20 ,20; 0 ,0 ,0 ,0 ,20 ,20 ,20 , 20]; %Vertices of the cube
H=[0 ,1 ,0 ,1 ,0 ,1 ,0 ,1; 0 ,0 ,1 ,1 ,0 ,0 ,1 ,1; 0 ,0 ,0 ,0 ,1 ,1 ,1 , 1];

    sinTheta = sind(theta);
    cosTheta = cosd(theta);
    
    for j = 1 : 1 : 8
        xs = H(1,j);
        ys = H(2,j);
        
        disp(H(1,j));
        
        H(1,j) = xs * cosTheta - ys * sinTheta;
        H(2,j) = ys * cosTheta + xs * sinTheta;
        disp(H(1,j));
        
    end




byLength = H .* [x_length; y_length; z_length];
% plusPoints = byLength + [x_point; y_point; z_point];
H = byLength + [x_point; y_point; z_point]
S=[1 2 4 3; 1 2 6 5; 1 3 7 5; 3 4 8 7; 2 4 8 6; 5 6 8 7]; %Surfaces of the cube

% xs = H(1,3);
% ys = H(2,1:8);
%ys = H();
%node = H;
% disp(xs);
% disp(ys);

figure(1)
hold on
    for i=1:size(S,1)    
        Si=S(i,:); 
%         fill3(plusPoints(1,Si),plusPoints(2,Si),plusPoints(3,Si),cube_color,'facealpha',1)
        fill3(H(1,Si),H(2,Si),H(3,Si),cube_color,'facealpha',1);
    end
axis equal, hold off, view(20,10)
end