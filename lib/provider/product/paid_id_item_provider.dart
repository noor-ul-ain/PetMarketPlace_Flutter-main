

import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/paid_ad_item_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/paid_ad_item.dart';

class PaidAdItemProvider extends PsProvider {
  PaidAdItemProvider(
      {required PaidAdItemRepository? repo, required this.psValueHolder, int limit = 0})
      : super(repo,limit) {
    _repo = repo;

    print('Paid Ad  Item Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    paidAdItemListStream =
        StreamController<PsResource<List<PaidAdItem>>>.broadcast();
    subscription = paidAdItemListStream.stream
        .listen((PsResource<List<PaidAdItem>> resource) {
      updateOffset(resource.data!.length);

      _paidAdItemList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  late StreamController<PsResource<List<PaidAdItem>>> paidAdItemListStream;

  PaidAdItemRepository? _repo;
  PsValueHolder? psValueHolder;

  PsResource<List<PaidAdItem>> _paidAdItemList =
      PsResource<List<PaidAdItem>>(PsStatus.NOACTION, '', <PaidAdItem>[]);

  PsResource<List<PaidAdItem>> get paidAdItemList => _paidAdItemList;
  late StreamSubscription<PsResource<List<PaidAdItem>>> subscription;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Paid Ad Item Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadPaidAdItemList(String? loginUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getPaidAdItemList(paidAdItemListStream, loginUserId,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextPaidAdItemList(String? loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPagePaidAdItemList(paidAdItemListStream, loginUserId,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetPaidAdItemList(String? loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getPaidAdItemList(paidAdItemListStream, loginUserId,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
