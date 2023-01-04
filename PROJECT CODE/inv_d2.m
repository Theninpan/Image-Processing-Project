%% Inverse filtering

close all
clear all
clc

% Read image
I = imread('input\cameraman.tif');

% Creating distorzion on the image
tf = fftshift(fft2(I));
b = lbutterworth(I,15,2);
tb = tf .* b;
tba = abs(ifft2(tb));
tba = uint8(255*mat2gray(tba));
subplot(1,2,1);
imshow(tba)

% Image reconstruction
t1 = fftshift(fft2(tba)) ./ b;
tla = real(abs(ifft2(t1)));
subplot(1,2,2);
imshow(uint8(tla),[]);