import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/product/paid_ad_product_provider%20copy.dart';
import 'package:flutterbuyandsell/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/widgets/my_header_widget.dart';
import 'package:flutterbuyandsell/ui/item/item/product_horizontal_list_item.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomePaidAdProductHorizontalListWidget extends StatelessWidget {
  const HomePaidAdProductHorizontalListWidget({
    Key? key,
    required this.animationController,
    required this.animation,
    required this.psValueHolder,
  }) : super(key: key);

  final AnimationController? animationController;
  final Animation<double> animation;
  final PsValueHolder? psValueHolder;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<PaidAdProductProvider>(
        builder: (BuildContext context, PaidAdProductProvider paidAdItemProvider, Widget? child) {
          return AnimatedBuilder(
            animation: animationController!,
            child: (paidAdItemProvider.productList.data != null && paidAdItemProvider.productList.data!.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      MyHeaderWidget(
                        headerName: Utils.getString(context, 'home__drawer_menu_feature_item'),
                        headerDescription: '',
                        viewAllClicked: () {
                          Navigator.pushNamed(context, RoutePaths.paidAdProductList);
                        },
                      ),
                      Container(
                          height: PsDimens.space280,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: paidAdItemProvider.productList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (paidAdItemProvider.productList.status == PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: const Row(children: <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  final Product product = paidAdItemProvider.productList.data![index];
                                  return ProductHorizontalListItem(
                                    coreTagKey: paidAdItemProvider.hashCode.toString() + product.id!,
                                    product: paidAdItemProvider.productList.data![index],
                                    onTap: () {
                                      print(paidAdItemProvider.productList.data![index].defaultPhoto!.imgPath);
                                      final ProductDetailIntentHolder holder = ProductDetailIntentHolder(productId: paidAdItemProvider.productList.data![index].id, heroTagImage: paidAdItemProvider.hashCode.toString() + product.id! + PsConst.HERO_TAG__IMAGE, heroTagTitle: paidAdItemProvider.hashCode.toString() + product.id! + PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(context, RoutePaths.productDetail, arguments: holder);
                                    },
                                  );
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(transform: Matrix4.translationValues(0.0, 100 * (1.0 - animation.value), 0.0), child: child),
              );
            },
          );
        },
      ),
    );
  }
}
