clear all;
load ../images.mat;
clc;

h = y1./x1;
H = fft2(h)