import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/chat/seller_chat_history_list_provider.dart';
import 'package:flutterbuyandsell/repository/chat_history_repository.dart';
import 'package:flutterbuyandsell/ui/chat/item/chat_seller_list_item.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/chat_history_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:provider/provider.dart';

class ChatSellerListView extends StatefulWidget {
  const ChatSellerListView({
    Key? key,
    required this.animationController,
    @required this.provider
  }) : super(key: key);

  final AnimationController? animationController;
  final SellerChatHistoryListProvider? provider;
  @override
  _ChatSellerListViewState createState() => _ChatSellerListViewState(provider!);
}

class _ChatSellerListViewState extends State<ChatSellerListView>
    with SingleTickerProviderStateMixin {
  _ChatSellerListViewState(this.provider);

  final ScrollController _scrollController = ScrollController();
  late SellerChatHistoryListProvider _chatHistoryListProvider;
  SellerChatHistoryListProvider provider;

  late AnimationController animationController;
  Animation<double>? animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        holder!.getBuyerHistoryList().userId = psValueHolder.loginUserId;
        _chatHistoryListProvider.resetShowProgress(true);
        _chatHistoryListProvider.nextChatHistoryList(holder);
      }
    });
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  late ChatHistoryRepository chatHistoryRepository;
  late PsValueHolder psValueHolder;
  ChatHistoryParameterHolder? holder;
  dynamic data;

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);
    holder = ChatHistoryParameterHolder().getSellerHistoryList();
    holder!.getSellerHistoryList().userId = psValueHolder.loginUserId;

    if (provider.chatHistoryList.data != null &&
            provider.chatHistoryList.data!.isNotEmpty &&
            psValueHolder.loginUserId != null) {
          return Scaffold(
            backgroundColor: PsColors.baseColor,
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                      child: RefreshIndicator(
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.chatHistoryList.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final int count =
                              provider.chatHistoryList.data!.length;
                          widget.animationController!.forward();
                          return ChatSellerListItem(
                            animationController: widget.animationController,
                            animation:
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: widget.animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn),
                              ),
                            ),
                            chatHistory: provider.chatHistoryList.data![index],
                            onTap: () async {
                              print(provider
                                  .chatHistoryList.data![index].item!.id);
                              final dynamic returnData =
                                  await Navigator.pushNamed(
                                      context, RoutePaths.chatView,
                                      arguments: ChatHistoryIntentHolder(
                                          chatFlag: PsConst.CHAT_FROM_SELLER,
                                          itemId: provider.chatHistoryList
                                              .data![index].item!.id,
                                          buyerUserId: provider.chatHistoryList
                                              .data![index].buyerUserId,
                                          sellerUserId: provider.chatHistoryList
                                              .data![index].sellerUserId));
                              if (returnData == null) {
                                provider.loadChatHistoryListFromDB(holder!);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    onRefresh: () {
                      provider.resetShowProgress(true);
                      return provider.resetChatHistoryList(holder!);
                    },
                  )),
                ),
                if (provider.showProgress)
                  PSProgressIndicator(provider.chatHistoryList.status)
                else 
                  const PSProgressIndicator(PsStatus.NOACTION)
              ],
            ),
          );
        } else {
          widget.animationController!.forward();
          return Container();
        }


    // chatHistoryRepository = Provider.of<ChatHistoryRepository>(context);

    // return ChangeNotifierProvider<ChatHistoryListProvider>(
    //   lazy: false,
    //   create: (BuildContext context) {
    //     final ChatHistoryListProvider provider =
    //         ChatHistoryListProvider(repo: chatHistoryRepository);
    //     provider.loadChatHistoryList(holder!);
    //     return provider;
    //   },
    //   child: Consumer<ChatHistoryListProvider>(builder: (BuildContext context,
    //       ChatHistoryListProvider provider, Widget? child) {
    //     if (provider.chatHistoryList.data != null &&
    //         provider.chatHistoryList.data!.isNotEmpty &&
    //         psValueHolder.loginUserId != null) {
    //       return Scaffold(
    //         body: Column(
    //           mainAxisSize: MainAxisSize.max,
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Expanded(
    //               child: Container(
    //                   child: RefreshIndicator(
    //                 child: MediaQuery.removePadding(
    //                   removeTop: true,
    //                   context: context,
    //                   child: ListView.builder(
    //                     shrinkWrap: true,
    //                     itemCount: provider.chatHistoryList.data!.length,
    //                     itemBuilder: (BuildContext context, int index) {
    //                       final int count =
    //                           provider.chatHistoryList.data!.length;
    //                       widget.animationController!.forward();
    //                       return ChatSellerListItem(
    //                         animationController: widget.animationController,
    //                         animation:
    //                             Tween<double>(begin: 0.0, end: 1.0).animate(
    //                           CurvedAnimation(
    //                             parent: widget.animationController!,
    //                             curve: Interval((1 / count) * index, 1.0,
    //                                 curve: Curves.fastOutSlowIn),
    //                           ),
    //                         ),
    //                         chatHistory: provider.chatHistoryList.data![index],
    //                         onTap: () async {
    //                           print(provider
    //                               .chatHistoryList.data![index].item!.id);
    //                           final dynamic returnData =
    //                               await Navigator.pushNamed(
    //                                   context, RoutePaths.chatView,
    //                                   arguments: ChatHistoryIntentHolder(
    //                                       chatFlag: PsConst.CHAT_FROM_SELLER,
    //                                       itemId: provider.chatHistoryList
    //                                           .data![index].item!.id,
    //                                       buyerUserId: provider.chatHistoryList
    //                                           .data![index].buyerUserId,
    //                                       sellerUserId: provider.chatHistoryList
    //                                           .data![index].sellerUserId));
    //                           if (returnData == null) {
    //                             provider.resetChatHistoryList(holder!);
    //                           }
    //                         },
    //                       );
    //                     },
    //                   ),
    //                 ),
    //                 onRefresh: () {
    //                   return provider.resetChatHistoryList(holder!);
    //                 },
    //               )),
    //             ),
    //             PSProgressIndicator(provider.chatHistoryList.status)
    //           ],
    //         ),
    //       );
    //     } else {
    //       widget.animationController!.forward();
    //       return Container();
    //     }
    //   }),
    //   // )
    // );
  }
}
