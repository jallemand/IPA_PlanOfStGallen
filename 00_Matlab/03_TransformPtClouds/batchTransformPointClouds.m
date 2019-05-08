function batchTransformPointClouds(ptCloudDir, transDir, outputDir)
    ptCloudFiles = dir(fullfile(ptCloudDir, '*.ply'));
    tfmFiles = dir(fullfile(transDir, '*.tfm'));
    n = length(ptCloudFiles);
    if  n ~= length(tfmFiles)
        error("The number of point cloud files do not match the number of transformation files\n")
    else
        
        tic
        parfor i = 1:length(ptCloudFiles)
            
            ptCloudPath = [ptCloudFiles(i).folder, '\', ptCloudFiles(i).name];
            
            tfmPath = [tfmFiles(i).folder, '\', tfmFiles(i).name];
            
            fprintf('Transforming: \n    - %s\nwith:\n    - %s\n\n', ptCloudFiles(i).name, tfmFiles(i).name);
            if strcmp(ptCloudFiles(i).name(1:end-4), tfmFiles(i).name(1:end-4))
                pcloud = pcread(ptCloudPath);
                pcloud = pcTransformWithTFM(pcloud, tfmPath);
                [~, name, ~] = fileparts(ptCloudPath);
                outPath = [outputDir, '\', name, '_local.ply'];
                pcwrite(pcloud, outPath, 'Encoding', 'binary'),
            else
                error("The transformation file doesn't match the input point cloud file.\n");
            end
        
        end
        t = toc;
        fprintf("Total processing time = %.3f\nTime per file = %.3f\n", t, t/n);
    end
end