function [ImCutted vector]= imCutQR(ImOriginal)
    
    % IMCUTQR    Crop QR image in order to 
    %            select just the essencial data
    
    [rows col] = size(ImOriginal);
    sup_right = [0 0];
    bottom_left = [0 0];
    col = min(rows, col);
    flag = 0; 
    for b = col : -1 : 1
      for u = 0 : 1 : col-b - 1
        y = u + b;
        if flag == 1 break; end; 
        if  ImOriginal(y+1, u+1) == 0    % 0 é preto!
          bottom_left(1) = y+1;
          bottom_left(2) = u+1;
          flag = 1;
          break;
        end
      end  
      if flag == 1 break; end;
    end
    flag = 0;
    for b = -col : 1 : -1
      for u = -b : 1 : col - 1
        y = u + b;
        if flag == 1 break; end; 
        if ImOriginal(y+1,u+1) == 0 % linha e coluna (y, x)
          sup_right(1) = y+1;
          sup_right(2) = u+1;
          flag = 1;
          break;
        end
      end
     if flag == 1 break; end; 
    end
    
    % info
    x1 = bottom_left(2);
    y1 = sup_right(1);
    x2 = sup_right(2);
    y2 = bottom_left(1);
    rows_new = bottom_left(1) - sup_right(1);
    col_new = sup_right(2) - bottom_left(2);
    
    try
      ImCutted = imcrop(ImOriginal, vector=[x1 y1 col_new rows_new] );
    catch
      ImCutted = ImOriginal;
      fprintf('Nao precisou cortar\n');
    end
end