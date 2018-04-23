clear 
close all
clc

v = VideoWriter('Cube.mp4');
v.FrameRate = 30;
open(v);

for i = 9:-0.1:0
    
    [cube_1_x,cube_1_y] = cameracalib(0,0,0+i);
[cube_2_x,cube_2_y] = cameracalib(1,0,0+i);
[cube_3_x,cube_3_y] = cameracalib(0,1,0+i);
[cube_4_x,cube_4_y] = cameracalib(1,1,0+i);
[cube_5_x,cube_5_y] = cameracalib(0,0,1+i);
[cube_6_x,cube_6_y] = cameracalib(1,0,1+i);
[cube_7_x,cube_7_y] = cameracalib(0,1,1+i);
[cube_8_x,cube_8_y] = cameracalib(1,1,1+i);



cube_x = [ceil(cube_1_x),ceil(cube_2_x),ceil(cube_3_x),ceil(cube_4_x),ceil(cube_5_x),ceil(cube_6_x),ceil(cube_7_x),ceil(cube_8_x)];
cube_y = [ceil(cube_1_y),ceil(cube_2_y),ceil(cube_3_y),ceil(cube_4_y),ceil(cube_5_y),ceil(cube_6_y),ceil(cube_7_y),ceil(cube_8_y)];

I = imread('test_image.bmp');
h = figure
set(h,'visible','off')
imshow(I);

hold on;

plot([cube_1_x,cube_2_x],[cube_1_y,cube_2_y],'LineWidth', 2,'Color','b');
plot([cube_x(1,1),cube_x(1,2)],[cube_y(1,1),cube_y(1,2)],'LineWidth', 2,'Color','r');
plot([cube_x(1,1),cube_x(1,5)],[cube_y(1,1),cube_y(1,5)],'LineWidth', 2,'Color','r');
plot([cube_x(1,1),cube_x(1,3)],[cube_y(1,1),cube_y(1,3)],'LineWidth', 2,'Color','r');
plot([cube_x(1,3),cube_x(1,7)],[cube_y(1,3),cube_y(1,7)],'LineWidth', 2,'Color','r');
plot([cube_x(1,3),cube_x(1,4)],[cube_y(1,3),cube_y(1,4)],'LineWidth', 2,'Color','r');
plot([cube_x(1,7),cube_x(1,8)],[cube_y(1,7),cube_y(1,8)],'LineWidth', 2,'Color','r');
plot([cube_x(1,5),cube_x(1,6)],[cube_y(1,5),cube_y(1,6)],'LineWidth', 2,'Color','r');
plot([cube_x(1,5),cube_x(1,7)],[cube_y(1,5),cube_y(1,7)],'LineWidth', 2,'Color','r');
plot([cube_x(1,8),cube_x(1,6)],[cube_y(1,8),cube_y(1,6)],'LineWidth', 2,'Color','r');
plot([cube_x(1,6),cube_x(1,2)],[cube_y(1,6),cube_y(1,2)],'LineWidth', 2,'Color','r');
plot([cube_x(1,8),cube_x(1,4)],[cube_y(1,8),cube_y(1,4)],'LineWidth', 2,'Color','r');
plot([cube_x(1,4),cube_x(1,2)],[cube_y(1,4),cube_y(1,2)],'LineWidth', 2,'Color','r');
% 
saveas(h,sprintf('disconew.png'))

G = imread('disconew.png');

writeVideo(v,G);

end
close(v);



function [u_1,v_1] = cameracalib(P1,P2,P3)
I = imread('test_image.bmp');
[lx, ly] = size(I);
%figure(1),imshow(I);
load observe.dat
load model.dat
[On,Ot] = size(observe);
for i=1:On
    ic_x(i,1) = observe(i,1);
    
    ic_y(i,1) = observe(i,2);
end
[Oq,Ow,Oe] = size(model);
for i=1:Oq
    wc_x(i,1) = model(i,1);
    
    wc_y(i,1) = model(i,2);
    wc_z(i,1) = model(i,3);
end

n = On;


Q(1:2*n,1:12) = 0;

j=1;

for i=1:2:(2*n)
    Q(i,1) = wc_x(j);
    Q(i,2) = wc_y(j);
    Q(i,3) = wc_z(j);
    Q(i,4) = 1;
    Q(i+1,5) = wc_x(j);
    Q(i+1,6) = wc_y(j);
    Q(i+1,7) = wc_z(j);
    Q(i+1,8) = 1;
    Q(i,9:12) = Q(i,1:4) * -1 * ic_x(j);
    Q(i+1, 9:12) = Q(i,1:4) * -1 * ic_y(j);
    j = j+1;
end

[~,S,V] = svd(Q);

[~, minimum_index] = min(diag(S(1:12,1:12)));

m = V(1:12,minimum_index);

norm_rt = norm(m(9:11));

m_normazlised = m / norm_rt;

M(1,1:4) = m_normazlised(1:4);
M(2,1:4) = m_normazlised(5:8);
M(3,1:4) = m_normazlised(9:12);
m3 = M(3,1:4);

a1 = M(1,1:3);
a2 = M(2,1:3);
a3 = M(3,1:3);
b = M(1:3,4);
r3 = a3;

rho = -1/norm(a3);

u_o = rho^2 * (dot(a1,a3));
v_o = rho^2 * (dot(a2,a3));

crossa1a3 = cross(a1,a3);
crossa2a3 = cross(a2,a3);

theta = acos(-1 * dot(crossa1a3,crossa2a3)/(norm(crossa1a3)*norm(crossa2a3)));
alpha = norm(crossa1a3) * sin(theta);
beta = norm(crossa2a3) * sin(theta);


r1 = crossa2a3/norm(crossa2a3);
r2 = cross(r3,r1);

K = [alpha, -1*alpha*cot(theta), u_o;
    0, beta/sin(theta), v_o;
    0,0,1];

trnnls_vector = inv(K) * b;

R(1,1:3) = r1;
R(2,1:3) = r2;
R(3,1:3) = r3;

A1 = M(1,1:4);
A2 = M(2,1:4);
A3 = M(3,1:4);

Proj_points = [P1,P2,P3,1];

z_variable = A3 * Proj_points';

u_1 = (A1 * Proj_points')/z_variable;
v_1 = (A2* Proj_points')/z_variable;
end
