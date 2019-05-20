function H = getImageHomographies(originalImage, remappedImage)

    % make single

    originalImage = imread(originalImage);
    [~,~,numChannels] = size(originalImage);
    if numChannels == 4
        originalImage = originalImage(:,:,1:3);
    end
    
    remappedImage = imread(remappedImage);
    [~,~,numChannels] = size(remappedImage);
    if numChannels == 4
        remappedImage = remappedImage(:,:,1:3);
    end

    originalImage = im2single(originalImage);
    originalImage = imresize(originalImage, 0.5);

    remappedImage = im2single(remappedImage);
    remappedImage = imresize(remappedImage, 0.5);

    % make grayscale
    if size(originalImage,3) > 1
        im1g = rgb2gray(originalImage); 
    else
        im1g = originalImage;
    end
    if size(remappedImage,3) > 1
        im2g = rgb2gray(remappedImage);
    else
        im2g = remappedImage;
    end


    % --------------------------------------------------------------------
    %                                                         SIFT matches
    % --------------------------------------------------------------------

    [f1,d1] = vl_sift(im1g) ;
    [f2,d2] = vl_sift(im2g) ;

    [matches, ~] = vl_ubcmatch(d1,d2) ;

    numMatches = size(matches,2) ;

    X1 = f1(1:2,matches(1,:)) *2; X1(3,:) = 1 ;
    X2 = f2(1:2,matches(2,:)) *2; X2(3,:) = 1 ;

    % --------------------------------------------------------------------
    %                                         RANSAC with homography model
    % --------------------------------------------------------------------

    clear H score ok ;

    iterations = 100;
    score = zeros(1,iterations);
    H = cell(iterations,1);
    ok = cell(iterations,1);

    for t = 1:iterations
      % estimate homography
      subset = vl_colsubset(1:numMatches, 4) ;
      A = [] ;
      for i = subset
        A = cat(1, A, kron(X1(:,i)', vl_hat(X2(:,i)))) ;
      end
      [~,~,V] = svd(A) ;
      H{t} = reshape(V(:,9),3,3) ;

      % score homography
      X2_ = H{t} * X1 ;
      du = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:) ;
      dv = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:) ;
      ok{t} = (du.*du + dv.*dv) < 6*6 ;
      score(t) = sum(ok{t}) ;
    end

    [~, best] = max(score) ;
    H = H{best} ;

end