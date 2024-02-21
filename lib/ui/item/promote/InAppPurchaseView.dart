import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/provider/promotion/item_promotion_provider.dart';
import 'package:flutterbuyandsell/repository/item_paid_history_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/success_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/item_paid_history_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/item_paid_history.dart';
import 'package:flutterbuyandsell/viewobject/ps_app_info.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class InAppPurchaseView extends StatefulWidget {
  const InAppPurchaseView(this.itemId, this.appInfo);
  final String? itemId;
  final PSAppInfo? appInfo;
  @override
  _InAppPurchaseViewState createState() => _InAppPurchaseViewState();
}

class _InAppPurchaseViewState extends State<InAppPurchaseView> {
  /// Is the API available on the device
  bool available = true;

  /// The In App Purchase plugin
  final InAppPurchase _iap = InAppPurchase.instance;

  /// Products for sale
  List<ProductDetails> _products = <ProductDetails>[];

  /// Updates to purchases
  late StreamSubscription<List<PurchaseDetails>>? _subscription;

  final String _kConsumableId = 'consumable';

  ItemPaidHistoryRepository? repo1;
  PsValueHolder? psValueHolder;
  ItemPromotionProvider? itemPromotionProvider;
  TextEditingController startDateController = TextEditingController();
  String? amount;
  String status = '';

  String testId = 'android.test.purchased';
  String? prdIdforIOS;
  String? prdIdforAndroid;
  Map<String, String>? dayMap = <String, String>{};
  final bool _kAutoConsume = true;
  String? startDate;

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    PsProgressDialog.dismissDialog();
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (Platform.isAndroid) {
        if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
          final InAppPurchaseAndroidPlatformAddition androidAddition =
              _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          await androidAddition.consumePurchase(purchaseDetails);
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }

      if (purchaseDetails.status == PurchaseStatus.purchased) {
        //
        // Call PS Server
        //
        print('NEW PURCHASE');
        print(purchaseDetails.status);

        if (itemPromotionProvider!.selectedDate != null) {
          startDate = itemPromotionProvider!.selectedDate;
        }
        // final DateTime dateTime = DateTime.now();
        final int resultStartTimeStamp =
            Utils.getTimeStampDividedByOneThousand(itemPromotionProvider!.selectedDateTime!);

        if (await Utils.checkInternetConnectivity()) {
          final ItemPaidHistoryParameterHolder itemPaidHistoryParameterHolder =
              ItemPaidHistoryParameterHolder(
                  itemId: widget.itemId,
                  amount: amount,
                  howManyDay: dayMap![purchaseDetails.productID],
                  paymentMethod: PsConst.PAYMENT_IN_APP_PURCHASE_METHOD,
                  paymentMethodNounce: '',
                  startDate: startDate,
                  startTimeStamp: resultStartTimeStamp.toString(),
                  razorId: '',
                  purchasedId: purchaseDetails.purchaseID,
                  isPaystack: PsConst.ZERO);

          final PsResource<ItemPaidHistory> padiHistoryDataStatus =
              await itemPromotionProvider!
                  .postItemHistoryEntry(itemPaidHistoryParameterHolder.toMap());

          if (padiHistoryDataStatus.data != null) {
            // progressDialog.dismiss();
            PsProgressDialog.dismissDialog();
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext contet) {
                  return SuccessDialog(
                    message: Utils.getString(context, 'item_promote__success'),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  );
                });
          } else {
            PsProgressDialog.dismissDialog();
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message: padiHistoryDataStatus.message,
                  );
                });
          }
        } else {
          PsProgressDialog.dismissDialog();
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message:
                      Utils.getString(context, 'error_dialog__no_internet'),
                );
              });
        } //
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      }
    }
  }

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
      // await _removeUnfinishTransaction();
    }
  }

  Map<String, dynamic> getIdAndDayList(String? idAndDayString) {
    final List<String> idList = <String>[];
    final Map<String, String> dayMap = <String, String>{};
    final Set<String> ids = <String>{};

    if (idAndDayString != null && idAndDayString.contains('##')) {
      final List<String> idandDayList = idAndDayString.split('##');

      for (String idAndDay in idandDayList) {
        if (idAndDay.contains('@@')) {
          final List<String> idAndDaySplit = idAndDay.split('@@');
          idList.add(idAndDaySplit[0]);
          dayMap[idAndDaySplit[0]] = idAndDaySplit[1];
        }
      }

      for (int i = 0; i < idList.length; i++) {
        ids.add(idList[i]);
      }
    }

    return <String, dynamic>{'idSet': ids, 'dayMap': dayMap};
  }

  /// Get all products available for sale
  Future<void> _getProducts() async {
    ProductDetailsResponse response;
    Map<String, dynamic> idAndDayList;
    if (Platform.isAndroid) {
      idAndDayList =
          getIdAndDayList(widget.appInfo!.inAppPurchasedPrdIdAndroid);
    } else {
      idAndDayList = getIdAndDayList(widget.appInfo!.inAppPurchasedPrdIdIOS);
    }

    dayMap = idAndDayList['dayMap'];
    response = await _iap.queryProductDetails(idAndDayList['idSet']);
    setState(() {
      _products = response.productDetails;
       _products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
       
    });
  }

  // Future<void> _removeUnfinishTransaction() async {
  //   final SKPaymentQueueWrapper paymentWrapper = SKPaymentQueueWrapper();
  //   try {
  //     final List<SKPaymentTransactionWrapper> transactions =
  //         await paymentWrapper.transactions();
  //     for (SKPaymentTransactionWrapper transaction in transactions) {
  //       try {
  //         await paymentWrapper.finishTransaction(transaction);
  //       } catch (e) {
  //         print(e);
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  /// Purchase a product
  Future<void> _buyProduct(ProductDetails prod) async {
    final ProductDetails productDetails = prod;
    // ProductDetails(
    //     id: prod.id,
    //     price:
    //         prod.price.split(prod.currencyCode)[1].replaceAll(',', '').trim(),
    //     rawPrice: double.parse(
    //         prod.price.split(prod.currencyCode)[1].replaceAll(',', '').trim()),
    //     currencyCode: prod.currencyCode,
    //     title: prod.title,
    //     description: prod.description);

    ///
    /// Show Progress Dialog
    ///
    await PsProgressDialog.showDialog(context);

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
      final bool status = await _iap.buyConsumable(
          purchaseParam: purchaseParam, autoConsume: true);
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
    repo1 = Provider.of<ItemPaidHistoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
          ),
          iconTheme: Theme.of(context).iconTheme.copyWith(
            color: PsColors.backArrowColor
              // color: Utils.isLightMode(context)
              //     ? PsColors.primary500
              //     : PsColors.primaryDarkWhite
                  ),
          title: Text(
            Utils.getString(
                context, 'item_promote__purchase_promotion_packages'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold, 
              //  color: Utils.isLightMode(context)? PsColors.primary500 : PsColors.primaryDarkWhite
                ),
          )),
      body: PsWidgetWithMultiProvider(
        child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<ItemPromotionProvider?>(
              lazy: false,
              create: (BuildContext context) {
                itemPromotionProvider =
                    ItemPromotionProvider(itemPaidHistoryRepository: repo1);

                return itemPromotionProvider;
              },
            ),
          ],
          child: Container(
            color: PsColors.baseColor,
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: PsDimens.space12),
                  child: PsDropdownBaseWithControllerWidget(
                      title: Utils.getString(
                          context, 'item_promote__ads_start_date'),
                      textEditingController: startDateController,
                      isStar: true,
                      onTap: () async {
                        await DatePicker.showDateTimePicker(context,
                            minTime: DateTime.now(), onConfirm: (DateTime date) {
                          itemPromotionProvider!.selectedDateTime = date;
                        }, locale: LocaleType.en);

                        if (itemPromotionProvider!.selectedDateTime != null) {
                          itemPromotionProvider!.selectedDate =
                              DateFormat.yMMMMd('en_US').format(
                                      itemPromotionProvider!.selectedDateTime!) +
                                  ' ' +
                                  DateFormat.Hms('en_US').format(
                                      itemPromotionProvider!.selectedDateTime!);
                        }
                        setState(() {
                          startDateController.text =
                              itemPromotionProvider!.selectedDate!;
                        });
                      }),
                ),
                for (ProductDetails prod in _products) ...<Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: PsDimens.space145,
                    margin: const EdgeInsets.only(
                        left: PsDimens.space12,
                        right: PsDimens.space12,
                        bottom: PsDimens.space8),
                    decoration: BoxDecoration(
                      color: Utils.isLightMode(context)
                          ? Colors.white60
                          : Colors.black54,
                      borderRadius: BorderRadius.circular(PsDimens.space4),
                      border: Border.all(
                          color: Utils.isLightMode(context)
                              ? Colors.grey[200]!
                              : Colors.black87),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: PsDimens.space16, left: PsDimens.space16),
                          child: Text(
                            prod.title.split('(')[0],
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: PsDimens.space4,
                            left: PsDimens.space16,
                          ),
                          child: Text(
                            prod.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: PsDimens.space4,
                            left: PsDimens.space16,
                          ),
                          child: Text(
                            prod.price,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.all(PsDimens.space8),
                            child: MaterialButton(
                              color: PsColors.buttonColor,
                              height: 30,
                              shape: const BeveledRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(PsDimens.space2)),
                              ),
                              child: Text(
                                Utils.getString(
                                    context, 'item_promote__purchase_buy'),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: PsColors.baseColor),
                              ),
                              onPressed: () {
                                if (itemPromotionProvider!.selectedDate == null) {
                                  showDialog<dynamic>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return WarningDialog(
                                          message: Utils.getString(context,
                                              'item_promote__choose_start_date'),
                                          onPressed: () {},
                                        );
                                      });
                                } else {
                                  amount = prod.price;
                                  _buyProduct(prod);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ],
            )),
          ),
        ),
      ),
    );
  }
}
