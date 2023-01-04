clear 
close all
clc
import J_Inverse.*; %importing inverse filter function
import J_Median.*;  %importing proposed median filtering function
import J_Wiener.*;  %importing Wiener filtering function
import J_Mode.*; %importing Mode filtering function
import J_Mean.*; %importing Mean filtering function
import Adjust_int.*; %Adjusting intensity values by adding constant
import Evaluation.*; %Evaluation metrics 
import rmse.*;
import meanAbsoluteError.*;
import MSE3D.*;

in_img = im2double(imread("input\lena_color_512.tif"));
figure(3),subplot(2,4,1),imshow(in_img),title("Original");
imshow(in_img);
title("Original");
sz=size(in_img,1);

% Adding Motion Blur and Noise
h=fspecial('motion',10,45); % PSF to add motion blur
blur_img = imfilter(in_img,h,"conv");
g=imnoise(blur_img,'salt & pepper'); % Adding noise to the blur_img image
figure(3),subplot(2,4,2),imshow(g,[]),title("Blurred");

img_restored=zeros(size(g,1)); %empty image matrix
m=g;
g = padarray(g,[2 2],0,'both');
[r,c,h]=size(g);
for i=3:r-2
    for j=3:c-2
        mat_tmp = [g(i-2:i+2,j-2:j+2,:)];
        for k=1:3
        %for first row
        mat1=[g(i-2,j-2,k),g(i-2,j-1,k),g(i-2,j,k),g(i-2,j+1,k),g(i-2,j+2,k)];
        mat1=sort(mat1);
        mat1=median(mat1);

        %for last column
        mat2=[g(i-2,j+2,k),g(i-1,j+2,k),g(i,j+2,k),g(i+1,j+2,k),g(i+2,j+2,k)];
        mat2=sort(mat2);
        mat2=median(mat2);

        %for last row
        mat3=[g(i+2,j-2,k),g(i+2,j-1,k),g(i+2,j,k),g(i+2,j+1,k),g(i+2,j+2,k)];
        mat3=sort(mat3);
        mat3=median(mat3);

        m1=[mat1,mat2,mat3];
        m1=sort(m1);
        m1=median(m1);

        %for half of first column
        mat4=[g(i+2,j-2,k),g(i+1,j-2,k),g(i,j-2,k)];
        mat4=sort(mat4);
        mat4=median(mat4);

        %for half of middle row
        mat5=[g(i,j-2,k),g(i,j-1,k),g(i,j,k)];
        mat5=sort(mat5);
        mat5=median(mat5);

        m2= [mat4,mat5,m1];
        m2=sort(m2);
        img_restored(i-2,j-2,k)=median(m2);
        end        
    end
end 
mode_filtered=img_restored;
figure(3),subplot(2,4,3),imshow(mode_filtered,[]),title("Mode");
psnr(mode_filtered,m)