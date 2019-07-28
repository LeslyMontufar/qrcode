function savehist(im, name)
    azul_escuro = [0 0.4470 0.7410];
    azul_claro = [0.3010 0.7450 0.9330];  
    if length(unique(im)) > 255 im = rgb2gray(im); end %# Verifica se a im é rgb
    saveas(bar (imhist(im), 'EdgeColor', azul_claro, 'hist'), [name '-hist.jpg']);
  end