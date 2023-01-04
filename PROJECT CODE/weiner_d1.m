clear 
close all
clc
import J_Median.*;

in_img = im2double(imread("input\lena_std.tif"));
subplot(2,3,1)
imshow(in_img);
title("Original");
sz=size(in_img,1);

% Adding Motion Blur and Noise
h=fspecial('motion',10,45); % PSF to add motion blur
blur_img = imfilter(in_img,h,"conv");
g=imnoise(blur_img,'salt & pepper'); % Adding noise to the blur_img image
subplot(2,3,2);
imshow(g,[]);
title("Blurred");


signal_var = var(in_img(:));
img_res=zeros(size(g));
max_psnr=psnr(img_res,g);
noise_var=0.001;
%k=J_Median(g);
while noise_var < 0.01
    NSR = noise_var / signal_var;
    img_temp=deconvwnr(g,h,NSR);
    tmp_psnr=psnr(img_temp,g);
    if tmp_psnr > max_psnr
        max_psnr=tmp_psnr;
        img_res=img_temp;
    end
    noise_var=noise_var+0.001;
end 

%img_res=J_Median(img_res);
inten=0.001;
img_temp=img_res;
while inten < 1
    img_temp=img_temp+inten;
    tmp_psnr=psnr(img_temp,g);
    if tmp_psnr > max_psnr
        max_psnr=tmp_psnr;
        img_res=img_temp;
    end
    inten=inten+0.003;
end 

subplot(2,3,3);
imshow(img_res,[]);
title("Weiner");

psnr(img_res,g)