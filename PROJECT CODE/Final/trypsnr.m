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
figure(1),subplot(2,2,1),imshow(in_img),title("Original");
imshow(in_img);
title("Original");
sz=size(in_img,1);

% Adding Motion Blur and Noise
h=fspecial('motion',10,45); % PSF to add motion blur
blur_img = imfilter(in_img,h,"conv");
g=imnoise(blur_img,'gaussian'); % Adding noise to the blur_img image
figure(1),subplot(2,2,2),imshow(g,[]),title("Blurred");


%Calling Proposed median filter
imgRestored_med = J_Mode(g);
imgRestored_med = Adjust_int(imgRestored_med,g);
figure(1);
subplot(2,2,3);
imshow(imgRestored_med,[]);
title("Median filtered");

MAX=max(imgRestored_med(:));
k=MSE3D(g,imgRestored_med);
img= 20*log(MAX/(k)^(1/2))