  %clc;
  close all;
  clear all;
  function savehist(im, name)
    azul_escuro = [0 0.4470 0.7410];
    azul_claro = [0.3010 0.7450 0.9330];  
    if length(unique(im)) > 255 im = rgb2gray(im); end %# Verifica se a im é rgb
    saveas(bar (imhist(im), 'EdgeColor', azul_claro, 'hist'), [name '-hist.jpg']);
  end
  function saveimage(nome, im)
    imwrite(im.diff, [nome '-' im.ref '-diff.jpg']);
    imwrite(im.cutted, [nome '-' im.ref '.jpg']);
  end 
  function im_new = redimensiona(im_original, n)
    [row col e] = size(im_original);
    x = n/((row*col)^(1/2));
    im_new = imresize(im_original, [floor(row*x) floor(col*x)], 'nearest');
  end 
  function showimage(image, def, n, actual, ii)
    if nargin>4 figure; end  
    subplot(1,n,actual);
    imshow(image);
    title(def);  
  end
  function info(T, f)
    fprintf(f, 'METHOD: %s\n', T.name);
    fprintf(f, '\tMean: %g\n', T.mean)
    fprintf(f, '\tSize of cutted image: %g %g\n', T.size);
    fprintf(f, '\tPercent of error: %g\n', T.err);
    fprintf(f, '\tTime of execution: %g\n\n', T.timer);
    
  end
  function [T] = limiarconstante(c, im_original, im_modelo)
    tic; T.result = threshold(c, im_original); T.timer = toc;
    
    % isso repete
    [T.cutted T.dim] = imCutQR(T.result);
    [T.diff T.err] = imDifference(T.cutted, im_modelo);
    T.size = size(T.cutted);
    T.mean = mean(mean(T.cutted));
  end
  function [T] = equalizacaohist(im_original, im_modelo)
    tic; T.result = histeq(im_original); T.timer = toc;
    T.histogram = imhist(T.result, 256);
    T.previousmean = mean(mean(T.result));
    T.tresult = threshold(T.previousmean, T.result);
    
    % isso repete
    [T.cutted T.dim] = imCutQR(T.tresult); % tresult
    [T.diff T.err] = imDifference(T.cutted, im_modelo);
    T.size = size(T.cutted);
    T.mean = mean(mean(T.cutted));
  end
  function [T] = subregioes(n, im_original, im_modelo)
    tic;
    T.n = n;
    [lines col] = size(im_original);
    T.lines = floor(lines/T.n);
    T.col = floor(col/T.n);
    
    for i = 1 : T.n
      for j = 1 : T.n
        number = (i-1)*T.n +j; 
        
        T.result_init(:, :, number) = im_original((i-1)*T.lines + 1 : i*T.lines, ...
        (j-1)*T.col + 1 : j*T.col);
        
        T.constant(number) = mean(mean(T.result_init(:, :, number)));
        T.result_thres(:,:, number) = threshold(T.constant(number), T.result_init(:,:, number));
        
        % junta as partes da imagem binarizada
        T.result((i-1)*T.lines + 1 : i*T.lines, ...
        (j-1)*T.col + 1 : j*T.col) = T.result_thres(:,:, number); 
      end
    end
    T.timer = toc;
    
    % isso repete
    [T.cutted T.dim] = imCutQR(T.result); 
    [T.diff T.err] = imDifference(T.cutted, im_modelo);
    T.size = size(T.cutted);
    T.mean = mean(mean(T.cutted));
  end
  
  cd photo-path;
  [Photo.filename path] = uigetfile('*jpg', 'Select an Image', 'MultiSelect', 'on');
  Photo.path = strcat(path, Photo.filename);
  cd ..;
  
  cd qrcodes-path;
  [QR.filename path] = uigetfile({'*.png'; '*.jpg'}, 'Select an Image', 'MultiSelect', 'on');
  QR.path = strcat(path, QR.filename);
  cd ..;
  
  clear path;
  
  n = input('Numero para os arquivos txt: ');
  str = '\%';
  if (bool = input('Salvar logs dos metodos? (1/0) '))
    f = fopen(sprintf('info%02d.txt', n),'w');
  end
  salvar = input('Salvar todas as imagens resultantes dos metodos? (1/0) ');
  if (gerar_tabela = input('Gerar tabela de erros? (1/0) '))  
    fid = fopen(sprintf('errortable%02d.txt', n),'w'); 
  end 
  
  for ii = 1 : size(Photo.path, 2)
  
  % Coleta das imagens a serem analisadas
  Photo.rgb = imread(Photo.path{1, ii});
  Photo.gray = rgb2gray(Photo.rgb);
  Photo.mean = mean(mean(Photo.gray));
  Photo.size = size(Photo.gray);
  
  QR.rgb = imread(QR.path{1, ii});
  QR.gray = rgb2gray(QR.rgb .* 255); % png 2 gray
  QR.cutted = imCutQR(QR.gray); % Corta
  QR.mean = mean(mean(QR.cutted));
  QR.size = size(QR.cutted);
  
  fprintf(f, 'Image Information\n');
  fprintf(f, '\tfilename: %s\n\tPhoto size %g %g\n', Photo.filename{1, ii}, Photo.size);
  fprintf(f, '\tfilenameQR: %s\n\tQR Cutted size: %g %g\n\n', QR.filename{1, ii}, QR.size);
  
  % Analise das imagens

  % Binarização com limiar constante
  Image{1, ii}.M{1,1} = limiarconstante(128, Photo.gray, QR.cutted);
  Image{1, ii}.M{1,2} = limiarconstante(Photo.mean, Photo.gray, QR.cutted);
  Image{1, ii}.M{1,1}.name = 'Limiar fixo'; Image{1, ii}.M{1,1}.ref = 'LF';
  Image{1, ii}.M{1,2}.name = 'Limiar variável'; Image{1, ii}.M{1,2}.ref = 'LV';
  if bool
    info(Image{1, ii}.M{1,1}, f);
    info(Image{1, ii}.M{1,2}, f);
  end

  % Binarização pós equalização por histograma
  Image{1, ii}.M{1,3} = equalizacaohist(Photo.gray, QR.cutted);
  Image{1, ii}.M{1,3}.name = 'Equalização de Histograma'; Image{1, ii}.M{1,3}.ref = 'EH';
  if bool info(Image{1, ii}.M{1,3}, f); end
  
  % Binarização pós subdivisão em sub-regiões retangulares
  Image{1, ii}.M{1,4} = subregioes(3, Photo.gray, QR.cutted);
  Image{1, ii}.M{1,4}.name = 'Subregiões'; Image{1, ii}.M{1,4}.ref = 'S';
  if bool info(Image{1, ii}.M{1,4}, f); end
  
  % Salvando imagens (Opcional)
  if salvar
    cd im-generated;
    for m = 1 : 4
      saveimage(Photo.filename{1, ii}(1:end-4), Image{1, ii}.M{1,m});
    end 
    cd ..;
    cd artigo;
    savehist(Photo.gray, Photo.filename{1, ii}(1:end-4));
    cd ..;
  end

  % Informações uteis para a tabela (Opcional)
  Photo.version(ii) = str2num(QR.filename{1, ii}(10:11));
  Photo.errcorrection(ii) = QR.filename{1, ii}(13);
  [tabela.err(ii) ierr] = min([Image{1, ii}.M{1,1}.err Image{1, ii}.M{1,2}.err Image{1, ii}.M{1,3}.err Image{1, ii}.M{1,4}.err]);
  tabela.method{1, ii} = Image{1, ii}.M{1, ierr}.ref;
  
  % Salva linha por linha da tabela (Opcional)
  fprintf(fid, '%s & %.2f%s & %.2f%s & %.2f%s & %.2f%s & %s %s\n', Photo.filename{1, ii}(1:end-4), ...
    Image{1, ii}.M{1,1}.err,str, Image{1, ii}.M{1,2}.err,str, Image{1, ii}.M{1,3}.err,str, Image{1, ii}.M{1,4}.err,str, ...
    tabela.method{1, ii}, '\\');
  end

  if gerar_tabela fclose(fid); end
  if bool fclose(f); end
  clear m ii bool salvar gerar_tabela str f fid;

   
  ## imagem 3 padrao 1 
##  15.27
##13.97
##14.26
##13.66
  ## imagem 16 padrao 2
##  20.33
##20.73
##20.33
##21.00
  ## imagem29 padrao 3
##  49.89
##34.73
##34.24
##23.43