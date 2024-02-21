import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/product/nearest_product_provider.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/widgets/my_header_widget.dart';
import 'package:flutterbuyandsell/ui/item/item/product_horizontal_list_item.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NearestProductHorizontalListWidget extends StatefulWidget {
  const NearestProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController? animationController;
  final Animation<double> animation;
  final PsValueHolder? psValueHolder;

  @override
  _NearestProductHorizontalListWidgetState createState() =>
      _NearestProductHorizontalListWidgetState();
}

class _NearestProductHorizontalListWidgetState
    extends State<NearestProductHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  late PsValueHolder psValueHolder;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && psValueHolder.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);
    if (!isConnectedToInternet && psValueHolder.isShowAdmob!) {
      print('loading ads....');
      // checkConnection();
    }

    return SliverToBoxAdapter(
        // fdfdf
        child: Consumer<NearestProductProvider>(builder: (BuildContext context,
            NearestProductProvider productProvider, Widget? child) {
      return RefreshIndicator(
        child: AnimatedBuilder(
            animation: widget.animationController!,
            child: ((productProvider.productList.data != null &&
                          productProvider.productList.data!.isNotEmpty) &&
                      (productProvider.productNearestParameterHolder.lat != '' &&
                          productProvider.productNearestParameterHolder.lng !=
                              ''))
                ? Column(children: <Widget>[
                    MyHeaderWidget(
                      headerName:
                          Utils.getString(context, 'dashboard_nearest_product'),
                      headerDescription:
                          '',
                      viewAllClicked: () {
                       final ProductParameterHolder holder =
                          ProductParameterHolder().getNearestParameterHolder();
                          holder.mile = psValueHolder.mile;
                          holder.lat = productProvider.productNearestParameterHolder.lat;
                          holder.lng = productProvider.productNearestParameterHolder.lng;
                      Navigator.pushNamed(context, RoutePaths.nearestProductList,
                          arguments: ProductListIntentHolder(
                              appBarTitle: Utils.getString(
                                  context, 'dashboard_nearest_product'),
                              productParameterHolder: holder));
                      }
                    ),
                    Container(
                        height: PsDimens.space280,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productProvider.productList.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (productProvider.productList.status ==
                                  PsStatus.BLOCK_LOADING) {
                                return Shimmer.fromColors(
                                    baseColor: PsColors.grey,
                                    highlightColor: PsColors.white,
                                    child: const Row(children: <Widget>[
                                      PsFrameUIForLoading(),
                                    ]));
                              } else {
                                final Product product =
                                    productProvider.productList.data![index];
                                return ProductHorizontalListItem(
                                  coreTagKey:
                                      productProvider.hashCode.toString() +
                                          product.id!,
                                  product:
                                      productProvider.productList.data![index],
                                  onTap: () {
                                    print(productProvider.productList.data![index]
                                        .defaultPhoto!.imgPath);

                                    final ProductDetailIntentHolder holder =
                                        ProductDetailIntentHolder(
                                            productId: productProvider
                                                .productList.data![index].id,
                                            heroTagImage: productProvider.hashCode
                                                    .toString() +
                                                product.id! +
                                                PsConst.HERO_TAG__IMAGE,
                                            heroTagTitle: productProvider.hashCode
                                                    .toString() +
                                                product.id! +
                                                PsConst.HERO_TAG__TITLE);
                                    Navigator.pushNamed(
                                        context, RoutePaths.productDetail,
                                        arguments: holder);
                                  },
                                );
                              }
                            })),
                    const PsAdMobBannerWidget(
                      admobSize: AdSize.mediumRectangle,
                      // admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                    ),
                  ])
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            }),
         onRefresh: () {
          return productProvider.resetProductList(
              widget.psValueHolder!.loginUserId!,
              productProvider.productNearestParameterHolder,context);
        },
      );
    }));
  }
}
