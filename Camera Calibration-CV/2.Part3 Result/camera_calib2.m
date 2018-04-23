%This .m file plots the required output 3. i.e. plotting of points on the
%coodinate exes.


clear
clc
close all
load observe.dat
load model.dat


array_x=[];

h =1;

%writing separate for loops for eachpoint to be plotted along each axis
 for i=0:10
     for j = 0:10
     [ln,lm] = cameracalib(i,j,0);
     array_x(h,1) = ceil(ln);
     array_x(h,2) = ceil(lm);
     h = h+1;
     end
 end
     
 for k=0:10
     for j = 0:10
     [ln,lm] = cameracalib(j,10,k);
     array_x(h,1) = ceil(ln);
     array_x(h,2) = ceil(lm);
     h = h+1;
     end
 end
  for k=0:10
     for j = 0:10
     [ln,lm] = cameracalib(10,j,k);
     array_x(h,1) = ceil(ln);
     array_x(h,2) = ceil(lm);
     h = h+1;
     end
 end
     
 
 
     
    
 I = imread('test_image.bmp');
 figure(1),imshow(I);
 [lx, ly] = size(array_x);
 
 %By using the logic given in lecture 7, a black dot is plotted at each
 %required point
 for i=1:lx
     mx=array_x(i,1);
     my=array_x(i,2);
     for j=mx-2:mx+2
         for k=my-2:my+2
             I(k,j)=0;
         end
     end
 end


 figure(2),imshow(I) %showing the result

%COMMENTS FOR THE FUNCTION HAVE BEEN DONE IN THE PARAMETERS.MLX FILE

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
