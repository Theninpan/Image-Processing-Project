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
            tmp_mat=mat_tmp(:,:,k);
            img_restored(i-2,j-2,k)=mean(tmp_mat(:));
        end        
    end
end 
mode_filtered=Adjust_int(img_restored,m);
figure(3),subplot(2,4,3),imshow(mode_filtered,[]),title("Mean");
psnr(mode_filtered,m)