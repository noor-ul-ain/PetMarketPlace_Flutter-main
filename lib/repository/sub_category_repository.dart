

import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/api/ps_api_service.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/db/sub_category_dao.dart';
import 'package:flutterbuyandsell/repository/Common/ps_repository.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/sub_category.dart';
import 'package:sembast/sembast.dart';

class SubCategoryRepository extends PsRepository {
  SubCategoryRepository(
      {required PsApiService psApiService,
      required SubCategoryDao subCategoryDao}) {
    _psApiService = psApiService;
    _subCategoryDao = subCategoryDao;
  }

  late PsApiService _psApiService;
  late SubCategoryDao _subCategoryDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(SubCategory subCategory) async {
    return _subCategoryDao.insert(_primaryKey, subCategory);
  }

  Future<dynamic> update(SubCategory subCategory) async {
    return _subCategoryDao.update(subCategory);
  }

  Future<dynamic> delete(SubCategory subCategory) async {
    return _subCategoryDao.delete(subCategory);
  }

  Future<dynamic> getSubCategoryListByCategoryId(
      StreamController<PsResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      Map<dynamic, dynamic> jsonMap,
      String? loginUserId,
      String? categoryId,
      int limit,
      int? offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(status: status, finder: finder));

    if (isConnectedToIntenet) {

    final PsResource<List<SubCategory>> _resource = await _psApiService
        .getSubCategoryList(jsonMap, loginUserId, limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      await _subCategoryDao.deleteWithFinder(finder);
     // await _subCategoryDao.deleteAll();
      await _subCategoryDao.insertAll(_primaryKey, _resource.data!);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _subCategoryDao.deleteWithFinder(finder);
      //  await _subCategoryDao.deleteAll();
      }
    }
    subCategoryListStream.sink.add(await _subCategoryDao.getAll(finder: finder));
    }
  }

  Future<dynamic> getAllSubCategoryListByCategoryId(
      StreamController<PsResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      PsStatus status,
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(status: status, finder: finder));

    final PsResource<List<SubCategory>> _resource =
        await _psApiService.getAllSubCategoryList(jsonMap,loginUserId);

    if (_resource.status == PsStatus.SUCCESS) {
      await _subCategoryDao.deleteWithFinder(finder);
      await _subCategoryDao.insertAll(_primaryKey, _resource.data!);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _subCategoryDao.deleteWithFinder(finder);
      }
    }
    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder));
  }

  Future<dynamic> getNextPageSubCategoryList(
      StreamController<PsResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      Map<dynamic, dynamic> jsonMap,
      String? loginUserId,
       String categoryId,
      int limit,
      int? offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));
    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(status: status,finder: finder));

    final PsResource<List<SubCategory>> _resource = await _psApiService
        .getSubCategoryList(jsonMap, loginUserId, limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _subCategoryDao
          .insertAll(_primaryKey, _resource.data!)
          .then((dynamic data) async {
        subCategoryListStream.sink
            .add(await _subCategoryDao.getAll());
      });
    } else {
      subCategoryListStream.sink
          .add(await _subCategoryDao.getAll(finder: finder));
    }
  }



  Future<PsResource<ApiStatus>> postSubCategorySubscribe(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postSubCategorySubscribe(jsonMap,);
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
