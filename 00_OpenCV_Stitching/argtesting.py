import cv2
import numpy as np


def wave_correct_check(wave_correct):
    if wave_correct == 'no':
        do_wave_correct = False
    else:
        do_wave_correct = True
    return do_wave_correct


def save_graph_check(save_graph):
    save_graph_to = None
    if save_graph is not None:
        save_graph = True
        save_graph_to = save_graph
    return save_graph, save_graph_to


def exposure_comp_check(args_expos_comp):
    expos_comp_type = ''
    if args_expos_comp == 'no':
        expos_comp_type = cv2.detail.ExposureCompensator_NO
    elif args_expos_comp == 'gain':
        expos_comp_type = cv2.detail.ExposureCompensator_GAIN
    elif args_expos_comp == 'gain_blocks':
        expos_comp_type = cv2.detail.ExposureCompensator_GAIN_BLOCKS
    elif args_expos_comp == 'channel':
        expos_comp_type = cv2.detail.ExposureCompensator_CHANNELS
    elif args_expos_comp == 'channel_blocks':
        expos_comp_type = cv2.detail.ExposureCompensator_CHANNELS_BLOCKS
    else:
        print("Bad exposure compensation method")
        exit()

    if expos_comp_type != '':
        return expos_comp_type


def timelapse_check(args_timelapse):
    if args_timelapse is not None:
        timelapse = True
        timelapse_type = None
        if args_timelapse == "as_is":
            timelapse_type = cv2.detail.Timelapser_AS_IS
        elif args_timelapse == "crop":
            timelapse_type = cv2.detail.Timelapser_CROP
        else:
            print("Bad timelapse method")
            exit()
    else:
        timelapse = False
        timelapse_type = None

    return timelapse, timelapse_type


def features_check(features_type):
    finder = None
    if features_type == 'orb':
        finder = cv2.ORB.create()
    elif features_type == 'surf':
        finder = cv2.xfeatures2d_SURF.create()
    elif features_type == 'sift':
        finder = cv2.xfeatures2d_SIFT.create()
    else:
        print("Unknown descriptor type")
        exit()

    return finder


def matcher_type_check(matcher_type, range_width, try_cuda, match_conf):
    matcher = None
    if matcher_type == "affine":
        matcher = cv2.detail_AffineBestOf2NearestMatcher(False, try_cuda, match_conf)
    elif range_width == -1:
        matcher = cv2.detail.BestOf2NearestMatcher_create(try_cuda, match_conf)
    else:
        matcher = cv2.detail.BestOf2NearestRangeMatcher_create(range_width, try_cuda, match_conf)
    return matcher


def estimator_type_check(estimator_type):
    if estimator_type == "affine":
        estimator = cv2.detail_AffineBasedEstimator()
        print('\nAffine Estimator\n')
    else:
        estimator = cv2.detail_HomographyBasedEstimator()
        print('\nHomography Estimator\n')
    return estimator


def bundle_adjustment_cost_function_check(ba_cost_func):
    adjuster = None
    if ba_cost_func == "reproj":
        adjuster = cv2.detail_BundleAdjusterReproj()
    elif ba_cost_func == "ray":
        adjuster = cv2.detail_BundleAdjusterRay()
    elif ba_cost_func == "affine":
        adjuster = cv2.detail_BundleAdjusterAffinePartial()
    elif ba_cost_func == "no":
        adjuster = cv2.detail_NoBundleAdjuster()
    else:
        print("Unknown bundle adjustment cost function: ", ba_cost_func)
        exit()
    return adjuster


def refine_mask_check(ba_refine_mask):
    refine_mask = np.zeros((3, 3), np.uint8)
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
    return refine_mask


def exposure_compensator_check(expos_comp_type, expos_comp_nr_feeds, expos_comp_block_size, expos_comp_nr_filtering):
    if cv2.detail.ExposureCompensator_GAIN == expos_comp_type:
        compensator = cv2.detail_ChannelsCompensator(expos_comp_nr_feeds)
    #    compensator.setNrGainsFilteringIterations(expos_comp_nr_filtering)
    elif cv2.detail.ExposureCompensator_GAIN_BLOCKS == expos_comp_type:
        compensator = cv2.detail_BlocksChannelsCompensator(
            expos_comp_block_size, expos_comp_block_size, expos_comp_nr_feeds)
    #    compensator.setNrGainsFilteringIterations(expos_comp_nr_filtering)
    else:
        compensator = cv2.detail.ExposureCompensator_createDefault(expos_comp_type)
    return compensator


def seam_type_check(seam_find_type):
    seam_finder = None
    if seam_find_type == "no":
        seam_finder = cv2.detail.SeamFinder_createDefault(cv2.detail.SeamFinder_NO)
    elif seam_find_type == "voronoi":
        seam_finder = cv2.detail.SeamFinder_createDefault(cv2.detail.SeamFinder_VORONOI_SEAM)
    elif seam_find_type == "gc_color":
        seam_finder = cv2.detail_GraphCutSeamFinder("COST_COLOR")
    elif seam_find_type == "gc_colorgrad":
        seam_finder = cv2.detail_GraphCutSeamFinder("COST_COLOR_GRAD")
    elif seam_find_type == "dp_color":
        seam_finder = cv2.detail_DpSeamFinder("COLOR")
    elif seam_find_type == "dp_colorgrad":
        seam_finder = cv2.detail_DpSeamFinder("COLOR_GRAD")

    if seam_finder is None:
        print("Can't create the following seam finder ", seam_find_type)
        exit()

    return seam_finder



