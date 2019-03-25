from imutils import paths
import argparse
import argtesting
import cv2
import numpy as np
import os

# https://docs.opencv.org/trunk/d8/d19/tutorial_stitcher.html

# ============ INPUT IMAGES ============

# Define the argparse for command line functionality
# ap = argparse.ArgumentParser()
# ap.add_argument("-i", "--images", type=str, required=True, help="path to input directory of images to stitch")
# ap.add_argument("-o", "--output", type=str, required=True, help="path to the output image")
#
# args = vars(ap.parse_args())

input_folder = 'D:\\Dropbox\\01_Uni\\02_ETH\\04_Sem4\\00_IPA\\03_Data\\05_White_Ambient_Subsampled'
output_folder = 'D:\\Dropbox\\01_Uni\\02_ETH\\04_Sem4\\00_IPA\\03_Data\\test_opencv'


# Main Processing Parameters.
# img_names = sorted(list(paths.list_images(args["images"])))
img_names = sorted(list(paths.list_images(input_folder)))
images = []

# Flags:
#     --preview
#         Run stitching in the preview mode. Works faster than usual mode,
#         but output image will have lower resolution.
preview = 'yes'                 # For quick testing of output

#     --try_cuda (yes|no)
#         Try to use CUDA. The default value is 'no'. All default values
#         are for CPU mode.
try_cuda = 1             # For improving the processing time

# Motion Estimation Flags:
#     --work_megapix <float>
#         Resolution for image registration step. The default is 0.6 Mpx.
work_megapix = 0.6       # For determininng the size of the images used for registration.

#     --features (surf|orb|sift)
#         Type of features used for images matching. The default is surf.
features_type = 'sift'           # Type of feature detector to use

#     --matcher (homography|affine)
#         Matcher used for pairwise image matching.
matcher_type = 'affine'           # Type of transformation expected between features to use for matching

#     --estimator (homography|affine)
#         Type of estimator used for transformation estimation.
estimator_type = 'affine'        # Type of transformation for estimation

#     --match_conf <float>
#         Confidence for feature matching step. The default is 0.65 for surf and 0.3 for orb.
match_conf = 0.65           # Confidence level of feature matching. Should be high as there will be little variation
# due to limited perspective changes

#     --conf_thresh <float>
#         Threshold for two images are from the same panorama confidence.
#         The default is 1.0.
conf_thresh = 1.0          # Threshold test if images are in the same panorama. Should also be set high

#     --ba (no|reproj|ray|affine)
#         Bundle adjustment cost function. The default is ray.
ba_cost_func = 'affine'                  # Potentially set to affine?

#     --ba_refine_mask (mask)
#         Set refinement mask for bundle adjustment. It looks like 'x_xxx',
#         where 'x' means refine respective parameter and '_' means don't
#         refine one, and has the following format:
#         <fx><skew><ppx><aspect><ppy>. The default mask is 'xxxxx'. If bundle
#         adjustment doesn't support estimation of selected parameter then
#         the respective flag is ignored.
ba_refine_mask = 'xxxxx'    # Control which parameters of the bundle adjustment should be refined. Hopefully we get
# calibration matrix and can fix it.

#     --wave_correct (no|horiz|vert)
#         Perform wave effect correction. The default is 'horiz'.
wave_correct = 'no'        # Remove any kind of drift of the camera motion caused by chaining together the stitching.
# Possibly look into the algorithm here and see how it processes.

#     --save_graph <file_name>
#         Save matches graph represented in DOT language to <file_name> file.
#         Labels description: Nm is number of matches, Ni is number of inliers,
#         C is confidence.
save_graph = os.path.join(output_folder, 'matching_graph')           # Output the graph showing connected matches

# Compositing Flags:
#     --warp (affine|plane|cylindrical|spherical|fisheye|stereographic|compressedPlaneA2B1|compressedPlaneA1.5B1
#     |compressedPlanePortraitA2B1|compressedPlanePortraitA1.5B1|paniniA2B1|paniniA1.5B1|paniniPortraitA2B1
#     |paniniPortraitA1.5B1|mercator|transverseMercator)
#         Warp surface type. The default is 'spherical'.
warp_type = 'plane'                 # Define the warp of the images for a certain stitching. Closely resembles the
# scene or object to be stitched.

#     --seam_megapix <float>
#         Resolution for seam estimation step. The default is 0.1 Mpx.
seam_megapix = 0.1        # Set the resolution of the low-resolution images for stitching

#     --seam (no|voronoi|gc_color|gc_colorgrad)
#         Seam estimation method. The default is 'gc_color'.
seam_find_type = 'gc_color'              # Set the estimation method for estimating the seam

#     --compose_megapix <float>
#         Resolution for compositing step. Use -1 for original resolution.
#         The default is -1.
compose_megapix = -1  # Resolution used for the compositing step. I think this controls the output.

#     --expos_comp (no|gain|gain_blocks)
#         Exposure compensation method. The default is 'gain_blocks'.
args_expos_comp = 'no'                         # The final processed data probably shouldn't need additional processing.

#     --blend (no|feather|multiband)
#         Blending method. The default is 'multiband'.
blend_type = 'multiband'               # Need to look at the difference between blending methods

#     --blend_strength <float>
#         Blending strength from [0,100] range. The default is 5.
blend_strength = 5    # Check the strength...

#     --output <result_img>
#         The default is 'result.jpg'.
result_name = os.path.join(output_folder, 'Plan_Stitched.png')              # Define the name of the output panorama.
# PNG

#     --timelapse (as_is|crop)
#         Output warped images separately as frames of a time lapse movie, with 'fixed_' prepended to input file names.
args_timelapse = 'as_is'

#     --rangewidth <int>
#         uses range_width to limit number of images to match with.\n
range_width = 8


# parser.add_argument('--expos_comp_nr_feeds', action='store', default=1,
#                         help='Number of exposure compensation feed.', type=np.int32, dest='expos_comp_nr_feeds')
expos_comp_nr_feeds = 1

# parser.add_argument('--expos_comp_nr_filtering', action='store', default=2,
#                     help='Number of filtering iterations of the exposure compensation gains', type=float,
#                     dest='expos_comp_nr_filtering')
expos_comp_nr_filtering = 2

# parser.add_argument('--expos_comp_block_size', action='store', default=32,
#                     help='BLock size in pixels used by the exposure compensator.', type=np.int32,
#                     dest='expos_comp_block_size')
expos_comp_block_size = 32

# Check input args and assign the appropriate output variables
do_wave_correct = argtesting.wave_correct_check(wave_correct)
save_graph, save_graph_to = argtesting.save_graph_check(save_graph)
expos_comp_type = argtesting.exposure_comp_check(args_expos_comp)
timelapse, timelapse_type = argtesting.timelapse_check(args_timelapse)
finder = argtesting.features_check(features_type)
matcher = argtesting.matcher_type_check(matcher_type, range_width, try_cuda, match_conf)
estimator = argtesting.estimator_type_check(estimator_type)
adjuster = argtesting.bundle_adjustment_cost_function_check(ba_cost_func)
refine_mask = argtesting.refine_mask_check(ba_refine_mask)
compensator = argtesting.exposure_compensator_check(
    expos_comp_type, expos_comp_nr_feeds, expos_comp_block_size, expos_comp_nr_filtering)
seam_finder = argtesting.seam_type_check(seam_find_type)

seam_work_aspect = 1
full_img_sizes = []
features = []
images = []
is_work_scale_set = False
is_seam_scale_set = False
is_compose_scale_set = False

for name in img_names:
    full_img = cv2.imread(name)
    if full_img is None:
        print("Cannot read image ", name)
        exit()
    full_img_sizes.append((full_img.shape[1], full_img.shape[0]))
    if work_megapix < 0:
        img = full_img
        work_scale = 1
        is_work_scale_set = True
    else:
        if is_work_scale_set is False:
            work_scale = min(1.0, np.sqrt(work_megapix * 1e6 / (full_img.shape[0]*full_img.shape[1])))
            is_work_scale_set = True
        img = cv2.resize(src=full_img, dsize=None, fx=work_scale, fy=work_scale, interpolation=cv2.INTER_LINEAR_EXACT)
    if is_seam_scale_set is False:
        seam_scale = min(1.0, np.sqrt(seam_megapix * 1e6 / (full_img.shape[0]*full_img.shape[1])))
        seam_work_aspect = seam_scale / work_scale
        is_seam_scale_set = True
    imgFea = cv2.detail.computeImageFeatures2(finder,img)
    features.append(imgFea)
    img = cv2.resize(src=full_img, dsize=None, fx=seam_scale, fy=seam_scale, interpolation=cv2.INTER_LINEAR_EXACT)
    images.append(img)

p = matcher.apply2(features)
matcher.collectGarbage()

if save_graph:
    f = open(save_graph_to, "w")
    f.write(cv2.detail.matchesGraphAsString(img_names, p, conf_thresh))
    f.close()

indices = cv2.detail.leaveBiggestComponent(features, p, 0.3)

img_subset = []
img_names_subset = []
full_img_sizes_subset = []
num_images = len(indices)

for i in range(len(indices)):
    img_names_subset.append(img_names[indices[i, 0]])
    img_subset.append(images[indices[i, 0]])
    full_img_sizes_subset.append(full_img_sizes[indices[i, 0]])

images = img_subset
img_names = img_names_subset
full_img_sizes = full_img_sizes_subset
num_images = len(img_names)

if num_images < 2:
    print("Need more images")
    exit()

b, cameras = estimator.apply(features, p, None)

if not b:
    print("Homography estimation failed.")
    exit()

for cam in cameras:
    cam.R = cam.R.astype(np.float32)

adjuster.setConfThresh(1)

adjuster.setRefinementMask(refine_mask)

b, cameras = adjuster.apply(features, p, cameras)

if not b:
    print("Camera parameters adjusting failed.")
    exit()

focals = []

for cam in cameras:
    focals.append(cam.focal)

sorted(focals)

if len(focals) % 2 == 1:
    warped_image_scale = focals[len(focals) // 2]
else:
    warped_image_scale = (focals[len(focals) // 2]+focals[len(focals) // 2-1])/2

if do_wave_correct:
    rmats = []
    for cam in cameras:
        rmats.append(np.copy(cam.R))
    rmats = cv2.detail.waveCorrect(rmats, cv2.detail.WAVE_CORRECT_HORIZ)
    for idx, cam in enumerate(cameras):
        cam.R = rmats[idx]

corners = []
mask = []
masks_warped = []
images_warped = []
sizes = []
masks = []

for i in range(0, num_images):
    um = cv2.UMat(255 * np.ones((images[i].shape[0], images[i].shape[1]), np.uint8))
    masks.append(um)

warper = cv2.PyRotationWarper(warp_type, warped_image_scale * seam_work_aspect)

for idx in range(0, num_images):
    K = cameras[idx].K().astype(np.float32)
    swa = seam_work_aspect
    K[0, 0] *= swa
    K[0, 2] *= swa
    K[1, 1] *= swa
    K[1, 2] *= swa
    corner, image_wp = warper.warp(images[idx], K, cameras[idx].R, cv2.INTER_LINEAR, cv2.BORDER_REFLECT)
    corners.append(corner)
    sizes.append((image_wp.shape[1], image_wp.shape[0]))
    images_warped.append(image_wp)

    p, mask_wp = warper.warp(masks[idx], K, cameras[idx].R, cv2.INTER_NEAREST, cv2.BORDER_CONSTANT)
    masks_warped.append(mask_wp.get())
images_warped_f = []
for img in images_warped:
    imgf = img.astype(np.float32)
    images_warped_f.append(imgf)

compensator.feed(corners=corners, images=images_warped, masks=masks_warped)

seam_finder.find(images_warped_f, corners, masks_warped)

imgListe = []
compose_scale = 1
corners = []
sizes = []
images_warped = []
images_warped_f = []
masks = []
blender = None
timelapser = None
compose_work_aspect = 1

for idx, name in enumerate(img_names):  # https://github.com/opencv/opencv/blob/master/samples/cpp/stitching_detailed
    # .cpp#L725 ?
    full_img = cv2.imread(name)
    if not is_compose_scale_set:
        if compose_megapix > 0:
            compose_scale = min(1.0, np.sqrt(compose_megapix * 1e6 / (full_img.shape[0] * full_img.shape[1])))
        is_compose_scale_set = True
        compose_work_aspect = compose_scale / work_scale
        warped_image_scale *= compose_work_aspect
        warper = cv2.PyRotationWarper(warp_type, warped_image_scale)
        for i in range(0, len(img_names)):
            cameras[i].focal *= compose_work_aspect
            cameras[i].ppx *= compose_work_aspect
            cameras[i].ppy *= compose_work_aspect
            sz = (full_img_sizes[i][0] * compose_scale, full_img_sizes[i][1] * compose_scale)
            K = cameras[i].K().astype(np.float32)
            roi = warper.warpRoi(sz, K, cameras[i].R)
            corners.append(roi[0:2])
            sizes.append(roi[2:4])

    if abs(compose_scale - 1) > 1e-1:
        img = cv2.resize(
            src=full_img, dsize=None, fx=compose_scale, fy=compose_scale, interpolation=cv2.INTER_LINEAR_EXACT)
    else:
        img = full_img

    img_size = (img.shape[1], img.shape[0])
    K = cameras[idx].K().astype(np.float32)
    corner, image_warped = warper.warp(img, K, cameras[idx].R, cv2.INTER_LINEAR, cv2.BORDER_REFLECT)
    mask = 255 * np.ones((img.shape[0], img.shape[1]), np.uint8)
    p, mask_warped = warper.warp(mask, K, cameras[idx].R, cv2.INTER_NEAREST, cv2.BORDER_CONSTANT)
    compensator.apply(idx, corners[idx], image_warped, mask_warped)
    image_warped_s = image_warped.astype(np.int16)
    image_warped = []
    dilated_mask = cv2.dilate(masks_warped[idx], None)
    seam_mask = cv2.resize(dilated_mask, (mask_warped.shape[1], mask_warped.shape[0]), 0, 0, cv2.INTER_LINEAR_EXACT)
    mask_warped = cv2.bitwise_and(seam_mask, mask_warped)

    if blender is None and not timelapse:
        blender = cv2.detail.Blender_createDefault(cv2.detail.Blender_NO)
        dst_sz = cv2.detail.resultRoi(corners=corners, sizes=sizes)
        blend_width = np.sqrt(dst_sz[2]*dst_sz[3]) * blend_strength / 100
        if blend_width < 1:
            blender = cv2.detail.Blender_createDefault(cv2.detail.Blender_NO)
        elif blend_type == "multiband":
            blender = cv2.detail_MultiBandBlender()
            blender.setNumBands((np.log(blend_width)/np.log(2.) - 1.).astype(np.int))
        elif blend_type == "feather":
            blender = cv2.detail_FeatherBlender()
            blender.setSharpness(1./blend_width)
        blender.prepare(dst_sz)

    elif timelapser is None and timelapse:
        timelapser = cv2.detail.Timelapser_createDefault(timelapse_type)
        timelapser.initialize(corners, sizes)

    if timelapse:
        matones = np.ones((image_warped_s.shape[0], image_warped_s.shape[1]), np.uint8)
        timelapser.process(image_warped_s, matones, corners[idx])
        pos_s = img_names[idx].rfind("/")

        if pos_s == -1:
            fixedFileName = "fixed_" + img_names[idx]
        else:
            fixedFileName = img_names[idx][:pos_s + 1]+"fixed_" + img_names[idx][pos_s + 1:]

        cv2.imwrite(fixedFileName, timelapser.getDst())

    else:
        blender.feed(cv2.UMat(image_warped_s), mask_warped, corners[idx])

if not timelapse:
    result = None
    result_mask = None
    result, result_mask = blender.blend(result, result_mask)
    cv2.imwrite(result_name, result)
    zoomx = 600 / result.shape[1]
    dst = cv2.normalize(src=result, dst=None, alpha=255., norm_type=cv2.NORM_MINMAX, dtype=cv2.CV_8U)
    dst = cv2.resize(dst, dsize=None, fx=zoomx, fy=zoomx)
    cv2.imshow(result_name, dst)
    cv2.waitKey()
