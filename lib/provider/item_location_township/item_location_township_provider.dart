import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/item_location_township_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/location_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/item_location_township.dart';

class ItemLocationTownshipProvider extends PsProvider {
  ItemLocationTownshipProvider(
      {required ItemLocationTownshipRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Item Location Township Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    itemLocationTownshipListStream =
        StreamController<PsResource<List<ItemLocationTownship>>>.broadcast();
    subscription = itemLocationTownshipListStream.stream
        .listen((PsResource<List<ItemLocationTownship>> resource) {
      updateOffset(resource.data!.length);

      if (ItemLocationTownship()
          .isListEqual(_itemLocationTownshipList.data!, resource.data!)) {
        _itemLocationTownshipList.status = resource.status;
        _itemLocationTownshipList.message = resource.message;
      } else {
        _itemLocationTownshipList = resource;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  // String selectedTownshipId = '';
  // String selectedTownshipName = '';
  String itemLocationTownshipId = '';
  String itemLocationTownshipName = '';
  String itemLocationTownshipLat = '';
  String itemLocationTownshipLng = '';
  ItemLocationTownshipRepository? _repo;
  PsValueHolder? psValueHolder;
  LocationParameterHolder latestLocationParameterHolder =
      LocationParameterHolder().getDefaultParameterHolder();
  PsResource<List<ItemLocationTownship>> _itemLocationTownshipList =
      PsResource<List<ItemLocationTownship>>(
          PsStatus.NOACTION, '', <ItemLocationTownship>[]);

  PsResource<List<ItemLocationTownship>> get itemLocationTownshipList =>
      _itemLocationTownshipList;
  late StreamSubscription<PsResource<List<ItemLocationTownship>>> subscription;
  late StreamController<PsResource<List<ItemLocationTownship>>>
      itemLocationTownshipListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('ItemLocation Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemLocationTownshipListByCityId(
      Map<dynamic, dynamic> jsonMap, String? loginUserId, String cityId) async {
    isLoading = true;
    _itemLocationTownshipList = PsResource<List<ItemLocationTownship>>(
        PsStatus.NOACTION, '', <ItemLocationTownship>[]);
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await _repo!.getAllItemLocationTownshipList(
        itemLocationTownshipListStream,
        isConnectedToInternet,
        jsonMap,
        loginUserId,
        limit,
        offset,
        cityId,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemLocationTownshipListByCityId(
    Map<dynamic, dynamic> jsonMap,
    String? loginUserId,
    String cityId,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPageItemLocationTownshipList(
          itemLocationTownshipListStream,
          isConnectedToInternet,
          jsonMap,
          loginUserId,
          limit,
          offset,
          cityId,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemLocationTownshipListByCityId(
    Map<dynamic, dynamic> jsonMap,
    String? loginUserId,
    String cityId,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getAllItemLocationTownshipList(
        itemLocationTownshipListStream,
        isConnectedToInternet,
        jsonMap,
        loginUserId,
        limit,
        offset,
        cityId,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  List<String> getLocationTownshipList() {
    final List<String> dataList = <String>[];

    if (itemLocationTownshipList.data != null) {
      for (ItemLocationTownship item
          in itemLocationTownshipList.data ?? <ItemLocationTownship>[]) {
        final String name = item.townshipName ?? '';
        if (name != '') {
          dataList.add(name);
        }
      }
    }
    
    return dataList;
  }

  //   String getTownshipIdWithName(String name) {
  //   if (itemLocationTownshipList.data == null) {
  //     return '';
  //   }

  //   String cityId = '';
  //   for (ItemLocationTownship item in itemLocationTownshipList.data ?? <ItemLocationTownship>[]) {
  //     if (name == item.townshipName) {
  //       cityId = item.id!;
  //     }
  //   }

  //   return cityId;
  // }
}
