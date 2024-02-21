import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/paid_ad_item.dart';
import 'package:provider/provider.dart';

class PaidAdItemHorizontalListItem extends StatelessWidget {
  const PaidAdItemHorizontalListItem({
    Key? key,
    required this.paidAdItem,
    this.onTap,
  }) : super(key: key);

  final PaidAdItem paidAdItem;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    const Widget _dividerWidget = Divider(
      height: 3,
      thickness: 2,
    );
    return InkWell(
      onTap: onTap as void Function()?,
      // child: Card(
      //   elevation: 0.3,
      //   child: ClipPath(
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: PsDimens.space4, vertical: PsDimens.space8),
        decoration: BoxDecoration(
          color: PsColors.cardBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        width: PsDimens.space180,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                            imagePath:
                                paidAdItem.item!.user!.userProfilePhoto,
                            // width: PsDimens.space40,
                            // height: PsDimens.space40,
                            boxfit: BoxFit.cover,
                            onTap: () {
                              Utils.psPrint(
                                  paidAdItem.item!.defaultPhoto!.imgParentId);
                              onTap!();
                            },
                          ),
                        ),
                        const SizedBox(width: PsDimens.space8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: PsDimens.space8,
                                top: PsDimens.space8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                          paidAdItem.item!.user!.userName == ''
                                              ? Utils.getString(context,
                                                  'default__user_name')
                                              : '${paidAdItem.item!.user!.userName}',
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                    ),
                                    if (paidAdItem.item!.user!.isVerifyBlueMark ==
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

                                // if (paidAdItem.paidStatus ==
                                //     PsConst.PAID_AD_PROGRESS)
                                //   Text(
                                //       Utils.getString(
                                //           context, 'paid_ad__sponsor'),
                                //       textAlign: TextAlign.start,
                                //       style: Theme.of(context)
                                //           .textTheme
                                //           .caption
                                //           .copyWith(color: Colors.blue))
                                // else
                                Text('${paidAdItem.addedDateStr}',
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
                          width: PsDimens.space180,
                          height: double.infinity,
                          child: PsNetworkImage(
                            photoKey: '',
                            defaultPhoto: paidAdItem.item!.defaultPhoto,
                            boxfit: BoxFit.cover,
                            imageAspectRation: PsConst.Aspect_Ratio_2x,
                            onTap: () {
                              Utils.psPrint(
                                  paidAdItem.item!.defaultPhoto!.imgParentId);
                              onTap!();
                            },
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            child: (paidAdItem.paidStatus ==
                                    PsConst.ADSPROGRESS)
                                ? Container(
                                    width: PsDimens.space180,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                PsDimens.space4),
                                            topRight: Radius.circular(
                                                PsDimens.space4)),
                                        color: Colors.lightGreen),
                                    padding:
                                        const EdgeInsets.all(PsDimens.space12),
                                    child: Text(
                                      Utils.getString(
                                          context, 'paid__ads_in_progress'),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                  )
                                : (paidAdItem.paidStatus == PsConst.ADSFINISHED)
                                    ? Container(
                                        width: PsDimens.space180,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    PsDimens.space4),
                                                topRight: Radius.circular(
                                                    PsDimens.space4)),
                                            color: Colors.black45),
                                        padding: const EdgeInsets.all(
                                            PsDimens.space12),
                                        child: Text(
                                          Utils.getString(context,
                                              'paid__ads_in_completed'),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.white),
                                        ),
                                      )
                                    : (paidAdItem.paidStatus ==
                                            PsConst.ADSNOTYETSTART)
                                        ? Container(
                                            width: PsDimens.space180,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        PsDimens.space4),
                                                    topRight: Radius.circular(
                                                        PsDimens.space4)),
                                                color: Colors.yellow),
                                            padding: const EdgeInsets.all(
                                                PsDimens.space12),
                                            child: Text(
                                              Utils.getString(context,
                                                  'paid__ads_is_not_yet_start'),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          )
                                        : Container()),
                      ],
                    ),
                  ),

                  Container(
                    height: 60,
                      padding: const EdgeInsets.only(top: PsDimens.space8, left: PsDimens.space8,
                      right: PsDimens.space8, bottom: PsDimens.space4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                paidAdItem.item!.title!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                maxLines: 1,
                              ),
                            ),
                            if (Utils.showUI(valueHolder.conditionOfItemId))
                              Padding(
                              padding: const EdgeInsets.only(
                                  left: PsDimens.space8, right: PsDimens.space8),
                              child: Text(
                                '${paidAdItem.item!.conditionOfItem!.name}',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                    color: PsColors.textColor1),
                              ),
                            ),
                          ],
                        ),
                        Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            paidAdItem.item != null && (paidAdItem.item!.discountRate == '' || paidAdItem.item!.discountRate == '0') ? 
                             // paidAdItem.item != null &&
                                      paidAdItem.item!.price != '0' &&
                                      paidAdItem.item!.price != ''
                                  ? '${paidAdItem.item!.itemCurrency!.currencySymbol}${Utils.getPriceFormat(paidAdItem.item!.price!, valueHolder.priceFormat!)}'
                                  : Utils.getString(context, 'item_price_free') :
                                  '${paidAdItem.item!.itemCurrency!.currencySymbol}${Utils.getPriceFormat(paidAdItem.item!.discountedPrice!, valueHolder.priceFormat!)}',
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: PsColors.textColor1, fontSize: 16)),
                          Visibility(
                            maintainAnimation: true,
                            maintainSize: true,
                            maintainState: true,
                                      visible: paidAdItem.item!.discountRate != '0',
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                                '  ${paidAdItem.item!.itemCurrency!.currencySymbol}${Utils.getPriceFormat(paidAdItem.item!.price!, valueHolder.priceFormat!)}  ',                                      
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
                                                '-${paidAdItem.item!.discountRate}%',                                      
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
                      // Padding(
                      //     padding: const EdgeInsets.only(
                      //         left: PsDimens.space8,
                      //         right: PsDimens.space8),
                      //     child: Text(
                      //         '(${paidAdItem.item!.conditionOfItem!.name})',
                      //         textAlign: TextAlign.start,
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .bodyText2!
                      //             .copyWith(color: Colors.blue)))
                    ],
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: <Widget>[
                  //     Expanded(
                  //       child: Row(
                  //         children: <Widget>[
                  //           Image.asset(
                  //             'assets/images/baseline_pin_black_24.png',
                  //             width: PsDimens.space10,
                  //             height: PsDimens.space10,
                  //             fit: BoxFit.contain,
                  //             color: PsColors.textColor2,
                  //             // ),
                  //           ),
                  //           Expanded(
                  //               child: Padding(
                  //                   padding: const EdgeInsets.only(
                  //                       left: PsDimens.space8,
                  //                       right: PsDimens.space8),
                  //                   child: Text(
                  //                       valueHolder.isSubLocation ==
                  //                               PsConst.ONE
                  //                           ? (paidAdItem.item!.itemLocationTownship!.townshipName != null &&
                  //                               paidAdItem.item!.itemLocationTownship!.townshipName != '') ?
                  //                           '${paidAdItem.item!.itemLocationTownship!.townshipName}' :
                  //                           '${paidAdItem.item!.itemLocation!.name}'
                  //                           : '${paidAdItem.item!.itemLocation!.name}',
                  //                       overflow: TextOverflow.ellipsis,
                  //                       textAlign: TextAlign.start,
                  //                       style: Theme.of(context)
                  //                           .textTheme
                  //                           .bodySmall!.copyWith(
                  //                                color: PsColors.textColor3
                  //                             )))),
                  //         ],
                  //       ),
                  //     ),
                  //     if (Utils.showUI(valueHolder.typeId))
                  //       Padding(
                  //         padding: const EdgeInsets.only(
                  //             left: PsDimens.space8),
                  //         child: Text('${paidAdItem.item!.itemType!.name}',
                  //             textAlign: TextAlign.start,
                  //             style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  //                         color: PsColors.textColor2,
                  //                       )))
                  //   ],
                  // ),
                      ],
                    ),
                  ),
                  
                  Container(
                      padding: const EdgeInsets.only(
                        left: PsDimens.space24,
                        right: PsDimens.space8,
                        top: PsDimens.space6,
                      ),
                      child: _dividerWidget),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space14,
                        right: PsDimens.space14,
                        top: PsDimens.space8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // Container(
                        //   width: PsDimens.space6,
                        //   height: PsDimens.space6,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10),
                        //     border: Border.all(
                        //       width: 3,
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // ),
                        Text(
                            Utils.getString(context, 'profile__start_date'),
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: PsColors.textColor2, 
                                    fontSize: 9)),
                        Flexible(
                          child: Text(
                              paidAdItem.startTimeStamp == ''
                                  ? ''
                                  : Utils
                                      .changeTimeStampToStandardDateTimeFormat(
                                          paidAdItem.startTimeStamp),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                                  Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: PsColors.textColor2,
                                          fontSize: 10)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space14,
                        right: PsDimens.space14,
                        top: PsDimens.space8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // Container(
                        //   width: PsDimens.space6,
                        //   height: PsDimens.space6,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10),
                        //     border: Border.all(
                        //       width: 3,
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // ),
                        Text(
                            Utils.getString(context, 'profile__end_date'),
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: PsColors.textColor2,
                                    fontSize: 9,
                                    )),
                        Flexible(
                          child: Text(
                              paidAdItem.endTimeStamp == ''
                                  ? ''
                                  : Utils
                                      .changeTimeStampToStandardDateTimeFormat(
                                          paidAdItem.endTimeStamp),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                                  Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: PsColors.textColor2,
                                          fontSize: 10)),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space14,
                        right: PsDimens.space8,
                        top: PsDimens.space8,
                        bottom: PsDimens.space16),
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    child: Row(
                      children: <Widget>[
                        // Container(
                        //   width: PsDimens.space6,
                        //   height: PsDimens.space6,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10),
                        //     border: Border.all(
                        //       width: 3,
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // ),
                        Text(
                            Utils.getString(context, 'profile__amount'),
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: PsColors.textColor2, 
                                    fontSize: 9)),
                        Flexible(
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: PsDimens.space8),
                              child: Text(
                                  '${paidAdItem.amount}',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: PsColors.textColor1))),
                        ),
                      ],
                      // ),
                      //],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      //     clipper: ShapeBorderClipper(
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(4))),
      //   ),
      // )
    );
  }
}
