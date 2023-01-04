clear 
close all
clc
import J_Inverse.*; %importing inverse filter function
import J_Median.*;  %importing proposed median filtering function
import J_Wiener.*;  %importing Wiener filtering function
import Adjust_int.*;
import Evaluation.*;
import rmse.*;
import meanAbsoluteError.*;
import MSE3D.*;

in_img = im2double(imread("input\lena_std.tif"));
figure(1),subplot(2,2,1),imshow(in_img),title("Original");
figure(2),subplot(2,3,1),imshow(in_img),title("Original");
figure(3),subplot(2,3,1),imshow(in_img),title("Original");
imshow(in_img);
title("Original");
sz=size(in_img,1);

% Adding Motion Blur and Noise
h=fspecial('motion',10,45); % PSF to add motion blur
blur_img = imfilter(in_img,h,"conv");
g=imnoise(blur_img,'salt & pepper'); % Adding noise to the blur_img image
figure(1),subplot(2,2,2),imshow(g,[]),title("Blurred");
figure(2),subplot(2,3,2),imshow(g,[]),title("Blurred");
figure(3),subplot(2,3,2),imshow(g,[]),title("Blurred");

% Calling Inverse filter
imgRestored_inv = J_Inverse(g,h);
figure(1);
subplot(2,2,3);
imshow(imgRestored_inv,[]);
title("Inverse filtered");

%Calling Proposed median filter
imgRestored_med = J_Median(g);
figure(2);
subplot(2,3,3);
imshow(imgRestored_med,[]);
title("Median filtered");

%Merged filtering
imgRestored_merged = J_Median(imgRestored_inv);
figure(3);
subplot(2,3,3);
imshow(imgRestored_merged,[])
title("Inverse Merged filtered");

%Wiener filtering
signal_var = var(in_img(:));
imgRestored_wnr = J_Wiener(imgRestored_merged,h,signal_var);
imgRestored_wnr = Adjust_int(imgRestored_wnr,g);
figure(1)
subplot(2,2,4);
imshow(imgRestored_wnr,[])
title("Wiener filtered");

%Merged Wiener filtering
imgRestored_merged_wnr = J_Median(imgRestored_wnr);
imgRestored_wnr = Adjust_int(imgRestored_wnr,g);
figure(3);
subplot(2,3,4);
imshow(imgRestored_merged_wnr,[])
title("Merged Wiener filtered");


%Performance Metrics calculation%
%{
%PSNR
Inverse_PSNR = psnr(imgRestored_inv,g);
Median_PSNR = psnr(imgRestored_med,g);
Merged_PSNR = psnr(imgRestored_merged,g);
Wiener_PSNR = psnr(imgRestored_wnr,g);
PSNR_mat=[Inverse_PSNR,Median_PSNR,Merged_PSNR,Wiener_PSNR];

%Entropy
R_ent=entropy(imgRestored_inv(:,:,1));
G_ent=entropy(imgRestored_inv(:,:,2));
B_ent=entropy(imgRestored_inv(:,:,3));
Inv_ent=(R_ent+G_ent+B_ent)/3;

R_ent=entropy(imgRestored_med(:,:,1));
G_ent=entropy(imgRestored_med(:,:,2));
B_ent=entropy(imgRestored_med(:,:,3));
Med_ent=(R_ent+G_ent+B_ent)/3;

R_ent=entropy(imgRestored_merged(:,:,1));
G_ent=entropy(imgRestored_merged(:,:,2));
B_ent=entropy(imgRestored_merged(:,:,3));
Merge_ent=(R_ent+G_ent+B_ent)/3;

R_ent=entropy(imgRestored_wnr(:,:,1));
G_ent=entropy(imgRestored_wnr(:,:,2));
B_ent=entropy(imgRestored_wnr(:,:,3));
Wnr_ent=(R_ent+G_ent+B_ent)/3;

ent_mat=[Inv_ent,Med_ent,Merge_ent,Wnr_ent];

%RMSE
inv_rmse=rmse(imgRestored_inv,g);
med_rmse=rmse(imgRestored_med,g);
merge_rmse=rmse(imgRestored_merged,g);
wnr_rmse=rmse(imgRestored_wnr,g);
rmse_mat=[inv_rmse,med_rmse,merge_rmse,wnr_rmse];

%MAE
inv_mae=meanAbsoluteError(imgRestored_inv,g);
med_mae=meanAbsoluteError(imgRestored_med,g);
merge_mae=meanAbsoluteError(imgRestored_merged,g);
wnr_mae=meanAbsoluteError(imgRestored_wnr,g);
mae_mat=[inv_mae,med_mae,merge_mae,wnr_mae];

%MSE
inv_mse=MSE3D(g,imgRestored_inv);
med_mse=MSE3D(g,imgRestored_med);
merge_mse=MSE3D(g,imgRestored_merged);
wnr_mse=MSE3D(g,imgRestored_wnr);
mse_mat=[inv_mse,med_mse,merge_mse,wnr_mse];


perf_dat=[ent_mat;rmse_mat;mae_mat;PSNR_mat;mse_mat];
col=["Inverse Filter","Proposed Median Filter","Merged proposed Median and Inverse filter","Wiener Filtered"];
row=["Entropy","RMSE","MAE","PSNR","MSE"];
figure(3);
uitable('FontSize',12,'columnname',col,'rowname',row,'position',[50 50 620 620],'data',perf_dat);
%}

%Inverse+Median
tab_data=Evaluation(imgRestored_inv,imgRestored_med,imgRestored_merged,g);
col=["Inverse Filter","Proposed Median Filter","Merged proposed Median and Inverse filter"];
row=["Entropy","RMSE","MAE","PSNR","MSE"];
figure('Name','Inverse + Median Evaluation','NumberTitle','off');
uitable('FontSize',12,'columnname',col,'rowname',row,'position',[50 50 620 620],'data',tab_data);

%Wiener+Median
tab_data=Evaluation(imgRestored_wnr,imgRestored_med,imgRestored_merged_wnr,g);
col=["Wiener Filter","Proposed Median Filter","Merged proposed Median and Wiener filter"];
row=["Entropy","RMSE","MAE","PSNR","MSE"];
figure('Name','Wiener + Median Evaluation','NumberTitle','off');
uitable('FontSize',12,'columnname',col,'rowname',row,'position',[50 50 620 620],'data',tab_data);

