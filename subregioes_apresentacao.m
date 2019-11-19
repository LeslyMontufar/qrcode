clc;
close all;
clear all;  

cd photo-path;
[Photo.filename, path] = uigetfile('*jpg', 'Select an Image');
Photo.path = strcat(path, Photo.filename);
cd ..;

cd qrcodes-path;
[QR.filename, path] = uigetfile({'*.png'; '*.jpg'}, 'Select an Image');
QR.path = strcat(path, QR.filename);
cd ..;

clear path;

ii=1;
Photo.rgb = imread(Photo.path);
Photo.gray = rgb2gray(Photo.rgb);
Photo.mean = mean(mean(Photo.gray));
Photo.size = size(Photo.gray);

QR.rgb = imread(QR.path);
QR.gray = rgb2gray(QR.rgb .* 255); % png 2 gray
QR.cutted = imCutQR(QR.gray); % Corta
QR.mean = mean(mean(QR.cutted));
QR.size = size(QR.cutted);


% Binarização pós subdivisão em sub-regiões retangulares
Image{1, ii}.M{1,4} = subregioes(3, Photo.gray, QR.cutted);
Image{1, ii}.M{1,4}.name = 'Subregiões'; Image{1, ii}.M{1,4}.ref = 'S';
 
function [T] = subregioes(n, im_original, im_modelo)
    tic;
    T.n = n;
    [lines, col] = size(im_original);
    T.lines = floor(lines/T.n);
    T.col = floor(col/T.n);
    
    for i = 1 : T.n
      for j = 1 : T.n
        number = (i-1)*T.n +j; 
        
        T.result_init(:, :, number) = im_original((i-1)*T.lines + 1 : i*T.lines, ...
        (j-1)*T.col + 1 : j*T.col);
        
        subplot(n, n, number);imshow(T.result_init(:, :, number));
        
        T.constant(number) = mean(mean(T.result_init(:, :, number)));
        T.result_thres(:,:, number) = threshold(T.constant(number), T.result_init(:,:, number));
        
        % junta as partes da imagem binarizada
        T.result((i-1)*T.lines + 1 : i*T.lines, ...
        (j-1)*T.col + 1 : j*T.col) = T.result_thres(:,:, number); 
      end
    end
    T.timer = toc;
    
    % isso repete
    [T.cutted, T.dim] = imCutQR(T.result); 
    [T.diff, T.err] = imDifference(T.cutted, im_modelo);
    T.size = size(T.cutted);
    T.mean = mean(mean(T.cutted));
  end