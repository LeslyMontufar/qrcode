  fid = fopen(sprintf('tabela%02d.txt', n),'w');
##  fprintf(fid, '\\textbf{Nome da Imagem}& \\textbf{Vers�o}& \\textbf{N�vel de Corre��o de Erro}& \\textbf{Erro (\\%)}& \\textbf{M�todo} %s \n','\\\hline' )
  for ii = 1 : size(Photo.path, 2)
    fprintf(fid, '%s & %g & %c & %g & %s %s', Photo.filename{1, ii}(1:end-4), ...
    Photo.version(ii), Photo.errcorrection(ii), ...
    tabela.err(ii), tabela.method{1, ii}, '\\\hline');
    fprintf(fid, '\n');
  end
  fclose(fid);