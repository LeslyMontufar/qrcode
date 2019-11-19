close all;
clc;
azul_escuro = [0 0.4470 0.7410];
azul_claro = [0.3010 0.7450 0.9330]; 

figure;
[filename, path] = uigetfile('*jpg', 'Select an Image', 'MultiSelect', 'on');
path = strcat(path, filename);
im = imread(path);
im_gray = rgb2gray(im);

hist = imhist(im_gray);
m = mean(mean(im_gray));

%subplot(121); plot(hist);
% line ([m m], [100000 0], "linestyle", "-", "color", "g"); 
% subplot(122); 
bar(imhist(im_gray), 'EdgeColor', azul_escuro);
line ([m m], [100000 0], "linestyle", "-", "color", "g"); 

saveas(gcf, [filename(1:end-4) '-with-line.png']);