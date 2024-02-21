import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';

class ItemEntryProvider extends PsProvider {
  ItemEntryProvider(
      {required ProductRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    isDispose = false;
    print('Item Entry Provider: $hashCode');

    itemListStream = StreamController<PsResource<Product>>.broadcast();
    subscription = itemListStream.stream.listen((PsResource<Product> resource) {
      if (resource.data != null) {
        _itemResource = resource;
        item = resource.data;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  ProductRepository? _repo;
  PsValueHolder? psValueHolder;
  PsResource<Product> _itemResource =
      PsResource<Product>(PsStatus.NOACTION, '', null);
  PsResource<Product> get itemResource => _itemResource;

  late StreamSubscription<PsResource<Product>> subscription;
  late StreamController<PsResource<Product>> itemListStream;

  Product? item;

  String? categoryId = '';
  String? subCategoryId = '';
  String? itemTypeId = '';
  String? itemConditionId = '';
  String? itemPriceTypeId = '';
  String? itemCurrencyId = '';
  String? itemDealOptionId = '';
  String? itemLocationId = '';
  String? itemLocationTownshipId = '';
  bool isCheckBoxSelect = true;
  String checkOrNotShop = '1';
  String? itemId = '';

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Item Entry Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postItemEntry(
    Map<dynamic, dynamic> jsonMap, String loginUserId,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _itemResource = await _repo!.postItemEntry(
        jsonMap, loginUserId, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _itemResource;
  }

  Future<dynamic> getItemFromDB(String? itemId) async {
    isLoading = true;

    await _repo!
        .getItemFromDB(itemId, itemListStream, PsStatus.PROGRESS_LOADING);
  }
}
