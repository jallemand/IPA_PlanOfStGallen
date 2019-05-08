from __future__ import print_function

import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt
import os


def drawlines(img1, img2, lines, pts1, pts2):
    """ img1 - image on which we draw the epilines for the points in img2
        lines - corresponding epilines """
    r, c, _ = img1.shape

    for r, pt1, pt2 in zip(lines, pts1, pts2):
        color = tuple(np.random.randint(0, 255, 3).tolist())
        x0, y0 = map(int, [0, -r[2]/r[1]])
        x1, y1 = map(int, [c, -(r[2]+r[0]*c)/r[1]])
        img1 = cv.line(img1, (x0, y0), (x1, y1), color, 1)
        img1 = cv.circle(img1, tuple(pt1), 5, color, -1)
        img2 = cv.circle(img2, tuple(pt2), 5, color, -1)

    return img1, img2


def main():
    files_directory = r'C:\Scratch\IPA_Data\Sampled\15_Ambient_Combined\06_red_green_blue'

    image_names = [r'a0_amb.tif',
                   r'b0_amb.tif']

    image_paths = []

    for filename in image_names:
        image_paths.append(os.path.join(files_directory, filename))

    img1 = cv.imread(image_paths[0], 1)
    img2 = cv.imread(image_paths[1], 1)

    surf = cv.xfeatures2d.SURF_create()

    surf.setHessianThreshold(400)

    # find the keypoints and descriptors with SIFT
    kp1, des1 = surf.detectAndCompute(img1, None)
    kp2, des2 = surf.detectAndCompute(img2, None)

    print(len(kp1))
    print(len(kp2))

    img3 = cv.drawKeypoints(img1, kp1, None, (255, 0, 0), 4)
    img4 = cv.drawKeypoints(img2, kp2, None, (255, 0, 0), 4)

    bf = cv.BFMatcher()
    matches = bf.knnMatch(des1, des2, k=2)

    # Apply ratio test
    good = []
    pts2 = []
    pts1 = []

    for i, (m, n) in enumerate(matches):
        if m.distance < 0.8 * n.distance:
            good.append(m)
            pts2.append(kp2[m.trainIdx].pt)
            pts1.append(kp1[m.queryIdx].pt)

    pts1 = np.int32(pts1)
    pts2 = np.int32(pts2)
    f_matrix, mask = cv.findFundamentalMat(pts1, pts2, cv.FM_LMEDS)
    homog = cv.findHomography(pts1, pts2)

    aff = cv.estimateAffine2D(pts1, pts2, np.ones([len(pts1)]), cv.LMEDS, 3, 2000, 0.99, 10)

    warp_dst = cv.warpAffine(img1, aff[0], (img2.shape[1], img2.shape[0]))

    center = (warp_dst.shape[1] // 2, warp_dst.shape[0] // 2)

    cv.imshow('Source image', img2)
    cv.imshow('Warp', warp_dst)

    cv.waitKey()

    #
    # print(f_matrix)
    # print(homog)
    # print(f_matrix - homog)
    #
    # # cv.drawMatchesKnn expects list of lists as matches.
    # # Find epilines corresponding to points in right image (second image) and
    # # drawing its lines on left image
    # lines1 = cv.computeCorrespondEpilines(pts2.reshape(-1, 1, 2), 2, f_matrix)
    # lines1 = lines1.reshape(-1, 3)
    # img5, img6 = drawlines(img1, img2, lines1, pts1, pts2)
    #
    # # Find epilines corresponding to points in left image (first image) and
    # # drawing its lines on right image
    # lines2 = cv.computeCorrespondEpilines(pts1.reshape(-1, 1, 2), 1, f_matrix)
    # lines2 = lines2.reshape(-1, 3)
    # img3, img4 = drawlines(img2, img1, lines2, pts2, pts1)
    # plt.subplot(121), plt.imshow(img5)
    # plt.subplot(122), plt.imshow(img3)
    # plt.show()


if __name__ == '__main__':
    print(__doc__)
    main()
    cv.destroyAllWindows()



