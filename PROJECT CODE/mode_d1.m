clear all
close all
clc
import J_Inverse.*; %importing inverse filter function
import J_Median.*;  %importing proposed median filtering function
import rmse.*;
import meanAbsoluteError.*;
import MSE3D.*;

in_img = im2double(imread("input\lena_color_256.tif"));
subplot(2,3,1)
imshow(in_img);
title("Original");
sz=size(in_img,1);

% Adding Motion Blur and Noise
h=fspecial('gaussian',sz,2); % PSF to add motion blur
blur_img = imfilter(in_img,h,"replicate");
g=imnoise(blur_img,'salt & pepper'); % Adding noise to the blur_img image
subplot(2,3,2);
imshow(g,[]);
title("Blurred");



img_restored=zeros(size(g,1));



img_g = J_Inverse(g);
subplot(2,3,3);
imshow(img_g,[]);
title("Inversed");
img_restored=mode_d2(g);
im1= img_restored;
subplot(2,3,4);
imshow(img_restored,[]);
title("Mode filtered");
ll=g;
g = padarray(g,[1 1],'replicate','post');
[r c h]=size(g);

for i=2:r-1
    for j=2:c-1
        for k=1:3
            mat1 = g(i-1:i+1,j-1:j+1,k);
            mm=mode(mat1(:));
            img_restored(i-1,j-1,k)=mm;
        end      
    end
end 
subplot(2,3,5);
imshow(img_restored,[]);
title("Mode filtered mine");

psnr(ll,in_img)
psnr(img_g,in_img)
psnr(im1,in_img)
psnr(img_restored,in_img)
