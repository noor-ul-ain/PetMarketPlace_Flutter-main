import 'dart:async';
import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
// import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/entry/item_entry_provider.dart';
import 'package:flutterbuyandsell/provider/gallery/gallery_provider.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/gallery_repository.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutterbuyandsell/ui/common/dialog/choose_camera_type_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/in_app_purchase_for_package_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/retry_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/dialog/success_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_textfield_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/condition_of_item.dart';
import 'package:flutterbuyandsell/viewobject/deal_option.dart';
import 'package:flutterbuyandsell/viewobject/default_photo.dart';
import 'package:flutterbuyandsell/viewobject/holder/delete_item_image_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/image_reorder_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/google_map_pin_call_back_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/map_pin_call_back_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/item_entry_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/item_currency.dart';
import 'package:flutterbuyandsell/viewobject/item_location.dart';
import 'package:flutterbuyandsell/viewobject/item_location_township.dart';
import 'package:flutterbuyandsell/viewobject/item_price_type.dart';
import 'package:flutterbuyandsell/viewobject/item_type.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:flutterbuyandsell/viewobject/sub_category.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googlemap;
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
// import 'package:video_meta_info/video_meta_info.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ItemEntryView extends StatefulWidget {
  const ItemEntryView({
    Key? key,
    this.flag,
    this.item,
    required this.animationController,
    this.onItemUploaded,
    required this.maxImageCount,
  }) : super(key: key);
  final AnimationController? animationController;
  final String? flag;
  final Product? item;
  final Function? onItemUploaded;
  final int maxImageCount;

  @override
  State<StatefulWidget> createState() => _ItemEntryViewState();
}

class _ItemEntryViewState extends State<ItemEntryView> {
  ProductRepository? repo1;
  GalleryRepository? galleryRepository;
  ItemEntryProvider? _itemEntryProvider;
  GalleryProvider? galleryProvider;
  UserProvider? userProvider;
  UserRepository? userRepository;
  PsValueHolder? valueHolder;
  final TextEditingController userInputListingTitle = TextEditingController();
  final TextEditingController userInputBrand = TextEditingController();
  final TextEditingController userInputHighLightInformation =
  TextEditingController();
  final TextEditingController userInputDescription = TextEditingController();
  final TextEditingController userInputDealOptionText = TextEditingController();
  final TextEditingController userInputLattitude = TextEditingController();
  final TextEditingController userInputLongitude = TextEditingController();
  final TextEditingController userInputAddress = TextEditingController();
  final TextEditingController userInputWhatsappNum = TextEditingController();
  final TextEditingController userInputPrice = TextEditingController();
  final TextEditingController userInputDiscount = TextEditingController();
  final MapController mapController = MapController();
  googlemap.GoogleMapController? googleMapController;

  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController itemConditionController = TextEditingController();
  final TextEditingController priceTypeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController dealOptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController locationTownshipController =
  TextEditingController();

  late LatLng latlng;
  final double zoom = 16;
  bool bindDataFirstTime = true;
  bool bindImageFirstTime = true;
  bool isSelectedVideoImagePath = false;
  List<XFile> images = <XFile>[];
  late List<bool> isImageSelected;
  late List<XFile?> galleryImageAsset;
  late List<String?> cameraImagePath;
  late List<DefaultPhoto?> uploadedImages;
  String? videoFilePath;
  String? selectedVideoImagePath;
  String? videoFileThumbnailPath;
  String? selectedVideoPath;
  XFile? defaultAssetImage;

  String isShopCheckbox = '1';

  dynamic updateMapController(googlemap.GoogleMapController mapController) {
    googleMapController = mapController;
  }

  // ProgressDialog progressDialog;

  // File file;
  @override
  void initState() {
    super.initState();
    isImageSelected =
    List<bool>.generate(widget.maxImageCount, (int index) => false);
    galleryImageAsset =
    List<XFile?>.generate(widget.maxImageCount, (int index) => null);
    cameraImagePath =
    List<String?>.generate(widget.maxImageCount, (int index) => null);
    uploadedImages = List<DefaultPhoto?>.generate(widget.maxImageCount,
            (int index) => DefaultPhoto(imgId: '', imgPath: ''));
  }

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');
    valueHolder = Provider.of<PsValueHolder>(context);

    void showRetryDialog(String description, Function uploadImage) {
      if (PsProgressDialog.isShowing()) {
        PsProgressDialog.dismissDialog();
      }
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return RetryDialogView(
                description: description,
                rightButtonText: Utils.getString(context, 'item_entry__retry'),
                onAgreeTap: () {
                  Navigator.pop(context);
                  uploadImage();
                });
          });
    }

    Future<dynamic> uploadImage(String itemId) async {
      bool _isVideoDone = isSelectedVideoImagePath;
      final List<ImageReorderParameterHolder> reorderObjList =
      <ImageReorderParameterHolder>[];
      for (int i = 0;
      i < widget.maxImageCount && isImageSelected.contains(true);
      i++) {
        if (isImageSelected[i]) {
          if (galleryImageAsset[i] != null || cameraImagePath[i] != null) {
            if (!PsProgressDialog.isShowing()) {
              if (!isImageSelected[i]) {
                PsProgressDialog.dismissDialog();
              } else {
                await PsProgressDialog.showDialog(context,
                    message:
                    Utils.getString(context, 'Image ${i + 1} uploading'));
              }
            }
            final dynamic _apiStatus = await galleryProvider!
                .postItemImageUpload(
                itemId,
                uploadedImages[i]!.imgId,
                '${i + 1}',
                galleryImageAsset[i] == null
                    ? await Utils.getImageFileFromCameraImagePath(
                    cameraImagePath[i], valueHolder!.uploadImageSize!)
                    : await Utils.getImageFileFromAssets(
                    galleryImageAsset[i]!,
                    valueHolder!.uploadImageSize!),
                valueHolder!.loginUserId!);
            PsProgressDialog.dismissDialog();

            if (_apiStatus != null &&
                _apiStatus.data is DefaultPhoto &&
                _apiStatus.data != null) {
              isImageSelected[i] = false;
              print('${i + 1} image uploaded');
            } else if (_apiStatus != null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: _apiStatus.message,
                    );
                  });
            }
          } else if (uploadedImages[i]!.imgPath != '') {
            reorderObjList.add(ImageReorderParameterHolder(
                imgId: uploadedImages[i]!.imgId, ordering: (i + 1).toString()));
          }
        }
      }

      //reordering
      if (reorderObjList.isNotEmpty) {
        await PsProgressDialog.showDialog(context);
        final List<Map<String, dynamic>> reorderMapList =
        <Map<String, dynamic>>[];
        for (ImageReorderParameterHolder? data in reorderObjList) {
          if (data != null) {
            reorderMapList.add(data.toMap());
          }
        }
        final PsResource<ApiStatus>? _apiStatus = await galleryProvider!
            .postReorderImages(reorderMapList, valueHolder!.loginUserId!);
        PsProgressDialog.dismissDialog();

        if (_apiStatus!.data != null && _apiStatus.status == PsStatus.SUCCESS) {
          isImageSelected =
              isImageSelected.map<bool>((bool v) => false).toList();
          reorderObjList.clear();
        } else {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: _apiStatus.message,
                );
              });
        }
      }

      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedVideoImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
              Utils.getString(context, 'progressloading_video_uploading'));
        }
      }

      if (isSelectedVideoImagePath) {
        final PsResource<DefaultPhoto> _apiStatus = await galleryProvider!
            .postVideoUpload(
            itemId, '', File(videoFilePath!), valueHolder!.loginUserId!);
        final PsResource<DefaultPhoto> _apiStatus2 = await galleryProvider!
            .postVideoThumbnailUpload(itemId, '', File(videoFileThumbnailPath!),
            valueHolder!.loginUserId!);
        if (_apiStatus.data != null && _apiStatus2.data != null) {
          PsProgressDialog.dismissDialog();
          isSelectedVideoImagePath = false;
          _isVideoDone = isSelectedVideoImagePath;
        } else {
          showRetryDialog(
              Utils.getString(context, 'item_entry__fail_to_upload_video'), () {
            uploadImage(itemId);
          });
          return;
        }
      }
      PsProgressDialog.dismissDialog();

      if (!(isImageSelected.contains(true) || _isVideoDone)) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                message: Utils.getString(context, 'item_entry_item_uploaded'),
                onPressed: () {
                  if (widget.flag == PsConst.ADD_NEW_ITEM) {
                    if (widget.onItemUploaded != null) {
                      widget.onItemUploaded!(_itemEntryProvider!.itemId);
                    }
                  } else {
                    Navigator.pop(context, true);
                  }
                  // Navigator.pop(context, true);
                },
              );
            });
      }

      return;
    }

    dynamic updateImagesFromVideo(String imagePath, int index) {
      if (mounted) {
        setState(() {
          //for single select image
          if (index == -2 && imagePath.isNotEmpty) {
            videoFilePath = imagePath;
            // selectedVideoImagePath = imagePath;
            isSelectedVideoImagePath = true;
          }
          //end single select image
        });
      }
    }

    dynamic _getImageFromVideo(String videoPathUrl) async {
      videoFileThumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoPathUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
        128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      return videoFileThumbnailPath;
    }

    dynamic onReorder(int oldIndex, int newIndex) {
      if (galleryImageAsset[oldIndex] != null) {
        if (galleryImageAsset[newIndex] != null) {
          setState(() {
            final XFile? temp = galleryImageAsset[oldIndex];
            galleryImageAsset[oldIndex] = galleryImageAsset[newIndex];
            galleryImageAsset[newIndex] = temp;
          });
        } else if (cameraImagePath[newIndex] != null &&
            cameraImagePath[newIndex] != '') {
          setState(() {
            cameraImagePath[oldIndex] = cameraImagePath[newIndex];
            galleryImageAsset[newIndex] = galleryImageAsset[oldIndex];
            galleryImageAsset[oldIndex] = null;
            cameraImagePath[newIndex] = null;
          });
        } else if (uploadedImages[newIndex]!.imgPath != '' &&
            uploadedImages[newIndex]!.imgId != '') {
          setState(() {
            uploadedImages[oldIndex] = uploadedImages[newIndex];
            uploadedImages[newIndex] = DefaultPhoto(imgId: '', imgPath: '');
            galleryImageAsset[newIndex] = galleryImageAsset[oldIndex];
            galleryImageAsset[oldIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        }
      } else if (cameraImagePath[oldIndex] != null &&
          cameraImagePath[oldIndex] != '') {
        if (galleryImageAsset[newIndex] != null) {
          setState(() {
            galleryImageAsset[oldIndex] = galleryImageAsset[newIndex];
            cameraImagePath[newIndex] = cameraImagePath[oldIndex];
            cameraImagePath[oldIndex] = null;
            galleryImageAsset[newIndex] = null;
          });
        } else if (cameraImagePath[newIndex] != null &&
            cameraImagePath[newIndex] != '') {
          setState(() {
            final String? temp = cameraImagePath[oldIndex];
            cameraImagePath[oldIndex] = cameraImagePath[newIndex];
            cameraImagePath[newIndex] = temp;
          });
        } else if (uploadedImages[newIndex]!.imgPath != '' &&
            uploadedImages[newIndex]!.imgId != '') {
          setState(() {
            uploadedImages[oldIndex] = uploadedImages[newIndex];
            uploadedImages[newIndex] = DefaultPhoto(imgId: '', imgPath: '');
            cameraImagePath[newIndex] = cameraImagePath[oldIndex];
            cameraImagePath[oldIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        }
      } else if (uploadedImages[oldIndex]!.imgPath != '' &&
          uploadedImages[oldIndex]!.imgId != '') {
        if (galleryImageAsset[newIndex] != null) {
          setState(() {
            uploadedImages[newIndex] = uploadedImages[oldIndex];
            uploadedImages[oldIndex] = DefaultPhoto(imgId: '', imgPath: '');
            galleryImageAsset[oldIndex] = galleryImageAsset[newIndex];
            galleryImageAsset[newIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        } else if (cameraImagePath[newIndex] != null &&
            cameraImagePath[newIndex] != '') {
          setState(() {
            uploadedImages[newIndex] = uploadedImages[oldIndex];
            uploadedImages[oldIndex] = DefaultPhoto(imgId: '', imgPath: '');
            cameraImagePath[oldIndex] = cameraImagePath[newIndex];
            cameraImagePath[newIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        } else if (uploadedImages[newIndex]!.imgPath != '' &&
            uploadedImages[newIndex]!.imgId != '') {
          setState(() {
            final DefaultPhoto? temp = uploadedImages[newIndex];
            uploadedImages[newIndex] = uploadedImages[oldIndex];
            uploadedImages[oldIndex] = temp;

            isImageSelected[oldIndex] = true;
            isImageSelected[newIndex] = true;
          });
        }
      }
    }

    dynamic updateImagesFromCustomCamera(String imagePath, int index) {
      if (mounted) {
        setState(() {
          //for single select image
          if (imagePath.isNotEmpty) {
            int indexToStart =
            0; //find the right starting_index for storing images
            for (indexToStart = 0; indexToStart < index; indexToStart++) {
              if (!isImageSelected[indexToStart] &&
                  indexToStart > galleryProvider!.selectedImageList!.length - 1)
                break;
            }
            galleryImageAsset[indexToStart] = null;
            cameraImagePath[indexToStart] = imagePath;
            isImageSelected[indexToStart] = true;
          }
          //end single select image
        });
      }
    }

    dynamic updateImages(List<XFile> resultList, int index, int currentIndex) {
      // if (index == -1) {
      //   for(int i = 0; i < galleryImageAsset.length; i++) {
      //     galleryImageAsset[i] = defaultAssetImage;
      //   }
      // }
      setState(() {
        images = resultList;

        //for single select image
        if (index != -1 && resultList.isNotEmpty) {
          galleryImageAsset[currentIndex] = resultList[0];
          isImageSelected[currentIndex] = true;
        }
        //end single select image

        //for multi select
        if (index == -1) {
          int indexToStart =
          0; //find the right starting_index for storing images
          for (indexToStart = 0; indexToStart < currentIndex; indexToStart++) {
            if (!isImageSelected[indexToStart] &&
                indexToStart > galleryProvider!.selectedImageList!.length - 1)
              break;
          }
          for (int i = 0;
          i < resultList.length && indexToStart < widget.maxImageCount;
          i++, indexToStart++) {
            galleryImageAsset[indexToStart] = resultList[i];
            isImageSelected[indexToStart] = true;
          }
        }
        //end multi select
      });
    }

    repo1 = Provider.of<ProductRepository>(context);
    galleryRepository = Provider.of<GalleryRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    widget.animationController!.forward();
    return PsWidgetWithMultiProvider(
      child: MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<ItemEntryProvider?>(
              lazy: false,
              create: (BuildContext context) {
                _itemEntryProvider =
                    ItemEntryProvider(repo: repo1, psValueHolder: valueHolder);

                _itemEntryProvider!.item = widget.item;

                if (valueHolder!.isSubLocation == PsConst.ONE &&
                    valueHolder!.locationTownshipLat != '') {
                  latlng = LatLng(
                      double.parse(valueHolder!.locationTownshipLat),
                      double.parse(valueHolder!.locationTownshipLng));
                  if (_itemEntryProvider!.itemLocationTownshipId != null ||
                      _itemEntryProvider!.itemLocationTownshipId != '') {
                    _itemEntryProvider!.itemLocationTownshipId =
                        _itemEntryProvider!.psValueHolder!.locationTownshipId;
                  }
                  if (userInputLattitude.text.isEmpty)
                    userInputLattitude.text =
                        _itemEntryProvider!.psValueHolder!.locationTownshipLat;
                  if (userInputLongitude.text.isEmpty)
                    userInputLongitude.text =
                        _itemEntryProvider!.psValueHolder!.locationTownshipLng;
                } else {
                  latlng = LatLng(double.parse(valueHolder!.locationLat!),
                      double.parse(valueHolder!.locationLng!));
                  if (userInputLattitude.text.isEmpty)
                    userInputLattitude.text =
                    _itemEntryProvider!.psValueHolder!.locationLat!;
                  if (userInputLongitude.text.isEmpty)
                    userInputLongitude.text =
                    _itemEntryProvider!.psValueHolder!.locationLng!;
                }
                if (_itemEntryProvider!.itemLocationId != null ||
                    _itemEntryProvider!.itemLocationId != '') {
                  _itemEntryProvider!.itemLocationId =
                      _itemEntryProvider!.psValueHolder!.locationId;
                }
                _itemEntryProvider!.itemCurrencyId =
                    _itemEntryProvider!.psValueHolder!.defaultCurrencyId;
                priceController.text =
                    _itemEntryProvider!.psValueHolder!.defaultCurrency;
                _itemEntryProvider!.getItemFromDB(widget.item!.id);

                return _itemEntryProvider;
              }),
          ChangeNotifierProvider<GalleryProvider?>(
              lazy: false,
              create: (BuildContext context) {
                galleryProvider = GalleryProvider(repo: galleryRepository!);
                if (widget.flag == PsConst.EDIT_ITEM) {
                  galleryProvider!.loadImageList(
                      widget.item!.defaultPhoto!.imgParentId,
                      PsConst.ITEM_TYPE);
                }
                return galleryProvider;
              }),
          ChangeNotifierProvider<UserProvider?>(
            lazy: false,
            create: (BuildContext context) {
              userProvider = UserProvider(
                  repo: userRepository, psValueHolder: valueHolder);
              userProvider!.getUser(valueHolder!.loginUserId);
              return userProvider;
            },
          ),
        ],
        child: Consumer<UserProvider>(
          builder:
              (BuildContext context, UserProvider provider, Widget? child) {
            if (widget.flag == PsConst.ADD_NEW_ITEM &&
                valueHolder!.isPaidApp == PsConst.ONE &&
                provider.user.data == null)
              return Container(
                color: PsColors.coreBackgroundColor,
              );
            if (widget.flag == PsConst.EDIT_ITEM ||
                (valueHolder!.isPaidApp != PsConst.ONE ||
                    (provider.user.data != null &&
                        int.parse(provider.user.data!.remainingPost!) > 0)))
              return SingleChildScrollView(
                child: AnimatedBuilder(
                    animation: widget.animationController!,
                    child: Container(
                      color: PsColors.baseColor,
                      padding:
                      const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Consumer<GalleryProvider>(builder:
                              (BuildContext context, GalleryProvider provider,
                              Widget? child) {
                            if (bindImageFirstTime &&
                                provider.galleryList.data!.isNotEmpty) {
                              for (int i = 0;
                              i < widget.maxImageCount &&
                                  i < provider.galleryList.data!.length;
                              i++) {
                                if (provider.galleryList.data![i].imgId !=
                                    null) {
                                  uploadedImages[i] =
                                  provider.galleryList.data![i];
                                }
                              }
                              bindImageFirstTime = false;
                            }

                            //  if (Utils.showUI(valueHolder!.image))
                            return ImageUploadHorizontalList(
                              flag: widget.flag,
                              images: images,
                              selectedImageList: uploadedImages,
                              updateImages: updateImages,
                              updateImagesFromCustomCamera:
                              updateImagesFromCustomCamera,
                              videoFilePath: videoFilePath,
                              videoFileThumbnailPath: videoFileThumbnailPath,
                              selectedVideoImagePath: selectedVideoImagePath,
                              updateImagesFromVideo: updateImagesFromVideo,
                              selectedVideoPath: selectedVideoPath,
                              getImageFromVideo: _getImageFromVideo,
                              imageDesc1Controller:
                              galleryProvider!.imageDesc1Controller,
                              provider: _itemEntryProvider,
                              galleryProvider: provider,
                              onReorder: onReorder,
                              cameraImagePath: cameraImagePath,
                              galleryImagePath: galleryImageAsset,
                            );
                          }),
                          Consumer<ItemEntryProvider>(builder:
                              (BuildContext context, ItemEntryProvider provider,
                              Widget? child) {
                            if (provider.item != null &&
                                provider.item!.id != null) {
                              if (bindDataFirstTime) {
                                userInputListingTitle.text =
                                provider.item!.title!;
                                userInputBrand.text = provider.item!.brand!;
                                userInputHighLightInformation.text =
                                provider.item!.highlightInformation!;
                                userInputDescription.text =
                                provider.item!.description!;
                                userInputDealOptionText.text =
                                provider.item!.dealOptionRemark!;

                                if (valueHolder!.isSubLocation == PsConst.ONE) {
                                  userInputLattitude.text =
                                  provider.item!.itemLocationTownship!.lat!;
                                  userInputLongitude.text =
                                  provider.item!.itemLocationTownship!.lng!;
                                  provider.itemLocationTownshipId =
                                      provider.item!.itemLocationTownship!.id;
                                  locationTownshipController.text = provider
                                      .item!
                                      .itemLocationTownship!
                                      .townshipName!;
                                } else {
                                  userInputLattitude.text = provider.item!.lat!;
                                  userInputLongitude.text = provider.item!.lng!;
                                }
                                provider.itemLocationId =
                                    provider.item!.itemLocation!.id;
                                locationController.text =
                                provider.item!.itemLocation!.name!;
                                userInputAddress.text = provider.item!.address!;
                                print(userInputAddress.text);
                                userInputWhatsappNum.text =
                                provider.item!.whatsappNumber!;
                                userInputPrice.text = provider.item!.price!;
                                userInputDiscount.text =
                                provider.item!.discountRate!;
                                categoryController.text =
                                provider.item!.category!.catName!;
                                subCategoryController.text =
                                provider.item!.subCategory!.name!;
                                typeController.text =
                                provider.item!.itemType!.name!;
                                itemConditionController.text =
                                provider.item!.conditionOfItem!.name!;
                                priceTypeController.text =
                                provider.item!.itemPriceType!.name!;
                                priceController.text = provider
                                    .item!.itemCurrency!.currencySymbol!;
                                dealOptionController.text =
                                provider.item!.dealOption!.name!;
                                provider.categoryId =
                                    provider.item!.category!.catId;
                                provider.subCategoryId =
                                    provider.item!.subCategory!.id;
                                provider.itemTypeId =
                                    provider.item!.itemType!.id;
                                provider.itemConditionId =
                                    provider.item!.conditionOfItem!.id;
                                provider.itemCurrencyId =
                                    provider.item!.itemCurrency!.id;
                                provider.itemDealOptionId =
                                    provider.item!.dealOption!.id;
                                provider.itemPriceTypeId =
                                    provider.item!.itemPriceType!.id;
                                selectedVideoImagePath =
                                    provider.item!.videoThumbnail!.imgPath;
                                selectedVideoPath =
                                    provider.item!.video!.imgPath;
                                bindDataFirstTime = false;

                                if (provider.item!.businessMode == '1') {
                                  Utils.psPrint('Check On is shop');
                                  provider.isCheckBoxSelect = true;
                                  _BusinessModeCheckbox();
                                } else {
                                  provider.isCheckBoxSelect = false;
                                  Utils.psPrint('Check Off is shop');
                                  //  updateCheckBox(context, provider);
                                  _BusinessModeCheckbox();
                                }
                              }
                            }
                            return AllControllerTextWidget(
                              userInputListingTitle: userInputListingTitle,
                              categoryController: categoryController,
                              subCategoryController: subCategoryController,
                              typeController: typeController,
                              itemConditionController: itemConditionController,
                              userInputBrand: userInputBrand,
                              priceTypeController: priceTypeController,
                              priceController: priceController,
                              userInputHighLightInformation:
                              userInputHighLightInformation,
                              userInputDescription: userInputDescription,
                              dealOptionController: dealOptionController,
                              userInputDealOptionText: userInputDealOptionText,
                              locationController: locationController,
                              locationTownshipController:
                              locationTownshipController,
                              userInputLattitude: userInputLattitude,
                              userInputLongitude: userInputLongitude,
                              userInputAddress: userInputAddress,
                              userInputPrice: userInputPrice,
                              userInputDiscount: userInputDiscount,
                              mapController: mapController,
                              userInputWhatsappNum: userInputWhatsappNum,
                              zoom: zoom,
                              flag: widget.flag,
                              item: widget.item,
                              provider: provider,
                              galleryProvider: galleryProvider,
                              userProvider: userProvider,
                              latlng: latlng,
                              uploadImage: (String itemId) {
                                //  if (isImageSelected.contains(true) || isSelectedVideoImagePath)
                                uploadImage(itemId);
                              },
                              isImageSelected: isImageSelected,
                              isSelectedVideoImagePath:
                              isSelectedVideoImagePath,
                              updateMapController: updateMapController,
                              googleMapController: googleMapController,
                            );
                          })
                        ],
                      ),
                    ),
                    builder: (BuildContext context, Widget? child) {
                      return child!;
                    }),
              );
            else
              return InAppPurchaseBuyPackageDialog(
                onInAppPurchaseTap: () async {
                  // InAppPurchase View
                  final dynamic returnData = await Navigator.pushNamed(
                      context, RoutePaths.buyPackage,
                      arguments: <String, dynamic>{
                        'android': valueHolder?.packageAndroidKeyList,
                        'ios': valueHolder?.packageIOSKeyList
                      });

                  if (returnData != null) {
                    setState(() {
                      userProvider!.user.data!.remainingPost = returnData;
                    });
                  } else {
                    provider.getUser(valueHolder!.loginUserId);
                  }
                },
              );
          },
        ),
      ),
    );
  }
}

class AllControllerTextWidget extends StatefulWidget {
  const AllControllerTextWidget({
    Key? key,
    this.userInputListingTitle,
    this.categoryController,
    this.subCategoryController,
    this.typeController,
    this.itemConditionController,
    this.userInputBrand,
    this.priceTypeController,
    this.priceController,
    this.userInputHighLightInformation,
    this.userInputDescription,
    this.dealOptionController,
    this.userInputDealOptionText,
    this.locationController,
    this.locationTownshipController,
    this.userInputLattitude,
    this.userInputLongitude,
    this.userInputAddress,
    this.userInputPrice,
    this.userInputDiscount,
    this.mapController,
    this.provider,
    this.galleryProvider,
    this.userProvider,
    this.latlng,
    this.zoom,
    this.flag,
    this.item,
    this.uploadImage,
    required this.isImageSelected,
    this.isSelectedVideoImagePath,
    this.googleMapController,
    this.updateMapController,
    this.userInputWhatsappNum,
  }) : super(key: key);

  final TextEditingController? userInputListingTitle;
  final TextEditingController? categoryController;
  final TextEditingController? subCategoryController;
  final TextEditingController? typeController;
  final TextEditingController? itemConditionController;
  final TextEditingController? userInputBrand;
  final TextEditingController? priceTypeController;
  final TextEditingController? priceController;
  final TextEditingController? userInputHighLightInformation;
  final TextEditingController? userInputDescription;
  final TextEditingController? dealOptionController;
  final TextEditingController? userInputDealOptionText;
  final TextEditingController? locationController;
  final TextEditingController? locationTownshipController;
  final TextEditingController? userInputLattitude;
  final TextEditingController? userInputLongitude;
  final TextEditingController? userInputAddress;
  final TextEditingController? userInputWhatsappNum;
  final TextEditingController? userInputPrice;
  final TextEditingController? userInputDiscount;
  final MapController? mapController;
  final ItemEntryProvider? provider;
  final double? zoom;
  final String? flag;
  final Product? item;
  final LatLng? latlng;
  final Function? uploadImage;
  final List<bool> isImageSelected;
  final bool? isSelectedVideoImagePath;
  final googlemap.GoogleMapController? googleMapController;
  final Function? updateMapController;
  final GalleryProvider? galleryProvider;
  final UserProvider? userProvider;

  @override
  _AllControllerTextWidgetState createState() =>
      _AllControllerTextWidgetState();
}

class _AllControllerTextWidgetState extends State<AllControllerTextWidget> {
  LatLng? _latlng;
  googlemap.CameraPosition? _kLake;
  PsValueHolder? valueHolder;
  late ItemEntryProvider itemEntryProvider;
  late googlemap.CameraPosition kGooglePlex;
  late double? zoom = 13.0;

  // dynamic  _zoomIn() {
  //   zoom = zoom! + 1;
  //   widget.mapController!.move(_latlng!, zoom!);
  // }

  //   dynamic  _zoomOut() {
  //   zoom = zoom! - 1;
  //   widget.mapController!.move(_latlng!, zoom!);
  // }

  @override
  Widget build(BuildContext context) {
    itemEntryProvider = Provider.of<ItemEntryProvider>(context, listen: false);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    _latlng ??= widget.latlng;
    kGooglePlex = googlemap.CameraPosition(
      target: googlemap.LatLng(_latlng!.latitude, _latlng!.longitude),
      zoom: widget.zoom!,
    );
    // if ((widget.flag == PsConst.ADD_NEW_ITEM &&
    //     widget.locationController!.text ==
    //         itemEntryProvider.psValueHolder!.locactionName) ||
    //     (widget.flag == PsConst.ADD_NEW_ITEM &&
    //         widget.locationController!.text.isEmpty)) {
    //   widget.locationController!.text =
    //   itemEntryProvider.psValueHolder!.locactionName!;
    //   // widget.locationTownshipController.text =
    //   //     itemEntryProvider.psValueHolder.locationTownshipName;
    // }
    if (itemEntryProvider.item != null && widget.flag == PsConst.EDIT_ITEM) {
      if (valueHolder!.isSubLocation == PsConst.ONE &&
          itemEntryProvider.item!.itemLocationTownship!.lat != null &&
          itemEntryProvider.item!.itemLocationTownship!.lat != '') {
        _latlng = LatLng(
            double.parse(itemEntryProvider.item!.itemLocationTownship!.lat!),
            double.parse(itemEntryProvider.item!.itemLocationTownship!.lng!));
        kGooglePlex = googlemap.CameraPosition(
          target: googlemap.LatLng(
              double.parse(itemEntryProvider.item!.itemLocationTownship!.lat!),
              double.parse(itemEntryProvider.item!.itemLocationTownship!.lng!)),
          zoom: widget.zoom!,
        );
      } else {
        _latlng = LatLng(double.parse(itemEntryProvider.item!.lat!),
            double.parse(itemEntryProvider.item!.lng!));
        kGooglePlex = googlemap.CameraPosition(
          target: googlemap.LatLng(double.parse(itemEntryProvider.item!.lat!),
              double.parse(itemEntryProvider.item!.lng!)),
          zoom: widget.zoom!,
        );
      }
    }

    final Widget _uploadItemWidget = Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space16,
            bottom: PsDimens.space48),
        width: double.infinity,
        height: PsDimens.space44,
        child: PSButtonWidget(
            colorData: PsColors.buttonColor,
            hasShadow: false,
            width: double.infinity,
            titleText: Utils.getString(context, 'login__submit'),
            onPressed: () async {
              if ( //Utils.showUI(valueHolder!.image) &&
              !widget.isImageSelected.contains(true) &&
                  widget.galleryProvider!.galleryList.data!.isEmpty) {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return WarningDialog(
                        message:
                        Utils.getString(context, 'item_entry_need_image'),
                        onPressed: () {},
                      );
                    });
              } else if ( //Utils.showUI(valueHolder!.title) &&
              widget.userInputListingTitle!.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry__need_listing_title'),
                        onPressed: () {},
                      );
                    });
              } else if ( //Utils.showUI(valueHolder!.categoryId) &&
              widget.categoryController!.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry_need_category'),
                        onPressed: () {},
                      );
                    });
              }
              // else if (widget.subCategoryController!.text == '') {
              //   showDialog<dynamic>(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return WarningDialog(
              //           message: Utils.getString(
              //               context, 'item_entry_need_subcategory'),
              //           onPressed: () {},
              //         );
              //       });
              // }
              //  else if (widget.typeController!.text == '') {
              //   showDialog<dynamic>(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return WarningDialog(
              //           message: Utils.getString(context, 'item_entry_need_type'),
              //           onPressed: () {},
              //         );
              //       });
              // } else if (widget.itemConditionController!.text == '') {
              //   showDialog<dynamic>(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return WarningDialog(
              //           message: Utils.getString(
              //               context, 'item_entry_need_item_condition'),
              //           onPressed: () {},
              //         );
              //       });
              //}
              else if ( //Utils.showUI(valueHolder!.itemCurrencyId) &&
              widget.priceController!.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry_need_currency_symbol'),
                        onPressed: () {},
                      );
                    });
              } else if ( //Utils.showUI(valueHolder!.price) &&
              widget.userInputPrice!.text == '' ||
                  widget.userInputPrice!.text == '0') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return WarningDialog(
                        message:
                        Utils.getString(context, 'item_entry_need_price'),
                        onPressed: () {},
                      );
                    });
              } else if ( //Utils.showUI(valueHolder!.description) &&
              widget.userInputDescription!.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry_need_description'),
                        onPressed: () {},
                      );
                    });
              }
              // else if (widget.dealOptionController!.text == '') {
              //   showDialog<dynamic>(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return WarningDialog(
              //           message: Utils.getString(
              //               context, 'item_entry_need_deal_option'),
              //           onPressed: () {},
              //         );
              //       });
              //}
              // else if ( //Utils.showUI(valueHolder!.itemLocationId) &&
              // widget.provider!.itemLocationId == '') {
              //   showDialog<dynamic>(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return WarningDialog(
              //           message: Utils.getString(
              //               context, 'item_entry_need_location_id'),
              //           onPressed: () {},
              //         );
              //       });
              // }
              // else if (valueHolder!.isSubLocation == PsConst.ONE &&
              //     (widget.locationTownshipController!.text == '')) {
              //   showDialog<dynamic>(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return WarningDialog(
              //           message: Utils.getString(
              //               context, 'item_entry_need_location_township'),
              //           onPressed: () {},
              //         );
              //       });
              // }
              else if (Utils.showUI(valueHolder!.latitude) &&
                  (widget.userInputLattitude!.text == PsConst.ZERO ||
                      widget.userInputLattitude!.text == PsConst.ZERO ||
                      widget.userInputLattitude!.text ==
                          PsConst.INVALID_LAT_LNG ||
                      widget.userInputLattitude!.text ==
                          PsConst.INVALID_LAT_LNG)) {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry_pick_location'),
                        onPressed: () {},
                      );
                    });
              } else if ( //Utils.showUI(valueHolder!.title) &&
              widget.userInputWhatsappNum!.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return WarningDialog(
                        message: Utils.getString(
                            context, 'enter_your_whatsApp_number'),
                        onPressed: () {},
                      );
                    });
              } else {
                print('userInput Address : ${widget.userInputAddress!.text}');
                print('userInput WhatsappNum ${widget.userInputWhatsappNum!.text}');
                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                  // if (valueHolder!.isPaidApp != PsConst.ONE ||
                  //               int.parse(widget.userProvider!.user.data!.remainingPost!) > 0) {
                  if (!PsProgressDialog.isShowing()) {
                    await PsProgressDialog.showDialog(context,
                        message: Utils.getString(
                            context, 'progressloading_item_uploading'));
                  }
                  //add new
                  final ItemEntryParameterHolder itemEntryParameterHolder =
                  ItemEntryParameterHolder(
                    catId: widget.provider!.categoryId,
                    subCatId: widget.provider!.subCategoryId,
                    itemTypeId: widget.provider!.itemTypeId,
                    conditionOfItemId: widget.provider!.itemConditionId,
                    itemPriceTypeId: widget.provider!.itemPriceTypeId,
                    itemCurrencyId: widget.provider!.itemCurrencyId,
                    price: widget.userInputPrice!.text,
                    discountRate: widget.userInputDiscount!.text,
                    dealOptionId: widget.provider!.itemDealOptionId,
                    itemLocationId: widget.provider!.itemLocationId,
                    itemLocationTownshipId:
                    widget.provider!.itemLocationTownshipId,
                    businessMode: widget.provider!.checkOrNotShop,
                    isSoldOut: '', //must be ''
                    title: widget.userInputListingTitle!.text,
                    brand: widget.userInputBrand!.text,
                    highlightInfomation:
                    widget.userInputHighLightInformation!.text,
                    description: widget.userInputDescription!.text,
                    dealOptionRemark: widget.userInputDealOptionText!.text,
                    latitude: widget.userInputLattitude!.text,
                    longitude: widget.userInputLongitude!.text,
                    address: widget.userInputAddress!.text,
                    whatsappNumber: widget.userInputWhatsappNum!.text,
                    id: widget.provider!.itemId, //must be '' <<< ID
                    addedUserId: widget.provider!.psValueHolder!.loginUserId,
                  );

                  final PsResource<Product> itemData = await widget.provider!
                      .postItemEntry(itemEntryParameterHolder.toMap(),
                      widget.provider!.psValueHolder!.loginUserId!);
                  PsProgressDialog.dismissDialog();

                  if (itemData.status == PsStatus.SUCCESS) {
                    widget.provider!.itemId = itemData.data!.id;
                    if (itemData.data != null) {
                      if (widget.isImageSelected.contains(true)) {
                        widget.uploadImage!(itemData.data!.id);

                        // if (widget.isSelectedFirstImagePath ||
                        //     widget.isSelectedSecondImagePath ||
                        //     widget.isSelectedThirdImagePath ||
                        //     widget.isSelectedFouthImagePath ||
                        //     widget.isSelectedFifthImagePath ||
                        //     widget.isSelectedVideoImagePath ) {
                        //   widget.uploadImage(itemData.data!.id);
                        // }
                      }
                    }
                  } else {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(
                            message: itemData.message,
                          );
                        });
                  }
                  // } else {
                  //   showDialog<dynamic>(context: context, builder: (BuildContext context) {
                  //       return InAppPurchaseBuyPackageDialog(
                  //     onInAppPurchaseTap: () async {
                  //       // InAppPurchase View
                  //       final dynamic returnData = await Navigator.pushNamed(
                  //           context, RoutePaths.buyPackage,
                  //           arguments: <String, dynamic>{
                  //             'userId': widget.userProvider!.user.data!.userId,
                  //           });

                  //       if (returnData != null) {
                  //         setState(() {
                  //           widget.userProvider!.user.data!.remainingPost = returnData;
                  //         });
                  //         // if (!PsProgressDialog.isShowing()) {
                  //         // await PsProgressDialog.showDialog(context,
                  //         // message: Utils.getString(
                  //         //     context, 'login__loading'));
                  //         //  }
                  //         // await widget.userProvider!
                  //         //     .getUser(valueHolder!.loginUserId);
                  //         // PsProgressDialog.dismissDialog();
                  //       }
                  //     },
                  //   );
                  //   });

                  // }
                } else {
                  // edit item
                  if (!PsProgressDialog.isShowing()) {
                    await PsProgressDialog.showDialog(context,
                        message: Utils.getString(
                            context, 'progressloading_item_uploading'));
                  }
                  final ItemEntryParameterHolder itemEntryParameterHolder =
                  ItemEntryParameterHolder(
                    catId: widget.provider!.categoryId,
                    subCatId: widget.provider!.subCategoryId,
                    itemTypeId: widget.provider!.itemTypeId,
                    conditionOfItemId: widget.provider!.itemConditionId,
                    itemPriceTypeId: widget.provider!.itemPriceTypeId,
                    itemCurrencyId: widget.provider!.itemCurrencyId,
                    price: widget.userInputPrice!.text,
                    discountRate: widget.userInputDiscount!.text,
                    dealOptionId: widget.provider!.itemDealOptionId,
                    itemLocationId: widget.provider!.itemLocationId,
                    itemLocationTownshipId:
                    widget.provider!.itemLocationTownshipId,
                    businessMode: widget.provider!.checkOrNotShop,
                    isSoldOut: widget.item!.isSoldOut,
                    title: widget.userInputListingTitle!.text,
                    brand: widget.userInputBrand!.text,
                    highlightInfomation:
                    widget.userInputHighLightInformation!.text,
                    description: widget.userInputDescription!.text,
                    dealOptionRemark: widget.userInputDealOptionText!.text,
                    latitude: widget.userInputLattitude!.text,
                    longitude: widget.userInputLongitude!.text,
                    address: widget.userInputAddress!.text,
                    whatsappNumber: widget.userInputWhatsappNum!.text,
                    id: widget.item!.id,
                    addedUserId: widget.provider!.psValueHolder!.loginUserId,
                  );

                  final PsResource<Product> itemData = await widget.provider!
                      .postItemEntry(itemEntryParameterHolder.toMap(),
                      widget.provider!.psValueHolder!.loginUserId!);
                  PsProgressDialog.dismissDialog();

                  if (itemData.status == PsStatus.SUCCESS) {
                    if (itemData.data != null) {
                      Fluttertoast.showToast(
                          msg: 'Item Uploaded',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white);

                      if (widget.isImageSelected.contains(true) ||
                          widget.isSelectedVideoImagePath!) {
                        widget.uploadImage!(itemData.data!.id);

                        // if (widget.isSelectedFirstImagePath ||
                        //     widget.isSelectedSecondImagePath ||
                        //     widget.isSelectedThirdImagePath ||
                        //     widget.isSelectedFouthImagePath ||
                        //     widget.isSelectedFifthImagePath ||
                        //     widget.isSelectedVideoImagePath) {
                        //   widget.uploadImage(itemData.data!.id);
                      }
                    }
                  } else {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(
                            message: itemData.message,
                          );
                        });
                  }
                }
              }
            }));

    return Column(children: <Widget>[
      //  if (Utils.showUI(valueHolder!.title))
      PsTextFieldWidget(
        //  height: 46,
        titleText: Utils.getString(context, 'item_entry__listing_title'),
        textAboutMe: false,
        hintText: Utils.getString(context, 'item_entry__entry_title'),
        textEditingController: widget.userInputListingTitle,
        isStar: true,
      ),
      //  if (Utils.showUI(valueHolder!.categoryId))
      PsDropdownBaseWithControllerWidget(
        title: Utils.getString(context, 'item_entry__category'),
        textEditingController: widget.categoryController,
        isStar: true,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          final ItemEntryProvider provider =
          Provider.of<ItemEntryProvider>(context, listen: false);

          final dynamic categoryResult =
          await Navigator.pushNamed(context, RoutePaths.searchCategory);

          if (categoryResult != null && categoryResult is Category) {
            provider.categoryId = categoryResult.catId;
            widget.categoryController!.text = categoryResult.catName!;
            provider.subCategoryId = '';

            setState(() {
              widget.categoryController!.text = categoryResult.catName!;
              widget.subCategoryController!.text = '';
            });
          }
        },
      ),
      if (Utils.showUI(valueHolder!.subCatId))
        PsDropdownBaseWithControllerWidget(
            title: Utils.getString(context, 'item_entry__subCategory'),
            textEditingController: widget.subCategoryController,
            //  isStar: true,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final ItemEntryProvider provider =
              Provider.of<ItemEntryProvider>(context, listen: false);
              if (provider.categoryId != '') {
                final dynamic subCategoryResult = await Navigator.pushNamed(
                    context, RoutePaths.searchSubCategory,
                    arguments: provider.categoryId);
                if (subCategoryResult != null &&
                    subCategoryResult is SubCategory) {
                  provider.subCategoryId = subCategoryResult.id;

                  widget.subCategoryController!.text = subCategoryResult.name!;
                }
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'home_search__choose_category_first'),
                      );
                    });
                const ErrorDialog(message: 'Choose Category first');
              }
            }),
      if (Utils.showUI(valueHolder!.typeId))
        PsDropdownBaseWithControllerWidget(
            title: Utils.getString(context, 'item_entry__type'),
            textEditingController: widget.typeController,
            //  isStar: true,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final ItemEntryProvider provider =
              Provider.of<ItemEntryProvider>(context, listen: false);

              final dynamic itemTypeResult =
              await Navigator.pushNamed(context, RoutePaths.itemType);

              if (itemTypeResult != null && itemTypeResult is ItemType) {
                provider.itemTypeId = itemTypeResult.id;

                setState(() {
                  widget.typeController!.text = itemTypeResult.name!;
                });
              }
            }),
      if (Utils.showUI(valueHolder!.conditionOfItemId))
        PsDropdownBaseWithControllerWidget(
            title: Utils.getString(context, 'item_entry__item_condition'),
            textEditingController: widget.itemConditionController,
            //  isStar: true,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final ItemEntryProvider provider =
              Provider.of<ItemEntryProvider>(context, listen: false);

              final dynamic itemConditionResult =
              await Navigator.pushNamed(context, RoutePaths.itemCondition);

              if (itemConditionResult != null &&
                  itemConditionResult is ConditionOfItem) {
                provider.itemConditionId = itemConditionResult.id;

                setState(() {
                  widget.itemConditionController!.text =
                  itemConditionResult.name!;
                });
              }
            }),
      if (Utils.showUI(valueHolder!.brand))
        PsTextFieldWidget(
          titleText: Utils.getString(context, 'item_entry__brand'),
          textAboutMe: false,
          textEditingController: widget.userInputBrand,
        ),
      if (Utils.showUI(valueHolder!.priceTypeId))
        PsDropdownBaseWithControllerWidget(
            title: Utils.getString(context, 'item_entry__price_type'),
            textEditingController: widget.priceTypeController,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final ItemEntryProvider provider =
              Provider.of<ItemEntryProvider>(context, listen: false);

              final dynamic itemPriceTypeResult =
              await Navigator.pushNamed(context, RoutePaths.itemPriceType);

              if (itemPriceTypeResult != null &&
                  itemPriceTypeResult is ItemPriceType) {
                provider.itemPriceTypeId = itemPriceTypeResult.id;
                // provider.subCategoryId = '';

                setState(() {
                  widget.priceTypeController!.text = itemPriceTypeResult.name!;
                  // provider.selectedSubCategoryName = '';
                });
              }
            }),
      //  if (Utils.showUI(valueHolder!.itemCurrencyId) && Utils.showUI(valueHolder!.price))
      PriceDropDownControllerWidget(
          currencySymbolController: widget.priceController,
          userInputPriceController: widget.userInputPrice),

      if (Utils.showUI(valueHolder!.discountRateByPercentage))
        PsTextFieldWidget(
          //  height: 46,
          titleText: Utils.getString(context, 'item_entry__discount_title'),
          textAboutMe: false,
          hintText: Utils.getString(context, 'item_entry__discount_info'),
          textEditingController: widget.userInputDiscount,
          keyboardType: TextInputType.number,
        ),
      const SizedBox(height: PsDimens.space8),
      Column(
        children: <Widget>[
          if (Utils.showUI(valueHolder!.dealOptionId))
            PsDropdownBaseWithControllerWidget(
                title: Utils.getString(context, 'item_entry__deal_option'),
                textEditingController: widget.dealOptionController,
                //    isStar: true,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final ItemEntryProvider provider =
                  Provider.of<ItemEntryProvider>(context, listen: false);

                  final dynamic itemDealOptionResult =
                  await Navigator.pushNamed(
                      context, RoutePaths.itemDealOption);

                  if (itemDealOptionResult != null &&
                      itemDealOptionResult is DealOption) {
                    provider.itemDealOptionId = itemDealOptionResult.id;

                    setState(() {
                      widget.dealOptionController!.text =
                      itemDealOptionResult.name!;
                    });
                  }
                }),
          if (Utils.showUI(valueHolder!.dealOptionRemark))
            Container(
              width: double.infinity,
              height: PsDimens.space44,
              margin: const EdgeInsets.only(
                  left: PsDimens.space12,
                  right: PsDimens.space12,
                  bottom: PsDimens.space12),
              decoration: BoxDecoration(
                color: PsColors.cardBackgroundColor,
                borderRadius: BorderRadius.circular(PsDimens.space10),
                border: Border.all(color: PsColors.mainDividerColor),
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                maxLines: null,
                controller: widget.userInputDealOptionText,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: PsColors.cardBackgroundColor,
                  contentPadding: const EdgeInsets.only(
                    left: PsDimens.space12,
                    bottom: PsDimens.space8,
                  ),
                  // border: InputBorder.none,
                  hintText: Utils.getString(context, 'item_entry__remark'),
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Utils.isLightMode(context)
                          ? PsColors.textPrimaryLightColor
                          : PsColors.primaryDarkGrey),
                ),
              ),
            )
        ],
      ),
      if (Utils.showUI(valueHolder!.businessMode))
        BusinessModeCheckbox(
          provider: widget.provider,
          onCheckBoxClick: () {
            setState(() {
              updateCheckBox(context, widget.provider!);
            });
          },
        ),
      if (Utils.showUI(valueHolder!.highlightInfo))
        PsTextFieldWidget(
          titleText: Utils.getString(context, 'item_entry__highlight_info'),
          height: PsDimens.space120,
          hintText: Utils.getString(context, 'item_entry__highlight_info'),
          textAboutMe: true,
          keyboardType: TextInputType.multiline,
          textEditingController: widget.userInputHighLightInformation,
        ),
      //  if (Utils.showUI(valueHolder!.description))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__description'),
        height: PsDimens.space120,
        hintText: Utils.getString(context, 'item_entry__description'),
        textAboutMe: true,
        keyboardType: TextInputType.multiline,
        textEditingController: widget.userInputDescription,
        isStar: true,
      ),
      //  if (Utils.showUI(valueHolder!.itemLocationId))
      ///Location Dropdown which will hide....
      // PsDropdownBaseWithControllerWidget(
      //     title: Utils.getString(context, 'item_entry__location'),
      //     // selectedText: provider.selectedItemLocation == ''
      //     //     ? provider.psValueHolder.locactionName
      //     //     : provider.selectedItemLocation,
      //
      //     textEditingController:
      //     // locationController.text == ''
      //     // ?
      //     // provider.psValueHolder.locactionName
      //     // :
      //     widget.locationController,
      //     isStar: true,
      //     onTap: () async {
      //       FocusScope.of(context).requestFocus(FocusNode());
      //       final ItemEntryProvider provider =
      //       Provider.of<ItemEntryProvider>(context, listen: false);
      //
      //       final dynamic itemLocationResult =
      //       await Navigator.pushNamed(context, RoutePaths.itemLocation);
      //
      //       if (itemLocationResult != null &&
      //           itemLocationResult is ItemLocation) {
      //         provider.itemLocationId = itemLocationResult.id;
      //         setState(() {
      //           widget.locationController!.text = itemLocationResult.name!;
      //           if (valueHolder!.isUseGoogleMap! &&
      //               valueHolder!.isSubLocation == PsConst.ZERO) {
      //             _kLake = googlemap.CameraPosition(
      //                 target: googlemap.LatLng(
      //                     double.parse(itemLocationResult.lat!),
      //                     double.parse(itemLocationResult.lng!)),
      //                 zoom: widget.zoom!);
      //             if (_kLake != null) {
      //               widget.googleMapController!.animateCamera(
      //                   googlemap.CameraUpdate.newCameraPosition(_kLake!));
      //             }
      //             widget.userInputLattitude!.text = itemLocationResult.lat!;
      //             widget.userInputLongitude!.text = itemLocationResult.lng!;
      //           } else if (!valueHolder!.isUseGoogleMap! &&
      //               valueHolder!.isSubLocation == PsConst.ZERO) {
      //             _latlng = LatLng(double.parse(itemLocationResult.lat!),
      //                 double.parse(itemLocationResult.lng!));
      //             widget.mapController!.move(_latlng!, widget.zoom!);
      //             widget.userInputLattitude!.text = itemLocationResult.lat!;
      //             widget.userInputLongitude!.text = itemLocationResult.lng!;
      //           } else {
      //             //do nothing
      //           }
      //
      //           widget.locationTownshipController!.text = '';
      //           provider.itemLocationTownshipId = '';
      //           widget.userInputAddress!.text = '';
      //         });
      //       }
      //     }),

      if (valueHolder!.isSubLocation == PsConst.ONE)
        PsDropdownBaseWithControllerWidget(
            title: Utils.getString(context, 'item_entry__location_township'),
            textEditingController: widget.locationTownshipController,
            //  isStar: true,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final ItemEntryProvider provider =
              Provider.of<ItemEntryProvider>(context, listen: false);
              if (provider.itemLocationId != '') {
                final dynamic itemLocationTownshipResult =
                await Navigator.pushNamed(
                    context, RoutePaths.itemLocationTownship,
                    arguments: provider.itemLocationId);

                if (itemLocationTownshipResult != null &&
                    itemLocationTownshipResult is ItemLocationTownship) {
                  provider.itemLocationTownshipId =
                      itemLocationTownshipResult.id;
                  setState(() {
                    widget.locationTownshipController!.text =
                    itemLocationTownshipResult.townshipName!;
                    if (valueHolder!.isUseGoogleMap!) {
                      _kLake = googlemap.CameraPosition(
                          target: googlemap.LatLng(
                              double.parse(itemLocationTownshipResult.lat!),
                              double.parse(itemLocationTownshipResult.lng!)),
                          zoom: widget.zoom!);
                      if (_kLake != null) {
                        widget.googleMapController!.animateCamera(
                            googlemap.CameraUpdate.newCameraPosition(_kLake!));
                      }
                      widget.userInputLattitude!.text =
                      itemLocationTownshipResult.lat!;
                      widget.userInputLongitude!.text =
                      itemLocationTownshipResult.lng!;
                      print('lat' + itemLocationTownshipResult.lat!);
                      print('lng' + itemLocationTownshipResult.lng!);
                    } else {
                      _latlng = LatLng(
                          double.parse(itemLocationTownshipResult.lat!),
                          double.parse(itemLocationTownshipResult.lng!));
                      widget.mapController!.move(_latlng!, widget.zoom!);
                    }
                    widget.userInputLattitude!.text =
                    itemLocationTownshipResult.lat!;
                    widget.userInputLongitude!.text =
                    itemLocationTownshipResult.lng!;

                    widget.userInputAddress!.text = '';
                  });
                }
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'home_search__choose_city_first'),
                      );
                    });
                const ErrorDialog(message: 'Choose City first');
              }
            })
      else
        Container(),

      if (Utils.showUI(valueHolder!.latitude) && !valueHolder!.isUseGoogleMap!)
        Container(
          height: 260,
          margin: const EdgeInsets.all(PsDimens.space12),
          //padding: const EdgeInsets.only(right: 8, left: 8),
          decoration: BoxDecoration(
            color: PsColors.cardBackgroundColor,
            borderRadius: BorderRadius.circular(PsDimens.space10),
            border: Border.all(color: PsColors.mainDividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Stack(
              //   children: <Widget>[
              //  Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text(Utils.getString(context, 'Drag pin to your location'),
              //       style: Theme.of(context).textTheme.caption),
              //     ),
              Padding(
                padding:
                const EdgeInsets.only(right: 4, left: 4, bottom: 8, top: 4),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PsDimens.space10),
                    border: Border.all(color: PsColors.mainDividerColor),
                  ),
                  height: 200,
                  child: FlutterMap(
                    mapController: widget.mapController,
                    options: MapOptions(
                        center:
                        _latlng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                        zoom: widget.zoom!, //10.0,
                        onTap: (dynamic tapPosition, LatLng latLngr) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _handleTap(_latlng, widget.mapController);
                        }),
                    nonRotatedChildren: <Widget>[
                      TileLayer(
                        urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                      MarkerLayer(markers: <Marker>[
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: _latlng!,
                          builder: (BuildContext ctx) => Container(
                            child: IconButton(
                              icon: Icon(
                                Icons.location_on,
                                color: PsColors.activeColor,
                              ),
                              iconSize: 45,
                              onPressed: () {},
                            ),
                          ),
                        )
                      ])
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   right: 10,
              //   bottom: 80,
              //   child: Container(
              //   decoration: BoxDecoration(
              //       color: PsColors.primary500,
              //       borderRadius: BorderRadius.circular(PsDimens.space10),
              //       border: Border.all(color: PsColors.mainDividerColor),
              //     ),
              //     child: InkWell(
              //       onTap: () {
              //          _zoomOut();
              //       },
              //     child:  Container(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Icon(Entypo.minus,color: PsColors.primaryDarkWhite,),
              //     )),
              //   )),
              //  Positioned(
              //   right: 10,
              //   bottom: 15,
              //   child: Container(
              //   decoration: BoxDecoration(
              //       color: PsColors.primary500,
              //       borderRadius: BorderRadius.circular(PsDimens.space10),
              //       border: Border.all(color: PsColors.mainDividerColor),
              //     ),
              //     child: InkWell(
              //       onTap: () {
              //          _zoomIn();
              //       },
              //     child:  Container(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Icon(Entypo.plus,color: PsColors.primaryDarkWhite,),
              //     )),
              //   ))

              //   ],
              // ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                        Utils.getString(context, 'item_entry__latitude'),
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: PsDimens.space120),
                    child: Text(widget.userInputLattitude!.text,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  // CurrentLocationWidget(
                  //         androidFusedLocation: true,
                  //         textEditingController: widget.userInputAddress,
                  //         latController: widget.userInputLattitude,
                  //         lngController: widget.userInputLongitude,
                  //         valueHolder: valueHolder,
                  //         updateLatLng: (Position currentPosition) {
                  //           setState(() {
                  //             _latlng = LatLng(
                  //                 currentPosition.latitude, currentPosition.longitude);
                  //             widget.mapController!.move(_latlng!, widget.zoom!);
                  //           });
                  //         },
                  //       ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                        Utils.getString(context, 'item_entry__longitude'),
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(widget.userInputLongitude!.text,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              ),
            ],
          ),
        )
      else if (Utils.showUI(valueHolder!.latitude))
        Column(
          children: <Widget>[
            // CurrentLocationWidget(
            //   androidFusedLocation: true,
            //   textEditingController: widget.userInputAddress,
            //   latController: widget.userInputLattitude,
            //   lngController: widget.userInputLongitude,
            //   valueHolder: valueHolder,
            //   updateLatLng: (Position currentPosition) {
            //     setState(() {
            //       _latlng = LatLng(
            //           currentPosition.latitude, currentPosition.longitude);
            //       _kLake = googlemap.CameraPosition(
            //           target: googlemap.LatLng(
            //               _latlng!.latitude, _latlng!.longitude),
            //           zoom: widget.zoom!);
            //       if (_kLake != null) {
            //         widget.googleMapController!.animateCamera(
            //             googlemap.CameraUpdate.newCameraPosition(_kLake!));
            //       }
            //     });
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 18, left: 18),
              child: Container(
                height: 250,
                child: googlemap.GoogleMap(
                    onMapCreated: widget.updateMapController as void Function(
                        googlemap.GoogleMapController)?,
                    initialCameraPosition: kGooglePlex,
                    circles: <googlemap.Circle>{}..add(googlemap.Circle(
                      circleId: googlemap.CircleId(
                          widget.userInputAddress.toString()),
                      center: googlemap.LatLng(
                          _latlng!.latitude, _latlng!.longitude),
                      radius: 50,
                      fillColor: Colors.blue.withOpacity(0.7),
                      strokeWidth: 3,
                      strokeColor: Colors.redAccent,
                    )),
                    onTap: (googlemap.LatLng latLngr) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _handleGoogleMapTap(_latlng, widget.googleMapController);
                    }),
              ),
            ),
          ],
        ),
      // PsTextFieldWidget(
      //   titleText: Utils.getString(context, 'item_entry__latitude'),
      //   textAboutMe: false,
      //   textEditingController: widget.userInputLattitude,
      // ),
      // PsTextFieldWidget(
      //   titleText: Utils.getString(context, 'item_entry__longitude'),
      //   textAboutMe: false,
      //   textEditingController: widget.userInputLongitude,
      // ),
      if (Utils.showUI(valueHolder!.latitude))
        CurrentLocationWidget(
          androidFusedLocation: true,
          textEditingController: widget.userInputAddress,
          latController: widget.userInputLattitude,
          lngController: widget.userInputLongitude,
          valueHolder: valueHolder,
          updateLatLng: (Position currentPosition) {
            setState(() {
              _latlng =
                  LatLng(currentPosition.latitude, currentPosition.longitude);
              widget.mapController!.move(_latlng!, widget.zoom!);
            });
          },
        ),
      if (Utils.showUI(valueHolder!.latitude))
        InkWell(
          onTap: () {
            _handleTap(_latlng, widget.mapController);
          },
          child: Row(
            children: <Widget>[
              Container(
                height: PsDimens.space28,
                width: PsDimens.space40,
                child: Icon(
                  Octicons.plus,
                  color: PsColors.activeColor,
                  size: PsDimens.space20,
                ),
              ),
              Text(
                Utils.getString(context, 'Pick on Map'),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: PsColors.activeColor),
              )
            ],
          ),
        ),
      if (Utils.showUI(valueHolder!.address))
        PsTextFieldWidget(
          titleText: Utils.getString(context, 'item_entry__address'),
          textAboutMe: false,
          height: PsDimens.space60,
          textEditingController: widget.userInputAddress,
          hintText: Utils.getString(context, 'item_entry__address'),
        ),

      ///Here whatsapp number option
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'whatsapp_number'),
        textAboutMe: false,
        keyboardType: TextInputType.phone,
        hintText: Utils.getString(context, '+959123456789'),
        textEditingController: widget.userInputWhatsappNum,
        isStar: true,
      ),
      _uploadItemWidget
    ]);
  }

  dynamic _handleTap(LatLng? latLng, MapController? mapController) async {
    final dynamic result = await Navigator.pushNamed(context, RoutePaths.mapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng!.latitude.toString(),
            mapLng: _latlng!.longitude.toString()));
    if (result != null && result is MapPinCallBackHolder) {
      setState(() {
        _latlng = result.latLng;
        mapController!.move(_latlng!, widget.zoom!);
        widget.userInputAddress!.text = result.address;
        // widget.userInputAddress.text = '';
        // tappedPoints = <LatLng>[];
        // tappedPoints.add(latlng);
      });
      widget.userInputLattitude!.text = result.latLng!.latitude.toString();
      widget.userInputLongitude!.text = result.latLng!.longitude.toString();
    }
  }

  dynamic _handleGoogleMapTap(LatLng? latLng,
      googlemap.GoogleMapController? googleMapController) async {
    final dynamic result = await Navigator.pushNamed(
        context, RoutePaths.googleMapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng!.latitude.toString(),
            mapLng: _latlng!.longitude.toString()));
    if (result != null && result is GoogleMapPinCallBackHolder) {
      setState(() {
        _latlng = LatLng(result.latLng!.latitude, result.latLng!.longitude);
        _kLake = googlemap.CameraPosition(
            target: googlemap.LatLng(_latlng!.latitude, _latlng!.longitude),
            zoom: widget.zoom!);
        if (_kLake != null) {
          googleMapController!
              .animateCamera(googlemap.CameraUpdate.newCameraPosition(_kLake!));
          widget.userInputAddress!.text = result.address;
          //   widget.userInputAddress.text = '';
          // tappedPoints = <LatLng>[];
          // tappedPoints.add(latlng);
        }
      });
      widget.userInputLattitude!.text = result.latLng!.latitude.toString();
      widget.userInputLongitude!.text = result.latLng!.longitude.toString();
    }
  }
}

// ignore: must_be_immutable
class ImageUploadHorizontalList extends StatefulWidget {
  ImageUploadHorizontalList({
    @required this.flag,
    @required this.images,
    @required this.selectedImageList,
    @required this.updateImages,
    @required this.updateImagesFromCustomCamera,
    @required this.updateImagesFromVideo,
    @required this.selectedVideoImagePath,
    @required this.videoFilePath,
    @required this.videoFileThumbnailPath,
    @required this.selectedVideoPath,
    required this.galleryImagePath,
    required this.cameraImagePath,
    @required this.getImageFromVideo,
    @required this.imageDesc1Controller,
    @required this.galleryProvider,
    required this.onReorder,
    this.provider,
  });
  final String? flag;
  final List<XFile>? images;
  final List<DefaultPhoto?>? selectedImageList;
  final Function? updateImages;
  final Function? updateImagesFromCustomCamera;
  final String? selectedVideoImagePath;
  final String? videoFilePath;
  final String? selectedVideoPath;
  final String? videoFileThumbnailPath;
  final Function? updateImagesFromVideo;
  List<XFile?> galleryImagePath;
  List<String?> cameraImagePath;
  final Function? getImageFromVideo;
  final TextEditingController? imageDesc1Controller;
  final ItemEntryProvider? provider;
  final GalleryProvider? galleryProvider;
  Function onReorder;

  @override
  State<StatefulWidget> createState() {
    return ImageUploadHorizontalListState();
  }
}

class ImageUploadHorizontalListState extends State<ImageUploadHorizontalList> {
  late ItemEntryProvider provider;
  late PsValueHolder psValueHolder;
  Future<void> loadPickMultiImage(int index) async {
    final ImagePicker _picker = ImagePicker();
    List<XFile> resultList = <XFile>[];

    try {
      resultList = await _picker.pickMultiImage();
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    for (int i = 0; i < resultList.length; i++) {
      if (resultList[i].name.contains('.webp')) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__webp_image'),
              );
            });
        return;
      }
    }
    widget.updateImages!(resultList, -1, index);
  }

  Future<void> loadSingleImage(int index) async {
    final ImagePicker _picker = ImagePicker();
    List<XFile> resultList = <XFile>[];

    try {
      resultList = await _picker.pickMultiImage();
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    if (resultList[0].name.contains('.webp')) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__webp_image'),
            );
          });
    } else {
      widget.updateImages!(resultList, index, index);
    }
  }

  List<Widget> _imageWidgetList = <Widget>[];
  late Widget _videoWidget;
  late Widget _firstImageWidget;
  @override
  Widget build(BuildContext context) {
    XFile? defaultAssetImage;
    DefaultPhoto? defaultUrlImage;
    psValueHolder = Provider.of<PsValueHolder>(context);
    provider = Provider.of<ItemEntryProvider>(context, listen: false);
    List<PlatformFile>? videoFilePath = <PlatformFile>[];

    final Widget _defaultWidget = Container(
      width: 78,
      height: 25,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(7.0),
              bottomRight: Radius.circular(7.0)),
        ),
      ),
      margin: const EdgeInsets.only(
          top: PsDimens.space4, left: PsDimens.space4, right: PsDimens.space1),
      child: Material(
        color: PsColors.textColor2,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(PsDimens.space16),
                bottomRight: Radius.circular(PsDimens.space16))),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                left: PsDimens.space8, right: PsDimens.space8),
            child: Text(
              Utils.getString(context, 'item_entry__default_image'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: PsColors.textColor4),
            ),
          ),
        ),
      ),
    );

    _videoWidget = Visibility(
      visible:
      Utils.showUI(provider.psValueHolder!.video), //PsConfig.showVideo,
      child: ItemEntryImageWidget(
        galleryProvider: widget.galleryProvider,
        index: -1, //video
        images: defaultAssetImage,
        selectedVideoImagePath: (widget.selectedVideoImagePath != null)
            ? widget.selectedVideoImagePath
            : null,
        videoFilePath:
        (widget.videoFilePath != null) ? widget.videoFilePath : null,
        videoFileThumbnailPath: (widget.videoFileThumbnailPath != null)
            ? widget.videoFileThumbnailPath
            : null,
        selectedVideoPath: widget.selectedVideoPath,
        cameraImagePath: null,
        provider: provider,
        selectedImage:
        widget.selectedVideoImagePath == null ? defaultUrlImage : null,
        onDeletItemImage: () {
          setState(() {
            final ItemEntryProvider itemEntryProvider =
            Provider.of<ItemEntryProvider>(context, listen: false);
            itemEntryProvider.item!.video!.imgId = '';
            itemEntryProvider.item!.videoThumbnail!.imgId = '';
            itemEntryProvider.item!.video = null;
            itemEntryProvider.item!.videoThumbnail = null;
          });
        },
        hideDesc: true,
        onTap: () async {
          // try {
          //   final ImagePicker picker = ImagePicker();
          //   final XFile? pickedFile = await picker.pickVideo(
          //     source: ImageSource.gallery,
          //   );

          try {
            videoFilePath = (await FilePicker.platform.pickFiles(
              type: FileType.video,
              allowMultiple: true,
            ))
                ?.files;
          } on PlatformException catch (e) {
            print('Unsupported operation' + e.toString());
          } catch (ex) {
            print(ex);
          }

          if (videoFilePath != null) {
            final File pickedVideo = File(videoFilePath![0].path!);
            final VideoPlayerController videoPlayer =
            VideoPlayerController.file(pickedVideo);
            await videoPlayer.initialize();

            final int maximumSecond =
            int.parse(psValueHolder.videoDuration ?? '60000');
            final int videoDuration = videoPlayer.value.duration.inMilliseconds;

            if (videoDuration < maximumSecond) {
              await widget.getImageFromVideo!(pickedVideo.path);
              widget.updateImagesFromVideo!(pickedVideo.path, -2);
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                        message: Utils.getString(
                            context, 'error_dialog__select_video'));
                  });
            }
          }
          // } catch (e) {
          //   showDialog<dynamic>(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return ErrorDialog(
          //             message: Utils.getString(
          //                 context, 'error_dialog__error'));
          //       });
          // }

          // final ImagePicker _imgPicker = ImagePicker();
          // final XFile? videoFile =
          //     await _imgPicker.pickVideo(source: ImageSource.gallery);
          // if (pickedFile != null) {
          // final String videoPath = videoFile.path;
          // final int videoLenght = await videoFile.length();
          // print(videoLenght);
          // final VideoMetaInfo? videoInfo = VideoMetaInfo();
          // VideoData? videoData =
          //     await videoInfo!.getVideoInfo(videoFilePath![0].path!);

          // if (length <=
          //     double.parse(psValueHolder.videoDuration ?? '60000')) {
          //   await widget.getImageFromVideo!(videoFilePath![0].path);
          //   widget.updateImagesFromVideo!(videoFilePath![0].path, -2);
          //  // videoData = null;
          //   //videoInfo = null;
          //   videoFilePath!.clear();
          // } else {
          //  // videoData = null;
          //   //videoInfo = null;
          //   videoFilePath!.clear();
          //   showDialog<dynamic>(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return ErrorDialog(
          //             message: Utils.getString(
          //                 context, 'error_dialog__select_video'));
          //       });
          // }

          // PsProgressDialog.dismissDialog();
          // }
        },
      ),
    );

    _firstImageWidget = Stack(
      key: const Key('0'),
      children: <Widget>[
        ItemEntryImageWidget(
          galleryProvider: widget.galleryProvider,
          index: 0,
          images: (widget.galleryImagePath[0] != null)
              ? widget.galleryImagePath[0]
              : defaultAssetImage,
          selectedVideoImagePath: null,
          selectedVideoPath: widget.selectedVideoPath,
          videoFilePath: null,
          videoFileThumbnailPath: null,
          cameraImagePath: (widget.cameraImagePath[0] != null)
              ? widget.cameraImagePath[0]
              : defaultAssetImage as String?,
          selectedImage: (widget.selectedImageList!.isNotEmpty &&
              widget.galleryImagePath[0] == null &&
              widget.cameraImagePath[0] == null)
              ? widget.selectedImageList![0]
              : null,
          onDeletItemImage: () {},
          hideDesc: false,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (provider.psValueHolder!.isCustomCamera) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ChooseCameraTypeDialog(
                      onCameraTap: () async {
                        final dynamic returnData = await Navigator.pushNamed(
                            context, RoutePaths.cameraView);
                        if (returnData is String) {
                          widget.updateImagesFromCustomCamera!(returnData, 0);
                        }
                      },
                      onGalleryTap: () {
                        if (widget.flag == PsConst.ADD_NEW_ITEM) {
                          loadPickMultiImage(0);
                        } else {
                          loadSingleImage(0);
                        }
                      },
                    );
                  });
            } else {
              if (widget.flag == PsConst.ADD_NEW_ITEM) {
                loadPickMultiImage(0);
              } else {
                loadSingleImage(0);
              }
            }
          },
        ),
        Positioned(
          child: _defaultWidget,
          left: 1,
          top: 51,
        ),
      ],
    );

    _imageWidgetList = List<Widget>.generate(
        psValueHolder.maxImageCount - 1,
            (int index) => ItemEntryImageWidget(
          galleryProvider: widget.galleryProvider,
          key: Key('${index + 1}'),
          index: index + 1,
          images: (widget.galleryImagePath[index + 1] != null)
              ? widget.galleryImagePath[index + 1]
              : defaultAssetImage,
          selectedVideoImagePath: null,
          selectedVideoPath: widget.selectedVideoPath,
          videoFilePath: null,
          videoFileThumbnailPath: null,
          cameraImagePath: (widget.cameraImagePath[index + 1] != null)
              ? widget.cameraImagePath[index + 1]
              : defaultAssetImage as String?,
          selectedImage:
          // (widget.secondImagePath != null) ? null : defaultUrlImage,
          (widget.selectedImageList!.length > index + 1 &&
              widget.galleryImagePath[index + 1] == null &&
              widget.cameraImagePath[index + 1] == null)
              ? widget.selectedImageList![index + 1]
              : null,
          hideDesc: false,
          onDeletItemImage: () {
            setState(() {
              widget.selectedImageList![index + 1]!.imgId = '';
              widget.selectedImageList![index + 1] =
                  DefaultPhoto(imgId: '', imgPath: '');
            });
          },
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());

            if (provider.psValueHolder!.isCustomCamera) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ChooseCameraTypeDialog(
                      onCameraTap: () async {
                        final dynamic returnData =
                        await Navigator.pushNamed(
                            context, RoutePaths.cameraView);
                        if (returnData is String) {
                          widget.updateImagesFromCustomCamera!(
                              returnData, index + 1);
                        }
                      },
                      onGalleryTap: () {
                        if (widget.flag == PsConst.ADD_NEW_ITEM) {
                          loadPickMultiImage(index + 1);
                        } else {
                          loadSingleImage(index + 1);
                        }
                      },
                    );
                  });
            } else {
              if (widget.flag == PsConst.ADD_NEW_ITEM) {
                loadPickMultiImage(index + 1);
              } else {
                loadSingleImage(index + 1);
              }
            }
          },
        ));

    _imageWidgetList.insert(
        0, _firstImageWidget); // add firt default image widget at index 0

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 6.0, bottom: 12.0),
          child: Text(
            Utils.getString(context, 'Image'),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: PsColors.textColor3),
          ),
        ),
        Container(
          height: PsDimens.space140,
          child: ReorderableListView(
            scrollDirection: Axis.horizontal,
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                widget.onReorder(oldIndex, newIndex);
              });
            },
            header: _videoWidget,
            children: _imageWidgetList,
          ),
        ),
      ],
    );
  }
}

class ItemEntryImageWidget extends StatefulWidget {
  const ItemEntryImageWidget(
      {Key? key,
        required this.index,
        required this.images,
        required this.cameraImagePath,
        required this.selectedVideoImagePath,
        required this.selectedVideoPath,
        required this.videoFilePath,
        required this.videoFileThumbnailPath,
        required this.selectedImage,
        required this.hideDesc,
        this.onTap,
        this.provider,
        required this.galleryProvider,
        @required this.onDeletItemImage})
      : super(key: key);

  final Function()? onTap;
  final Function? onDeletItemImage;
  final int? index;
  final XFile? images;
  final String? cameraImagePath;
  final String? selectedVideoImagePath;
  final String? selectedVideoPath;
  final String? videoFilePath;
  final String? videoFileThumbnailPath;
  final DefaultPhoto? selectedImage;
  final ItemEntryProvider? provider;
  final GalleryProvider? galleryProvider;
  final bool hideDesc;
  @override
  State<StatefulWidget> createState() {
    return ItemEntryImageWidgetState();
  }
}

class ItemEntryImageWidgetState extends State<ItemEntryImageWidget> {
  GalleryProvider? galleryProvider;
  PsValueHolder? valueHolder;
  // int i = 0;
  @override
  Widget build(BuildContext context) {
    galleryProvider = widget.galleryProvider;
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);

    final Widget _deleteWidget = Container(
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: PsDimens.space2),
        iconSize: PsDimens.space24,
        icon: const Icon(
          Icons.delete,
          color: Colors.grey,
        ),
        onPressed: () async {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                  description: Utils.getString(
                      context, 'item_entry__confirm_delete_item_image'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () async {
                    Navigator.pop(context);

                    final DeleteItemImageHolder deleteItemImageHolder =
                    DeleteItemImageHolder(
                        imageId: widget.selectedImage!.imgId);
                    await PsProgressDialog.showDialog(context);
                    final PsResource<ApiStatus> _apiStatus =
                    await galleryProvider!.deleItemImage(
                        deleteItemImageHolder.toMap(),
                        valueHolder!.loginUserId!);
                    PsProgressDialog.dismissDialog();
                    if (_apiStatus.data != null) {
                      widget.onDeletItemImage!();
                      galleryProvider!.loadImageList(
                          widget.selectedImage!.imgParentId, PsConst.ITEM_TYPE);
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(message: _apiStatus.message);
                          });
                    }
                  },
                );
              });
        },
      ),
      width: PsDimens.space32,
      height: PsDimens.space32,
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: BorderRadius.circular(PsDimens.space28),
      ),
    );

    final Widget _deleteVideoWidget = Container(
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: PsDimens.space2),
        iconSize: PsDimens.space24,
        icon: const Icon(
          Icons.delete,
          color: Colors.grey,
        ),
        onPressed: () async {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                  description: Utils.getString(
                      context, 'item_entry__confirm_delete_item_video'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () async {
                    Navigator.pop(context);

                    valueHolder =
                        Provider.of<PsValueHolder>(context, listen: false);
                    final DeleteItemImageHolder deleteItemImageHolder =
                    DeleteItemImageHolder(
                        imageId: widget.provider!.item!.video!.imgId);
                    final DeleteItemImageHolder deleteItemImageHolder2 =
                    DeleteItemImageHolder(
                        imageId:
                        widget.provider!.item!.videoThumbnail!.imgId);
                    await PsProgressDialog.showDialog(context);
                    final PsResource<ApiStatus> _apiStatus =
                    await galleryProvider!.deleItemVideo(
                        deleteItemImageHolder.toMap(),
                        valueHolder!.loginUserId!);
                    final PsResource<ApiStatus> _apiStatus2 =
                    await galleryProvider!.deleItemVideo(
                        deleteItemImageHolder2.toMap(),
                        valueHolder!.loginUserId!);
                    PsProgressDialog.dismissDialog();
                    if (_apiStatus.data != null && _apiStatus2.data != null) {
                      widget.onDeletItemImage!();
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(message: _apiStatus.message);
                          });
                    }
                  },
                );
              });
        },
      ),
      width: PsDimens.space32,
      height: PsDimens.space32,
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: BorderRadius.circular(PsDimens.space28),
      ),
    );

    if (widget.selectedImage != null && widget.selectedImage!.imgPath != '') {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(PsDimens.space20),
                      child: PsNetworkImageWithUrl(
                        photoKey: '',
                        imageAspectRation: PsConst.Aspect_Ratio_1x,
                        imagePath: widget.selectedImage!.imgPath,
                      ),
                    ),
                  ),
                  Positioned(
                    child: widget.index == 0 ? Container() : _deleteWidget,
                    right: 1,
                    bottom: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (widget.videoFilePath != null ||
        widget.videoFileThumbnailPath != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: Column(
          children: <Widget>[
            if (widget.videoFileThumbnailPath != '')
              Stack(children: <Widget>[
                InkWell(
                  onTap: widget.onTap,
                  child: Image(
                      width: 80,
                      height: 80,
                      fit: BoxFit.fill,
                      image: FileImage(File(widget.videoFileThumbnailPath!))),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: PsDimens.space14),
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.play_circle,
                        color: Colors.black54,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ])
            else
              InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.only(top: PsDimens.space16),
                    child: const Icon(
                      Icons.play_circle, //FontAwesome.google,
                      color: Colors.red,
                      size: 50,
                    ),
                  )),
            Visibility(
              visible: Utils.showUI(valueHolder!.video),
              child: Container(
                width: 80,
                padding: const EdgeInsets.only(top: PsDimens.space10),
                child: InkWell(
                  child: PSButtonWidget(
                      colorData: PsColors.buttonColor,
                      width: 30,
                      titleText: Utils.getString(context, 'Play')),
                  onTap: () {
                    if (widget.videoFilePath == null) {
                      Navigator.pushNamed(context, RoutePaths.video_online,
                          arguments: widget.selectedVideoPath);
                    } else {
                      Navigator.pushNamed(context, RoutePaths.video,
                          arguments: widget.videoFilePath);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      if (widget.images != null) {
        final XFile? asset = widget.images;
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(PsDimens.space20),
                child: Container(
                  child: InkWell(
                    onTap: widget.onTap,
                    child: Image.file(
                      File(asset!.path.toString()),
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (widget.cameraImagePath != null) {
        return Container(
          margin: const EdgeInsets.only(right: 4, left: 4),
          child: Stack(
            children: <Widget>[
              InkWell(
                onTap: widget.onTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(PsDimens.space20),
                  child: Image(
                      alignment: Alignment.center,
                      height: 80,
                      width: 80,
                      fit: BoxFit.fill,
                      image: FileImage(File(widget.cameraImagePath!))),
                ),
              ),
            ],
          ),
        );
      } else if (widget.selectedVideoImagePath != null) {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: Column(
            children: <Widget>[
              if (widget.selectedVideoImagePath != '')
                Stack(children: <Widget>[
                  InkWell(
                    onTap: widget.onTap,
                    child: Container(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(PsDimens.space18),
                        child: PsNetworkImageWithUrl(
                          photoKey: '',
                          imageAspectRation: PsConst.Aspect_Ratio_full_image,
                          imagePath: widget.selectedVideoImagePath,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: widget.onTap,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: PsDimens.space4),
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.play_circle,
                          color: Colors.black54,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Column(
                      children: <Widget>[
                        if (widget.provider!.item!.video == null &&
                            widget.provider!.item!.videoThumbnail == null)
                          Container()
                        else
                          _deleteVideoWidget
                      ],
                    ),
                    right: 1,
                    bottom: 1,
                  ),
                ])
              else
                InkWell(
                    onTap: widget.onTap,
                    child: Container(
                      padding: const EdgeInsets.only(top: PsDimens.space16),
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.play_circle,
                        color: Colors.black54,
                        size: 50,
                      ),
                    )),
              Container(
                width: 80,
                padding: const EdgeInsets.only(top: PsDimens.space16),
                child: InkWell(
                  child: PSButtonWidget(
                      colorData: PsColors.buttonColor,
                      width: 30,
                      titleText: Utils.getString(context, 'Play')),
                  onTap: () {
                    if (widget.videoFilePath == null) {
                      Navigator.pushNamed(context, RoutePaths.video_online,
                          arguments: widget.selectedVideoPath);
                    } else {
                      Navigator.pushNamed(context, RoutePaths.video,
                          arguments: widget.videoFilePath);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(
            right: 4,
            left: 4,
          ),
          child: Container(
            child: Column(
              children: <Widget>[
                if (!widget.hideDesc)
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: PsDimens.space1,
                    ),
                    child: InkWell(
                      onTap: widget.onTap,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(PsDimens.space18),
                        child: Image.asset(
                          'assets/images/default_image.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                else
                  InkWell(
                      onTap: widget.onTap,
                      child: Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.only(top: PsDimens.space16),
                        child: const Icon(
                          Icons.play_circle,
                          color: Colors.grey,
                          size: 50,
                        ),
                      )),
              ],
            ),
          ),
        );
      }
    }
  }
}

class PriceDropDownControllerWidget extends StatelessWidget {
  const PriceDropDownControllerWidget(
      {Key? key,
        // @required this.onTap,
        this.currencySymbolController,
        this.userInputPriceController})
      : super(key: key);

  final TextEditingController? currencySymbolController;
  final TextEditingController? userInputPriceController;
  // final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              top: PsDimens.space4,
              right: PsDimens.space12,
              left: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(
                Utils.getString(context, 'item_entry__price'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(' *',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: PsColors.activeColor))
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

                final dynamic itemCurrencySymbolResult =
                await Navigator.pushNamed(
                    context, RoutePaths.itemCurrencySymbol);

                if (itemCurrencySymbolResult != null &&
                    itemCurrencySymbolResult is ItemCurrency) {
                  provider.itemCurrencyId = itemCurrencySymbolResult.id;

                  currencySymbolController!.text =
                  itemCurrencySymbolResult.currencySymbol!;
                }
              },
              child: Container(
                width: PsDimens.space140,
                height: PsDimens.space44,
                margin: const EdgeInsets.all(PsDimens.space12),
                // decoration: BoxDecoration(
                //   color: Utils.isLightMode(context)
                //       ? Colors.white60
                //       : Colors.black54,
                //   borderRadius: BorderRadius.circular(PsDimens.space4),
                //   border: Border.all(
                //       color: Utils.isLightMode(context)
                //           ? Colors.grey[200]!
                //           : Colors.black87),
                // ),
                decoration: BoxDecoration(
                  color: PsColors.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(PsDimens.space10),
                  border: Border.all(color: PsColors.mainDividerColor),
                ),
                child: Container(
                  margin: const EdgeInsets.all(PsDimens.space12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          child: Ink(
                            color: PsColors.backgroundColor,
                            child: Text(
                              currencySymbolController!.text == ''
                                  ? Utils.getString(
                                  context, 'home_search__not_set')
                                  : currencySymbolController!.text,
                              style: currencySymbolController!.text == ''
                                  ? Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.grey[600])
                                  : Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: PsDimens.space44,
                // margin: const EdgeInsets.only(
                //     top: 24),
                // decoration: BoxDecoration(
                //   color: Utils.isLightMode(context)
                //       ? Colors.white60
                //       : Colors.black54,
                //   borderRadius: BorderRadius.circular(PsDimens.space4),
                //   border: Border.all(
                //       color: Utils.isLightMode(context)
                //           ? Colors.grey[200]!
                //           : Colors.black87),
                // ),
                decoration: BoxDecoration(
                  color: PsColors.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(PsDimens.space10),
                  border: Border.all(color: PsColors.mainDividerColor),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  controller: userInputPriceController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: PsDimens.space12, bottom: PsDimens.space4),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: PsDimens.space12),
          ],
        ),
      ],
    );
  }
}

class BusinessModeCheckbox extends StatefulWidget {
  const BusinessModeCheckbox(
      {required this.provider, required this.onCheckBoxClick});

  // final String checkOrNot;
  final ItemEntryProvider? provider;
  final Function onCheckBoxClick;

  @override
  _BusinessModeCheckbox createState() => _BusinessModeCheckbox();
}

class _BusinessModeCheckbox extends State<BusinessModeCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: PsDimens.space16),
          child: InkWell(
            child: Text(Utils.getString(context, 'item_entry__is_shop'),
                style: Theme.of(context).textTheme.titleSmall),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onCheckBoxClick();
            },
          ),
        ),
        Row(
          children: <Widget>[
            Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.grey,
              ),
              child: Checkbox(
                side: BorderSide(color: PsColors.primary500),
                checkColor: PsColors.baseColor,
                activeColor: PsColors.activeColor,
                value: widget.provider!.isCheckBoxSelect,
                onChanged: (bool? value) {
                  widget.onCheckBoxClick();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: PsDimens.space2),
              child: Text(
                  Utils.getString(context, 'item_entry__show_more_than_one'),
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ],
    );
  }
}

void updateCheckBox(BuildContext context, ItemEntryProvider provider) {
  if (provider.isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
    provider.checkOrNotShop = '0';
  } else {
    provider.isCheckBoxSelect = true;
    provider.checkOrNotShop = '1';
    // Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
  }
}

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({
    Key? key,

    /// If set, enable the FusedLocationProvider on Android
    required this.androidFusedLocation,
    required this.textEditingController,
    required this.latController,
    required this.lngController,
    required this.valueHolder,
    required this.updateLatLng,
  }) : super(key: key);

  final bool androidFusedLocation;
  final TextEditingController? textEditingController;
  final TextEditingController? latController;
  final TextEditingController? lngController;
  final PsValueHolder? valueHolder;
  final Function updateLatLng;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  String address = '';
  Position? _currentPosition;
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();

    _initCurrentLocation();
  }

  // dynamic loadAddress() async {
  //   if (_currentPosition != null) {
  //     try {
  //       final Address locationAddress = await GeoCode().reverseGeocoding(
  //           latitude: double.parse(_currentPosition!.latitude.toString()),
  //           longitude: double.parse(_currentPosition!.longitude.toString()));

  //       address =
  //           '${locationAddress.streetAddress}  \n, ${locationAddress.countryName}';
  //     } catch (e) {
  //       address = '';
  //       print(e);
  //     }
  //     setState(() {
  //       widget.textEditingController!.text = address;
  //       widget.latController!.text = _currentPosition!.latitude.toString();
  //       widget.lngController!.text = _currentPosition!.longitude.toString();
  //       widget.updateLatLng(_currentPosition);
  //     });
  //   }
  // }

  Future<void> loadAddress() async {
    if (_currentPosition != null) {
      if (widget.textEditingController!.text == '') {
        await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
            .then((List<Placemark> placemarks) {
          final Placemark place = placemarks[0];
          setState(() {
            address =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
            widget.textEditingController!.text = address;
            widget.latController!.text = _currentPosition!.latitude.toString();
            widget.lngController!.text = _currentPosition!.longitude.toString();
            widget.updateLatLng(_currentPosition);
          });
        }).catchError((dynamic e) {
          debugPrint(e.toString());
        });
      } else {
        address = widget.textEditingController!.text;
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  dynamic _initCurrentLocation() {
    Geolocator.checkPermission().then((LocationPermission permission) {
      if (permission == LocationPermission.denied) {
        Geolocator.requestPermission().then((LocationPermission permission) {
          if (permission == LocationPermission.denied) {
          } else {
            Geolocator
            //..forceAndroidLocationManager = !widget.androidFusedLocation
                .getCurrentPosition(
                desiredAccuracy: LocationAccuracy.medium,
                forceAndroidLocationManager: false)
                .then((Position position) {
              print(position);
              //     if (mounted) {
              //  setState(() {
              _currentPosition = position;
              loadAddress();
              //    });
              // _currentPosition = position;

              //    }
            }).catchError((Object e) {
              print(e);
            });
          }
        });
      } else {
        Geolocator
        //..forceAndroidLocationManager = !widget.androidFusedLocation
            .getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            forceAndroidLocationManager: !widget.androidFusedLocation)
            .then((Position position) {
          //    if (mounted) {
          setState(() {
            _currentPosition = position;
            loadAddress();
          });
          //    }
        }).catchError((Object e) {
          print(e);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _initCurrentLocation();
            // if (_currentPosition == null) {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //           message: Utils.getString(context, 'map_pin__open_gps'),
            //           onPressed: () {},
            //         );
            //       });
            // } else {
            //   loadAddress();
            // }
          },
          child: Container(
            child: InkWell(
              onTap: () {
                _initCurrentLocation();
                // if (_currentPosition == null) {
                //   showDialog<dynamic>(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return WarningDialog(
                //           message: Utils.getString(
                //               context, 'map_pin__open_gps'),
                //           onPressed: () {},
                //         );
                //       });
                // } else {
                //   loadAddress();
                // }
              },
              child: Row(
                children: <Widget>[
                  Container(
                    height: PsDimens.space28,
                    width: PsDimens.space40,
                    child: Icon(
                      Icons.gps_fixed,
                      color: PsColors.activeColor,
                      size: PsDimens.space20,
                    ),
                  ),
                  Text(
                    Utils.getString(context, 'Use Current Location'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: PsColors.activeColor),
                  )
                ],
              ),
            ),
          ),
        ),
        //  ),
        // ),
      ],
    );
  }
}