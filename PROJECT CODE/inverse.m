clc
close all
import inverseFilter.*;
a=imread("input\lena_color_256.tif");
a=rgb2gray(a);
subplot(2,2,1);
imshow(a);
title("Original");

psf=fspecial('motion',20,45);
b=imfilter(a,psf,'replicate');
subplot(2,2,2);
imshow(b);
title("Motion blurred");

c=imnoise(b,'gaussian');
subplot(2,2,3);
imshow(c);
title("Blurred + AddedNoise");

d=fft2(c);
ihf=fft2(psf,256,256);
%invimgR=d(:,:,1)./ihf;
%invimgG=d(:,:,2)./ihf;
%invimgB=d(:,:,3)./ihf;
%invimg=cat(3,invimgR,invimgG,invimgB);
invimg=ihf.*d;
realimg=uint8(inverseFilter(b,psf,1.5));
subplot(2,2,4);
imshow(realimg);
title("Enhanced image");

peak1=psnr(b,a);
peak2=psnr(c,a);
peakfinal=psnr(realimg,a);


