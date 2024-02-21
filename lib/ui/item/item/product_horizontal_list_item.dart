import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_hero.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:provider/provider.dart';

class ProductHorizontalListItem extends StatelessWidget {
  const ProductHorizontalListItem({
    Key? key,
    required this.product,
    required this.coreTagKey,
    this.onTap,
  }) : super(key: key);

  final Product product;
  final Function? onTap;
  final String coreTagKey;

  @override
  Widget build(BuildContext context) {
    // print('***Tag*** $coreTagKey${PsConst.HERO_TAG__IMAGE}');
    final PsValueHolder valueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    return InkWell(
      onTap: onTap as void Function()?,
      child: Card(
        elevation: 0.0,
        color: PsColors.transparent,
        child: Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space4, right: PsDimens.space4, 
              bottom: PsDimens.space12),
          decoration: BoxDecoration(
            color: PsColors.cardBackgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          width: PsDimens.space180,
          // child:
          //  ClipPath(
          // child: Container(
          //   // color: Colors.white,
          //   width: PsDimens.space180,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if(valueHolder.isShowOwnerInfo!)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: PsDimens.space4,
                        top: PsDimens.space4,
                        right: PsDimens.space12,
                        bottom: PsDimens.space4,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: PsDimens.space40,
                            height: PsDimens.space40,
                            child: PsNetworkCircleImageForUser(
                              photoKey: '',
                              imagePath: product.user!.userProfilePhoto,
                              // width: PsDimens.space40,
                              // height: PsDimens.space40,
                              boxfit: BoxFit.cover,
                              onTap: () {
                                Utils.psPrint(product.defaultPhoto!.imgParentId);
                                onTap!();
                              },
                            ),
                          ),
                          const SizedBox(width: PsDimens.space8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: PsDimens.space8, top: PsDimens.space8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                            product.user?.userName == ''
                                                ? Utils.getString(
                                                    context, 'default__user_name')
                                                : '${product.user?.userName}',
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ),
                                      if (product.user?.isVerifyBlueMark ==
                                          PsConst.ONE)
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: PsDimens.space2),
                                          child: Icon(
                                            Icons.check_circle,
                                            color: PsColors.bluemarkColor,
                                            size: valueHolder.bluemarkSize,
                                          ),
                                        )
                                    ],
                                  ),
                                  if (product.paidStatus ==
                                      PsConst.PAID_AD_PROGRESS)
                                    Text(
                                        Utils.getString(
                                            context, 'paid_ad__sponsor'),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: PsColors.primary500))
                                  else
                                    Text('${product.addedDateStr}',
                                        textAlign: TextAlign.start,
                                        style:
                                            Theme.of(context).textTheme.bodySmall)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                    else
                      Container(),
                    // Stack(
                    //   children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Container(
                             width: double.infinity, //PsDimens.space180,
                              height: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(PsDimens.space6),
                              child: PsNetworkImage(
                                photoKey: '$coreTagKey${PsConst.HERO_TAG__IMAGE}',
                                defaultPhoto: product.defaultPhoto,
                                boxfit: BoxFit.cover,
                                imageAspectRation: PsConst.Aspect_Ratio_2x,
                                onTap: () {
                                  Utils.psPrint(product.defaultPhoto!.imgParentId);
                                  onTap!();
                                },
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              child: product.isSoldOut == '1'
                                  ? Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: PsDimens.space12),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              Utils.getString(
                                                  context, 'dashboard__sold_out'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: PsColors.white)),
                                        ),
                                      ),
                                      height: 30,
                                      width: PsDimens.space180,
                                      decoration: BoxDecoration(
                                          color: PsColors.soldOutUIColor),
                                    )
                                  : Container()
                              //   )
                              // ],
                              ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: null, // Setting height to null allows the container to expand vertically based on its child widgets
                      child:Container(
                      //height: 60,
                      padding: const EdgeInsets.only(left: PsDimens.space8,right: PsDimens.space8,top: PsDimens.space8, bottom: PsDimens.space4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      product.title!,
                                      overflow: TextOverflow.ellipsis,
                                    //  style: Theme.of(context).textTheme.subtitle2,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 14, 
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (Utils.showUI(valueHolder.conditionOfItemId))
                                    Padding(
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space4,
                                        right: PsDimens.space8),
                                    child: Text(
                                        '${product.conditionOfItem!.name}',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          color: PsColors.textColor1
                                        ),
                                      //  style: Theme.of(context)
                                      //      .textTheme
                                      //      .caption?.copyWith(color: Utils.isLightMode(context) ? PsColors.primary500 : PsColors.primaryDarkAccent),
                                      ),
                                  ),
                                ],
                              ),
                              Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              PsHero(
                                tag: '$coreTagKey$PsConst.HERO_TAG__UNIT_PRICE',
                                flightShuttleBuilder: Utils.flightShuttleBuilder,
                                child: Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      product.discountRate == '0' || product.discountRate == '' ?
                                      product.price != '0' && product.price != ''
                                          ? '${product.itemCurrency!.currencySymbol}${Utils.getPriceFormat(product.price!, valueHolder.priceFormat!)}'
                                          : Utils.getString(context, 'item_price_free') :
                                      '${product.itemCurrency!.currencySymbol}${Utils.getPriceFormat(product.discountedPrice!, valueHolder.priceFormat!)}',
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                          color: PsColors.textColor1,
                                          fontSize: 16
                                      ),)
                                ),
                              ),
                              Visibility(
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: product.discountRate != '0',
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        '  ${product.itemCurrency!.currencySymbol}${Utils.getPriceFormat(product.price!, valueHolder.priceFormat!)}  ',
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                            color: Utils.isLightMode(context)? PsColors.textPrimaryLightColor: PsColors.primaryDarkGrey,
                                            decoration: TextDecoration.lineThrough,
                                            fontSize: 10),
                                      ),
                                      const SizedBox(
                                          width: PsDimens.space6
                                      ),
                                      Text(
                                        '-${product.discountRate}%',
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                            color: Utils.isLightMode(context)? PsColors.textPrimaryLightColor: PsColors.primaryDarkGrey,
                                            fontSize: 10),
                                      ),
                                    ],
                                  )
                              )
                            ],
                          ),
                          // Flexible(
                          //   child: Padding(
                          //       padding: const EdgeInsets.only(
                          //           left: PsDimens.space8,
                          //           right: PsDimens.space8),
                          //       child: Text('(${product.conditionOfItem!.name})',
                          //           textAlign: TextAlign.start,
                          //           overflow: TextOverflow.ellipsis,
                          //           style: Theme.of(context)
                          //               .textTheme
                          //               .bodyText2!
                          //               .copyWith(color: PsColors.primary500))),
                          // )
                        ],
                      ),
                      // Row(
                      //   children: <Widget>[
                      //      Expanded(
                      //         child: Row(
                      //           children: <Widget>[
                      //             Image.asset(
                      //               'assets/images/baseline_pin_black_24.png',
                      //               width: PsDimens.space10,
                      //               height: PsDimens.space10,
                      //               fit: BoxFit.contain,
                      //               color: PsColors.textColor2,
                      //             ),
                      //             Expanded(
                      //                 child: Padding(
                      //                     padding: const EdgeInsets.only(
                      //                         left: PsDimens.space8,
                      //                         right: PsDimens.space8),
                      //                     child: Text(
                      //                         valueHolder.isSubLocation == PsConst.ONE
                      //                             ? (product.itemLocationTownship!.townshipName != '' &&
                      //                                product.itemLocationTownship!.townshipName != null) ? // check optional township is empty
                      //                                '${product.itemLocationTownship!.townshipName}' : '${product.itemLocation!.name}'
                      //                             : '${product.itemLocation!.name}',
                      //                         overflow: TextOverflow.ellipsis,
                      //                         textAlign: TextAlign.start,
                      //                         style: Theme.of(context)
                      //                             .textTheme
                      //                             .bodySmall!.copyWith(
                      //                               color: PsColors.textColor3
                      //                             )))),
                      //             if (Utils.showUI(valueHolder.typeId))
                      //               Flexible(
                      //                 child: Padding(
                      //                 padding: const EdgeInsets.only(
                      //                     left: PsDimens.space8,),
                      //                 child: Text('${product.itemType!.name}',
                      //                     textAlign: TextAlign.start,
                      //                     overflow: TextOverflow.ellipsis,
                      //                     style:
                      //                         Theme.of(context).textTheme.bodySmall!.copyWith(
                      //                           color: PsColors.textColor2,
                      //                         ))),
                      //               )
                      //           ],
                      //         ),
                      //       ),
                      //   ],
                      // ),
                        ],
                      ),
                    ),
                    ),
                    
                    
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: PsDimens.space8,
                    //       right: PsDimens.space8,
                    //       bottom: PsDimens.space16),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Row(
                    //         children: <Widget>[
                    //           Container(
                    //             width: PsDimens.space8,
                    //             height: PsDimens.space8,
                    //             decoration: BoxDecoration(
                    //                 color: PsColors.itemTypeColor,
                    //                 borderRadius: const BorderRadius.all(
                    //                     Radius.circular(PsDimens.space4))),
                    //           ),
                    //           Padding(
                    //               padding: const EdgeInsets.only(
                    //                   left: PsDimens.space8,
                    //                   right: PsDimens.space4),
                    //               child: Text('${product.itemType!.name}',
                    //                   textAlign: TextAlign.start,
                    //                   style: Theme.of(context).textTheme.caption))
                    //         ],
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Image.asset(
                    //             'assets/images/baseline_favourite_grey_24.png',
                    //             width: PsDimens.space10,
                    //             height: PsDimens.space10,
                    //             fit: BoxFit.contain,
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.only(
                    //               left: PsDimens.space4,
                    //             ),
                    //             child: Text('${product.favouriteCount}',
                    //                 textAlign: TextAlign.start,
                    //                 style: Theme.of(context).textTheme.caption),
                    //           )
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          // ),
          // clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        ),
      ),
    );
  }
}
