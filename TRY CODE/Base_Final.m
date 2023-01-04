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
figure(2),subplot(2,3,1),imshow(in_img),title("Original");
figure(3),subplot(2,4,1),imshow(in_img),title("Original");
imshow(in_img);
title("Original");
sz=size(in_img,1);

% Adding Motion Blur and Noise
h=fspecial('motion',10,45); % PSF to add motion blur
blur_img = imfilter(in_img,h,"conv");
g=imnoise(blur_img,'salt & pepper'); % Adding noise to the blur_img image
figure(1),subplot(2,2,2),imshow(g,[]),title("Blurred");
figure(2),subplot(2,3,2),imshow(g,[]),title("Blurred");
figure(3),subplot(2,4,2),imshow(g,[]),title("Blurred");


%Calling Proposed median filter
imgRestored_med = J_Median(g);
figure(2);
subplot(2,3,3);
imshow(imgRestored_med,[]);
title("Median filtered");

%Mode Filtering
imgRestored_mode = J_Mode(g);
figure(2);
subplot(2,3,4);
imshow(imgRestored_mode,[]);
title("Mode filtered");

%Mean Filtering
imgRestored_mean = J_Mean(g);
imgRestored_mean = Adjust_int(imgRestored_mean,g);
figure(2);
subplot(2,3,5);
imshow(imgRestored_mean,[]);
title("Mean filtered");

% Calling Inverse filter
imgRestored_inv = J_Inverse(g,h);
figure(1);
subplot(2,2,3);
imshow(imgRestored_inv,[]);
title("Inverse filtered");

%Wiener filtering
signal_var = var(in_img(:));
imgRestored_wnr = J_Wiener(g,h,signal_var);
imgRestored_wnr = Adjust_int(imgRestored_wnr,g);
figure(1)
subplot(2,2,4);
imshow(imgRestored_wnr,[])
title("Wiener filtered");

%Merged Inverse+Median filtering
imgRestored_med_inv = J_Median(imgRestored_inv);
figure(3);
subplot(2,4,3);
imshow(imgRestored_med_inv,[])
title("Inverse+Median filtered");

%Merged Wiener+Median filtering
imgRestored_med_wnr = J_Median(imgRestored_wnr);
%imgRestored_med_wnr = Adjust_int(imgRestored_med_wnr,g);
figure(3);
subplot(2,4,4);
imshow(imgRestored_med_wnr,[])
title("Wiener+Median filtered");

%Merged Inverse+Mode Filtering
imgRestored_mode_inv = J_Mode(imgRestored_inv);
figure(3);
subplot(2,4,5);
imshow(imgRestored_mode_inv,[])
title("Inverse+Mode filtered");

%Merged Wiener+Mode Filtering
imgRestored_mode_wnr = J_Mode(imgRestored_wnr);
figure(3);
subplot(2,4,6);
imshow(imgRestored_mode_wnr,[])
title("Wiener+Mode filtered");

%Merged Inverse+Mean Filtering
imgRestored_mean_inv = J_Mean(imgRestored_inv);
imgRestored_mean_inv = Adjust_int(imgRestored_mean_inv,g);
figure(3);
subplot(2,4,7);
imshow(imgRestored_mean_inv,[])
title("Inverse+Mean filtered");

%Merged Wiener+Mean Filtering
imgRestored_mean_wnr = J_Mean(imgRestored_wnr);
imgRestored_mean_wnr = Adjust_int(imgRestored_mean_wnr,g);
figure(3);
subplot(2,4,8);
imshow(imgRestored_mean_wnr,[])
title("Wiener+Mean filtered");


%Performance Metrics calculation%

%Median Merge Metrics
%Inverse+Median
tab_data=Evaluation(imgRestored_inv,imgRestored_med,imgRestored_med_inv,g);
col=["Inverse Filter","Proposed Median Filter","Merged proposed Median and Inverse filter"];
row=["Entropy","RMSE","MAE","PSNR","MSE"];
figure('Name','Inverse + Median Evaluation','NumberTitle','off');
uitable('FontSize',12,'columnname',col,'rowname',row,'position',[50 50 620 620],'data',tab_data);

%Wiener+Median
tab_data=Evaluation(imgRestored_wnr,imgRestored_med,imgRestored_med_wnr,g);
col=["Wiener Filter","Proposed Median Filter","Merged proposed Median and Wiener filter"];
row=["Entropy","RMSE","MAE","PSNR","MSE"];
figure('Name','Wiener + Median Evaluation','NumberTitle','off');
uitable('FontSize',12,'columnname',col,'rowname',row,'position',[50 50 620 620],'data',tab_data);

%Mode Merge Metrics
%Inverse+Mode
tab_data=Evaluation(imgRestored_inv,imgRestored_mode,imgRestored_mode_inv,g);
col=["Inverse Filter","Mode Filter","Merged proposed Mode and Inverse filter"];
row=["Entropy","RMSE","MAE","PSNR","MSE"];
figure('Name','Inverse + Mode Evaluation','NumberTitle','off');
uitable('FontSize',12,'columnname',col,'rowname',row,'position',[50 50 620 620],'data',tab_data);

%Wiener+Mode
tab_data=Evaluation(imgRestored_wnr,imgRestored_mode,imgRestored_mode_wnr,g);
col=["Wiener Filter","Mode Filter","Merged proposed Mode and Wiener filter"];
row=["Entropy","RMSE","MAE","PSNR","MSE"];
figure('Name','Wiener + Mode Evaluation','NumberTitle','off');
uitable('FontSize',12,'columnname',col,'rowname',row,'position',[50 50 620 620],'data',tab_data);

%Mean Merge Metrics
%Inverse+Mean
tab_data=Evaluation(imgRestored_inv,imgRestored_mean,imgRestored_mean_inv,g);
col=["Inverse Filter","Mean Filter","Merged proposed Mean and Inverse filter"];
row=["Entropy","RMSE","MAE","PSNR","MSE"];
figure('Name','Inverse + Mean Evaluation','NumberTitle','off');
uitable('FontSize',12,'columnname',col,'rowname',row,'position',[50 50 620 620],'data',tab_data);

%Wiener+Mean
tab_data=Evaluation(imgRestored_wnr,imgRestored_mean,imgRestored_mean_wnr,g);
col=["Wiener Filter","Mean Filter","Merged proposed Mean and Wiener filter"];
row=["Entropy","RMSE","MAE","PSNR","MSE"];
figure('Name','Wiener + Mean Evaluation','NumberTitle','off');
uitable('FontSize',12,'columnname',col,'rowname',row,'position',[50 50 620 620],'data',tab_data);
