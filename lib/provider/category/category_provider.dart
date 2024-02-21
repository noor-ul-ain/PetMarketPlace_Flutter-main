import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/category_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/category_parameter_holder.dart';

class CategoryProvider extends PsProvider {
  CategoryProvider(
      {required CategoryRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }

    _repo = repo;

    print('Category Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    categoryListStream =
        StreamController<PsResource<List<Category>>>.broadcast();
    subscription = categoryListStream!.stream
        .listen((PsResource<List<Category>> resource) {
      updateOffset(resource.data!.length);

      _categoryList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<PsResource<List<Category>>>? categoryListStream;
  CategoryParameterHolder categoryParameterHolder =
      CategoryParameterHolder().getLatestParameterHolder();

  CategoryRepository? _repo;
  PsValueHolder? psValueHolder;

  PsResource<List<Category>> _categoryList =
      PsResource<List<Category>>(PsStatus.NOACTION, '', <Category>[]);

  PsResource<List<Category>> get categoryList => _categoryList;
  late StreamSubscription<PsResource<List<Category>>> subscription;

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Category Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadCategoryList(
      Map<dynamic, dynamic> jsonMap, String? loginUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (isConnectedToInternet) {
      await _repo!.getCategoryList(categoryListStream, isConnectedToInternet,
          jsonMap, loginUserId, limit, offset, PsStatus.PROGRESS_LOADING);
    }
    return isConnectedToInternet;
  }

  Future<dynamic> nextCategoryList(
      Map<dynamic, dynamic> jsonMap, String? loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPageCategoryList(
          categoryListStream,
          isConnectedToInternet,
          jsonMap,
          loginUserId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetCategoryList(
      Map<dynamic, dynamic> jsonMap, String? loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);
    if (isConnectedToInternet) {
      await _repo!.getCategoryList(categoryListStream, isConnectedToInternet,
          jsonMap, loginUserId, limit, offset, PsStatus.PROGRESS_LOADING);
    }

    isLoading = false;
    // return isConnectedToInternet;
  }

  Future<dynamic> postTouchCount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.postTouchCount(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
