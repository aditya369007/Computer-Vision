tic
clear
clc
vid = VideoWriter('MCMC1.avi','Uncompressed AVI');
vid.FrameRate = 100;
open(vid);
I=double(imread('discs1.bmp'))/255;     % read the test image
T=double(imread('target.bmp'))/255;     % read the target image
[X, Y]=size(I); Z=zeros(X,Y);

Kmax=1000;                               % the number of random walks
num_obj = 1;
Oxy=round(rand(1,2 * num_obj)*X)+1;               % an initial position
L1=likelihood(I,T,Oxy,num_obj);               % the initial likelihood
Io=drawcircle(I,Oxy,num_obj);                 % locate the object
figure(1),imshow(Io);
Imframe(1:X,1:Y,1)=Io; Imframe(1:X,1:Y,2)=Io; Imframe(1:X,1:Y,3)=Io;
% videoseg(1)=im2frame(Imframe);          % make the first frame
writeVideo(vid,Imframe);
for i=1:Kmax
    Dxy=Oxy+round(randn(1,2 * num_obj)*20);       % random walk
    Dxy=clip(Dxy,1,X);                  % make sure the position in the image
    L2=likelihood(I,T,Dxy,num_obj);           % evaluate the likelihood
    v=min(1,L2/L1);                     % compute the acceptance ratio
    L2/L1
    u=rand;                              % draw a sample uniformly in [0 1]
    if v>u
        Oxy=Dxy;     L1=L2;             % accept the move
        Io=drawcircle(I,Oxy,num_obj);         % draw the new position
    end
    figure(1),imshow(Io);

    Imframe(1:X,1:Y,1)=Io; Imframe(1:X,1:Y,2)=Io; Imframe(1:X,1:Y,3)=Io;
%     videoseg(i+1)=im2frame(Imframe); 
        writeVideo(vid,Imframe);
        vid.FrameCount
end

close(vid);
toc