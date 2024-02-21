import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/offer.dart';
import 'package:provider/provider.dart';

class OfferReceivedListItem extends StatelessWidget {
  const OfferReceivedListItem({
    Key? key,
    required this.offer,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final Offer offer;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController!,
        // ignore: unnecessary_null_comparison
        child: offer != null
            ? InkWell(
                onTap: onTap as void Function()?,
                child: Container(
                  margin: const EdgeInsets.only(bottom: PsDimens.space8),
                  child: Ink(
                    color: PsColors.baseColor,
                    child: Padding(
                      padding: const EdgeInsets.all(PsDimens.space16),
                      child: _ImageAndTextWidget(
                        offer: offer,
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation!.value), 0.0),
                  child: child));
        });
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({
    Key? key,
    required this.offer,
  }) : super(key: key);

  final Offer? offer;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space8,
    );

    if (offer?.item != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: PsDimens.space24),
            child: Container(
              width: PsDimens.space60,
              height: PsDimens.space60,
              child: PsNetworkCircleImageForUser(
                photoKey: '',
                imagePath: offer?.buyer?.userProfilePhoto,
                // width: PsDimens.space40,
                // height: PsDimens.space40,
                boxfit: BoxFit.cover,
                onTap: () {},
              ),
            ),
          ),
          const SizedBox(
            width: PsDimens.space14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          offer!.buyer!.userName == ''
                              ? Utils.getString(context, 'default__user_name')
                              : offer!.buyer!.userName ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!.copyWith(
                                color: PsColors.textColor2,
                                fontWeight: FontWeight.bold
                              ), //?.copyWith(color: Colors.grey),
                        ),
                        if (offer!.buyer!.isVerifyBlueMark == PsConst.ONE)
                          Container(
                            margin:
                                const EdgeInsets.only(left: PsDimens.space2),
                            child: Icon(
                              Icons.check_circle,
                              color: PsColors.bluemarkColor,
                              size: valueHolder.bluemarkSize,
                            ),
                          )
                      ],
                    ),
                    // if (offer!.buyerUnreadCount != null &&
                    //     offer!.buyerUnreadCount != '' &&
                    //     offer!.buyerUnreadCount == '0')
                    //   Container()
                    // else
                      Visibility(
                        maintainSize: true, 
                        maintainAnimation: true,
                        maintainState: true,
                        visible: !(offer!.sellerUnreadCount != null &&
                        offer!.sellerUnreadCount != '' &&
                        offer!.sellerUnreadCount == '0'),
                        child: Container(
                            width: 25,
                          padding: const EdgeInsets.all(PsDimens.space4),
                          decoration: BoxDecoration(
                            color: PsColors.activeColor,
                            borderRadius: BorderRadius.circular(PsDimens.space28),
                            border: Border.all(
                                color: Utils.isLightMode(context)
                                    ? Colors.grey[200]!
                                    : Colors.black87),
                          ),
                          child: Text(
                            offer!.sellerUnreadCount ?? '',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: PsColors.textColor4),
                          ),
                        ),
                      )
                  ],
                ),
              //  _spacingWidget,
                const Divider(
                  height: 2,
                ),
              //  _spacingWidget,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          offer!.item!.title!.length > 13 ? 
                          offer!.item!.title!.substring(0,13)  + '...': 
                          offer!.item!.title!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: PsColors.textColor2,
                            fontWeight: FontWeight.normal),
                        ),
                        Padding(
                      padding: const EdgeInsets.only(left: PsDimens.space6),
                      child: Text(
                        '${offer!.item!.conditionOfItem!.name}',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: PsColors.textColor3),
                      ),
                    ),
                      ],
                    ),
                    
                   // if (offer!.item!.isSoldOut == '1')
                      Visibility(
                        maintainSize: true, 
                        maintainAnimation: true,
                        maintainState: true,
                        visible: offer!.item!.isSoldOut == '1',
                        child: Container(
                          padding: const EdgeInsets.all(PsDimens.space4),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(PsDimens.space8),
                            border: Border.all(
                                color: Utils.isLightMode(context)
                                    ? Colors.grey[200]!
                                    : Colors.black87),
                          ),
                          child: Text(
                            // Utils.getString(
                            //     context, 'chat_history_list_item__sold'),
                            'Sold',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      )
                    // else
                    //   Container()
                  ],
                ),
               // _spacingWidget,
                Row(
                  children: <Widget>[
                    Text(
                      offer!.item != null &&
                              offer!.item!.price != '0' &&
                              offer!.item!.price != ''
                          ? '${offer!.item!.itemCurrency!.currencySymbol}  ${Utils.getPriceFormat(offer!.item!.price!, valueHolder.priceFormat!)}'
                          : Utils.getString(context, 'item_price_free'),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: PsColors.textColor1),
                    ),
                    const SizedBox(
                      width: PsDimens.space8,
                    ),
                    // Text(
                    //   '( ${offer!.item!.conditionOfItem!.name} )',
                    //   overflow: TextOverflow.ellipsis,
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .bodyText2!
                    //       .copyWith(color: Colors.blue),
                    // ),
                  ],
                ),
                _spacingWidget,
                Text(
                  offer!.addedDateStr!,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: PsColors.textColor3
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: PsDimens.space12,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(PsDimens.space4),
            child: Container(
              height: PsDimens.space84,
              width: PsDimens.space84,
              child: PsNetworkImage(
                // height: PsDimens.space60,
                // width: PsDimens.space60,
                imageAspectRation: PsConst.Aspect_Ratio_1x,
                photoKey: '',
                defaultPhoto: offer!.item!.defaultPhoto,
                boxfit: BoxFit.cover,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
