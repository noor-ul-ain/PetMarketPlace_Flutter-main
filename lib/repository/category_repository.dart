import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/api/ps_api_service.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/db/cateogry_dao.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';

import 'Common/ps_repository.dart';

class CategoryRepository extends PsRepository {
  CategoryRepository(
      {required PsApiService psApiService, required CategoryDao categoryDao}) {
    _psApiService = psApiService;
    _categoryDao = categoryDao;
  }

  String primaryKey = 'cat_id';
  String mapKey = 'map_key';
  late PsApiService _psApiService;
  late CategoryDao _categoryDao;

  void sinkCategoryListStream(
      StreamController<PsResource<List<Category>>>? categoryListStream,
      PsResource<List<Category>> dataList) {
    if (categoryListStream != null) {
      categoryListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(Category category) async {
    return _categoryDao.insert(primaryKey, category);
  }

  Future<dynamic> update(Category category) async {
    return _categoryDao.update(category);
  }

  Future<dynamic> delete(Category category) async {
    return _categoryDao.delete(category);
  }

  Future<dynamic> getCategoryList(
      StreamController<PsResource<List<Category>>>? categoryListStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      String? loginUserId,
      int limit,
      int? offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkCategoryListStream(
        categoryListStream, await _categoryDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Category>> _resource = await _psApiService
          .getCategoryList(jsonMap, loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Delete and Insert Map Dao
        await _categoryDao.deleteAll();

        // Insert Category
        await _categoryDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          print('delete all');
          await _categoryDao.deleteAll();
        }
      }
      // Load updated Data from Db and Send to UI
      sinkCategoryListStream(categoryListStream, await _categoryDao.getAll());
    }
  }

  Future<dynamic> getNextPageCategoryList(
      StreamController<PsResource<List<Category>>>? categoryListStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      String? loginUserId,
      int limit,
      int? offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkCategoryListStream(
        categoryListStream, await _categoryDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Category>> _resource = await _psApiService
          .getCategoryList(jsonMap, loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _categoryDao.getAll();

        await _categoryDao.insertAll(primaryKey, _resource.data!);
      }
      sinkCategoryListStream(categoryListStream, await _categoryDao.getAll());
    }
  }

  Future<PsResource<ApiStatus>> postTouchCount(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postTouchCount(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
