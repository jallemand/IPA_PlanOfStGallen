from __future__ import print_function

import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt
import os
import sys


def computeAffineTransform(image1_features, image2_features):
    aff = cv.estimateAffine2D(image1_features, image2_features, np.ones([len(image1_features)]),
                              cv.LMEDS, 3, 2000, 0.99, 10)
    return aff


def getAllImages(img_names, work_megapix, seam_megapix, finder):
    full_img = cv.imread(cv.samples.findFile(img_names[0]))
    full_img_size = (full_img.shape[1], full_img.shape[0])

    features = []
    images = []

    is_work_scale_set = False
    is_seam_scale_set = False

    if work_megapix < 0:
        # If a negative value entered, use its true scale
        img = full_img
        work_scale = 1
        is_work_scale_set = True
    else:
        if is_work_scale_set is False:
            work_scale = min(1.0, np.sqrt(work_megapix * 1e6 / (full_img.shape[0] * full_img.shape[1])))
            is_work_scale_set = True
        img = cv.resize(src=full_img, dsize=None, fx=work_scale, fy=work_scale, interpolation=cv.INTER_LINEAR_EXACT)

    # Define the scale for the seams that they will be processed
    if is_seam_scale_set is False:
        seam_scale = min(1.0, np.sqrt(seam_megapix * 1e6 / (full_img.shape[0] * full_img.shape[1])))
        seam_work_aspect = seam_scale / work_scale
        is_seam_scale_set = True

    # Iterate through the images computing their features and resized images
    for name in img_names[1:]:
        # Reads the image into a numpy array
        full_img = cv.imread(cv.samples.findFile(name))

        # Check if the file could be read successfully
        if full_img is None:
            print("Cannot read image ", name)
            exit()

        # Get the image features for this image
        img_fea = cv.detail.computeImageFeatures2(finder, img)
        features.append(img_fea)
        img = cv.resize(src=full_img, dsize=None, fx=seam_scale, fy=seam_scale, interpolation=cv.INTER_LINEAR_EXACT)
        images.append(img)

        return features, images, seam_work_aspect, full_img_size, is_work_scale_set, is_seam_scale_set


def main():
    files_directory = r'C:\Scratch\IPA_Data\Sampled\00_Normal_NIR'

    image_names = [r'a0_nor0.tif',
                   r'a1 _nor0.tif']
    # r'a2_nor0.tif',
    # r'a3_nor0.tif',
    # r'a4_nor0.tif',
    # r'a5_nor0.tif',
    # r'a6_nor0.tif',
    # r'a7_nor0.tif',
    # r'a8_nor0.tif',
    # r'a9_nor0.tif']
    # r'b1_nor0.tif',
    # r'b1_nor0.tif',
    # r'b2_nor0.tif',
    # r'b3_nor0.tif',
    # r'b4_nor0.tif',
    # r'b5_nor0.tif',
    # r'b6_nor0.tif',
    # r'b7_nor0.tif',
    # r'b8_nor0.tif',
    # r'b9_nor0.tif',
    # r'c0_nor0.tif',
    # r'c1_nor0.tif',
    # r'c2_nor0.tif',
    # r'c3_nor0.tif',
    # r'c4_nor0.tif',
    # r'c5_nor0.tif',
    # r'c6_nor0.tif',
    # r'c7_nor0.tif',
    # r'c8_nor0.tif',
    # r'c9_nor0.tif',
    # r'd0_nor0.tif',
    # r'd1_nor0.tif',
    # r'd2_nor0.tif',
    # r'd3_nor0.tif',
    # r'd4_nor0.tif',
    # r'd5_nor0.tif',
    # r'd6_nor0.tif',
    # r'd7_nor0.tif',
    # r'd8_nor0.tif',
    # r'd9_nor0.tif',
    # r'e0_nor0.tif',
    # r'e1_nor0.tif',
    # r'e2_nor0.tif',
    # r'e3_nor0.tif',
    # r'e4_nor0.tif',
    # r'e5_nor0.tif',
    # r'e6_nor0.tif',
    # r'e7_nor0.tif',
    # r'e8_nor0.tif',
    # r'e9_nor0.tif',
    # r'f0_nor0.tif',
    # r'f1_nor0.tif',
    # r'f2_nor0.tif',
    # r'f3_nor0.tif',
    # r'f4_nor0.tif',
    # r'f5_nor0.tif',
    # r'f6_nor0.tif',
    # r'f7_nor0.tif',
    # r'f8_nor0.tif',
    # r'f9_nor0.tif']

    image_paths = []

    for filename in image_names:
        image_paths.append(os.path.join(files_directory, filename))


if __name__ == '__main__':
    print(__doc__)
    main()
    cv.destroyAllWindows()
