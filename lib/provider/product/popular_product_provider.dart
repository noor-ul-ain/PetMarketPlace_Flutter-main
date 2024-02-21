import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:geolocator/geolocator.dart';

class PopularProductProvider extends PsProvider {
  PopularProductProvider({required ProductRepository repo, int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }
    _repo = repo;
    print('PopularProductProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    initSubscription();
  }

  late ProductRepository _repo;
  PsResource<List<Product>> _productList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);
  PsResource<List<Product>> _tempProductList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);    
  final ProductParameterHolder productPopularParameterHolder =
      ProductParameterHolder().getPopularParameterHolder();
  PsResource<List<Product>> get productList => _productList;
  PsResource<List<Product>> get tempProductList => _tempProductList;
  // ignore: cancel_subscriptions
  StreamSubscription<PsResource<List<Product>>>? subscription;
  StreamController<PsResource<List<Product>>>? productListStream;

  dynamic daoSubscription;

  Future<void> initSubscription() async {
    if (productListStream != null) {
      await productListStream!.close();
    }
    if (subscription != null) {
      await subscription!.cancel();
    }

    productListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        productListStream!.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data!.length);
      print('**** PopularProductProvider ${resource.data!.length}');
      _productList =
          PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);
      _tempProductList = resource;

      for (int i = 0; i < _tempProductList.data!.length; i++) {
        if (_tempProductList.data![i].adType == PsConst.GOOGLE_AD_TYPE) {
          _productList.data!.add(Product(
              id: i.toString() + PsConst.ADMOB_FLAG,
              adType: _tempProductList.data![i].adType)); 
        } 
        else {
          _productList.data!.add(_tempProductList.data![i]);
        }
      }
      _productList.data = Product().checkDuplicate(_productList.data!);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    if (subscription != null) {
      subscription!.cancel();
    }
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Trending Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductList(String? loginUserId,
      ProductParameterHolder productParameterHolder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    Position position = await Geolocator.getCurrentPosition();
    productParameterHolder.lat= position.latitude.toString();
    productParameterHolder.lng= position.longitude.toString();
    // daoSubscription = await _repo.getProductList(
    //     productListStream,
    //     isConnectedToInternet,
    //     loginUserId,
    //     limit,
    //     offset,
    //     PsStatus.PROGRESS_LOADING,
    //     productParameterHolder);


    if (daoSubscription != null) {
      await daoSubscription.cancel();
    }
    await initSubscription();
    daoSubscription = await _repo.subscribeProductList(
        productListStream, PsStatus.PROGRESS_LOADING, productParameterHolder);

    await _repo.getProductList(
        productListStream,
        isConnectedToInternet,
        loginUserId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        productParameterHolder);
  }

  Future<dynamic> resetProductList(String? loginUserId,
      ProductParameterHolder productParameterHolder) async {
    isLoading = true;

    updateOffset(0);
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    // daoSubscription = await _repo.getProductList(
    //     productListStream,
    //     isConnectedToInternet,
    //     loginUserId,
    //     limit,
    //     offset,
    //     PsStatus.PROGRESS_LOADING,
    //     productParameterHolder);
    if (daoSubscription != null) {
      await daoSubscription.cancel();
    }
    await initSubscription();
    daoSubscription = await _repo.subscribeProductList(
        productListStream, PsStatus.PROGRESS_LOADING, productParameterHolder);

    await _repo.getProductList(
        productListStream,
        isConnectedToInternet,
        loginUserId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        productParameterHolder);

    isLoading = false;
  }

  Future<dynamic> nextProductList(
      String loginUserId, ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getProductList(
          productListStream,
          isConnectedToInternet,
          loginUserId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          productParameterHolder);
    }
  }
}
