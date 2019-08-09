figure;
[filename path] = uigetfile('*jpg', 'Select an Image', 'MultiSelect', 'on');
path = strcat(path, filename);
im = imread(path);
im_gray = rgb2gray(im);

hist = imhist(im_gray);
m = mean(mean(im_gray));
plot(hist);
line ([m m], [100000 0], "linestyle", "-", "color", "g");
