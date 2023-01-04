clear all
close all
clc
import J_Inverse.*;

in_img = im2double(imread("input\lena_color_256.tif"));
subplot(2,2,1)
imshow(in_img);
title("Original");
N= size(in_img,1);
h=fspecial('motion',8,45);

n=0.0001;
blurred = imfilter(in_img,h,"circular");
%F=fft2(in_img);
H=fftshift(fft2(h,N,N));
%G=F.*H;
%g=real(ifft2(G));

g = imnoise(blurred,'speckle');
subplot(2,2,2);
imshow(g,[]);
title("Blurred");


G=fftshift(fft2(g)); %learn fftshift
subplot(2,2,3);
imshow(log(abs(G)),[]);
title("IMG Spectrum");

HF=find(abs(H)<n);
%H(HF)=max(max(H))/1.5;
%H(HF)=n;

Hf=ones(N,N)./H;
%I=G./Hf;
F=zeros(size(g));
R=40;

for u=1:size(g,2)
    for v=1:size(g,1)
        du= u - size(g,2)/2;
        dv= v - size(g,1)/2;
        if du^2 + dv^2 <=R^2
            F(v,u,:) = G(v,u,:)/Hf(v,u);
        else
            F(v,u,:) = n;
        end
    end
end

%figure;
%imshow(log(abs(F)),[]);


fRestored = real(ifft2(ifftshift(F)));
im=J_Inverse(g,ifft2(H));%real(ifft2(ifftshift(I)));

subplot(2,2,4);
imshow(fRestored,[]);
title("Filtered img");

med_im = J_Median(g);
figure;imshow(med_im);title("Median");
mer_im = J_Median(fRestored);
figure;imshow(mer_im);title("Merged");


psnr(fRestored,g)
psnr(med_im,g)
psnr(mer_im,g)
