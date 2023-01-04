clear all
close all
clc

in_img = im2double(imread("input\lena_color_256.tif"));
subplot(2,2,1)
imshow(in_img);
title("Original");

h=fspecial('gaussian',size(in_img,1),2);
blurred = imfilter(in_img,h,"circular");
noise = 0.003*rand(size(in_img));
g= blurred+noise;%imnoise(blurred,'gaussian');
subplot(2,2,2);
imshow(g,[]);
title("Blurred");

G=fftshift(fft2(g));
subplot(2,2,3);
imshow(log(abs(G)),[]);
title("IMG Spectrum");

h=ifftshift(fspecial('gaussian',size(in_img,1),2));

H=fftshift(fft2(h));
subplot(2,2,4);
imshow(log(abs(H)),[]);
title("PSF spectrum");

F=zeros(size(in_img));
R=70;

for u=1:size(in_img,2)
    for v=1:size(in_img,1)
        du= u - size(in_img,2)/2;
        dv= v - size(in_img,1)/2;
        if du^2 + dv^2 <=R^2
            F(v,u,:) = G(v,u,:)/H(v,u);
        end
    end
end

figure;
imshow(log(abs(F)),[]);

fRestored = real(ifft2(ifftshift(F)));
figure;
imshow(fRestored,[]);

peak_in=psnr(in_img,in_img)
peak_blur=psnr(g,in_img)
peak_out=psnr(fRestored,in_img)

es=in_img;
b=es;
[r c h]=size(es);
for i=2:r-1
    for j=2:c-1
        for k=1:3
        %for first row
        mat1=[es(i-1,j-1,k),es(i-1,j,k),es(i-1,j+1,k)];
        mat1=sort(mat1);
        mat1=mat1(2);
        
        %for last column
        mat2=[es(i-1,j+1,k),es(i,j+1,k),es(i+1,j+1,k)];
        mat2=sort(mat2);
        mat2=mat2(2);
            
        %for last row
        mat3=[es(i+1,j+1,k),es(i+1,j,k),es(i+1,j-1,k)];
        mat3=sort(mat3);
        mat3=mat3(2);

        %for half of first row
        mat4=[es(i+1,j-1,k),es(i,j-1,k)];
        mat4=sort(mat4);
        mat4=mat4(2);

        %for half of middle row
        mat5=[es(i,j-1,k),es(i,j,k)];
        mat5=sort(mat5);
        mat5=mat5(2);
        
        m= [mat1,mat2,mat3,mat4,mat5];
        m=sort(m);
        b(i,j,k)=m(3);
        end
    end
end
figure;
imshow(es);
title('Image corrupted with Salt & Pepper Noise');
figure;
imshow(b);
title('Image after filtering');

peak_in=psnr(es,in_img)
peak_blur=psnr(b,in_img)