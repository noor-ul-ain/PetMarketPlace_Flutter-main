// import 'package:flutter/material.dart';
// import 'package:flutterbuyandsell/config/ps_colors.dart';
// import 'package:flutterbuyandsell/config/ps_config.dart';
// import 'package:flutterbuyandsell/constant/ps_constants.dart';
// import 'package:flutterbuyandsell/constant/ps_dimens.dart';
// import 'package:flutterbuyandsell/constant/route_paths.dart';
// import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
// import 'package:flutterbuyandsell/utils/utils.dart';
// import 'package:flutterbuyandsell/viewobject/chat_history.dart';
// import 'package:flutterbuyandsell/viewobject/holder/intent_holder/user_intent_holder.dart';

// class ChatBuyerListItem extends StatelessWidget {
//   const ChatBuyerListItem({
//     Key? key,
//     required this.chatHistory,
//     this.animationController,
//     this.animation,
//     this.onTap,
//   }) : super(key: key);

//   final ChatHistory chatHistory;
//   final Function? onTap;
//   final AnimationController? animationController;
//   final Animation<double>? animation;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//         animation: animationController!,
//         child: InkWell(
//           onTap: onTap as void Function()?,
//           child: Container(
//             margin: const EdgeInsets.only(bottom: PsDimens.space8),
//             child: Ink(
//               color: PsColors.backgroundColor,
//               child: Padding(
//                 padding: const EdgeInsets.all(PsDimens.space16),
//                 child: _ImageAndTextWidget(
//                   chatHistory: chatHistory,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         builder: (BuildContext context, Widget? child) {
//           return FadeTransition(
//               opacity: animation!,
//               child: Transform(
//                   transform: Matrix4.translationValues(
//                       0.0, 100 * (1.0 - animation!.value), 0.0),
//                   child: child));
//         });
//   }
// }

// class _ImageAndTextWidget extends StatelessWidget {
//   const _ImageAndTextWidget({
//     Key? key,
//     required this.chatHistory,
//   }) : super(key: key);

//   final ChatHistory chatHistory;

//   @override
//   Widget build(BuildContext context) {
//     const Widget _spacingWidget = SizedBox(
//       height: PsDimens.space8,
//     );

//     if (chatHistory.item != null) {
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Padding(

//              padding: const EdgeInsets.only(top: PsDimens.space24),
//             child: Container(
//               width: PsDimens.space60,
//               height: PsDimens.space60,
//               child: PsNetworkCircleImageForUser(
//                 photoKey: '',
//                 imagePath: chatHistory.buyer!.userProfilePhoto,
//                 // width: PsDimens.space40,
//                 // height: PsDimens.space40,
//                 boxfit: BoxFit.cover,
//                 onTap: () {
//                   Navigator.pushNamed(context, RoutePaths.userDetail,
//                       arguments: UserIntentHolder(
//                           userId: chatHistory.buyer!.userId,
//                           userName: chatHistory.buyer!.userName));
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: PsDimens.space14,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           chatHistory.buyer?.userName == ''
//                               ? Utils.getString(context, 'default__user_name')
//                               : chatHistory.buyer?.userName ?? '',
//                           overflow: TextOverflow.ellipsis,
//                           style: Theme.of(context)
//                               .textTheme
//                               .caption,
//                         ),

//                         if (chatHistory.buyer?.isVerifyBlueMark ==
//                             PsConst.ONE)
//                           Container(
//                             margin:
//                                 const EdgeInsets.only(left: PsDimens.space2),
//                             child: Icon(
//                               Icons.check_circle,
//                               color: PsColors.bluemarkColor,
//                               size: PsConfig.blueMarkSize,
//                             ),
//                           )
//                       ],
//                     ),
//                     // if (chatHistory.sellerUnreadCount != null &&
//                     //     chatHistory.sellerUnreadCount != '' &&
//                     //     chatHistory.sellerUnreadCount == '0')
//                     //   Container()
//                     // else
//                       Visibility(
//                         maintainSize: true,
//                         maintainAnimation: true,
//                         maintainState: true,
//                         visible: !(chatHistory.sellerUnreadCount != null &&
//                         chatHistory.sellerUnreadCount != '' &&
//                         chatHistory.sellerUnreadCount == '0'),
//                         child: Container(
//                           width: 25,
//                           padding: const EdgeInsets.all(PsDimens.space4),
//                           decoration: BoxDecoration(
//                             color: PsColors.primary500,
//                             borderRadius: BorderRadius.circular(PsDimens.space28),
//                             border: Border.all(
//                                 color: Utils.isLightMode(context)
//                                     ? Colors.grey[200]!
//                                     : Colors.black87),
//                           ),
//                           child: Text(
//                             chatHistory.sellerUnreadCount!,
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .caption!
//                                 .copyWith(color: Colors.white),
//                           ),
//                         ),
//                       )
//                   ],
//                 ),
//                 const Divider(
//                   height: 2,
//                 ),
//               // _spacingWidget,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           chatHistory.item!.title!.length > 14 ? chatHistory.item!.title!.substring(0,14)  + '...':
//                           chatHistory.item!.title!,
//                           maxLines: 1,
//                           style: Theme.of(context).textTheme.bodyText2?.copyWith(color: PsColors.secondary500),
//                         ),
//                         Padding(
//                       padding: const EdgeInsets.only(left: PsDimens.space6),
//                       child: Text(
//                         '${chatHistory.item!.conditionOfItem!.name}',
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context)
//                             .textTheme
//                             .caption!
//                             .copyWith(color: PsColors.secondary300),
//                       ),
//                     ),
//                       ],
//                     ),

//                    // if (chatHistory.item!.isSoldOut == '1')
//                       Visibility(
//                         maintainSize: true,
//                         maintainAnimation: true,
//                         maintainState: true,
//                         visible: chatHistory.item!.isSoldOut == '1',
//                         child: Container(
//                           padding: const EdgeInsets.all(PsDimens.space4),
//                           decoration: BoxDecoration(
//                             color: Colors.grey,
//                             borderRadius: BorderRadius.circular(PsDimens.space8),
//                             border: Border.all(
//                                 color: Utils.isLightMode(context)
//                                     ? Colors.grey[200]!
//                                     : Colors.black87),
//                           ),
//                           child: Text(
//                             Utils.getString(
//                                 context, 'chat_history_list_item__sold'),
//                             // 'Sold',
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .caption!
//                                 .copyWith(color: Colors.white),
//                           ),
//                         ),
//                       )
//                   ],
//                 ),
//               //  _spacingWidget,
//                 Row(
//                   children: <Widget>[
//                     Text(
//                       chatHistory.item != null &&
//                               chatHistory.item!.price != '0' &&
//                               chatHistory.item!.price != ''
//                           ? '${chatHistory.item!.itemCurrency!.currencySymbol}  ${Utils.getPriceFormat(chatHistory.item!.price!)}'
//                           : Utils.getString(context, 'item_price_free'),
//                       overflow: TextOverflow.ellipsis,
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyText2!
//                           .copyWith(color: PsColors.primary500),
//                     ),
//                     const SizedBox(
//                       width: PsDimens.space8,
//                     ),
//                   ],
//                 ),
//                 _spacingWidget,
//                 Text(
//                   chatHistory.addedDateStr!,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.caption,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             width: PsDimens.space12,
//           ),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(PsDimens.space4),
//             child: Container(
//               height: PsDimens.space84,
//               width: PsDimens.space84,
//               child: PsNetworkImage(
//                 // height: PsDimens.space60,
//                 // width: PsDimens.space60,
//                 photoKey: '',
//                 imageAspectRation: PsConst.Aspect_Ratio_1x,
//                 defaultPhoto: chatHistory.item!.defaultPhoto,
//                 boxfit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Container();
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/chat_history.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:provider/provider.dart';

class ChatBuyerListItem extends StatelessWidget {
  const ChatBuyerListItem({
    Key? key,
    required this.chatHistory,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final ChatHistory chatHistory;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            margin: const EdgeInsets.only(bottom: PsDimens.space8),
            child: Ink(
              color: PsColors.baseColor,
              child: Padding(
                padding: const EdgeInsets.all(PsDimens.space16),
                child: _ImageAndTextWidget(
                  chatHistory: chatHistory,
                ),
              ),
            ),
          ),
        ),
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
    required this.chatHistory,
  }) : super(key: key);

  final ChatHistory chatHistory;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context);
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space8,
    );

    if (chatHistory.item != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: PsDimens.space18),
            child: Container(
              width: PsDimens.space60,
              height: PsDimens.space60,
              child: PsNetworkCircleImageForUser(
                photoKey: '',
                imagePath: chatHistory.buyer!.userProfilePhoto,
                // width: PsDimens.space40,
                // height: PsDimens.space40,
                boxfit: BoxFit.cover,
                onTap: () {
                  Navigator.pushNamed(context, RoutePaths.userDetail,
                      arguments: UserIntentHolder(
                          userId: chatHistory.buyer!.userId,
                          userName: chatHistory.buyer!.userName));
                },
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
                          chatHistory.buyer?.userName == ''
                              ? Utils.getString(context, 'default__user_name')
                              : chatHistory.buyer?.userName ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: PsColors.textColor2,
                              fontWeight: FontWeight
                                  .bold), //?.copyWith(color: Colors.grey),
                        ),
                        if (chatHistory.buyer?.isVerifyBlueMark == PsConst.ONE)
                          Container(
                            margin:
                                const EdgeInsets.only(left: PsDimens.space2),
                            child: Icon(
                              Icons.check_circle,
                              color: PsColors.bluemarkColor,
                              size: psValueHolder.bluemarkSize,
                            ),
                          )
                      ],
                    ),
                    // if (chatHistory.sellerUnreadCount != null &&
                    //     chatHistory.sellerUnreadCount != '' &&
                    //     chatHistory.sellerUnreadCount == '0')
                    //   Container()
                    // else
                    Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: !(chatHistory.sellerUnreadCount != null &&
                          chatHistory.sellerUnreadCount != '' &&
                          chatHistory.sellerUnreadCount == '0'),
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: PsDimens.space1, right: PsDimens.space1),
                        width: 20,
                        height: 20,
                        //  padding: const EdgeInsets.all(PsDimens.space4),
                        decoration: BoxDecoration(
                          color: PsColors.activeColor, //PsColors.primary500,
                          borderRadius: BorderRadius.circular(PsDimens.space28),
                          // border: Border.all(
                          //     color: Utils.isLightMode(context)
                          //         ? Colors.grey[200]!
                          //         : Colors.black87),
                        ),
                        child: Center(
                          child: Text(chatHistory.sellerUnreadCount!,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: PsColors.textColor4,
                                      fontSize: 10)),
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
                          chatHistory.item!.title!.length > 10
                              ? chatHistory.item!.title!.substring(0, 10) +
                                  '...'
                              : chatHistory.item!.title!,
                          // overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: PsColors.textColor2,
                                  fontWeight: FontWeight.normal),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: PsDimens.space6),
                          child: Text(
                            '${chatHistory.item!.conditionOfItem!.name}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: PsColors
                                        .textColor3), //PsColors.secondary300),
                          ),
                        ),
                      ],
                    ),

                    //  if (chatHistory.item!.isSoldOut == '1')
                    Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: chatHistory.item!.isSoldOut == '1',
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
                          Utils.getString(
                              context, 'chat_history_list_item__sold'),
                          // 'Sold',
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
                      chatHistory.item != null &&
                              chatHistory.item!.price != '0' &&
                              chatHistory.item!.price != ''
                          ? '${chatHistory.item!.itemCurrency!.currencySymbol}  ${Utils.getPriceFormat(chatHistory.item!.price!, psValueHolder.priceFormat!)}'
                          : Utils.getString(context, 'item_price_free'),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: PsColors.textColor1), //PsColors.primary500),
                    ),
                    const SizedBox(
                      width: PsDimens.space8,
                    ),
                  ],
                ),
                _spacingWidget,
                Text(
                  chatHistory.addedDateStr!,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: PsColors.textColor3),
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
                photoKey: '',
                imageAspectRation: PsConst.Aspect_Ratio_1x,
                defaultPhoto: chatHistory.item!.defaultPhoto,
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
