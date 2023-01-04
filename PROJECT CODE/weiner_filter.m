clc
clear all
close all
f=im2double(imread("input\lena_std.tif"));
subplot(2,2,1);
imshow(f,[]);
title("Original image");
N=size(f,1);

% Adding Motion Blur and Noise
h=fspecial('motion',10,45); % PSF to add motion blur
g= imfilter(f,h,"conv");
g=imnoise(g,'gaussian'); 
subplot(2,2,2);
imshow(g,[]);
title("Degraded image");

h=ifftshift(h);
H=fftshift(fft2(h,N,N));
G=fftshift(fft2(g));

Hs=conj(H);
Hm=(Hs.*H);
noise_var=0.001;
signal_var = var(f(:));
Fs=zeros(size(g));
max_psnr = psnr(Fs,g);
while noise_var < 1
    k=noise_var/signal_var;
    tmp_Fs=(Hs./(Hm+k)).*G;
    tmp_fs = real(ifft2(ifftshift(tmp_Fs)));
    tmp_psnr=psnr(tmp_fs,g);
    if tmp_psnr > max_psnr
        max_psnr=tmp_psnr;
        Fs=tmp_Fs;
    end
    noise_var=noise_var+0.001;
end


fs=real(ifft2(ifftshift(Fs)));
subplot(2,2,3);
imshow(fs,[]);
title("Enhanced image");
psnr(fs,g)
