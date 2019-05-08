# """
# Stitching sample (advanced)
# ===========================
#
# Show how to use Stitcher API from python.
# https://github.com/opencv/opencv/blob/master/samples/python/stitching_detailed.py
# """

# Python 2/3 compatibility
from __future__ import print_function

import numpy as np
import cv2 as cv


def main():
    img_names = [r'C:\Scratch\IPA_Data\FullRes\a0_nor.tif',
                 r'C:\Scratch\IPA_Data\FullRes\a1_nor.tif',
                 r'C:\Scratch\IPA_Data\FullRes\a2_nor.tif',
                 r'C:\Scratch\IPA_Data\FullRes\a3_nor.tif',
                 r'C:\Scratch\IPA_Data\FullRes\a4_nor.tif',
                 r'C:\Scratch\IPA_Data\FullRes\a5_nor.tif',
                 r'C:\Scratch\IPA_Data\FullRes\a6_nor.tif',
                 r'C:\Scratch\IPA_Data\FullRes\a7_nor.tif',
                 r'C:\Scratch\IPA_Data\FullRes\a8_nor.tif',
                 r'C:\Scratch\IPA_Data\FullRes\a9_nor.tif']
                 # r'C:\Scratch\IPA_Data\FullRes\b0_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\b1_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\b2_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\b3_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\b4_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\b5_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\b6_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\b7_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\b8_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\b9_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\c0_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\c1_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\c2_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\c3_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\c4_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\c5_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\c6_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\c7_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\c8_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\c9_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\d0_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\d1_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\d2_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\d3_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\d4_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\d5_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\d6_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\d7_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\d8_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\d9_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\e0_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\e1_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\e2_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\e3_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\e4_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\e5_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\e6_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\e7_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\e8_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\e9_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\f0_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\f1_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\f2_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\f3_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\f4_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\f5_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\f6_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\f7_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\f8_nor.tif',
                 # r'C:\Scratch\IPA_Data\FullRes\f9_nor.tif']
    print(img_names)

    # ================ DEFINE ALL PARAMETERS ================
    # Flags
    try_cuda = False
    work_megapix = 8
    features_type = "surf"
    matcher_type = "homography"
    estimator_type = "homography"
    match_conf = 0.75
    conf_thresh = 1.0

    ba_cost_func = "ray"
    ba_refine_mask = "xxxxx"
    wave_correct = "vert"
    save_graph_var = None

    # Compositing Flags
    warp_type = "affine"
    seam_megapix = 2.0
    seam_find_type = "gc_color"
    compose_megapix = -1
    expos_comp = "no"
    expos_comp_nr_feeds = 1
    # expos_comp_nr_filtering = 2
    expos_comp_block_size = 32
    blend_type = "multiband"
    blend_strength = 5
    result_name = "test_result_3.png"
    timelapse_name = None
    range_width = 8

    # Check if there is to be wave correction, then set the boolean check value
    if wave_correct == 'no':
        do_wave_correct = False
    else:
        do_wave_correct = True

    # Check if there is to be a graph file created
    if save_graph_var is None:
        save_graph = False
    else:
        save_graph = True
        save_graph_to = save_graph_var

    # Check if the exposure is to be compensated, if so define which compensator to use
    if expos_comp == 'no':
        expos_comp_type = cv.detail.ExposureCompensator_NO
    elif expos_comp == 'gain':
        expos_comp_type = cv.detail.ExposureCompensator_GAIN
    elif expos_comp == 'gain_blocks':
        expos_comp_type = cv.detail.ExposureCompensator_GAIN_BLOCKS
    elif expos_comp == 'channel':
        expos_comp_type = cv.detail.ExposureCompensator_CHANNELS
    elif expos_comp == 'channel_blocks':
        expos_comp_type = cv.detail.ExposureCompensator_CHANNELS_BLOCKS
    else:
        print("Bad exposure compensation method")
        exit()

    # Check if the timelapse is to be output. AKA the intermediate layers
    if timelapse_name is not None:
        timelapse = True
        if timelapse_name == "as_is":
            timelapse_type = cv.detail.Timelapser_AS_IS
        elif timelapse_name == "crop":
            timelapse_type = cv.detail.Timelapser_CROP
        else:
            print("Bad timelapse method")
            exit()
    else:
        timelapse = False

    # Check the feature type to be used and create the finder class that will be used
    # TODO - See if there other feature detectors which are more suitable
    if features_type == 'orb':
        finder = cv.ORB.create()
    elif features_type == 'surf':
        finder = cv.xfeatures2d_SURF.create(200, 8, 4, False, False)
    elif features_type == 'sift':
        finder = cv.xfeatures2d_SIFT.create()
    else:
        print("Unknown descriptor type")
        exit()

    # Pre-allocate other variables to work with
    seam_work_aspect = 1    # Seam aspect ratio
    full_img_sizes = []     # Size of full images
    features = []           # Array for storing features
    images = []             # Array for storing information about images

    is_work_scale_set = False       # Bool for working image scaling
    is_seam_scale_set = False       # Bool for seams scaling
    is_compose_scale_set = False    # Bool for composition image scaling

    # Iterate through the image names
    for name in img_names:
        # Reads the image into a numpy array
        full_img = cv.imread(cv.samples.findFile(name))

        # Check if the file could be read successfully
        if full_img is None:
            print("Cannot read image ", name)
            exit()

        # Add image size to the list ...
        # TODO Could change this to be constant...
        full_img_sizes.append((full_img.shape[1], full_img.shape[0]))

        # Define the working scale the images should be used based on the number of megapixel entered
        if work_megapix < 0:
            # If a negative value entered, use its true scale
            img = full_img
            work_scale = 1
            is_work_scale_set = True
        else:
            if is_work_scale_set is False:
                work_scale = min(1.0, np.sqrt(work_megapix * 1e6 / (full_img.shape[0]*full_img.shape[1])))
                is_work_scale_set = True
            img = cv.resize(src=full_img, dsize=None, fx=work_scale, fy=work_scale, interpolation=cv.INTER_LINEAR_EXACT)

        # Define the scale for the seams that they will be processed
        if is_seam_scale_set is False:
            seam_scale = min(1.0, np.sqrt(seam_megapix * 1e6 / (full_img.shape[0]*full_img.shape[1])))
            seam_work_aspect = seam_scale / work_scale
            is_seam_scale_set = True

        # Get the image features for this image
        img_fea = cv.detail.computeImageFeatures2(finder, img)

        test_feat_img = cv.drawKeypoints(img, img_fea.getKeypoints(), None, (255, 0, 0), 4)
        cv.namedWindow('image', cv.WINDOW_NORMAL)
        cv.imshow('image', test_feat_img)
        cv.resizeWindow('image', int(full_img_sizes[0][0] / 10), int(full_img_sizes[0][1] / 10))
        cv.waitKey()

        features.append(img_fea)
        img = cv.resize(src=full_img, dsize=None, fx=seam_scale, fy=seam_scale, interpolation=cv.INTER_LINEAR_EXACT)
        images.append(img)

    # Define the matcher type to be used for the features
    if matcher_type == "affine":
        matcher = cv.detail_AffineBestOf2NearestMatcher(False, try_cuda, match_conf)
    elif range_width == -1:
        matcher = cv.detail_BestOf2NearestMatcher(try_cuda, match_conf)
    else:
        matcher = cv.detail_BestOf2NearestRangeMatcher(range_width, try_cuda, match_conf)

    # Apply the matcher to the features, obtaining matches between them
    p = matcher.apply2(features)
    # Frees unused memory
    matcher.collectGarbage()

    # Save the graph if chosen
    if save_graph:
        f = open(save_graph_to, "w")
        f.write(cv.detail.matchesGraphAsString(img_names, p, conf_thresh))
        f.close()

    # Remove matches if not above a confidence threshold
    indices = cv.detail.leaveBiggestComponent(features, p, match_conf)

    # Pre-allocate
    img_subset = []                 # Array to hold subset of images numpy arrays?
    img_names_subset = []           # Array to list the names of subset images
    full_img_sizes_subset = []      # Sizes of the images in their full resolution within the subset
    num_images = len(indices)       # Number of images as determined by the thresholding of the feature matches

    # TODO this appears to be the issue running into before... the matching beforehand is producing 0 results
    # Itearte through the images that were matched and get lists of matches/images
    for i in range(num_images):
        img_names_subset.append(img_names[indices[i, 0]])               # Append the names
        img_subset.append(images[indices[i, 0]])                        # Append the actual image arrays
        full_img_sizes_subset.append(full_img_sizes[indices[i, 0]])     # Append their sizes

    # Update the list of images and image names
    images = img_subset
    img_names = img_names_subset
    full_img_sizes = full_img_sizes_subset

    # Get new number of matched images (shouldn't change with the mosaicing project
    num_images = len(img_names)

    # Do a simple test to check if sufficient images
    if num_images < 2:
        print("Need more images")
        exit()

    # Generate the estimator based on what was set to determine approximate relative orientation parameters
    if estimator_type == "affine":
        estimator = cv.detail_AffineBasedEstimator()
    else:
        estimator = cv.detail_HomographyBasedEstimator()
    b, cameras = estimator.apply(features, p, None)

    # Check if estimation passed based on the boolean 'b'
    if not b:
        print("Homography estimation failed.")
        exit()

    # Iterate through the camera orientations computed
    for cam in cameras:
        # Convert the camera rotation matrix to float 32
        cam.R = cam.R.astype(np.float32)

    # TODO read up on the documentation here
    # Define bundle adjustment cost function
    if ba_cost_func == "reproj":
        adjuster = cv.detail_BundleAdjusterReproj()
    elif ba_cost_func == "ray":
        adjuster = cv.detail_BundleAdjusterRay()
    elif ba_cost_func == "affine":
        adjuster = cv.detail_BundleAdjusterAffinePartial()
    elif ba_cost_func == "no":
        adjuster = cv.detail_NoBundleAdjuster()
    else:
        print("Unknown bundle adjustment cost function: ", ba_cost_func)
        exit()

    # Set the threshold for the adjuster
    adjuster.setConfThresh(1)
    # Pre-allocate array of the mask to be applied to determine which camera parameters to compute
    refine_mask = np.zeros((3, 3), np.uint8)

    # Determine which parameters to compute? Or vice versa... not compute
    # TODO check this
    if ba_refine_mask[0] == 'x':
        refine_mask[0, 0] = 1
    if ba_refine_mask[1] == 'x':
        refine_mask[0, 1] = 1
    if ba_refine_mask[2] == 'x':
        refine_mask[0, 2] = 1
    if ba_refine_mask[3] == 'x':
        refine_mask[1, 1] = 1
    if ba_refine_mask[4] == 'x':
        refine_mask[1, 2] = 1

    # Apply the refinement mask to the adjuster
    adjuster.setRefinementMask(refine_mask)

    # Recompute the camera orientation parameters with the refinement mask
    b, cameras = adjuster.apply(features, p, cameras)

    # Check if the parameters adjusted correctly
    if not b:
        print("Camera parameters adjusting failed.")
        exit()

    # Get list of focal lengths to scale images accordingly...
    # TODO probably remove this scaling as not required for this project, thus warped_image_scale should stay = 1
    focals = []
    for cam in cameras:
        focals.append(cam.focal)
    sorted(focals)
    if len(focals) % 2 == 1:
        warped_image_scale = focals[len(focals) // 2]
    else:
        warped_image_scale = (focals[len(focals) // 2]+focals[len(focals) // 2-1])/2

    # Perform the wave correction
    # TODO adjust this... only performs a horizontal correction, need to implement a vertical correction. Possibly both.
    #   Potentially not required at all if the estimation of camera parameter bundle adjustment is performed well
    if do_wave_correct:
        rmats = []
        for cam in cameras:
            rmats.append(np.copy(cam.R))

        if wave_correct == 'vert':
            rmats = cv.detail.waveCorrect(rmats, cv.detail.WAVE_CORRECT_VERT)
        elif wave_correct == 'horiz':
            rmats = cv.detail.waveCorrect(rmats, cv.detail.WAVE_CORRECT_HORIZ)

        for idx, cam in enumerate(cameras):
            cam.R = rmats[idx]

    # Pre-allocation
    corners = []            # Dimensions of warped images
    masks_warped = []       # The masking regions of the warped areas
    images_warped = []      # the images warped
    sizes = []              # Sizes of ....?
    masks = []              # Masks for the seams ...?

    # Iterate through the images creating 'i' as the index number and appending the pre-allocated mask
    for i in range(0, num_images):
        um = cv.UMat(255*np.ones((images[i].shape[0], images[i].shape[1]), np.uint8))
        masks.append(um)

    # This creates the warper to be used to distort the images according to the layout or shape they're to be stitched
    warper = cv.PyRotationWarper(warp_type, warped_image_scale*seam_work_aspect)

    # Iterate through the images to create the seams
    for idx in range(0, num_images):
        # Get the respective camera matrix
        mat_k = cameras[idx].K().astype(np.float32)

        # Scale the K matrix for the seam aspect scale
        mat_k[0, 0] *= seam_work_aspect
        mat_k[0, 2] *= seam_work_aspect
        mat_k[1, 1] *= seam_work_aspect
        mat_k[1, 2] *= seam_work_aspect

        # Project the image into the warping shape
        # TODO Not sure if we actually need the images warped. If the rotation and translation should suffice
        corner, image_wp = warper.warp(images[idx], mat_k, cameras[idx].R, cv.INTER_LINEAR, cv.BORDER_REFLECT)
        corners.append(corner)
        sizes.append((image_wp.shape[1], image_wp.shape[0]))
        images_warped.append(image_wp)

        # Warp the masks as well
        p, mask_wp = warper.warp(masks[idx], mat_k, cameras[idx].R, cv.INTER_NEAREST, cv.BORDER_CONSTANT)
        masks_warped.append(mask_wp.get())

    # Pre-allocation and conversion of the images warped images to floats
    images_warped_f = []
    for img in images_warped:
        imgf = img.astype(np.float32)
        images_warped_f.append(imgf)

    # If exposure correction required.... Shouldn't although there is one bad image in there so quite possibly
    if cv.detail.ExposureCompensator_CHANNELS == expos_comp_type:
        compensator = cv.detail_ChannelsCompensator(expos_comp_nr_feeds)
    #    compensator.setNrGainsFilteringIterations(expos_comp_nr_filtering)
    elif cv.detail.ExposureCompensator_CHANNELS_BLOCKS == expos_comp_type:
        compensator = cv.detail_BlocksChannelsCompensator(
            expos_comp_block_size, expos_comp_block_size, expos_comp_nr_feeds)
    #    compensator.setNrGainsFilteringIterations(expos_comp_nr_filtering)
    else:
        compensator = cv.detail.ExposureCompensator_createDefault(expos_comp_type)

    # Apply the exposure compensator? Or set it up at least
    compensator.feed(corners=corners, images=images_warped, masks=masks_warped)

    # Define the type of seam finder to be used
    if seam_find_type == "no":
        seam_finder = cv.detail.SeamFinder_createDefault(cv.detail.SeamFinder_NO)
    elif seam_find_type == "voronoi":
        seam_finder = cv.detail.SeamFinder_createDefault(cv.detail.SeamFinder_VORONOI_SEAM)
    elif seam_find_type == "gc_color":
        seam_finder = cv.detail_GraphCutSeamFinder("COST_COLOR")
    elif seam_find_type == "gc_colorgrad":
        seam_finder = cv.detail_GraphCutSeamFinder("COST_COLOR_GRAD")
    elif seam_find_type == "dp_color":
        seam_finder = cv.detail_DpSeamFinder("COLOR")
    elif seam_find_type == "dp_colorgrad":
        seam_finder = cv.detail_DpSeamFinder("COLOR_GRAD")
    if seam_finder is None:
        print("Can't create the following seam finder ", seam_find_type)
        exit()

    # Find the seams
    # TODO potentially try using the non-warped images
    seam_finder.find(images_warped_f, corners, masks_warped)

    # Clear the variables from memory / use later
    imgListe = []
    images_warped = []
    images_warped_f = []
    masks = []

    # Clear or pre-allocate variables
    compose_scale = 1
    corners = []
    sizes = []
    blender = None
    timelapser = None
    compose_work_aspect = 1

    # Iterate through all the images again
    for idx, name in enumerate(img_names):
        # Read in image and get the composition scale. Should be left to 1...
        # TODO check the composition scale and whether this needs to be scaled
        full_img = cv.imread(name)

        # Compute the composition scale, work aspect ratio, warped image scale and create a warper to scale
        if not is_compose_scale_set:
            if compose_megapix > 0:
                compose_scale = min(1.0, np.sqrt(compose_megapix * 1e6 / (full_img.shape[0]*full_img.shape[1])))
            is_compose_scale_set = True
            compose_work_aspect = compose_scale / work_scale
            warped_image_scale *= compose_work_aspect
            warper = cv.PyRotationWarper(warp_type, warped_image_scale)

            for i in range(0, len(img_names)):
                # Adjust the camera parameters based on the composition work aspect ratio
                cameras[i].focal *= compose_work_aspect
                cameras[i].ppx *= compose_work_aspect
                cameras[i].ppy *= compose_work_aspect

                # Compute the size of the scaled full image
                sz = (full_img_sizes[i][0] * compose_scale, full_img_sizes[i][1]*compose_scale)

                # Get the intrinsic camera matrix
                mat_k = cameras[i].K().astype(np.float32)

                # Generate a warper for the rotation and intrinsic matrix
                # TODO this could possibly be just the rotation matrix
                #   One possibility this isn't working is due to it should be translating images...
                roi = warper.warpRoi(sz, mat_k, cameras[i].R)

                # Get the corners from the output parameters
                corners.append(roi[0:2])
                # Get the sizes of the output parameters
                sizes.append(roi[2:4])

        # Scale the image to a size greater than the full resolution, otherwise leave as is
        if abs(compose_scale - 1) > 1e-1:
            img = cv.resize(src=full_img, dsize=None, fx=compose_scale, fy=compose_scale, interpolation=cv.INTER_LINEAR_EXACT)
        else:
            img = full_img

        # Create a tuple of the image size
        img_size = (img.shape[1], img.shape[0])

        # Convert the intrinsic matrix to float 32
        mat_k = cameras[idx].K().astype(np.float32)

        # Warp the images accordingly...
        # TODO look at the interpolation and border values
        corner, image_warped = warper.warp(img, mat_k, cameras[idx].R, cv.INTER_LINEAR, cv.BORDER_REFLECT)

        # Define the masks and warp them as well to the same shape
        mask = 255*np.ones((img.shape[0], img.shape[1]), np.uint8)
        p, mask_warped = warper.warp(mask, mat_k, cameras[idx].R, cv.INTER_NEAREST, cv.BORDER_CONSTANT)

        # Apply the exposure compensation
        compensator.apply(idx, corners[idx], image_warped, mask_warped)

        # Convert the images back to integer for minimal memory use
        image_warped_s = image_warped.astype(np.int16)
        image_warped = []   # Clear variable

        # Dilate the warped mask image
        dilated_mask = cv.dilate(masks_warped[idx], None)

        # Resize the dilated mask to create the seam mask
        seam_mask = cv.resize(dilated_mask, (mask_warped.shape[1], mask_warped.shape[0]), 0, 0, cv.INTER_LINEAR_EXACT)

        # Get the output seam
        mask_warped = cv.bitwise_and(seam_mask, mask_warped)

        # If the blender object hasn't been created yet
        if blender is None and not timelapse:
            blender = cv.detail.Blender_createDefault(cv.detail.Blender_NO)
            dst_sz = cv.detail.resultRoi(corners=corners, sizes=sizes)
            # Get the blend width
            blend_width = np.sqrt(dst_sz[2]*dst_sz[3]) * blend_strength / 100
            # Check if a width is computed. Based on the blend strength
            if blend_width < 1:
                blender = cv.detail.Blender_createDefault(cv.detail.Blender_NO)

            # Create a multiband blender
            elif blend_type == "multiband":
                blender = cv.detail_MultiBandBlender()
                blender.setNumBands((np.log(blend_width)/np.log(2.) - 1.).astype(np.int))

            # Create a feather blender
            elif blend_type == "feather":
                blender = cv.detail_FeatherBlender()
                blender.setSharpness(1./blend_width)

            # Prepare the blender based on the distance
            blender.prepare(dst_sz)

        # If a timelapse type is passed, create the timelapser object
        elif timelapser is None and timelapse:
            timelapser = cv.detail.Timelapser_createDefault(timelapse_type)
            timelapser.initialize(corners, sizes)

        # If the timelapse parameter is passed
        if timelapse:
            # Initialise an array of ones of the right shape
            matones = np.ones((image_warped_s.shape[0], image_warped_s.shape[1]), np.uint8)

            # Adds the warped image into the list
            timelapser.process(image_warped_s, matones, corners[idx])

            # Get the index for where the file name starts
            pos_s = img_names[idx].rfind("/")

            # Get the fixed file name
            if pos_s == -1:
                fixed_file_name = "fixed_" + img_names[idx]
            else:
                fixed_file_name = img_names[idx][:pos_s + 1]+"fixed_" + img_names[idx][pos_s + 1:]

            # Write the temporary partial image
            cv.imwrite(fixed_file_name, timelapser.getDst())
        else:
            # Pass the warped image into the blender
            blender.feed(cv.UMat(image_warped_s), mask_warped, corners[idx])

    # If the timelapse parameter is not passed
    if not timelapse:
        # Pre-allocate the results
        result = None
        result_mask = None

        # Get the blended results
        result, result_mask = blender.blend(result, result_mask)

        # Output the final result
        cv.imwrite(result_name, result)

        # Make the image shape fit into the window
        zoomx = 600.0 / result.shape[1]

        # Show the final output
        dst = cv.normalize(src=result, dst=None, alpha=255., norm_type=cv.NORM_MINMAX, dtype=cv.CV_8U)
        dst = cv.resize(dst, dsize=None, fx=zoomx, fy=zoomx)
        cv.imshow(result_name, dst)
        cv.waitKey()

    print('Done')


if __name__ == '__main__':
    print(__doc__)
    main()
    cv.destroyAllWindows()
