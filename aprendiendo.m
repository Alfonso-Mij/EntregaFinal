% test_patch.m
clc;
clear;


xi = 30;
yi = 230;   % (30, 230)
xf = 260;
yf = 80;    % (260, 80)
x1 = 100;
y1 = 100;   % (70, 140)
x2 = 180;
y2 = 270;   % (180, 270)


yy = [yi; y1; y2; yf];
xx = [xi^3 xi^2 xi 1;
      x1^3 x1^2 x1 1;
      x2^3 x2^2 x2 1;
      xf^3 xf^2 xf 1];

cofs = xx\ yy;

a = cofs(1);
b = cofs(2);
c = cofs(3);
d = cofs(4);

f  = @(x) (a*(x.^3) + (b*(x.^2)) + (c*x) + d);
fdt = @(x) (a*(3*x.^2) + (b*(2*x)) + c);
f2dt = @(x) (6*a*x + b*2);

x = xi:xf;
y = f(x);
z = f(x)*0;

lasX = x;
lasY = y;
% Puntos críticos
cr1 = abs((2*b - sqrt((2*b)^2-12*a*c))/(6*a));
cr2 = abs((2*b + sqrt((2*b)^2-12*a*c))/(6*a));

% Radio de la curvatura
r1 = abs(((1+fdt(x1)^2)^(3/2))/f2dt(x1));
r2 = abs(((1+fdt(x2)^2)^(3/2))/f2dt(x2));


lfdt = @(x) sqrt(1 + fdt(x).^2);
longitudPista = integral(lfdt, xi, xf);

% Graficación
%axes('XLim',[0 300],'YLim',[0 300],'ZLim',[0 300],'XDir','reverse','YDir','reverse');
view(2)
hold on;
line(x,y,z+1,'Color','k','LineWidth',4)
line(x,y,z+1,'Color','y','LineStyle','--')

%% Crando base de mapa

% Define vertices
vertices = [
    0,0,0;
    300,0,0;
    300,300,0;
    0,300,0;]; 

% Define faces
faces = [
    1, 2, 3, 4]; % face #1

% Draw patch
figure(1);
patch('Faces', faces, 'Vertices', vertices, 'FaceColor', 'g');

% Axes settings
xlabel('x'); ylabel('y'); zlabel('z');
axis vis3d equal;
view([142.5, 30]);
camlight;


%% Calculos
syms x
% Min N Max points
primeraD = (a*(3*x.^2)) + (b*(2*x)) + c;
answer = solve( primeraD == 0, x, 'MaxDegree', 3);
resultado = vpa(answer,6);
sprintf("Max: %s , %s", resultado(1), f(resultado(1)))
plot3(resultado(1), f(resultado(1)),3, '.');   
text(resultado(1), f(resultado(1)),10, '\leftarrow Max')
sprintf("Min: %s, %s", resultado(2), f(resultado(2)))
plot3(resultado(2), f(resultado(2)), 3, '.')
text(resultado(2), f(resultado(2)),10, '\leftarrow Min')

% Inflection point
segundaD = 6*a*x + 2*b;
answer2 = vpasolve(segundaD == 0, x, [-inf, inf]);
sprintf("Inflection: %s , %s", answer2(1), f(answer2(1)))
plot3(answer2(1), f(answer2(1)),3, '.');
text(answer2(1), f(answer2(1)),10, '\leftarrow Inflection')

% Track length
longitud_pista = integral(lfdt, xi, xf);
disp("Longitud de la pista: " + longitud_pista);

% Radius of curvature
valores = radiocurvatura(resultado(1), f(resultado(1)), fdt(resultado(1)), f2dt(resultado(1)));
plotcircle(valores(2), valores(3), valores(1));
plot3(valores(2), valores(3), 3, '.');
sprintf("Radio Curvatura Max: %s and %s",valores(2), valores(3))

valores_dos = radiocurvatura(resultado(2), f(resultado(2)), fdt(resultado(2)), f2dt(resultado(2)));
plotcircle(valores_dos(2), valores_dos(3), valores_dos(1));
plot3(valores_dos(2), valores_dos(3),3, '.');
sprintf("Radio Curvatura Min: %s and %s",valores_dos(2), valores_dos(3))
%axis([-20 20 -20 20])

% rc_inflection = radiocurvatura(answer2(1), f(answer2(1)),fdt(answer2(1)), f2dt(answer2(1)));
% sprintf("Radio Curvatura Punto Inflexión: %s", rc_inflection(1))
%daspect manual;
%(x_location, y_location, z_location, theta_grada)

%% Movimiento del auto x2 
generadorGradas(120, 90, 0, 60);

contador = 0;
while contador <= 3
% (xp,yp, theta)
coche = generadorAuto(lasX(1), lasY(1), atand(lfdt(1)));
ubicacion = text(lasX(1),  lasY(1), 7,['\leftarrow X: ', num2str(lasY(1))], 'Color','k', 'FontSize', 8);
for i = 1:5: length(lasX)
    delete(coche)
    delete(ubicacion)
    punto_ubi = lasX(i);
    ubicacion = text(lasX(i),  lasY(i), 7,['\leftarrow X: ', num2str(lasY(i))], 'Color','k', 'FontSize', 8);
    if lasX(i) > 81.28 && lasX(i) < 199
        coche = generadorAuto(lasX(i), lasY(i), atand(lfdt(i))+180);
    else 
        coche = generadorAuto(lasX(i), lasY(i), atand(lfdt(i)));
    %drawnow;
    end
     pause(0.1);
end
delete(coche)
delete(ubicacion)
contador = contador +1;
end



%% Functions 
function h = plotcircle(xs,ys,r)
    th = 0:pi/50:2*pi;
    xunit = r*cos(th) + xs;
    yunit = r*sin(th) + ys;
    h = plot(xunit, yunit, 'LineWidth',4);
end

% Input (x,f(x), f'(x), f''(x) )     f(x) = y
% [Radio de curvatura, x, y] de circulo


function t = radiocurvatura(xs, ys,fdtx, f2dtx)
    %r_c = (1 + (fdtx)^2)^(3/2)/ abs(f2dtx);
    r_c = abs(   sqrt(   (  1  + (fdtx).^2   ).^3   )   /  abs(f2dtx));
    alfa = xs - ((fdtx*(1+ fdtx^2))/f2dtx);
    beta = ys + ((1 + fdtx^2)/f2dtx);
    t = [r_c, alfa, beta];
end

% Plot Cube Plot
function [objeto] = plot_3d_cube(x_length, y_length, z_length, cube_color, x_point, y_point, z_point, theta) %%theta in radian
H=[0 ,1 ,0 ,1 ,0 ,1 ,0 ,1; 0 ,0 ,1 ,1 ,0 ,0 ,1 ,1; 0 ,0 ,0 ,0 ,1 ,1 ,1 , 1];

    sinTheta = sind(theta);
    cosTheta = cosd(theta);
    
    for j = 1 : 1 : 8
        xs = H(1,j);
        ys = H(2,j);
        
        H(1,j) = xs * cosTheta - ys * sinTheta;
        H(2,j) = ys * cosTheta + xs * sinTheta;
    end

byLength = H .* [x_length; y_length; z_length];
H = byLength + [x_point; y_point; z_point];
S=[1 2 4 3; 1 2 6 5; 1 3 7 5; 3 4 8 7; 2 4 8 6; 5 6 8 7]; %Surfaces of the cube

% elPatch = patch(H(1,1),H(2,1),H(3,1),cube_color);
%     for i=1:size(S,1)    
%         Si=S(i,:); 
%         elPatch = patch(H(1,Si),H(2,Si),H(3,Si),cube_color);
%     end
% objeto = elPatch;
objeto1 = patch(H(1,S(1,:)),H(2,S(1,:)),H(3,S(1,:)),cube_color);
objeto2 = patch(H(1,S(2,:)),H(2,S(2,:)),H(3,S(2,:)),cube_color);
objeto3 = patch(H(1,S(3,:)),H(2,S(3,:)),H(3,S(3,:)),cube_color);
objeto4 = patch(H(1,S(4,:)),H(2,S(4,:)),H(3,S(4,:)),cube_color);
objeto5 = patch(H(1,S(5,:)),H(2,S(5,:)),H(3,S(5,:)),cube_color);
objeto6 = patch(H(1,S(6,:)),H(2,S(6,:)),H(3,S(6,:)),cube_color);
objeto = [objeto1, objeto2, objeto3, objeto4, objeto5, objeto6];
end

function [gradaFinal]= generadorGradas(x_location, y_location, z_location, theta_grada)
% (x_length, y_length, z_length, cube_color, x_point, y_point, z_point, theta)
    x_l = 10;
    y_l = 10;
    z_l = 10;
    c_color = [0.75 0.75 0.75];
    
  %  if theta_grada >= 0 && theta_grada <= 90
        c1x = x_location + (-35*cosd(theta_grada));
        c1y = y_location + (-35*sind(theta_grada));
        c2x = x_location + (-25* cosd(theta_grada));
        c2y = y_location + (-25*sind(theta_grada));
        c3x = x_location + (-15* cosd(theta_grada));
        c3y = y_location + (-15*sind(theta_grada));
        c4x = x_location + (-5* cosd(theta_grada));
        c4y = y_location + (-5*sind(theta_grada));
        c5x = x_location + (5* cosd(theta_grada));
        c5y = y_location + (5*sind(theta_grada));
        c6x = x_location + (15* cosd(theta_grada));
        c6y = y_location + (15*sind(theta_grada));
        c7x = x_location + (25* cosd(theta_grada));
        c7y = y_location + (25*sind(theta_grada));
        c8x = x_location + (35*cosd(theta_grada));
        c8y = y_location + (35*sind(theta_grada));
        
   % end
    
    C1 = plot_3d_cube(x_l, y_l, z_l, c_color, c1x, c1y, z_location, theta_grada);
    C2 = plot_3d_cube(x_l, y_l, z_l, c_color, c2x, c2y, z_location, theta_grada);
    C3 = plot_3d_cube(x_l, y_l, z_l, c_color, c3x, c3y, z_location, theta_grada);
    C4 = plot_3d_cube(x_l, y_l, z_l, c_color, c4x, c4y, z_location, theta_grada);
    C5 = plot_3d_cube(x_l, y_l, z_l, c_color, c5x, c5y, z_location, theta_grada);
    C6 = plot_3d_cube(x_l, y_l, z_l, c_color, c6x, c6y, z_location, theta_grada);
    C7 = plot_3d_cube(x_l, y_l, z_l, c_color, c7x, c7y, z_location, theta_grada);
    C8 = plot_3d_cube(x_l, y_l, z_l, c_color, c8x, c8y, z_location, theta_grada);
    
    gradaFinal = [C1, C2, C3, C4, C5, C6, C7, C8];
end


% (x_length, y_length, z_length, cube_color, x_point, y_point, z_point, theta)
function [carrito] = generadorAuto(xp,yp, theta)
    
    p1x = xp + (-12*cosd(theta));
    p1y = yp + (-12*sind(theta));
    p2x = xp + (-4*cosd(theta));
    p2y = yp + (-4*sind(theta));
    p3x = xp + (4*cosd(theta));
    p3y = yp + (4*sind(theta));
    p4x = xp + (12*cosd(theta));
    p4y = yp + (12*sind(theta));
    p5x = xp + (4*cosd(theta));
    p5y = yp + (4*sind(theta));
    
    
    car1 = plot_3d_cube(8, 8, 8, 'r', p1x, p1y, 2, theta);
    car2 = plot_3d_cube(8, 8, 8, 'r', p2x, p2y, 2, theta);
    car3 = plot_3d_cube(8, 8, 8, 'r', p3x, p3y, 2, theta);
    car4 = plot_3d_cube(8, 8, 8, 'r', p4x, p4y, 2, theta);
    car5 = plot_3d_cube(8, 8, 8, 'b', p5x, p5y, 6, theta);
    
    carrito = [car1, car2, car3, car4, car5];
end

% function arbol = generadorArboles(point_x, point_y)
%     %arboles de 3*3
%     arb1 = plot_3d_cube(3, 3, 3, [0.2 0 0], point_x, point_y, 0, 0);
%     arb2 = plot_3d_cube(3, 3, 3, [0.2 0 0], point_x, point_y, 3, 0);
%     arb3 = plot_3d_cube(3, 3, 3, [0.2 0 0], point_x, point_y, 6, 0);
%     
%     vertices = [0+point_x, 1.5, 7;3+point_x, 1.5, 7;3+point_x ,1.5, 11;point_x, 1.5, 11;]; 
%     faces = [1, 2, 3, 4]; % face #1
%     vertices2 =[1.5, 0+point_y, 7; 1.5, 3+point_y, 7; 1.5, point_y, 11; 1.5, 0+point_y, 11];
%     faces2 =[1, 2, 3, 4];
% 
%     hojas1 = patch('Faces', faces, 'Vertices', vertices, 'FaceColor', 'g');
%     hojas2 = patch('Faces', faces2, 'Vertices', vertices2, 'FaceColor', 'g');
%     
%     arbol = [arb1, arb2, arb3, hojas1, hojas2];
% end