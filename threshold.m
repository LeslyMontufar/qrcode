function im_new = threshold(k, im)
  
    % THRESHOLD      Threshold with a constant K 
    %                threshold(k, im);

    [m n] = size(im);
    
    for ii = 1: m
      for jj = 1: n
        if im(ii, jj) < k
          im_new(ii, jj) = 0;
        else
          im_new(ii, jj) = 255;
        end
      end
    end
    
end