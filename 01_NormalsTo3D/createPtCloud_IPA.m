function [pCloud] = createPtCloud_IPA(xyz, imNorm, imAmb, normFlag, rgbFlag)
    
    if rgbFlag
        r = imAmb(:,:,1);
        g = imAmb(:,:,2);
        b = imAmb(:,:,3);
        rgb = [r(:), g(:), b(:)];
    end
    
    if normFlag
        norm_x = imNorm(:,:,1);
        norm_y = imNorm(:,:,2);
        norm_z = imNorm(:,:,3);
        outNorm = [norm_x(:), norm_y(:), norm_z(:)];
    end
        
    if rgbFlag
        if normFlag
            pCloud = pointCloud(xyz, 'Color', rgb, 'Normal', im2single(outNorm));
        else
            pCloud = pointCloud(xyz, 'Color', rgb);
        end
    else
        if normFlag
            pCloud = pointCloud(xyz, 'Normal', im2single(outNorm));
        else
            pCloud = pointCloud(xyz);
        end
    end
    
end