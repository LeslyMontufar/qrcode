[file path] = uigetfile('*.jpg', 'Select photo');
file = [path file];
im = imread(file);
[filemod path] = uigetfile('*.png', 'Select model');

filemod = [path filemod];
mod= imread(filemod);

mod= imread(filemod);
modgray = rgb2gray(mod.*255);
imgray = rgb2gray(im);
modcutted = imCutQR(modgray);

str = equalizacaohist(imgray, modcutted);
figure;
imshow(str.result);
figure;
savehist(str.result, 'imagem14-EH');
figure;
imshow(str.result);
imwrite(str.result, 'imagem14-EH-primaria.png');