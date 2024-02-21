

import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/sub_category_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/sub_category_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/sub_category.dart';

class SubCategoryProvider extends PsProvider {
  SubCategoryProvider(
      {required SubCategoryRepository? repo, this.psValueHolder, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('SubCategory Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    subCategoryListStream =
        StreamController<PsResource<List<SubCategory>>>.broadcast();
    subscription = subCategoryListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _subCategoryList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  late StreamController<PsResource<List<SubCategory>>> subCategoryListStream;
  SubCategoryRepository? _repo;
  PsValueHolder? psValueHolder;
   bool isChecked = false;
   String subcatId= '';
   String isSubscribe = '';

  PsResource<List<SubCategory>> _subCategoryList =
      PsResource<List<SubCategory>>(PsStatus.NOACTION, '', <SubCategory>[]);

  PsResource<List<SubCategory>> get subCategoryList => _subCategoryList;
  late StreamSubscription<PsResource<List<SubCategory>>> subscription;


    PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get apiStatus => _apiStatus;

  String categoryId = '';
  ProductParameterHolder subCategoryByCatIdParamenterHolder =
      ProductParameterHolder().getLatestParameterHolder();    
  SubCategoryParameterHolder subCategoryParameterHolder =
      SubCategoryParameterHolder().getLatestParameterHolder();

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('SubCategory Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadSubCategoryList(Map<dynamic, dynamic> jsonMap,
      String? loginUserId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getSubCategoryListByCategoryId(
        subCategoryListStream,
        isConnectedToInternet,
        jsonMap,
        loginUserId,
        categoryId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,);
  }

  Future<dynamic> loadAllSubCategoryList(Map<dynamic, dynamic> jsonMap,
      String? loginUserId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getAllSubCategoryListByCategoryId(subCategoryListStream,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING, jsonMap,loginUserId!, categoryId);
  }

  Future<dynamic> nextSubCategoryList(Map<dynamic, dynamic> jsonMap,
      String? loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageSubCategoryList(
          subCategoryListStream,
          isConnectedToInternet,
          jsonMap,
          loginUserId,
          categoryId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,);
    }
  }

  Future<void> resetSubCategoryList(Map<dynamic, dynamic> jsonMap,
      String? loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo!.getSubCategoryListByCategoryId(
        subCategoryListStream,
        isConnectedToInternet,
        jsonMap,
        loginUserId,
        categoryId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,);

    isLoading = false;
  }


    Future<dynamic> postSubCategorySubscribe(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.postSubCategorySubscribe(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
