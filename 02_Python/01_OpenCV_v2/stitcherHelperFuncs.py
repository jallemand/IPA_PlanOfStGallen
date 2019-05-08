from __future__ import print_function

import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt
import os
import sys


def getCombinedFeatures(norm_img1, norm_img2, amb_img1, amb_img2, finder):
    # This function computes and combines the keypoints and descriptors found in the normal and ambient images
    norm_kp1, norm_des1 = finder.detectAndCompute(norm_img1, None)
    norm_kp2, norm_des2 = finder.detectAndCompute(norm_img2, None)
    amb_kp1, amb_des1 = finder.detectAndCompute(amb_img1, None)
    amb_kp2, amb_des2 = finder.detectAndCompute(amb_img2, None)

    comb_kp1 = np.append(norm_kp1, amb_kp1)
    comb_kp2 = np.append(norm_kp2, amb_kp2)
    comb_des1 = np.append(norm_des1, amb_des1)
    comb_des2 = np.append(norm_des2, amb_des2)

    return comb_kp1, comb_kp2, comb_des1, comb_des2
