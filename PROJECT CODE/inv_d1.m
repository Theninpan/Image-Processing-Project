clear all
close all
clc
import J_Inverse.*;

in_img = im2double(imread("input\lena_color_256.tif"));
subplot(2,2,1)
imshow(in_img);
title("Original");

h=fspecial('motion',8,45);
blurred = imfilter(in_img,h,"circular");
g = imnoise(blurred,'gaussian');
subplot(2,2,2);
imshow(g,[]);
title("Blurred");
gamma=0.0001;
%{
G=fftshift(fft2(g));
subplot(2,2,3);
imshow(log(abs(G)),[]);
title("IMG Spectrum");

h=ifftshift(fspecial('motion',8,45));
N=size(g,1);
Hf=fftshift(fft2(h,N,N));

H = Hf.*(abs(Hf)>0)+1/gamma*(abs(Hf)==0);

F=zeros(size(g));
R=40;


for u=1:size(g,2)
    for v=1:size(g,1)
        du= u - size(g,2)/2;
        dv= v - size(g,1)/2;
        if du^2 + dv^2 <=R^2
            F(v,u,:) = G(v,u,:)/H(v,u);
        end
    end
end


figure;
imshow(log(abs(F)),[]);
%}
fRestored = inverseFilter(g,h,gamma);%real(ifft2(ifftshift(F)));
figure;
imshow(fRestored,[]);
title("Filtered");
peak_in=psnr(in_img,in_img)
peak_blur=psnr(g,in_img)
peak_out=psnr(fRestored,in_img)

