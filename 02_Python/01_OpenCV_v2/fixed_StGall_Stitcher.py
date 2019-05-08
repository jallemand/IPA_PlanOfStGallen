from __future__ import print_function

import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt
import os
import sys


def main():

    match_conf = 0.3
    normal_files_directory = r'C:\Scratch\IPA_Data\Sampled\00_Normal_NIR'
    ambient_files_directory = r'C:\Scratch\IPA_Data\Sampled\15_Ambient_Combined\06_red_green_blue'

    normal_image_names = [r'a0_nor0.tif',
                           r'a1_nor0.tif']
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

    ambient_image_names = [r'a0_amb.tif',
                          r'a1_amb.tif']
                        # r'a2_amb.tif',
                        # r'a3_amb.tif',
                        # r'a4_amb.tif',
                        # r'a5_amb.tif',
                        # r'a6_amb.tif',
                        # r'a7_amb.tif',
                        # r'a8_amb.tif',
                        # r'a9_amb.tif']
                        # r'b1_amb.tif',
                        # r'b1_amb.tif',
                        # r'b2_amb.tif',
                        # r'b3_amb.tif',
                        # r'b4_amb.tif',
                        # r'b5_amb.tif',
                        # r'b6_amb.tif',
                        # r'b7_amb.tif',
                        # r'b8_amb.tif',
                        # r'b9_amb.tif',
                        # r'c0_amb.tif',
                        # r'c1_amb.tif',
                        # r'c2_amb.tif',
                        # r'c3_amb.tif',
                        # r'c4_amb.tif',
                        # r'c5_amb.tif',
                        # r'c6_amb.tif',
                        # r'c7_amb.tif',
                        # r'c8_amb.tif',
                        # r'c9_amb.tif',
                        # r'd0_amb.tif',
                        # r'd1_amb.tif',
                        # r'd2_amb.tif',
                        # r'd3_amb.tif',
                        # r'd4_amb.tif',
                        # r'd5_amb.tif',
                        # r'd6_amb.tif',
                        # r'd7_amb.tif',
                        # r'd8_amb.tif',
                        # r'd9_amb.tif',
                        # r'e0_amb.tif',
                        # r'e1_amb.tif',
                        # r'e2_amb.tif',
                        # r'e3_amb.tif',
                        # r'e4_amb.tif',
                        # r'e5_amb.tif',
                        # r'e6_amb.tif',
                        # r'e7_amb.tif',
                        # r'e8_amb.tif',
                        # r'e9_amb.tif',
                        # r'f0_amb.tif',
                        # r'f1_amb.tif',
                        # r'f2_amb.tif',
                        # r'f3_amb.tif',
                        # r'f4_amb.tif',
                        # r'f5_amb.tif',
                        # r'f6_amb.tif',
                        # r'f7_amb.tif',
                        # r'f8_amb.tif',
                        # r'f9_amb.tif']

    normal_image_paths = []
    ambient_image_paths = []

    for filename in normal_image_names:
        normal_image_paths.append(os.path.join(normal_files_directory, filename))

    for filename in ambient_image_names:
        ambient_image_paths.append(os.path.join(ambient_files_directory, filename))

    norm_imgs = []
    amb_imgs = []

    full_image = cv.imread(cv.samples.findFile(normal_image_paths[0]), 0)
    full_img_size = full_image.shape

    for img_name in normal_image_paths:
        img = cv.imread(cv.samples.findFile(img_name), 0)

        if img is None:
            print("can't read image " + img_name)
            sys.exit(-1)
        norm_imgs.append(img)

    for img_name in ambient_image_paths:
        img = cv.imread(cv.samples.findFile(img_name))
        if img is None:
            print("can't read image " + img_name)
            sys.exit(-1)
        amb_imgs.append(img)

    finder = cv.xfeatures2d.SURF_create(300)

    norm_kp1, norm_des1 = finder.detectAndCompute(norm_imgs[0], None)
    norm_kp2, norm_des2 = finder.detectAndCompute(norm_imgs[1], None)
    amb_kp1, amb_des1 = finder.detectAndCompute(amb_imgs[0], None)
    amb_kp2, amb_des2 = finder.detectAndCompute(amb_imgs[1], None)

    # test_feat_img = cv.drawKeypoints(amb_imgs[0], norm_kp1, None, (255, 0, 0), 4)
    # cv.namedWindow('image', cv.WINDOW_NORMAL)
    # cv.imshow('image', test_feat_img)
    # cv.resizeWindow('image', int(full_img_size[0]), int(full_img_size[1]))
    # cv.waitKey()
    #
    # test_feat_img = cv.drawKeypoints(norm_imgs[0], amb_kp1, None, (255, 0, 0), 4)
    # cv.namedWindow('image', cv.WINDOW_NORMAL)
    # cv.imshow('image', test_feat_img)
    # cv.resizeWindow('image', int(full_img_size[0]), int(full_img_size[1]))
    # cv.waitKey()
    #
    # test_feat_img = cv.drawKeypoints(amb_imgs[1], norm_kp2, None, (255, 0, 0), 4)
    # cv.namedWindow('image', cv.WINDOW_NORMAL)
    # cv.imshow('image', test_feat_img)
    # cv.resizeWindow('image', int(full_img_size[1]), int(full_img_size[1]))
    # cv.waitKey()
    #
    # test_feat_img = cv.drawKeypoints(norm_imgs[1], amb_kp2, None, (255, 0, 0), 4)
    # cv.namedWindow('image', cv.WINDOW_NORMAL)
    # cv.imshow('image', test_feat_img)
    # cv.resizeWindow('image', int(full_img_size[1]), int(full_img_size[1]))
    # cv.waitKey()
    #
    #
    #

    comb_kp1 = np.concatenate([norm_kp1, amb_kp1])
    comb_kp2 = np.concatenate([norm_kp2, amb_kp2])

    comb_des1 = np.concatenate([norm_des1, amb_des1])
    comb_des2 = np.concatenate([norm_des2, amb_des2])

    #
    # test_feat_img = cv.drawKeypoints(amb_imgs[0], comb_kp1, None, (255, 0, 0), 4)
    # cv.namedWindow('image', cv.WINDOW_NORMAL)
    # cv.imshow('image', test_feat_img)
    # cv.resizeWindow('image', int(full_img_size[0]), int(full_img_size[1]))
    # cv.waitKey()
    #
    # test_feat_img = cv.drawKeypoints(norm_imgs[0], comb_kp1, None, (255, 0, 0), 4)
    # cv.namedWindow('image', cv.WINDOW_NORMAL)
    # cv.imshow('image', test_feat_img)
    # cv.resizeWindow('image', int(full_img_size[0]), int(full_img_size[1]))
    # cv.waitKey()
    #
    # test_feat_img = cv.drawKeypoints(amb_imgs[1], comb_kp2, None, (255, 0, 0), 4)
    # cv.namedWindow('image', cv.WINDOW_NORMAL)
    # cv.imshow('image', test_feat_img)
    # cv.resizeWindow('image', int(full_img_size[1]), int(full_img_size[1]))
    # cv.waitKey()
    #
    # test_feat_img = cv.drawKeypoints(norm_imgs[1], comb_kp2, None, (255, 0, 0), 4)
    # cv.namedWindow('image', cv.WINDOW_NORMAL)
    # cv.imshow('image', test_feat_img)
    # cv.resizeWindow('image', int(full_img_size[1]), int(full_img_size[1]))
    # cv.waitKey()

    matcher = cv.detail_AffineBestOf2NearestMatcher(False, False, match_conf)
    temp_1 = cv.detail.computeImageFeatures(finder, norm_imgs[0])
    temp_2 = cv.detail.computeImageFeatures(finder, amb_imgs[0])

    temp = temp_1.append(temp_2)


if __name__ == '__main__':
    print(__doc__)
    main()
    cv.destroyAllWindows()