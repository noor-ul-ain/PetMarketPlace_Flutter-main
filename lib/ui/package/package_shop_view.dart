import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/provider/package_bought/package_bought_provider.dart';
import 'package:flutterbuyandsell/repository/package_bought_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/success_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/package/package_item.dart';
import 'package:flutterbuyandsell/ui/stripe_card/stripe_payment_screen.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/package_bought_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/package.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class PackageShopInAppPurchaseView extends StatefulWidget {
  const PackageShopInAppPurchaseView(
      {required this.androidKeyList, required this.iosKeyList});
  final String? androidKeyList;
  final String? iosKeyList;

  @override
  _PackageShopInAppPurchaseViewState createState() =>
      _PackageShopInAppPurchaseViewState();
}

class _PackageShopInAppPurchaseViewState
    extends State<PackageShopInAppPurchaseView> {
  /// Is the API available on the device
  bool available = true;

  /// The In App Purchase plugin
  final InAppPurchase _iap = InAppPurchase.instance;

  /// Products for sale
  List<ProductDetails> _products = <ProductDetails>[];

  /// Updates to purchases
  late StreamSubscription<List<PurchaseDetails>>? _subscription;

  final String _kConsumableId = 'consumable';
  final bool _kAutoConsume = true;
  String? amount;

  PackageBoughtRepository? repo1;
  PsValueHolder? psValueHolder;
  PackageBoughtProvider? packageBoughtProvider;

  /// Initialize data
  Future<void> _initialize() async {
    // Check availability of In App Purchases
    available = await _iap.isAvailable();

    if (available) {
      await _getProducts();

      // Listen to new purchases
      _subscription = _iap.purchaseStream.listen(
          (List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        print('Done Purhcase');
        _subscription?.cancel();
      }, onError: (dynamic error) {
        print(error);
        print('Error Purchase');
        PsProgressDialog.dismissDialog();
        // handle error here.
      });
    }
  }

  Set<String> idListByPlatfrom() {
    String keyListString = '';

    if (Platform.isAndroid && widget.androidKeyList != null) {
      keyListString = widget.androidKeyList!;
    } else if (Platform.isIOS && widget.iosKeyList != null) {
      keyListString = widget.iosKeyList!;
    }
    // ignore: prefer_final_locals
    List<String> keyList = keyListString.split('##');
    keyList.removeLast();
    return keyList.toSet();
  }

  /// Get all products available for sale
  Future<void> _getProducts() async {
    ProductDetailsResponse response;
    response = await _iap.queryProductDetails(idListByPlatfrom());
    setState(() {
      _products = response.productDetails;
      _products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
    });
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (Platform.isAndroid) {
        if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
          final InAppPurchaseAndroidPlatformAddition androidAddition =
              _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          await androidAddition.consumePurchase(purchaseDetails);
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await PsProgressDialog.showDialog(context);
        await _iap.completePurchase(purchaseDetails);
      }

      if (purchaseDetails.status == PurchaseStatus.purchased) {
        //
        // Call PS Server
        //
       
        final Package package = getPackageByIAPKey(purchaseDetails.productID)!;
        final PackgageBoughtParameterHolder packgageBoughtParameterHolder =
            PackgageBoughtParameterHolder(
                userId: psValueHolder!.loginUserId,
                packageId: package.packageId,
                paymentMethod: PsConst.PAYMENT_IN_APP_PURCHASE_METHOD,
                price: amount,
                paymentMethodNonce: purchaseDetails.purchaseID,
                razorId: '',
                isPaystack: PsConst.ZERO);
        final PsResource<ApiStatus> packageBoughtStatus =
            await packageBoughtProvider!
                .buyAdPackge(packgageBoughtParameterHolder.toMap());
        PsProgressDialog.dismissDialog();
        if (packageBoughtStatus.status == PsStatus.SUCCESS) {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext contet) {
                return SuccessDialog(
                  message: Utils.getString(
                      context, 'item_entry__buy_package_success'),
                  onPressed: () {
                    Navigator.pop(context, package.postCount);
                  },
                );
              });
        } else {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: packageBoughtStatus.message,
                );
              });
        }
      }
      PsProgressDialog.dismissDialog();
    }
  }

  /// Purchase a product
  // Future<void> _buyProduct(Package package) async {
  //   final String? paymentNonce = await Navigator.push(context,
  //       MaterialPageRoute(builder: (BuildContext context)=> const StripePaymentScreen()));
  //   if(paymentNonce!=null && paymentNonce.isNotEmpty){
  //     final PackgageBoughtParameterHolder packgageBoughtParameterHolder =
  //     PackgageBoughtParameterHolder(
  //         userId: psValueHolder!.loginUserId,
  //         packageId: package.packageId,
  //         paymentMethod: PsConst.PAYMENT_STRIPE_METHOD,
  //         price: amount!,
  //         paymentMethodNonce: paymentNonce,
  //         razorId: '',
  //         isPaystack: PsConst.ZERO);
  //     final PsResource<ApiStatus> packageBoughtStatus =
  //     await packageBoughtProvider!
  //         .buyAdPackge(packgageBoughtParameterHolder.toMap());
  //     PsProgressDialog.dismissDialog();
  //     if (packageBoughtStatus.status == PsStatus.SUCCESS) {
  //       showDialog<dynamic>(
  //           context: context,
  //           builder: (BuildContext contet) {
  //             return SuccessDialog(
  //               message: Utils.getString(
  //                   context, 'item_entry__buy_package_success'),
  //               onPressed: () {
  //                 Navigator.pop(context, package.postCount);
  //               },
  //             );
  //           });
  //     } else {
  //       showDialog<dynamic>(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return ErrorDialog(
  //               message: packageBoughtStatus.message,
  //             );
  //           });
  //     }
  //   }
  //
  // }

  Future<void> _buyProduct(ProductDetails prod) async {
    final ProductDetails productDetails = prod;

    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);

    if (Platform.isIOS) {
      // try {
      //    final transactions = await SKPaymentQueueWrapper().transactions();
      //   transactions.forEach((skPaymentTransactionWrapper) {
      //       SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
      //   });
      //   final bool status = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      //   print(status);
      // }catch(e) {
      //   print(status);
      // }
      // await _removeUnfinishTransaction();
    }

    try {
      // if (productDetails.id == _kConsumableId) {
      final bool status =
          await _iap.buyConsumable(purchaseParam: purchaseParam);
      print("IAP STATUS");
      print(status);
      // }
    } catch (e) {
      print('error');
      PsProgressDialog.dismissDialog();
      if (Platform.isIOS) {
        // try {
        //   await _iap.buyNonConsumable(purchaseParam: purchaseParam);
        //   // await _removeUnfinishTransaction();
        //   try {
        //     final bool status =
        //         await _iap.buyConsumable(purchaseParam: purchaseParam);
        //     print(status);
        //   } catch (e) {
        //     print('error 2');
        //     print(e);
        //   }
        // }catch(e) {
        //   print('error 3');
        //   PsProgressDialog.dismissDialog();

        // }
      }
    }
  }

  Package? getPackageByIAPKey(String key) {
    final int index = packageBoughtProvider!.packageList.data!
        .indexWhere((Package package) => package.iapId == key);
    if (index == -1) return null;
    final Package package =
        packageBoughtProvider!.packageList.data!.elementAt(index);
    return package;
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<PackageBoughtRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.backArrowColor),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
          ),
          // backgroundColor:
          //     Utils.isLightMode(context) ? PsColors.activeColor : Colors.black12,
          title: Text(
            Utils.getString(context, 'item_entry__package_shop'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  //  color: Utils.isLightMode(context)? PsColors.primary500 : PsColors.primaryDarkWhite
                ),
          )),
      body: PsWidgetWithMultiProvider(
        child: MultiProvider(
            providers: <SingleChildWidget>[
              ChangeNotifierProvider<PackageBoughtProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  packageBoughtProvider = PackageBoughtProvider(repo: repo1);
                  packageBoughtProvider!.getAllPackages();

                  return packageBoughtProvider;
                },
              ),
            ],
            child: Consumer<PackageBoughtProvider>(
              builder: (BuildContext context, PackageBoughtProvider provider,
                  Widget? child) {
                return newUi(context, provider);
                if (provider.packageList.data != null ||
                    provider.packageList.data!.isNotEmpty) {
                  return Container(
                    padding: const EdgeInsets.only(
                        top: PsDimens.space10, right: PsDimens.space8),
                    color: PsColors.baseColor,
                    child: Stack(
                      children: <Widget>[
                        CustomScrollView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: false,
                            slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 1.40,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    // final int count =
                                    //     provider.packageList.data!.length;
                                    // final Package? package =
                                    //     getPackageByIAPKey(_products[index].id);
                                    // if (package == null) {
                                    //   return const SizedBox();
                                    // }
                                    return PackageItem(
                                      isNewUi: false,
                                      package:
                                          provider.packageList.data![index],
                                      priceWithCurrency: provider
                                              .packageList
                                              .data![index]
                                              .currency!
                                              .currencySymbol! +
                                          provider
                                              .packageList.data![index].price!,
                                      onTap: () {
                                        amount = provider
                                            .packageList.data![index].price;
                                        // _buyProduct(provider.packageList.data![index]); ///TODO: STRIPE IMPLEMENTATION
                                      },
                                    );
                                  },
                                  childCount: provider.packageList.data!.length,
                                ),
                              ),
                            ]),
                        PSProgressIndicator(provider.packageList.status)
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            )),
      ),
    );
  }

  Widget newUi(BuildContext context, PackageBoughtProvider provider) {
    const Color redTextColor = Color(0xffaa232a);
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: const Color(0xff3f8f8f8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: Image.asset('assets/packages_icons/p1.png'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    child: Image.asset('assets/packages_icons/p2.png'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    child: Image.asset('assets/packages_icons/p3.png'),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'More Ads, More Impact:\nElevate Your Presence with Premium!',
                style: TextStyle(color: redTextColor, fontSize: 25),
                textAlign: TextAlign.center,
              ),

              // const SizedBox(height: 30,),
              // const Text('The first 3 days\nare on us! Try now',
              //   style: TextStyle(color: redTextColor,fontSize: 35 ,fontWeight: FontWeight.bold),textAlign: TextAlign.center,
              // ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Upgrade today for limitless advertising!\n'
                'Premium members enjoy the freedom\n'
                'to post multiple ads maximizing their\n'
                'reach and engagement effortlessly.',
                style: TextStyle(
                    color: redTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              if (provider.packageList.data != null ||
                  provider.packageList.data!.isNotEmpty)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  color: Colors.transparent,
                  child: Stack(
                    children: <Widget>[
                      CustomScrollView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: false,
                          slivers: <Widget>[
                            SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 0.9,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  final Package? package =
                                      getPackageByIAPKey(_products[index].id);
                                  if (package == null) {
                                    return const SizedBox();
                                  }

                                  return PackageItem(
                                    package: package,
                                    // priceWithCurrency: provider.packageList.data![index].currency!.currencySymbol! + provider.packageList.data![index].price!,
                                    priceWithCurrency: _products[index].price,
                                    onTap: () {
                                      // amount = provider.packageList.data![index].price;
                                      // _buyProduct(provider.packageList.data![index]); ///TODO: STRIPE IMPLEMENTATION
                                      amount = _products[index].price;
                                      _buyProduct(_products[index]);
                                    },
                                    isNewUi: true,
                                  );
                                },
                                // childCount: provider.packageList.data!.length>3?3:provider.packageList.data!.length,
                                childCount:
                                    _products.length > 3 ? 3 : _products.length,
                              ),
                            ),
                          ]),
                      PSProgressIndicator(provider.packageList.status)
                    ],
                  ),
                )
              else
                Container(),
            ],
          ),
        ),
      ),
    );
  }
}
