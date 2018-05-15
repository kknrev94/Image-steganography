clc;
close all;
clear all;
tic
img  = imread('a.png'); 
%img  = rgb2gray(img);      
img=imresize(img,[300 300]);
img  = double(img);
c = 0.005;                        % Initialise the weight of stegnography
subplot(221);imshow(uint8(img)),title('Original Image');
[p q] = size(img);
p1=p;
q1=q;
%Generate the key 
n = imread('b.png');
n = rgb2gray(n);
key = imresize(double(n),[p q]);
subplot(222); imshow(uint8(key)),title('Key');
[ca,ch,cv,cd] = dwt2(img,'db1');    % Compute 2D wavelet transform
%Perform the encryption
y = [ca ch;cv cd];

Y = y + c*key; 
p=p/2;q=q/2;
for i=1:p
    for j=1:q
        nca(i,j) = Y(i,j);
        ncv(i,j) = Y(i+p,j);
        nch(i,j) = Y(i,j+q);
        ncd(i,j) =  Y (i+p,j+q);    
    end
end
%Display the stego image
wimg = idwt2(nca,nch,ncv,ncd,'db1');
subplot(223); imshow(uint8(wimg)),title('stego Image');
%Extraction of key from stego image
[rca,rch,rcv,rcd] = dwt2(wimg,'db1');% Compute 2D wavelet transform
n1=[rca,rch;rcv,rcd];
N1=n1-y;
subplot(224); imshow(double(N1));
%%%% Calculating PSNR & MSE
 origImg = double(img);
 stegoImg = double(n);
   [M N] = size(origImg);
   stegoImg1=imresize(stegoImg,[M N]);
   error = origImg - stegoImg1;
   MSE = sum(sum(error .* error)) / (M * N);
   if(MSE > 0)
       PSNR = (10*log(255*255/MSE)) / log(10);
   else
       PSNR = 99;
   end 
   PSNR1 = PSNR
   MSE1 = MSE
  %  disp(PSNR)
  %  disp(MSE)
  %   
   %%%% Normalisation of stego image
   stego=double(n)./255;
% psnrop=psnr(N1,key)
title('Extracted key from stego image')
figure,imshow(y/256)
toc                 