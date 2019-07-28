function im_new = redimensiona(im_original, n)
    [row col e] = size(im_original);
    x = n/((row*col)^(1/2));
    im_new = imresize(im_original, [floor(row*x) floor(col*x)], 'nearest');
end