import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/item_location_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/location_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/item_location.dart';

class ItemLocationProvider extends PsProvider {
  ItemLocationProvider(
      {required ItemLocationRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Item Location Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    itemLocationListStream =
        StreamController<PsResource<List<ItemLocation>>>.broadcast();
    subscription = itemLocationListStream.stream
        .listen((PsResource<List<ItemLocation>> resource) {
      updateOffset(resource.data!.length);

      if (ItemLocation().isListEqual(_itemLocationList.data!, resource.data!)) {
        _itemLocationList.status = resource.status;
        _itemLocationList.message = resource.message;
      } else {
        _itemLocationList = resource;
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

  String? itemLocationId = '';
  String? itemLocationName = 'ALL';
  String? itemLocationLat = '';
  String? itemLocationLng = '';
  String? itemLocationTownshipId = '';
  String? itemLocationTownshipName = '';
  String? itemLocationTownshipLat = '';
  String? itemLocationTownshipLng = '';

  String selectedCityId = '';
  String selectedCityName = '';
  String selectedTownshipId = '';
  String selectedTownshipName = '';

  ItemLocationRepository? _repo;
  PsValueHolder? psValueHolder;
  LocationParameterHolder latestLocationParameterHolder =
      LocationParameterHolder().getDefaultParameterHolder();
  PsResource<List<ItemLocation>> _itemLocationList =
      PsResource<List<ItemLocation>>(PsStatus.NOACTION, '', <ItemLocation>[]);

  PsResource<List<ItemLocation>> get itemLocationList => _itemLocationList;
  late StreamSubscription<PsResource<List<ItemLocation>>> subscription;
  late StreamController<PsResource<List<ItemLocation>>> itemLocationListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('ItemLocation Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemLocationList(
      Map<dynamic, dynamic> jsonMap, String? loginUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getAllItemLocationList(
        itemLocationListStream,
        isConnectedToInternet,
        jsonMap,
        loginUserId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemLocationList(
    Map<dynamic, dynamic> jsonMap,
    String? loginUserId,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPageItemLocationList(
          itemLocationListStream,
          isConnectedToInternet,
          jsonMap,
          loginUserId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemLocationList(
    Map<dynamic, dynamic> jsonMap,
    String? loginUserId,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getAllItemLocationList(
        itemLocationListStream,
        isConnectedToInternet,
        jsonMap,
        loginUserId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  String getCityIdWithName(String name) {
    if (itemLocationList.data == null) {
      return '';
    }

    String cityId = '';
    for (ItemLocation item in itemLocationList.data ?? <ItemLocation>[]) {
      if (name == item.name) {
        cityId = item.id;
      }
    }

   

    return cityId;
  }
}
