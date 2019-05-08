function pcloud = pcTransformWithTFM(pcloud, tfmFile)
tfm = importTFMFile(string(tfmFile));

pcloud = pctransform(pcloud, tfm);
end