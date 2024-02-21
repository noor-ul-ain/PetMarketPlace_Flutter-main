import 'dart:async';
import 'dart:io';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/api/ps_api_service.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/db/gallery_dao.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/default_photo.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class GalleryRepository extends PsRepository {
  GalleryRepository(
      {required PsApiService psApiService, required GalleryDao galleryDao}) {
    _psApiService = psApiService;
    _galleryDao = galleryDao;
  }

  String primaryKey = 'id';
  String imgParentId = 'img_parent_id';
  late PsApiService _psApiService;
  late GalleryDao _galleryDao;

  Future<dynamic> insert(DefaultPhoto? image) async {
    return _galleryDao.insert(primaryKey, image!);
  }

  Future<dynamic> update(DefaultPhoto image) async {
    return _galleryDao.update(image);
  }

  Future<dynamic> delete(DefaultPhoto image) async {
    return _galleryDao.delete(image);
  }

  Future<dynamic> getAllImageList(
      StreamController<PsResource<List<DefaultPhoto?>>> galleryListStream,
      bool isConnectedToInternet,
      String? parentImgId,
      String imageType,
      int limit,
      int? offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    galleryListStream.sink.add(await _galleryDao.getAll(
        finder: Finder(filter: Filter.equals(imgParentId, parentImgId)),
        sortOrderList: <SortOrder>[SortOrder('ordering', true)],
        status: status));

    if (isConnectedToInternet) {
      final PsResource<List<DefaultPhoto>> _resource = await _psApiService
          .getImageList(parentImgId, imageType, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _galleryDao.deleteWithFinder(
            Finder(filter: Filter.equals(imgParentId, parentImgId)));
        await _galleryDao.insertAll(imgParentId, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _galleryDao.deleteWithFinder(
              Finder(filter: Filter.equals(imgParentId, parentImgId)));
        }
      }
      galleryListStream.sink.add(await _galleryDao.getAll(
          finder: Finder(filter: Filter.equals(imgParentId, parentImgId)),
          sortOrderList: <SortOrder>[SortOrder('ordering', true)]));
    }
  }

  Future<PsResource<DefaultPhoto>> postItemImageUpload(
      String itemId,
      String? imgId,
      String ordering,
      File imageFile,
      String loginUserId,
      bool isConnectedToInternet,
      PsStatus status, 
      {bool isLoadFromServer = true}) async {
    final PsResource<DefaultPhoto> _resource = await _psApiService
        .postItemImageUpload(itemId, imgId, ordering, imageFile, loginUserId);
    if (_resource.status == PsStatus.SUCCESS) {
      await _galleryDao
          .deleteWithFinder(Finder(filter: Filter.equals(imgParentId, imgId)));
      await insert(_resource.data);
      return _resource;
    } else {
      final Completer<PsResource<DefaultPhoto>> completer =
          Completer<PsResource<DefaultPhoto>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> postReorderImages(
      List<Map<dynamic, dynamic>> jsonMap,
      String loginUserId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postReorderImages(jsonMap, loginUserId);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

    Future<PsResource<DefaultPhoto>> postVideoUpload(String itemId, String videoId,
      File imageFile, String loginUserId, bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<DefaultPhoto> _resource =
        await _psApiService.postVideoUpload(itemId, videoId, imageFile, loginUserId);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<DefaultPhoto>> completer =
          Completer<PsResource<DefaultPhoto>>();
      completer.complete(_resource);
      return completer.future;
    }
  }


    Future<PsResource<DefaultPhoto>> postVideoThumbnailUpload(String itemId, String videoId,
      File imageFile, String loginUserId, bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<DefaultPhoto> _resource =
        await _psApiService.postVideoThumbnailUpload(itemId, videoId, imageFile, loginUserId);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<DefaultPhoto>> completer =
          Completer<PsResource<DefaultPhoto>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

    Future<PsResource<ApiStatus>> deleItemVideo(Map<dynamic, dynamic> jsonMap,
      String loginUserId, bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.deleItemVideo(jsonMap, loginUserId);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }


  Future<PsResource<ApiStatus>> deleItemImage(Map<dynamic, dynamic> jsonMap,
      String? loginUserId, bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.deleteItemImage(jsonMap, loginUserId);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> postApplyBlueMark(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postApplyBlueMark(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<DefaultPhoto>> postChatImageUpload(
      String senderId,
      String sellerUserId,
      String buyerUserId,
      String itemId,
      String type,
      File imageFile,
      String isUserOnline,
      {bool isLoadFromServer = true}) async {
    final PsResource<DefaultPhoto> _resource =
        await _psApiService.postChatImageUpload(
            senderId, sellerUserId, buyerUserId, itemId, type, imageFile, isUserOnline);
    if (_resource.status == PsStatus.SUCCESS) {
      await _galleryDao.deleteAll();
      await insert(_resource.data);
      return _resource;
    } else {
      final Completer<PsResource<DefaultPhoto>> completer =
          Completer<PsResource<DefaultPhoto>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
