function createDiffImage(imgPath1, imgPath2, outFolder, wave1, wave2, formatType)
    temp = split(imgPath1, '\');
    temp = temp{end};
    temp = split(temp, '_');
    outFileName = [temp{1}, formatType, 'absdiff_', char(string(wave1-1)), '_', char(string(wave2-1)), '.png'];
    outMatFile = [temp{1}, formatType, 'diff_', char(string(wave1-1)), '_', char(string(wave2-1)), '.mat'];
    outPath = fullfile(outFolder, outFileName);
    outMatPath = fullfile(outFolder, outMatFile);
    
    img1 = int8(imread(imgPath1));
    img2 = int8(imread(imgPath2));
    
    diff = img1 - img2;
    save(outMatPath, 'diff');
    
    diff = uint8(abs(single(diff)));
    imwrite(diff, outPath, 'png', 'BitDepth',8);
    fprintf('%s ...... Complete.\n', outPath);
end