cd padrao2;
dirData = dir('*.jpg');         %# Get the selected file data
fileNames = {dirData.name};     %# Create a cell array of file names
for iFile = 1:numel(fileNames)  %# Loop over the file names
  movefile(fileNames{iFile},sprintf('imagem%02d.jpg',27-iFile));%# Rename the file
end
cd ..