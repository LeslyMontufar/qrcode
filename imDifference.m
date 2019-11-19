function [ImDif, percenterror] = imDifference(ImOriginal, ImNew)
    
    % IMDIFFERENCE    Put in Red the differences 
    %                 between two images
    
    [rows, col] = size(ImNew);
    ImOriginal = imresize(ImOriginal, [rows col], 'nearest');
    ImDif(:, :, 1:3) = 0; % preto! 
    errorpoints = 0;
    
    for ii = 1:rows
      for jj = 1:col
        if ImNew(ii, jj) ~= ImOriginal(ii, jj)
          ImDif(ii, jj, 1) = 255;
          errorpoints = errorpoints + 1;
        else
          ImDif(ii, jj, 1:3) = ImOriginal(ii, jj);
        end
      end
    end  
    percenterror = 100*errorpoints/(rows*col);
  end
  function imK = threshold(k, im)
    [m, n] = size(im);
    for ii = 1: m
      for jj = 1: n
        if im(ii, jj) < k
          imK(ii, jj) = 0;
        else
          imK(ii, jj) = 255;
        end
      end
    end
end