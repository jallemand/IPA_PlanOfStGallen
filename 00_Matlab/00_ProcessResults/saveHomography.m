function saveHomography(imRaw, imWarped, imPatch, outputFolder)

H = getImageHomographies(imRaw, imWarped);
save(fullfile(outputFolder, [imPatch, '_homography.mat']), 'H');
end

