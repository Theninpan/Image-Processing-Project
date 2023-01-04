clc
clear all
close all
input=imread("input\lena_color_256.tif");
%es=rgb2gray(es);
img_in=imnoise(input,'salt & pepper',0.1);
img_restored=img_in;
[r c h]=size(img_in);
for i=3:r-2
    for j=3:c-2
        for k=1:3
        %for first row
        mat1=[img_in(i-2,j-2,k),img_in(i-2,j-1,k),img_in(i-2,j,k),img_in(i-2,j+1,k),img_in(i-2,j+2,k)];
        mat1=sort(mat1);
        mat1=mat1(3);

        %for last column
        mat2=[img_in(i-2,j+2,k),img_in(i-1,j+2,k),img_in(i,j+2,k),img_in(i+1,j+2,k),img_in(i+2,j+2,k)];
        mat2=sort(mat2);
        mat2=mat2(3);

        %for last row
        mat3=[img_in(i+2,j-2,k),img_in(i+2,j-1,k),img_in(i+2,j,k),img_in(i+2,j+1,k),img_in(i+2,j+2,k)];
        mat3=sort(mat3);
        mat3=mat3(3);

        m1=[mat1,mat2,mat3];
        m1=sort(m1);
        m1=m1(2);

        %for half of first column
        mat4=[img_in(i+2,j-2,k),img_in(i+1,j-2,k),img_in(i,j-2,k)];
        mat4=sort(mat4);
        mat4=mat4(2);

        %for half of middle row
        mat5=[img_in(i,j-2,k),img_in(i,j-1,k),img_in(i,j,k)];
        mat5=sort(mat5);
        mat5=mat5(2);

        m2= [mat4,mat5,m1];
        m2=sort(m2);
        img_restored(i,j,k)=m2(2);
        end
    end
end
figure;
imshow(img_in);
title('Image corrupted with Salt & Pepper Noise');
figure;
imshow(img_restored);
title('Image after filtering');
peak_in=psnr(img_in,input)
peak_blur=psnr(img_restored,input)