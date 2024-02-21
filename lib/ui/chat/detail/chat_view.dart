import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/chat/chat_history_list_provider.dart';
import 'package:flutterbuyandsell/provider/chat/get_chat_history_provider.dart';
import 'package:flutterbuyandsell/provider/chat/user_unread_message_provider.dart';
import 'package:flutterbuyandsell/provider/common/notification_provider.dart';
import 'package:flutterbuyandsell/provider/gallery/gallery_provider.dart';
import 'package:flutterbuyandsell/provider/product/product_provider.dart';
import 'package:flutterbuyandsell/repository/Common/notification_repository.dart';
import 'package:flutterbuyandsell/repository/chat_history_repository.dart';
import 'package:flutterbuyandsell/repository/gallery_repository.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/repository/user_unread_message_repository.dart';
import 'package:flutterbuyandsell/ui/chat/dialog/chat_make_offer_dialog.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutterbuyandsell/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_textfield_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/rating/entry/rating_input_dialog.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/chat.dart';
import 'package:flutterbuyandsell/viewobject/chat_history.dart';
import 'package:flutterbuyandsell/viewobject/chat_user_presence.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/default_photo.dart';
import 'package:flutterbuyandsell/viewobject/holder/get_chat_history_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/make_is_user_bought_parameter_holde.dart';
import 'package:flutterbuyandsell/viewobject/holder/make_mark_as_sold_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/make_offer_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/reset_unread_message_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/sync_chat_history_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/message.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    Key? key,
    required this.itemId,
    required this.chatFlag,
    required this.buyerUserId,
    required this.sellerUserId,
    // @required this.isOffer,
  }) : super(key: key);

  final String? itemId;
  final String chatFlag;
  final String? buyerUserId;
  final String? sellerUserId;
  // final String isOffer;
  @override
  _ChatViewState createState() => _ChatViewState();
}

enum ChatUserStatus { active, in_active, offline }

class _ChatViewState extends State<ChatView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController? animationController;
  late DatabaseReference _messagesRef;
  late DatabaseReference _chatRef;
  late DatabaseReference _userPresence;
  // StreamSubscription<Event> _counterSubscription;
  // StreamSubscription<Event> _messagesSubscription;
  final bool _anchorToBottom = true;
   FirebaseApp? firebaseApp;
  late PsValueHolder psValueHolder;
  String? sessionId;
  late ChatHistoryRepository chatHistoryRepository;
  NotificationRepository? notiRepo;
  UserUnreadMessageRepository? userUnreadMessageRepository;
  late GalleryRepository galleryRepo;
  ProductRepository? productRepo;
  late GetChatHistoryProvider getChatHistoryProvider;
  UserUnreadMessageProvider? userUnreadMessageProvider;
  late ChatHistoryListProvider chatHistoryListProvider;
  ItemDetailProvider? itemDetailProvider;
  GalleryProvider? galleryProvider;
  NotificationProvider? notiProvider;
  SyncChatHistoryParameterHolder? holder;
  late GetChatHistoryParameterHolder getChatHistoryParameterHolder;
  PsResource<ChatHistory>? chatHistory;
  String? lastTimeStamp;
  int? lastAddedDateTimeStamp;
  String status = '';
  String? itemId;
  String? receiverId;
  String? senderId;
  String? otherUserId;

  ChatUserStatus? isActive;
  // bool isInActive = false;

  TextEditingController messageController = TextEditingController();

  // Future<FirebaseApp> configureDatabase() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   final FirebaseApp app = await Firebase.initializeApp(
  //     // name: 'flutter-buy-and-sell',
  //     options: Platform.isIOS
  //         ? const FirebaseOptions(
  //             appId: PsConfig.iosGoogleAppId,
  //             messagingSenderId: PsConfig.iosGcmSenderId,
  //             databaseURL: PsConfig.iosDatabaseUrl,
  //             projectId: PsConfig.iosProjectId,
  //             apiKey: PsConfig.iosApiKey)
  //         : const FirebaseOptions(
  //             appId: PsConfig.androidGoogleAppId,
  //             apiKey: PsConfig.androidApiKey,
  //             projectId: PsConfig.androidProjectId,
  //             messagingSenderId: PsConfig.androidGcmSenderId,
  //             databaseURL: PsConfig.androidDatabaseUrl,
  //           ),
  //   );

  //   return app;
  // }

  @override
  void initState() {
    super.initState();
      Firebase.initializeApp();
    // configureDatabase().then((FirebaseApp app) {
    //   firebaseApp = app;
    // });
    // Demonstrates configuring the database directly
    final FirebaseDatabase database = FirebaseDatabase.instance;
    _messagesRef = database.ref().child('Message');
    _chatRef = database.ref().child('Current_Chat_With');
    _userPresence = database.ref().child('User_Presence');

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
    } else if (state == AppLifecycleState.inactive) {
      _chatRef.child(psValueHolder.loginUserId!).remove();
      // app is inactive
    } else if (state == AppLifecycleState.paused) {
      _chatRef.child(psValueHolder.loginUserId!).remove();

      // user is about quit our app temporally
    } else if (state == AppLifecycleState.detached) {
      // app suspended (not used in iOS)
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (mounted) {
      _chatRef.child(psValueHolder.loginUserId!).remove();
      _userPresence.child(psValueHolder.loginUserId!).remove();
    }

    WidgetsBinding.instance.removeObserver(this);
    Utils.isReachChatView = false;
  }

  Future<bool> resetUnreadMessageCount(
      ChatHistoryListProvider chatHistoryListProvider,
      PsValueHolder? valueHolder,
      UserUnreadMessageProvider? userUnreadMessageProvider) async {
    final ResetUnreadMessageParameterHolder resetUnreadMessageParameterHolder =
        ResetUnreadMessageParameterHolder(
            itemId: widget.itemId,
            buyerUserId: widget.buyerUserId,
            sellerUserId: widget.sellerUserId,
            type: widget.chatFlag == PsConst.CHAT_FROM_BUYER
                ? PsConst.CHAT_TO_SELLER
                : PsConst.CHAT_TO_BUYER);

    final dynamic _returnData = await chatHistoryListProvider
        .resetUnreadMessageCount(resetUnreadMessageParameterHolder.toMap());

    if (_returnData == null) {
      //!= null && _returnData.status == PsStatus.SUCCESS) {
      if (valueHolder!.loginUserId != null && valueHolder.loginUserId != '') {
        final UserUnreadMessageParameterHolder userUnreadMessageHolder =
            UserUnreadMessageParameterHolder(
                userId: valueHolder.loginUserId,
                deviceToken: valueHolder.deviceToken);
        userUnreadMessageProvider!
            .userUnreadMessageCount(userUnreadMessageHolder);
      }
      return true;
    } else {
      return false;
    }
  }

  // dynamic pushNoti() async {
  //   //check offline or online
  //   final ChatNotiParameterHolder chatNotiParameterHolder =
  //       ChatNotiParameterHolder(
  //           itemId: widget.itemId,
  //           buyerUserId: widget.buyerUserId,
  //           sellerUserId: widget.sellerUserId,
  //           message: messageController.text,
  //           type: widget.chatFlag == PsConst.CHAT_FROM_BUYER
  //               ? PsConst.CHAT_TO_BUYER
  //               : PsConst.CHAT_TO_SELLER);
  //   // api no 19
  //   //   await notiProvider.postChatNoti(chatNotiParameterHolder.toMap());
  // }

  Future<void> _insertDataToFireBase(
    String id,
    bool isSold,
    bool isUserBought,
    String itemId,
    String message,
    int offerStatus,
    String sendByUserId,
    String sessionId,
    int type,
  ) async {
    final Message messages = Message();
    messages.addedDate = Utils.getTimeStamp();
    messages.id = id;
    messages.isSold = isSold;
    messages.isUserBought = isUserBought;
    messages.itemId = itemId;
    messages.message = message;
    messages.offerStatus = offerStatus;
    messages.sendByUserId = sendByUserId;
    messages.sessionId = sessionId;
    messages.type = type;

    final String? newkey = _messagesRef.child(sessionId).push().key;
    messages.id = newkey;
    // Add / Update
    _messagesRef
        .child(sessionId)
        .child(newkey ?? '')
        .set(messages.toInsertMap(messages));
    // if (isActive != ChatUserStatus.active) {
    //   await pushNoti();
    // }
  }

  Future<void> _deleteDataToFireBase(
    String id,
    bool isSold,
    String itemId,
    String message,
    String sendByUserId,
    String sessionId,
  ) async {
    final Message messages = Message();
    messages.addedDate = Utils.getTimeStamp();
    messages.id = id;
    messages.isSold = isSold;
    messages.itemId = itemId;
    messages.message = message;
    messages.sendByUserId = sendByUserId;
    messages.sessionId = sessionId;

    final String key =
        _messagesRef.child(sessionId).child(id).remove().toString();
    messages.id = key;
    // delete
    _messagesRef
        .child(sessionId)
        .child(key)
        .set(messages.toDeleteMap(messages));
    // if (isActive != ChatUserStatus.active) {
    //   await pushNoti();
    // }
  }

  Future<void> _updateDataToFireBase(
    int addedDate,
    String id,
    bool isSold,
    bool isUserBought,
    String itemId,
    String message,
    int offerStatus,
    String sendByUserId,
    String sessionId,
    int type,
  ) async {
    final Message messages = Message();
    // chat.addedDate = Utils.getTimeStamp();
    messages.id = id;
    messages.isSold = isSold;
    messages.isUserBought = isUserBought;
    messages.itemId = itemId;
    messages.message = message;
    messages.offerStatus = offerStatus;
    messages.sendByUserId = sendByUserId;
    messages.sessionId = sessionId;
    messages.type = type;
    messages.addedDateTimeStamp = addedDate;

    // Update
    _messagesRef
        .child(sessionId)
        .child(messages.id!)
        .set(messages.toUpdateMap(messages));
    // if (isActive != ChatUserStatus.active) {
    //   await pushNoti();
    // }
  }


  Future<void> _insertSenderAndReceiverToFireBase(
      String? sessionId,
      String? itemId,
      String? receiverId,
      String senderId,
      String? userName) async {
    final Chat chat =
        Chat(itemId: itemId, receiverId: receiverId, senderId: senderId);
    // chat.itemId = itemId;
    // chat.receiverId = receiverId;
    // chat.senderId = senderId;

    // _chatRef.child(senderId).child(sessionId).set(chat.toMap(chat));
    _chatRef.child(senderId).set(chat.toMap(chat));

    final ChatUserPresence chatUserPresence =
        ChatUserPresence(userId: senderId, userName: userName);

    _userPresence.child(senderId).set(chatUserPresence.toMap(chatUserPresence));
  }

  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      width: PsDimens.space10,
    );
    lastTimeStamp = null;

    psValueHolder = Provider.of<PsValueHolder>(context);
    chatHistoryRepository = Provider.of<ChatHistoryRepository>(context);
    notiRepo = Provider.of<NotificationRepository>(context);
    galleryRepo = Provider.of<GalleryRepository>(context);
    productRepo = Provider.of<ProductRepository>(context);
    userUnreadMessageRepository =
        Provider.of<UserUnreadMessageRepository>(context);
    if (psValueHolder.loginUserId != null) {
      if (psValueHolder.loginUserId == widget.buyerUserId) {
        sessionId =
            Utils.sortingUserId(widget.sellerUserId!, widget.buyerUserId!);
        otherUserId = widget.sellerUserId;
      } else if (psValueHolder.loginUserId == widget.sellerUserId) {
        sessionId =
            Utils.sortingUserId(widget.buyerUserId!, widget.sellerUserId!);
        otherUserId = widget.buyerUserId;
      }

      _insertSenderAndReceiverToFireBase(sessionId, widget.itemId, otherUserId,
          psValueHolder.loginUserId!, psValueHolder.loginUserName);
    }
    
    _chatRef.child(otherUserId!).onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value == null) {
        if (isActive == null || isActive != ChatUserStatus.offline && mounted) {
          setState(() {
            status = Utils.getString(context, 'chat_view__status_offline');
            isActive = ChatUserStatus.offline;
          });
        }
      } else {
        itemId = (event.snapshot.value as Chat).itemId;// ['itemId'];
        final String? _receiverId = (event.snapshot.value as Chat).receiverId;// event.snapshot.value['receiver_id'];
      

        //   itemId = event.snapshot.value.toString();
        // final String? _receiverId = event.snapshot.value.toString();
        if (_receiverId == psValueHolder.loginUserId &&
            itemId == widget.itemId) {
          if (isActive != ChatUserStatus.active && mounted) {
            setState(() {
              status = Utils.getString(context, 'chat_view__status_active');
              isActive = ChatUserStatus.active;
            });
          }
        } else {
          if (isActive != ChatUserStatus.in_active) {
            setState(() {
              status = Utils.getString(context, 'chat_view__status_inactive');
              isActive = ChatUserStatus.in_active;
            });
          }
        }
      }
    });

    Future<void> checkOfferStatus(ChatHistory chatHistory) async {
      if (chatHistory.isOffer == PsConst.ONE &&
          chatHistory.isAccept != PsConst.ONE) {
        await getChatHistoryProvider
            .getChatHistory(getChatHistoryParameterHolder);
        // setState(() {});
      }
    }

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
          ),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.backArrowColor),
          title: Text(
            status,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,),
              //  color: Utils.isLightMode(context)? PsColors.primary500 : PsColors.primaryDarkWhite),
          )),
      body: PsWidgetWithMultiProvider(
          child: MultiProvider(
              providers: <SingleChildWidget>[
            ChangeNotifierProvider<ItemDetailProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  itemDetailProvider = ItemDetailProvider(
                      repo: productRepo, psValueHolder: psValueHolder);

                  final String? loginUserId =
                      Utils.checkUserLoginId(psValueHolder);
                  itemDetailProvider!.loadProduct(widget.itemId, loginUserId);

                  return itemDetailProvider;
                }),
            ChangeNotifierProvider<UserUnreadMessageProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  userUnreadMessageProvider = UserUnreadMessageProvider(
                      repo: userUnreadMessageRepository);
                  return userUnreadMessageProvider;
                }),
            ChangeNotifierProvider<ChatHistoryListProvider>(
                lazy: false,
                create: (BuildContext context) {
                  chatHistoryListProvider =
                      ChatHistoryListProvider(repo: chatHistoryRepository);

                  //call read message count
                  resetUnreadMessageCount(chatHistoryListProvider,
                      psValueHolder, userUnreadMessageProvider);
                  return chatHistoryListProvider;
                }),
            ChangeNotifierProvider<NotificationProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  notiProvider = NotificationProvider(
                      repo: notiRepo, psValueHolder: psValueHolder);

                  return notiProvider;
                }),
            ChangeNotifierProvider<GalleryProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  galleryProvider = GalleryProvider(
                    repo: galleryRepo,
                  );

                  return galleryProvider;
                }),
            ChangeNotifierProvider<GetChatHistoryProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  getChatHistoryProvider =
                      GetChatHistoryProvider(repo: chatHistoryRepository);
                  getChatHistoryParameterHolder = GetChatHistoryParameterHolder(
                      itemId: widget.itemId,
                      buyerUserId: widget.buyerUserId,
                      sellerUserId: widget.sellerUserId);
                  getChatHistoryProvider
                      .getChatHistory(getChatHistoryParameterHolder);

                  return getChatHistoryProvider;
                }),
          ],
              child: Consumer<ItemDetailProvider>(builder:
                  (BuildContext context, ItemDetailProvider itemDetailProvider,
                      Widget? child) {
                // if (getChatHistoryProvider.chatHistory != null &&
                //     getChatHistoryProvider.chatHistory.data != null &&
                if (itemDetailProvider.itemDetail.data != null) {
                  return Container(
                    color: Utils.isLightMode(context)
                        ? Colors.grey[100]
                        : Colors.grey[900],
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              alignment: Alignment.topCenter,
                              width: double.infinity,
                              child: ItemInfoWidget(
                                insertDataToFireBase: _insertDataToFireBase,
                                sessionId: sessionId,
                                itemData: itemDetailProvider.itemDetail.data,
                                sendByUserId: psValueHolder.loginUserId ?? '',
                                chatFlag: widget.chatFlag,
                                buyerUserId: widget.buyerUserId,
                                sellerUserId: widget.sellerUserId,
                                chatHistoryProvider: getChatHistoryProvider,
                                isOffer:
                                    (getChatHistoryProvider.chatHistory.data !=
                                                null &&
                                            getChatHistoryProvider
                                                    .chatHistory.data!.id !=
                                                '')
                                        ? getChatHistoryProvider
                                            .chatHistory.data!.isOffer
                                        : '0',
                                isUserOnline: isActive == ChatUserStatus.active
                                    ? PsConst.ONE
                                    : PsConst.ZERO,
                              ),
                            )),
                        Flexible(
                          child: Container(
                            margin:
                                const EdgeInsets.only(bottom: PsDimens.space12),
                            child: FirebaseAnimatedList(
                              key: ValueKey<bool>(_anchorToBottom),
                              query: _messagesRef
                                  .child(sessionId!)
                                  .orderByChild('itemId')
                                  .equalTo(widget.itemId),
                              reverse: _anchorToBottom,
                              sort: _anchorToBottom
                                  ? (DataSnapshot a, DataSnapshot b) {
                                      return Message().fromMap(b.value)!.addedDateTimeStamp// ['addedDate']
                                        .toString()
                                        .compareTo(Message().fromMap(a.value)!.addedDateTimeStamp.toString());
                                    }
                                  : null,
                              itemBuilder: (BuildContext context,
                                  DataSnapshot snapshot,
                                  Animation<double> animation,
                                  int index) {
                                print('- - - - - - -  /nIndex : $index');

                                bool isSameDate = false;
                                final Message messages =
                                    Message().fromMap(snapshot.value)!;

                                final String chatDateString =
                                    Utils.convertTimeStampToDate(
                                        messages.addedDateTimeStamp);

                                if (index == 0 || lastTimeStamp == null) {
                                  lastTimeStamp = chatDateString;
                                  lastAddedDateTimeStamp =
                                      messages.addedDateTimeStamp;
                                }

                                final DateTime msgDate =
                                    Utils.getDateOnlyFromTimeStamp(
                                        messages.addedDateTimeStamp!);

                                final DateTime lastDate =
                                    Utils.getDateOnlyFromTimeStamp(
                                        lastAddedDateTimeStamp!);

                                // print(msgDate.compareTo(lastDate));

                                if (lastTimeStamp == chatDateString ||
                                    msgDate.compareTo(lastDate) >= 0) {
                                  isSameDate = true;
                                } else {
                                  isSameDate = false;
                                }

                                // print(isSameDate);
                                final Widget _chatCell = _ChatPageWidget(
                                  buyerUserId: widget.buyerUserId,
                                  sellerUserId: widget.sellerUserId,
                                  chatFlag: widget.chatFlag,
                                  chatHistoryProvider: getChatHistoryProvider,
                                  chatHistoryParameterHolder:
                                      getChatHistoryParameterHolder,
                                  messageObj: messages,
                                  itemDetail:
                                      itemDetailProvider.itemDetail.data,
                                  psValueHolder: psValueHolder,
                                  updateDataToFireBase: _updateDataToFireBase,
                                  insertDataToFireBase: _insertDataToFireBase,
                                  deleteDataToFireBase: _deleteDataToFireBase,
                                  checkOfferStatus: checkOfferStatus,
                                  index: index,
                                  isUserOnline:
                                      isActive == ChatUserStatus.active
                                          ? PsConst.ONE
                                          : PsConst.ZERO,
                                );

                                late Widget _dateWidget;
                                if (!isSameDate) {
                                  _dateWidget = Container(
                                    margin: const EdgeInsets.only(
                                        top: PsDimens.space8,
                                        bottom: PsDimens.space8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        _spacingWidget,
                                        const Expanded(
                                          child: Divider(
                                              height: PsDimens.space1,
                                              color: Colors.black54),
                                        ),
                                        _spacingWidget,
                                        Container(
                                          padding: const EdgeInsets.all(
                                              PsDimens.space4),
                                          decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      PsDimens.space8)),
                                          child: Text(
                                            lastTimeStamp!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall?.copyWith(color: Colors.white),
                                          ),
                                        ),
                                        _spacingWidget,
                                        const Expanded(
                                          child: Divider(
                                              height: PsDimens.space1,
                                              color: Colors.black54),
                                        ),
                                        _spacingWidget,
                                      ],
                                    ),
                                  );

                                  lastTimeStamp = chatDateString;
                                  lastAddedDateTimeStamp =
                                      messages.addedDateTimeStamp;
                                }

                                if (msgDate.compareTo(lastDate) >= 0) {
                                  lastTimeStamp = chatDateString;
                                  lastAddedDateTimeStamp =
                                      messages.addedDateTimeStamp;
                                }

                                return isSameDate
                                    ? _chatCell
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          _chatCell,
                                          _dateWidget,
                                        ],
                                      );
                              },
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              width: double.infinity,
                              child: EditTextAndButtonWidget(
                                messageController: messageController,
                                insertDataToFireBase: _insertDataToFireBase,
                                sessionId: sessionId,
                                itemData: itemDetailProvider.itemDetail.data,
                                psValueHolder: psValueHolder,
                                chatFlag: widget.chatFlag,
                                chatHistoryProvider: getChatHistoryProvider,
                                galleryProvider: galleryProvider,
                                buyerUserId: widget.buyerUserId,
                                sellerUserId: widget.sellerUserId,
                                isUserOnline: isActive == ChatUserStatus.active
                                    ? PsConst.ONE
                                    : PsConst.ZERO,
                              ),
                            ))
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }))),
    );
  }
}

class _ChatPageWidget extends StatefulWidget {
  const _ChatPageWidget(
      {required this.psValueHolder,
      required this.messageObj,
      required this.itemDetail,
      required this.buyerUserId,
      required this.sellerUserId,
      required this.updateDataToFireBase,
      required this.insertDataToFireBase,
      required this.deleteDataToFireBase,
      required this.chatHistoryProvider,
      required this.chatHistoryParameterHolder,
      required this.chatFlag,
      required this.checkOfferStatus,
      required this.index,
      required this.isUserOnline});

  final PsValueHolder psValueHolder;
  final Message messageObj;
  final Product? itemDetail;
  final String? buyerUserId;
  final String? sellerUserId;
  final Function updateDataToFireBase;
  final Function insertDataToFireBase;
  final Function deleteDataToFireBase;
  final GetChatHistoryProvider chatHistoryProvider;
  final String chatFlag;
  final GetChatHistoryParameterHolder chatHistoryParameterHolder;
  final Function checkOfferStatus;
  final int index;
  final String? isUserOnline;

  @override
  __ChatPageWidgetState createState() => __ChatPageWidgetState();
}

class __ChatPageWidgetState extends State<_ChatPageWidget> {
  @override
  Widget build(BuildContext context) {
    // Checking User id
    if (widget.psValueHolder.loginUserId == '' ||
        widget.messageObj.sendByUserId == '') {
      return Container();
    }

    if (widget.psValueHolder.loginUserId == widget.messageObj.sendByUserId) {
      // sender
      if (widget.messageObj.type == PsConst.CHAT_TYPE_TEXT) {
        if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_OFFER) {
          return _ChatMakeOfferSenderBoxWidget(
            messageObj: widget.messageObj,
            itemDetail: widget.itemDetail,
            psValueHolder: widget.psValueHolder,
          );
        } else if (widget.messageObj.offerStatus ==
            PsConst.CHAT_STATUS_ACCEPT) {
          if (widget.psValueHolder.loginUserId == widget.sellerUserId &&
              widget.messageObj.isSold != null &&
              widget.messageObj.isUserBought != null &&
              !widget.messageObj.isSold! &&
              !widget.messageObj.isUserBought!) {
            return _OfferAcceptedWithIsUserBoughtWidget(
              messageObj: widget.messageObj,
              updateDataToFireBase: widget.updateDataToFireBase,
              insertDataToFireBase: widget.insertDataToFireBase,
              chatHistoryProvider: widget.chatHistoryProvider,
              loginUserId: widget.psValueHolder.loginUserId,
              sellerUserId: widget.sellerUserId,
              buyerUserId: widget.buyerUserId,
              itemDetail: widget.itemDetail,
              isUserOnline: widget.isUserOnline,
              psValueHolder: widget.psValueHolder,
            );
          } else if (widget.psValueHolder.loginUserId == widget.sellerUserId &&
              widget.messageObj.isSold != null &&
              widget.messageObj.isUserBought != null &&
              widget.messageObj.isSold! &&
              widget.messageObj.isUserBought!) {
            return Container();
          } else {
            return _ChatAcceptedOrRejectedOfferSenderBoxWidget(
              messageObj: widget.messageObj,
              itemDetail: widget.itemDetail,
              psValueHolder: widget.psValueHolder,
            );
          }
        } else if (widget.messageObj.offerStatus ==
            PsConst.CHAT_STATUS_REJECT) {
          if (widget.index == 0 && widget.chatHistoryProvider.chatHistory.data != null) {
            widget
                .checkOfferStatus(widget.chatHistoryProvider.chatHistory.data);
          }
          return _ChatAcceptedOrRejectedOfferSenderBoxWidget(
            messageObj: widget.messageObj,
            itemDetail: widget.itemDetail,
            psValueHolder: widget.psValueHolder,
          );
        } else {
          return _ChatTextSenderWidget(
            widget: widget,
            deleteDataToFireBase: widget.deleteDataToFireBase,
          );
        }
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_OFFER) {
        return _ChatMakeOfferSenderBoxWidget(
          messageObj: widget.messageObj,
          itemDetail: widget.itemDetail,
          psValueHolder: widget.psValueHolder,
        );
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_BOUGHT) {
        return _MakeIsUserBoughtWidget(
          messageObj: widget.messageObj,
          updateDataToFireBase: widget.updateDataToFireBase,
          insertDataToFireBase: widget.insertDataToFireBase,
          chatHistoryProvider: widget.chatHistoryProvider,
          itemDetail: widget.itemDetail,
          psValueHolder: widget.psValueHolder,
          buyerUserId: widget.buyerUserId,
          sellerUserId: widget.sellerUserId,
          loginUserId: widget.psValueHolder.loginUserId,
        );
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_SOLD) {
        return Column(
          children: <Widget>[
            _MakeIsUserBoughtForBuyerWidget(
              messageObj: widget.messageObj,
              itemDetail: widget.itemDetail,
              psValueHolder: widget.psValueHolder,
              buyerUserId: widget.buyerUserId,
              sellerUserId: widget.sellerUserId,
            ),
            _MakeMarkAsSoldWidget(
              messageObj: widget.messageObj,
              itemDetail: widget.itemDetail,
              psValueHolder: widget.psValueHolder,
              buyerUserId: widget.buyerUserId,
              sellerUserId: widget.sellerUserId,
            ),
          ],
        );
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_IMAGE) {
        return _ChatImageSenderWidget(
          widget: widget,
          deleteDataToFireBase: widget.deleteDataToFireBase,
        );
      } else {
        return Container();
      }
    } else {
      //receiver
      if (widget.messageObj.type == PsConst.CHAT_TYPE_TEXT) {
        if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_OFFER) {
          // return _ChatMakeOfferReceiverBoxWidget(
          //   messageObj: widget.messageObj,
          // );
          return _OfferReceivedBoxWithoutAcceptAndRejectWidget(
            messageObj: widget.messageObj,
            itemDetail: widget.itemDetail,
            psValueHolder: widget.psValueHolder,
          );
        } else if (widget.messageObj.offerStatus ==
            PsConst.CHAT_STATUS_ACCEPT) {
          if (widget.psValueHolder.loginUserId == widget.sellerUserId &&
              widget.messageObj.isSold != null &&
              widget.messageObj.isUserBought != null &&
              !widget.messageObj.isSold! &&
              !widget.messageObj.isUserBought!) {
            return _OfferAcceptedWithIsUserBoughtWidget(
              messageObj: widget.messageObj,
              updateDataToFireBase: widget.updateDataToFireBase,
              insertDataToFireBase: widget.insertDataToFireBase,
              chatHistoryProvider: widget.chatHistoryProvider,
              loginUserId: widget.psValueHolder.loginUserId,
              sellerUserId: widget.sellerUserId,
              buyerUserId: widget.buyerUserId,
              itemDetail: widget.itemDetail,
              isUserOnline: widget.isUserOnline,
              psValueHolder: widget.psValueHolder
            );
          } else if (widget.psValueHolder.loginUserId == widget.buyerUserId &&
              widget.messageObj.isSold != null &&
              widget.messageObj.isUserBought != null &&
              widget.messageObj.isSold! &&
              widget.messageObj.isUserBought!) {
            return Container();
          } else {
            return _ChatAcceptedOrRejectedOfferReceiverBoxWidget(
              messageObj: widget.messageObj,
              itemDetail: widget.itemDetail,
              psValueHolder: widget.psValueHolder,
            );
          }
        } else if (widget.messageObj.offerStatus ==
            PsConst.CHAT_STATUS_REJECT) {
          if (widget.index == 0) {
            if (widget.chatHistoryProvider.chatHistory.data != null) {
              widget.checkOfferStatus(
                  widget.chatHistoryProvider.chatHistory.data);
            }
          }
          return _ChatAcceptedOrRejectedOfferReceiverBoxWidget(
            messageObj: widget.messageObj,
            itemDetail: widget.itemDetail,
            psValueHolder: widget.psValueHolder,
          );
        } else {
          return _ChatTextReceiverWidget(
            widget: widget,
            itemDetail: widget.itemDetail,
          );
        }
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_OFFER) {
        return _OfferReceivedBoxWithAcceptAndRejectWidget(
          messageObj: widget.messageObj,
          chatFlag: widget.chatFlag,
          updateDataToFireBase: widget.updateDataToFireBase,
          insertDataToFireBase: widget.insertDataToFireBase,
          chatHistoryProvider: widget.chatHistoryProvider,
          loginUserId: widget.psValueHolder.loginUserId,
          sellerUserId: widget.sellerUserId,
          buyerUserId: widget.buyerUserId,
          itemDetail: widget.itemDetail,
          isUserOnline: widget.isUserOnline,
          psValueHolder: widget.psValueHolder,
        );
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_SOLD) {
        return Column(
          children: <Widget>[
            _MakeIsUserBoughtForBuyerWidget(
              messageObj: widget.messageObj,
              itemDetail: widget.itemDetail,
              psValueHolder: widget.psValueHolder,
              buyerUserId: widget.buyerUserId,
              sellerUserId: widget.sellerUserId,
            ),
            _MakeMarkAsSoldWidget(
              messageObj: widget.messageObj,
              itemDetail: widget.itemDetail,
              psValueHolder: widget.psValueHolder,
              buyerUserId: widget.buyerUserId,
              sellerUserId: widget.sellerUserId,
            ),
          ],
        );
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_IMAGE) {
        return _ChatImageReceiverWidget(
          widget: widget,
        );
        
      } else if (widget.messageObj.type == PsConst.CHAT_TYPE_BOUGHT) {
                  if (widget.index == 0) {
               if (widget.chatHistoryProvider.chatHistory.data != null) {
              widget.checkOfferStatus(
                  widget.chatHistoryProvider.chatHistory.data);
            }
          }
        return _MakeIsUserBoughtForBuyerWidget(
          messageObj: widget.messageObj,
          itemDetail: widget.itemDetail,
          psValueHolder: widget.psValueHolder,
          buyerUserId: widget.buyerUserId,
          sellerUserId: widget.sellerUserId,
        );
      } else {
        return Container();
      }
    }

    // if (widget.psValueHolder.loginUserId == widget.messageObj.sendByUserId &&
    //     widget.messageObj.itemId == widget.itemDetail.id &&
    //     widget.messageObj.offerStatus == PsConst.CHAT_STATUS_NULL &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_TEXT) {
    //   ///
    //   /// Text UI ( Sender )true
    //   ///
    //   return _ChatTextSenderWidget(widget: widget);
    // } else if (widget.psValueHolder.loginUserId !=
    //         widget.messageObj.sendByUserId &&
    //     widget.messageObj.itemId == widget.itemDetail.id &&
    //     widget.messageObj.offerStatus == PsConst.CHAT_STATUS_NULL &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_TEXT) {
    //   ///
    //   /// Text UI ( Receiver ) true
    //   ///

    //   return _ChatTextReceiverWidget(widget: widget);
    // }
    // if (widget.psValueHolder.loginUserId == widget.messageObj.sendByUserId &&
    //     widget.messageObj.itemId == widget.itemDetail.id &&
    //     widget.messageObj.offerStatus == PsConst.CHAT_STATUS_NULL &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_IMAGE) {
    //   ///
    //   /// Image UI ( Sender )true
    //   ///
    //   return _ChatImageSenderWidget(
    //     widget: widget,
    //   );
    // } else if (widget.psValueHolder.loginUserId !=
    //         widget.messageObj.sendByUserId &&
    //     widget.messageObj.itemId == widget.itemDetail.id &&
    //     widget.messageObj.offerStatus == PsConst.CHAT_STATUS_NULL &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_IMAGE) {
    //   ///
    //   /// Image UI ( Receiver ) true
    //   ///

    //   return _ChatImageReceiverWidget(widget: widget);
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_OFFER &&
    //     (widget.messageObj.type == PsConst.CHAT_TYPE_OFFER ||
    //         widget.messageObj.type == PsConst.CHAT_TYPE_REJECT ||
    //         widget.messageObj.type == PsConst.CHAT_TYPE_ACCEPT) &&
    //     widget.psValueHolder.loginUserId != widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Make Offer UI (Sender)
    //   ///
    //   return _MakeOfferBoxWidget(
    //     messageObj: widget.messageObj,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_OFFER &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_OFFER &&
    //     widget.psValueHolder.loginUserId == widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Make Offer UI (Receiver) true
    //   ///
    //   return _OfferReceivedBoxWithAcceptAndRejectWidget(
    //     messageObj: widget.messageObj,
    //     chatFlag: widget.chatFlag,
    //     updateDataToFireBase: widget.updateDataToFireBase,
    //     insertDataToFireBase: widget.insertDataToFireBase,
    //     chatHistoryProvider: widget.chatHistoryProvider,
    //     loginUserId: widget.psValueHolder.loginUserId,
    //     sellerUserId: widget.sellerUserId,
    //     buyerUserId: widget.buyerUserId,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_OFFER &&
    //     (widget.messageObj.type == PsConst.CHAT_TYPE_ACCEPT ||
    //         widget.messageObj.type == PsConst.CHAT_TYPE_REJECT) &&
    //     widget.psValueHolder.loginUserId == widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Offer Received (Item Owner) true
    //   ///
    //   return _OfferReceivedBoxWithoutAcceptAndRejectWidget(
    //     messageObj: widget.messageObj,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT &&
    //     (widget.messageObj.type == PsConst.CHAT_TYPE_ACCEPT ||
    //         widget.messageObj.type == PsConst.CHAT_TYPE_SOLD) &&
    //     widget.psValueHolder.loginUserId == widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Offer Accepted (Item Owner) true
    //   ///
    //   return _OfferAcceptedWithMarkAsSoldWidget(
    //       messageObj: widget.messageObj,
    //       updateDataToFireBase: widget.updateDataToFireBase,
    //       insertDataToFireBase: widget.insertDataToFireBase,
    //       chatHistoryProvider: widget.chatHistoryProvider,
    //       loginUserId: widget.psValueHolder.loginUserId,
    //       sellerUserId: widget.sellerUserId,
    //       buyerUserId: widget.buyerUserId);
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_REJECT &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_REJECT &&
    //     widget.psValueHolder.loginUserId == widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Offer Rejected (Item Ownder) true
    //   ///
    //   return _AcceptedOrRejectedMessageWidget(
    //     messageObj: widget.messageObj,
    //   );
    // } else if ((widget.messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT ||
    //         widget.messageObj.offerStatus == PsConst.CHAT_STATUS_REJECT) &&
    //     (widget.messageObj.type == PsConst.CHAT_TYPE_ACCEPT ||
    //         widget.messageObj.type == PsConst.CHAT_TYPE_REJECT) &&
    //     widget.psValueHolder.loginUserId != widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Offer Received  (Item Buyer) true
    //   ///
    //   return _AcceptedOrRejectedOfferBoxWidget(
    //     messageObj: widget.messageObj,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_REJECT &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_REJECT &&
    //     widget.psValueHolder.loginUserId != widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Offer  Rejected (Item Buyer) true
    //   ///
    //   return _AcceptedOrRejectedOfferBoxWidget(
    //     messageObj: widget.messageObj,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_SOLD &&
    //     widget.psValueHolder.loginUserId != widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   ///
    //   ///
    //   return _AcceptedOrRejectedOfferBoxWidget(
    //     messageObj: widget.messageObj,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_SOLD &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_SOLD &&
    //     widget.psValueHolder.loginUserId == widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Mark As Sold (Item Owner)
    //   ///
    //   return _MakeMarkAsSoldWidget(
    //     messageObj: widget.messageObj,
    //     itemDetail: widget.itemDetail,
    //     psValueHolder: widget.psValueHolder,
    //     buyerUserId: widget.buyerUserId,
    //     sellerUserId: widget.sellerUserId,
    //   );
    // } else if (widget.messageObj.offerStatus == PsConst.CHAT_STATUS_SOLD &&
    //     widget.messageObj.type == PsConst.CHAT_TYPE_SOLD &&
    //     widget.psValueHolder.loginUserId != widget.itemDetail.user.userId &&
    //     widget.messageObj.itemId == widget.itemDetail.id) {
    //   ///
    //   /// Mark As Sold (Item Buyer)
    //   ///
    //   return _MakeMarkAsSoldWidget(
    //       messageObj: widget.messageObj,
    //       itemDetail: widget.itemDetail,
    //       psValueHolder: widget.psValueHolder,
    //       buyerUserId: widget.buyerUserId,
    //       sellerUserId: widget.sellerUserId);
    // } else {
    //   return Container();
    // }
  }
}

class _ChatImageReceiverWidget extends StatelessWidget {
  const _ChatImageReceiverWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final _ChatPageWidget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
            child: Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(PsDimens.space8),
            child: PsNetworkImageWithUrl(
              photoKey: '',
              imagePath: widget.messageObj.message,
              width: double.infinity,
              height: PsDimens.space200,
              boxfit: BoxFit.cover,
              imageAspectRation: PsConst.Aspect_Ratio_3x,
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.chatImageDetailView,
                    arguments: widget.messageObj);
              },
            ),
          ),
        )),
        Expanded(
          child: Text(
            Utils.convertTimeStampToTime(widget.messageObj.addedDateTimeStamp),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _ChatImageSenderWidget extends StatelessWidget {
  const _ChatImageSenderWidget({
    Key? key,
    required this.widget,
    required this.deleteDataToFireBase,
  }) : super(key: key);

  final _ChatPageWidget widget;
  final Function deleteDataToFireBase;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: Text(
            Utils.convertTimeStampToTime(widget.messageObj.addedDateTimeStamp),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space8,
                right: PsDimens.space8,
                top: PsDimens.space16),
            child: GestureDetector(
              onLongPress: () {
                FocusScope.of(context).requestFocus(FocusNode());
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmDialogView(
                        description:
                            Utils.getString(context, 'chat_message_delete'),
                        leftButtonText:
                            Utils.getString(context, 'dialog__cancel'),
                        rightButtonText: Utils.getString(context, 'dialog__ok'),
                        onAgreeTap: () async {
                          Navigator.pop(context);
                          await deleteDataToFireBase(
                            widget.messageObj.id,
                            false,
                            widget.messageObj.itemId,
                            widget.messageObj.message,
                            widget.messageObj.sendByUserId,
                            widget.messageObj.sessionId,
                          );
                        },
                      );
                    });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(PsDimens.space8),
                child: PsNetworkImageWithUrl(
                  photoKey: '',
                  imagePath: widget.messageObj.message,
                  width: double.infinity,
                  height: PsDimens.space200,
                  imageAspectRation: PsConst.Aspect_Ratio_3x,
                  boxfit: BoxFit.cover,
                  onTap: () {
                    Navigator.pushNamed(context, RoutePaths.chatImageDetailView,
                        arguments: widget.messageObj);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatTextReceiverWidget extends StatefulWidget {
  const _ChatTextReceiverWidget({
    Key? key,
    required this.widget,
    required this.itemDetail,
  }) : super(key: key);

  final _ChatPageWidget widget;
  final Product? itemDetail;

  @override
  __ChatTextReceiverWidgetState createState() =>
      __ChatTextReceiverWidgetState();
}

class __ChatTextReceiverWidgetState extends State<_ChatTextReceiverWidget> {
  late dynamic _tapPosition;
  late PsValueHolder valueHolder;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    return Consumer<GetChatHistoryProvider>(builder: (BuildContext context,
        GetChatHistoryProvider getChatHistoryProvider, Widget? child) {
      if (getChatHistoryProvider.chatHistory.data != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                left: PsDimens.space8,
              ),
              width: 40,
              height: 40,
              child: PsNetworkCircleImageForUser(
                photoKey: '',
                imagePath: (getChatHistoryProvider.chatHistory.data != null)
                    ? (valueHolder.loginUserId ==
                            getChatHistoryProvider
                                .chatHistory.data!.seller!.userId)
                        ? getChatHistoryProvider
                            .chatHistory.data!.buyer!.userProfilePhoto
                        : getChatHistoryProvider
                            .chatHistory.data!.seller!.userProfilePhoto
                    : '',
                boxfit: BoxFit.cover,
                onTap: () {},
              ),
            ),
            Flexible(
              child: Container(
                // width: MediaQuery.of(context).size.width / 2,
                margin: const EdgeInsets.only(
                    left: PsDimens.space8,
                    right: PsDimens.space8,
                    top: PsDimens.space16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    color: PsColors.white),
                padding: const EdgeInsets.all(PsDimens.space12),
                // child: Text(
                //   widget.messageObj.message,
                //   style: Theme.of(context)
                //       .textTheme
                //       .bodyText2
                //       .copyWith(color: PsColors.textPrimaryColorForLight),
                // ),

                child: GestureDetector(
                  onLongPress: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final RenderBox overlay = Overlay.of(context)
                        .context
                        .findRenderObject() as RenderBox;

                    showMenu(
                        context: context,
                        items: <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                              value: '1',
                              // child: Expanded(
                              child: MaterialButton(
                                height: 50,
                                minWidth: double.infinity,
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  Clipboard.setData(ClipboardData(
                                      text: widget.widget.messageObj.message!));
                                  Fluttertoast.showToast(
                                      msg: ' copied.',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: PsColors.activeColor,
                                      textColor: PsColors.baseColor);
                                },
                                child: Text(
                                  Utils.getString(context, 'message_copy'),
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                //)
                              )),
                          PopupMenuItem<String>(
                              value: '3',
                              // child: Expanded(
                              child: MaterialButton(
                                height: 50,
                                minWidth: double.infinity,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  Utils.getString(context, 'message_cancle'),
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                //)
                              )),
                        ],
                        position: RelativeRect.fromRect(
                            _tapPosition & const Size(1, 1),
                            Offset.zero &
                                overlay.size // Bigger rect, the entire screen
                            ));
                  },
                  onTapDown: _storePosition,
                  child: Linkify(
                    onOpen: Utils.linkifyLinkOpen,
                    text: widget.widget.messageObj.message!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                Utils.convertTimeStampToTime(
                    widget.widget.messageObj.addedDateTimeStamp),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }
}

class _ChatTextSenderWidget extends StatefulWidget {
  const _ChatTextSenderWidget({
    Key? key,
    required this.widget,
    required this.deleteDataToFireBase,
  }) : super(key: key);

  final _ChatPageWidget widget;
  final Function deleteDataToFireBase;

  @override
  __ChatTextSenderWidgetState createState() => __ChatTextSenderWidgetState();
}

class __ChatTextSenderWidgetState extends State<_ChatTextSenderWidget> {
  late dynamic _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: Text(
            Utils.convertTimeStampToTime(
                widget.widget.messageObj.addedDateTimeStamp),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Flexible(
            child: Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PsDimens.space4),
              color: Colors.lightBlue[100]),
          padding: const EdgeInsets.all(PsDimens.space12),
          // child: Text(
          //   widget.messageObj.message,
          //   style: Theme.of(context)
          //       .textTheme
          //       .bodyText2
          //       .copyWith(color: PsColors.textPrimaryColorForLight),
          // ),

          child: GestureDetector(
            onLongPress: () {
              FocusScope.of(context).requestFocus(FocusNode());
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;

              showMenu(
                  context: context,
                  items: <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                        value: '1',
                        //child: Expanded(
                        child: MaterialButton(
                          height: 50,
                          minWidth: double.infinity,
                          onPressed: () {
                            Navigator.of(context).pop();

                            Clipboard.setData(ClipboardData(
                                text: widget.widget.messageObj.message!));
                            Fluttertoast.showToast(
                                msg: ' copied.',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: PsColors.activeColor,
                                textColor: PsColors.baseColor);
                          },
                          child: Text(
                            Utils.getString(context, 'message_copy'),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          //)
                        )),
                    PopupMenuItem<String>(
                        value: '2',
                        //child: Expanded(
                        child: MaterialButton(
                          height: 50,
                          minWidth: double.infinity,
                          onPressed: () {
                            Navigator.of(context).pop();
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialogView(
                                    description: Utils.getString(
                                        context, 'chat_message_delete'),
                                    leftButtonText: Utils.getString(
                                        context, 'dialog__cancel'),
                                    rightButtonText:
                                        Utils.getString(context, 'dialog__ok'),
                                    onAgreeTap: () async {
                                      Navigator.pop(context);
                                      await widget.deleteDataToFireBase(
                                        widget.widget.messageObj.id,
                                        false,
                                        widget.widget.messageObj.itemId,
                                        widget.widget.messageObj.message,
                                        widget.widget.messageObj.sendByUserId,
                                        widget.widget.messageObj.sessionId,
                                      );
                                    },
                                  );
                                });
                          },
                          child: Text(
                            Utils.getString(context, 'message_delete'),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),

                          //)
                        )),
                    PopupMenuItem<String>(
                        value: '3',
                        //child: Expanded(
                        child: MaterialButton(
                          height: 50,
                          minWidth: double.infinity,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            Utils.getString(context, 'message_cancle'),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),

                          /// )
                        )),
                  ],
                  position: RelativeRect.fromRect(
                      _tapPosition & const Size(1, 1),
                      Offset.zero &
                          overlay.size // Bigger rect, the entire screen
                      ));
            },
            onTapDown: _storePosition,
            child: Linkify(
              onOpen: Utils.linkifyLinkOpen,
              text: widget.widget.messageObj.message!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
            ),
          ),
        )),
      ],
    );
  }
}

class _MakeIsUserBoughtWidget extends StatefulWidget {
  const _MakeIsUserBoughtWidget(
      {required this.messageObj,
      required this.updateDataToFireBase,
      required this.insertDataToFireBase,
      required this.chatHistoryProvider,
      required this.loginUserId,
      required this.sellerUserId,
      required this.buyerUserId,
      required this.itemDetail,
      required this.psValueHolder});
  final Message messageObj;
  final Function updateDataToFireBase;
  final Function insertDataToFireBase;
  final GetChatHistoryProvider? chatHistoryProvider;
  final String? loginUserId;
  final String? sellerUserId;
  final String? buyerUserId;
  final Product? itemDetail;
  final PsValueHolder? psValueHolder;

  @override
  __MakeIsUserBoughtWidgetState createState() =>
      __MakeIsUserBoughtWidgetState();
}

class __MakeIsUserBoughtWidgetState extends State<_MakeIsUserBoughtWidget> {
  @override
  Widget build(BuildContext context) {
    MakeMarkAsSoldParameterHolder makeMarkAsSoldHolder;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                top: PsDimens.space8,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  color: Colors.white),
              padding: const EdgeInsets.all(PsDimens.space12),
              child: Column(
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'chat_view__user_bought_message'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
                  ),
                  const SizedBox(height: PsDimens.space12),
                  Text(
                    widget.itemDetail!.price != '0'
                        ? Utils.getChatPriceFormat(widget.messageObj.message!, widget.psValueHolder!.priceFormat!)
                        : Utils.getString(context, 'item_price_free'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                Utils.psPrint('Buyer user id : ' + widget.buyerUserId!);
                Utils.psPrint('Seller user id : ' + widget.sellerUserId!);
                await showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return RatingInputDialog(
                        buyerUserId: widget.buyerUserId,
                        sellerUserId: widget.sellerUserId,
                      );
                    });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                    left: PsDimens.space8,
                    right: PsDimens.space8,
                    top: PsDimens.space16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    color: PsColors.activeColor),
                padding: const EdgeInsets.all(PsDimens.space12),
                child: Ink(
                  color: PsColors.backgroundColor,
                  child: Text(
                    Utils.getString(context, 'chat_view__give_review_button'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium?.copyWith(color: PsColors.textColor2),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await widget.updateDataToFireBase(
                    widget.messageObj.addedDateTimeStamp,
                    widget.messageObj.id,
                    true,
                    true,
                    widget.messageObj.itemId,
                    widget.messageObj.message,
                    PsConst.CHAT_STATUS_ACCEPT,
                    widget.loginUserId,
                    widget.messageObj.sessionId,
                    PsConst.CHAT_TYPE_TEXT);

                await widget.insertDataToFireBase(
                    '',
                    true,
                    true,
                    widget.messageObj.itemId,
                    widget.messageObj.message,
                    PsConst.CHAT_STATUS_SOLD,
                    widget.loginUserId,
                    widget.messageObj.sessionId,
                    PsConst.CHAT_TYPE_SOLD);

                makeMarkAsSoldHolder = MakeMarkAsSoldParameterHolder(
                  itemId: widget.messageObj.itemId,
                  buyerUserId: widget.buyerUserId,
                  sellerUserId: widget.sellerUserId,
                );
                widget.chatHistoryProvider!.makeMarkAsSoldItem(
                    widget.loginUserId, makeMarkAsSoldHolder);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        left: PsDimens.space8,
                        right: PsDimens.space8,
                        top: PsDimens.space16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(PsDimens.space4),
                        color: PsColors.activeColor),
                    padding: const EdgeInsets.all(PsDimens.space12),
                    child: Ink(
                      child: Text(
                        Utils.getString(context, 'chat_view__mark_as_sold'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium?.copyWith(color: PsColors.textColor2),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _MakeMarkAsSoldWidget extends StatefulWidget {
  const _MakeMarkAsSoldWidget(
      {required this.messageObj,
      required this.itemDetail,
      required this.psValueHolder,
      required this.buyerUserId,
      required this.sellerUserId});
  final Message messageObj;
  final Product? itemDetail;
  final PsValueHolder? psValueHolder;
  final String? buyerUserId;
  final String? sellerUserId;
  @override
  __MakeMarkAsSoldWidgetState createState() => __MakeMarkAsSoldWidgetState();
}

class __MakeMarkAsSoldWidgetState extends State<_MakeMarkAsSoldWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                top: PsDimens.space8,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  color: Colors.white),
              padding: const EdgeInsets.all(PsDimens.space12),
              child: Column(
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'chat_view__mark_as_sold_message'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
                  ),
                  const SizedBox(height: PsDimens.space12),
                  Text(
                    widget.itemDetail!.price != '0'
                        ? Utils.getChatPriceFormat(widget.messageObj.message!, widget.psValueHolder!.priceFormat!)
                        : Utils.getString(context, 'item_price_free'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MakeIsUserBoughtForBuyerWidget extends StatefulWidget {
  const _MakeIsUserBoughtForBuyerWidget(
      {required this.messageObj,
      required this.itemDetail,
      required this.psValueHolder,
      required this.buyerUserId,
      required this.sellerUserId});
  final Message messageObj;
  final Product? itemDetail;
  final PsValueHolder? psValueHolder;
  final String? buyerUserId;
  final String? sellerUserId;
  @override
  __MakeIsUserBoughtForBuyerWidgetState createState() =>
      __MakeIsUserBoughtForBuyerWidgetState();
}

class __MakeIsUserBoughtForBuyerWidgetState
    extends State<_MakeIsUserBoughtForBuyerWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                top: PsDimens.space8,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  color: Colors.white),
              padding: const EdgeInsets.all(PsDimens.space12),
              child: Column(
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'chat_view__user_bought_message'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: PsColors.textPrimaryColorForLight),
                  ),
                  const SizedBox(height: PsDimens.space12),
                  Text(
                    widget.itemDetail!.price != '0'
                        ? Utils.getChatPriceFormat(widget.messageObj.message!, widget.psValueHolder!.priceFormat!)
                        : Utils.getString(context, 'item_price_free'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
                  ),
                ],
              ),
            ),
            // if (widget.buyerUserId == widget.psValueHolder.loginUserId)
            InkWell(
              onTap: () async {
                Utils.psPrint('Buyer user id : ' + widget.buyerUserId!);
                Utils.psPrint('Seller user id : ' + widget.sellerUserId!);
                await showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return RatingInputDialog(
                        buyerUserId: widget.buyerUserId,
                        sellerUserId: widget.sellerUserId,
                      );
                    });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                    left: PsDimens.space8,
                    right: PsDimens.space8,
                    top: PsDimens.space16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    color: PsColors.activeColor),
                padding: const EdgeInsets.all(PsDimens.space12),
                child: Ink(
                  color: PsColors.backgroundColor,
                  child: Text(
                    Utils.getString(context, 'chat_view__give_review_button'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium?.copyWith(color: PsColors.baseColor)
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _OfferReceivedBoxWithoutAcceptAndRejectWidget extends StatelessWidget {
  const _OfferReceivedBoxWithoutAcceptAndRejectWidget({
    required this.messageObj,
    required this.itemDetail,
    required this.psValueHolder,
  });
  final Message messageObj;
  final Product? itemDetail;
  final PsValueHolder psValueHolder;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: PsDimens.space140,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            left: PsDimens.space20,
            right: PsDimens.space8,
            top: PsDimens.space8,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PsDimens.space4),
              color: Colors.yellow[200]),
          padding: const EdgeInsets.all(PsDimens.space12),
          child: Column(
            children: <Widget>[
              Text(
                Utils.getString(context, 'chat_view__receive_offer_message'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
              ),
              const SizedBox(height: PsDimens.space12),
              Text(
                itemDetail!.price != '0'
                    ? Utils.getChatPriceFormat(messageObj.message!, psValueHolder.priceFormat!)
                    : Utils.getString(context, 'item_price_free'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge?.copyWith(color: PsColors.textPrimaryColorForLight),
              ),
            ],
          ),
        ),
        Text(
          Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }
}

class _OfferReceivedBoxWithAcceptAndRejectWidget extends StatelessWidget {
  const _OfferReceivedBoxWithAcceptAndRejectWidget(
      {required this.messageObj,
      required this.chatFlag,
      required this.updateDataToFireBase,
      required this.insertDataToFireBase,
      required this.chatHistoryProvider,
      required this.loginUserId,
      required this.sellerUserId,
      required this.itemDetail,
      required this.buyerUserId,
      required this.isUserOnline,
      required this.psValueHolder});
  final Message messageObj;
  final String chatFlag;
  final Function updateDataToFireBase;
  final Function insertDataToFireBase;
  final GetChatHistoryProvider? chatHistoryProvider;
  final String? loginUserId;
  final String? sellerUserId;
  final Product? itemDetail;
  final String? buyerUserId;
  final String? isUserOnline;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    MakeOfferParameterHolder makeOfferHolder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: PsDimens.space140,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            left: PsDimens.space20,
            right: PsDimens.space8,
            top: PsDimens.space8,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PsDimens.space4),
              color: Colors.yellow[200]),
          padding: const EdgeInsets.all(PsDimens.space12),
          child: Column(
            children: <Widget>[
              Text(
                Utils.getString(context, 'chat_view__receive_offer_message'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
              ),
              const SizedBox(height: PsDimens.space12),
              Text(
                itemDetail!.price != '0'
                    ? Utils.getChatPriceFormat(messageObj.message!, psValueHolder.priceFormat!)
                    : Utils.getString(context, 'item_price_free'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge?.copyWith(color: PsColors.textPrimaryColorForLight),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmDialogView(
                          description: Utils.getString(
                              context, 'chat_view__accept_description'),
                          leftButtonText: Utils.getString(
                              context, 'chat_view__accept_cancel_button'),
                          rightButtonText: Utils.getString(
                              context, 'chat_view__accept_ok_button'),
                          onAgreeTap: () async {
                            await updateDataToFireBase(
                              messageObj.addedDateTimeStamp,
                              messageObj.id,
                              false,
                              false,
                              messageObj.itemId,
                              messageObj.message,
                              PsConst.CHAT_STATUS_OFFER,
                              messageObj.sendByUserId,
                              messageObj.sessionId,
                              PsConst.CHAT_TYPE_ACCEPT
                            );
                            await insertDataToFireBase(
                                '',
                                false,
                                false,
                                messageObj.itemId,
                                messageObj.message,
                                PsConst.CHAT_STATUS_ACCEPT,
                                loginUserId,
                                //messageObj.sendByUserId,
                                messageObj.sessionId,
                                PsConst.CHAT_TYPE_ACCEPT);
                            if (chatFlag == PsConst.CHAT_FROM_BUYER) {
                              makeOfferHolder = MakeOfferParameterHolder(
                                  itemId: messageObj.itemId,
                                  buyerUserId: buyerUserId,
                                  sellerUserId: sellerUserId,
                                  isUserOnline: isUserOnline,
                                  negoPrice:
                                      Utils.splitMessage(messageObj.message!),
                                  type: PsConst.CHAT_TO_BUYER);
                              chatHistoryProvider!.postAcceptedOffer(
                                  makeOfferHolder.toMap(), loginUserId);
                            } else {
                              makeOfferHolder = MakeOfferParameterHolder(
                                  itemId: messageObj.itemId,
                                  buyerUserId: buyerUserId,
                                  sellerUserId: sellerUserId,
                                  isUserOnline: isUserOnline,
                                  negoPrice:
                                      Utils.splitMessage(messageObj.message!),
                                  type: PsConst.CHAT_TO_SELLER);
                              chatHistoryProvider!.postAcceptedOffer(
                                  makeOfferHolder.toMap(), loginUserId);
                            }
                            Navigator.of(context).pop();
                          });
                    });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                    left: PsDimens.space8,
                    right: PsDimens.space8,
                    top: PsDimens.space8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    color: PsColors.activeColor),
                padding: const EdgeInsets.all(PsDimens.space12),
                child: Ink(
                  color: PsColors.backgroundColor,
                  child: Text(
                    Utils.getString(context, 'chat_view__offer_accept_button'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium?.copyWith(color: PsColors.baseColor),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmDialogView(
                          description: Utils.getString(
                              context, 'chat_view__reject_description'),
                          leftButtonText: Utils.getString(
                              context, 'chat_view__reject_cancel_button'),
                          rightButtonText: Utils.getString(
                              context, 'chat_view__reject_ok_button'),
                          onAgreeTap: () async {
                            await updateDataToFireBase(
                                messageObj.addedDateTimeStamp,
                                messageObj.id,
                                false,
                                false,
                                messageObj.itemId,
                                messageObj.message,
                                PsConst.CHAT_STATUS_OFFER,
                                messageObj.sendByUserId,
                                messageObj.sessionId,
                                PsConst.CHAT_TYPE_REJECT);

                            await insertDataToFireBase(
                                '',
                                false,
                                false,
                                messageObj.itemId,
                                messageObj.message,
                                PsConst.CHAT_STATUS_REJECT,
                                messageObj.sendByUserId,
                                messageObj.sessionId,
                                PsConst.CHAT_TYPE_REJECT);

                            if (chatFlag == PsConst.CHAT_FROM_BUYER) {
                              makeOfferHolder = MakeOfferParameterHolder(
                                  itemId: messageObj.itemId,
                                  buyerUserId: buyerUserId,
                                  sellerUserId: sellerUserId,
                                  negoPrice: PsConst.ZERO,
                                  isUserOnline: isUserOnline,
                                  type: PsConst.CHAT_TO_BUYER);
                              chatHistoryProvider!.postRejectedOffer(
                                  makeOfferHolder.toMap(), loginUserId);
                            } else {
                              makeOfferHolder = MakeOfferParameterHolder(
                                  itemId: messageObj.itemId,
                                  buyerUserId: buyerUserId,
                                  sellerUserId: sellerUserId,
                                  negoPrice: PsConst.ZERO,
                                  type: PsConst.CHAT_TO_SELLER,
                                  isUserOnline: isUserOnline);
                              chatHistoryProvider!.postRejectedOffer(
                                  makeOfferHolder.toMap(), loginUserId);
                            }
                            Navigator.of(context).pop();
                          });
                    });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                    top: PsDimens.space8, right: PsDimens.space8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    color: PsColors.grey),
                padding: const EdgeInsets.all(PsDimens.space12),
                child: Ink(
                  color: PsColors.backgroundColor,
                  child: Text(
                    Utils.getString(context, 'chat_view__offer_reject_button'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
            Text(
              Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        )
      ],
    );
  }
}

class _OfferAcceptedWithIsUserBoughtWidget extends StatelessWidget {

  const _OfferAcceptedWithIsUserBoughtWidget(
      {required this.messageObj,
      required this.updateDataToFireBase,
      required this.insertDataToFireBase,
      required this.chatHistoryProvider,
      required this.loginUserId,
      required this.sellerUserId,
      required this.buyerUserId,
      required this.itemDetail,
      required this.isUserOnline,
      required this.psValueHolder});
  final Message messageObj;
  final Function updateDataToFireBase;
  final Function insertDataToFireBase;
  final GetChatHistoryProvider? chatHistoryProvider;
  final String? loginUserId;
  final String? sellerUserId;
  final String? buyerUserId;
  final Product? itemDetail;
  final String? isUserOnline;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    // MakeMarkAsSoldParameterHolder makeMarkAsSoldHolder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _AcceptedOrRejectedMessageWidget(
          messageObj: messageObj,
          itemDetail: itemDetail,
          psValueHolder: psValueHolder,
        ),
        const SizedBox(height: PsDimens.space8),
        if (messageObj.type == PsConst.CHAT_TYPE_ACCEPT)
          InkWell(
            onTap: () async {
              await updateDataToFireBase(
                  messageObj.addedDateTimeStamp,
                  messageObj.id,
                  false,
                  true,
                  messageObj.itemId,
                  messageObj.message,
                  PsConst.CHAT_STATUS_ACCEPT,
                  loginUserId,
                  messageObj.sessionId,
                  PsConst.CHAT_TYPE_TEXT);
              await insertDataToFireBase(
                  '',
                  false,
                  true,
                  messageObj.itemId,
                  messageObj.message,
                  PsConst.CHAT_STATUS_IS_USER_BOUGHT,
                  loginUserId,
                  messageObj.sessionId,
                  PsConst.CHAT_TYPE_BOUGHT);
              final MakeIsUserBoughtParameterHolder
                  makeIsUserBoughtParameterHolder =
                  MakeIsUserBoughtParameterHolder(
                itemId: messageObj.itemId,
                buyerUserId: buyerUserId,
                sellerUserId: sellerUserId,
                isUserOnline: isUserOnline,
              );
              chatHistoryProvider!.makeUserBoughtItem(
                  makeIsUserBoughtParameterHolder.toMap(), loginUserId);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                    right: PsDimens.space14,
                    bottom: PsDimens.space8,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(PsDimens.space4),
                      color: PsColors.activeColor),
                  padding: const EdgeInsets.all(PsDimens.space12),
                  child: Ink(
                    child: Text(
                      Utils.getString(context, 'chat_view__is_user_bought'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium?.copyWith(color: PsColors.baseColor),
                    ),
                  ),
                )
              ],
            ),
          )
        else
          Container()
      ],
    );
  }
}

class _AcceptedOrRejectedMessageWidget extends StatelessWidget {
  const _AcceptedOrRejectedMessageWidget(
      {required this.messageObj, required this.itemDetail, required this.psValueHolder});
  final Message messageObj;
  final Product? itemDetail;
  final PsValueHolder psValueHolder;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: Text(
            Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Flexible(
          child: Container(
            width: PsDimens.space140,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
                left: PsDimens.space8,
                right: PsDimens.space8,
                top: PsDimens.space16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(PsDimens.space4),
                color: messageObj.offerStatus != PsConst.CHAT_STATUS_ACCEPT
                    ? Colors.red[100]
                    : Colors.green[200]),
            padding: const EdgeInsets.all(PsDimens.space12),
            child: Column(
              children: <Widget>[
                Text(
                  messageObj.offerStatus != PsConst.CHAT_STATUS_ACCEPT
                      ? Utils.getString(
                          context, 'chat_view__reject_offer_message')
                      : Utils.getString(
                          context, 'chat_view__accept_offer_message'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
                ),
                const SizedBox(height: PsDimens.space12),
                Text(
                  itemDetail!.price != '0'
                      ? Utils.getChatPriceFormat(messageObj.message!, psValueHolder.priceFormat!)
                      : Utils.getString(context, 'item_price_free'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge?.copyWith(color: PsColors.textPrimaryColorForLight),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EditTextAndButtonWidget extends StatefulWidget {
  const EditTextAndButtonWidget({
    Key? key,
    required this.messageController,
    required this.insertDataToFireBase,
    required this.sessionId,
    required this.itemData,
    required this.psValueHolder,
    required this.chatFlag,
    required this.chatHistoryProvider,
    required this.galleryProvider,
    required this.buyerUserId,
    required this.sellerUserId,
    required this.isUserOnline,
  }) : super(key: key);

  final TextEditingController messageController;
  final Function insertDataToFireBase;
  final String? sessionId;
  final Product? itemData;
  final PsValueHolder? psValueHolder;
  final String chatFlag;
  final GetChatHistoryProvider? chatHistoryProvider;
  final GalleryProvider? galleryProvider;
  final String? buyerUserId;
  final String? sellerUserId;
  final String? isUserOnline;

  @override
  _EditTextAndButtonWidgetState createState() =>
      _EditTextAndButtonWidgetState();
}

XFile? pickedImage;
List<XFile> images = <XFile>[];
XFile? defaultAssetImage;
final TextEditingController messageController1 = TextEditingController();


class _EditTextAndButtonWidgetState extends State<EditTextAndButtonWidget> {
  Future<bool> requestGalleryPermission() async {
    const Permission _photos = Permission.photos;
    final PermissionStatus permissionss = await _photos.request();
    // await PermissionHandler()
    //     .requestPermissions(<Permission>[Permission.photos]);
    if (permissionss == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _pickImage(GalleryProvider provider) async {
 final ImagePicker _picker = ImagePicker();

    try {
      pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
    // pickedImage = _picker;
    // setState(() {});

   // if (pickedImage.isNotEmpty) {
      if (pickedImage!.name.contains('.webp')) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__webp_image'),
              );
            });
      } else {
        await PsProgressDialog.showDialog(context);
        // pr.show();
        PsResource<DefaultPhoto> _apiStatus;
        if (widget.chatFlag == PsConst.CHAT_FROM_BUYER) {
          _apiStatus = await provider.postChatImageUpload(
            widget.psValueHolder!.loginUserId!,
            widget.psValueHolder!.loginUserId!,
            widget.buyerUserId!,
            widget.itemData!.id!,
            PsConst.CHAT_TO_BUYER,
            await Utils.getImageFileFromAssets(
                pickedImage!, widget.psValueHolder!.chatImageSize!),
            widget.isUserOnline!,
          );
        } else {
          _apiStatus = await provider.postChatImageUpload(
            widget.sellerUserId!,
            widget.sellerUserId!,
            widget.psValueHolder!.loginUserId!,
            widget.itemData!.id!,
            PsConst.CHAT_TO_SELLER,
            await Utils.getImageFileFromAssets(
                 pickedImage!, widget.psValueHolder!.chatImageSize!),
            widget.isUserOnline!,
          );
        }

        if (_apiStatus.data != null) {
          await widget.insertDataToFireBase(
              '',
              false,
              false,
              widget.itemData!.id,
              _apiStatus.data!.imgPath,
              PsConst.CHAT_STATUS_NULL,
              widget.psValueHolder!.loginUserId,
              widget.sessionId,
              PsConst.CHAT_TYPE_IMAGE);
          PsProgressDialog.dismissDialog();
        }
      }
   // }
  }

  @override
  Widget build(BuildContext context) {
    SyncChatHistoryParameterHolder holder;
    return Consumer<GalleryProvider>(builder:
        (BuildContext context, GalleryProvider provider, Widget? child) {
      return SizedBox(
        width: double.infinity,
        height: PsDimens.space72,
        child: Container(
          decoration: BoxDecoration(
            color: Utils.isLightMode(context) ? Colors.white : Colors.black45,
            border: Border.all(
                color: Utils.isLightMode(context)
                    ? Colors.grey[200]! : Colors.black45),
                  //  : Colors.grey[900]!),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(PsDimens.space12),
                topRight: Radius.circular(PsDimens.space12)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Utils.isLightMode(context)
                    ? Colors.grey[300]!
                    : Colors.grey[900]!,
                blurRadius: 1.0, // has the effect of softening the shadow
                spreadRadius: 0, // has the effect of extending the shadow
                offset: const Offset(
                  0.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(PsDimens.space1),
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: PsDimens.space8,
                ),
                InkWell(
                  onTap: () async {
                    await _pickImage(provider);
                  },
                  child: Icon(
                    FontAwesome.camera, //Octicons.device_camera,
                    color: IconTheme.of(context).color,
                    size: PsDimens.space20,
                  ),
                ),
                Expanded(
                    flex: 6,
                    child: PsTextFieldWidget(
                      hintText: Utils.getString(
                          context, 'chat_view__message_hint_text'),
                      textEditingController: messageController1,
                      showTitle: false,
                      keyboardType: TextInputType.multiline,
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: PsDimens.space44,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                        left: PsDimens.space4, right: PsDimens.space4),
                    decoration: BoxDecoration(
                      color: PsColors.iconColor,
                      borderRadius: BorderRadius.circular(PsDimens.space4),
                      border: Border.all(
                          color: Utils.isLightMode(context)
                              ? Colors.grey[200]!
                              : Colors.black87),
                    ),
                    child: InkWell(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: PsDimens.space20,
                        ),
                      ),
                      onTap: () async {
                        // print(DateTime.now().millisecondsSinceEpoch);

                        if (
                          //messageController1 == null ||
                            messageController1.text == '') {
                          return;
                        }
                        if (widget.chatFlag == PsConst.CHAT_FROM_BUYER) {
                          holder = SyncChatHistoryParameterHolder(
                              itemId: widget.itemData!.id,
                              buyerUserId: widget.buyerUserId,
                              sellerUserId: widget.sellerUserId,
                              type: PsConst.CHAT_TO_BUYER,
                              isUserOnline: widget.isUserOnline,
                              message: messageController1.text);
                          widget.chatHistoryProvider!
                              .postChatHistory(holder.toMap());
                        } else {
                          holder = SyncChatHistoryParameterHolder(
                              itemId: widget.itemData!.id,
                              sellerUserId: widget.sellerUserId,
                              buyerUserId: widget.buyerUserId,
                              type: PsConst.CHAT_TO_SELLER,
                              isUserOnline: widget.isUserOnline,
                              message: messageController1.text);
                          widget.chatHistoryProvider!
                              .postChatHistory(holder.toMap());
                        }
                        await widget.insertDataToFireBase(
                            '',
                            false,
                            false,
                            widget.itemData!.id,
                            messageController1.text,
                            PsConst.CHAT_STATUS_NULL,
                            widget.psValueHolder!.loginUserId!,
                            widget.sessionId,
                            PsConst.CHAT_TYPE_TEXT);
                        messageController1.clear();
                      },
                    ),

                    // onTap: () {
                    //   // print(DateTime.now().millisecondsSinceEpoch);

                    //   widget.insertDataToFireBase(
                    //       '',
                    //       false,
                    //       widget.itemData.id,
                    //       widget.messageController.text,
                    //       PsConst.CHAT_STATUS_NULL,
                    //       widget.psValueHolder.loginUserId,
                    //       widget.sessionId,
                    //       PsConst.CHAT_TYPE_TEXT);
                    //   widget.messageController.clear();
                    //   if (widget.chatFlag == PsConst.CHAT_FROM_BUYER) {
                    //     holder = SyncChatHistoryParameterHolder(
                    //         itemId: widget.itemData.id,
                    //         buyerUserId: widget.buyerUserId,
                    //         sellerUserId: widget.sellerUserId,
                    //         type: PsConst.CHAT_FROM_SELLER);
                    //     widget.chatHistoryProvider
                    //         .postChatHistory(holder.toMap());
                    //   } else {
                    //     holder = SyncChatHistoryParameterHolder(
                    //         itemId: widget.itemData.id,
                    //         sellerUserId: widget.sellerUserId,
                    //         buyerUserId: widget.buyerUserId,
                    //         type: PsConst.CHAT_FROM_BUYER);
                    //     widget.chatHistoryProvider
                    //         .postChatHistory(holder.toMap());
                    //   }
                    // },
                  ),
                ),
                const SizedBox(
                  width: PsDimens.space4,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ItemInfoWidget extends StatefulWidget {
  const ItemInfoWidget({
    Key? key,
    required this.insertDataToFireBase,
    required this.sessionId,
    required this.itemData,
    required this.sendByUserId,
    required this.chatFlag,
    required this.chatHistoryProvider,
    required this.buyerUserId,
    required this.sellerUserId,
    required this.isOffer,
    required this.isUserOnline,
  }) : super(key: key);

  final Function insertDataToFireBase;
  final String? sessionId;
  final Product? itemData;
  final String sendByUserId;
  final String chatFlag;
  final GetChatHistoryProvider? chatHistoryProvider;
  final String? buyerUserId;
  final String? sellerUserId;
  final String? isOffer;
  final String? isUserOnline;


  @override
  _ItemInfoWidgetState createState() => _ItemInfoWidgetState();
}

class _ItemInfoWidgetState extends State<ItemInfoWidget> {
  // String _isOffer;

  @override
  void initState() {
    // _isOffer = widget.isOffer;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PsResource<ChatHistory> _apiStatus;
    MakeOfferParameterHolder holder;
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);

    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );

    final Widget _imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: widget.itemData!.defaultPhoto,
      // width: 50,
      // height: 50,
      imageAspectRation: PsConst.Aspect_Ratio_1x,
      boxfit: BoxFit.cover,
      onTap: () {
        final ProductDetailIntentHolder holder = ProductDetailIntentHolder(
            productId: widget.itemData!.id,
            heroTagImage: widget.chatHistoryProvider.hashCode.toString() +
                widget.itemData!.id! +
                PsConst.HERO_TAG__IMAGE,
            heroTagTitle: widget.chatHistoryProvider.hashCode.toString() +
                widget.itemData!.id! +
                PsConst.HERO_TAG__TITLE);
        Navigator.pushNamed(context, RoutePaths.productDetail,
            arguments: holder);
      },
    );

    return GestureDetector(
      onTap: () {
        final ProductDetailIntentHolder holder = ProductDetailIntentHolder(
            productId: widget.itemData!.id,
            heroTagImage: widget.chatHistoryProvider.hashCode.toString() +
                widget.itemData!.id! +
                PsConst.HERO_TAG__IMAGE,
            heroTagTitle: widget.chatHistoryProvider.hashCode.toString() +
                widget.itemData!.id! +
                PsConst.HERO_TAG__TITLE);
        Navigator.pushNamed(context, RoutePaths.productDetail,
            arguments: holder);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PsDimens.space4),
            color:
                Utils.isLightMode(context) ? Colors.white70 : Colors.black12),
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(width: 50, height: 50, child: _imageWidget),
            const SizedBox(
              width: PsDimens.space12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
// 'dddd'

                      widget.itemData!.title!,
                      style: Theme.of(context).textTheme.titleMedium),
                  _spacingWidget,
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.itemData!.price != null &&
                                    widget.itemData!.price != '0' &&
                                    widget.itemData!.price != ''
                                ? '${widget.itemData!.itemCurrency!.currencySymbol} ${Utils.getPriceFormat(widget.itemData!.price!, valueHolder.priceFormat!)} ( ${widget.itemData!.conditionOfItem!.name} )'
                                : Utils.getString(context, 'item_price_free'),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(width: PsDimens.space8),
                        if (widget.chatFlag == PsConst.CHAT_FROM_BUYER &&
                            widget.itemData!.isSoldOut == '1')
                          Container(
                            width: PsDimens.space44,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(PsDimens.space8),
                                color: PsColors.activeColor),
                            padding: const EdgeInsets.all(PsDimens.space2),
                            child: Text(
                              Utils.getString(context, 'chat_view__sold'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall?.copyWith(color: PsColors.baseColor),
                            ),
                          )
                        else if (widget.chatFlag == PsConst.CHAT_FROM_SELLER &&
                            widget.itemData!.isSoldOut == '1')
                          Container(
                            width: PsDimens.space44,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(PsDimens.space8),
                                color: PsColors.activeColor),
                            padding: const EdgeInsets.all(PsDimens.space2),
                            child: Text(
                              Utils.getString(context, 'chat_view__sold'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall?.copyWith(color: PsColors.baseColor),
                            ),
                          )
                        else
                          Container(
                            width: PsDimens.space44,
                            height: PsDimens.space12,
                          )
                      ])
                ],
              ),
            ),
            Consumer<GetChatHistoryProvider>(builder: (BuildContext context,
                GetChatHistoryProvider getChatHistoryProvider, Widget? child) {
              if (getChatHistoryProvider.chatHistory.data == null) {
                return Container();
              }
              bool _showOffer = true;
              if (getChatHistoryProvider.chatHistory.data!.id != '') {
                if (getChatHistoryProvider.chatHistory.data!.isOffer == '1') {
                  _showOffer = false;
                }
              }
              return InkWell(
                  onTap: () {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ChatMakeOfferDialog(
                            itemDetail: widget.itemData,
                            onMakeOfferTap: (String price) async {
                              await PsProgressDialog.showDialog(context);

                              if (widget.chatFlag == PsConst.CHAT_FROM_BUYER) {
                                holder = MakeOfferParameterHolder(
                                    itemId: widget.itemData!.id,
                                    buyerUserId: widget.buyerUserId == ''
                                        ? widget.sendByUserId
                                        : widget.buyerUserId,
                                    sellerUserId: widget.sellerUserId == ''
                                        ? widget.itemData!.user!.userId
                                        : widget.sellerUserId,
                                    type: PsConst.CHAT_TO_BUYER,
                                    negoPrice: price,
                                    isUserOnline: widget.isUserOnline);

                                _apiStatus = await widget.chatHistoryProvider!
                                        .postRejectedOffer(
                                            holder.toMap(), widget.sendByUserId);

                                if (_apiStatus.data != null) {
                                  setState(() {
// _isOffer = _apiStatus.data.isOffer;
                                  });
                                }
                              } else {
                                holder = MakeOfferParameterHolder(
                                    itemId: widget.itemData!.id,
                                    sellerUserId: widget.sellerUserId == ''
                                        ? widget.itemData!.user!.userId
                                        : widget.sellerUserId,
                                    buyerUserId: widget.buyerUserId == ''
                                        ? widget.sendByUserId
                                        : widget.buyerUserId,
                                    type: PsConst.CHAT_TO_SELLER,
                                    negoPrice: price,
                                    isUserOnline: widget.isUserOnline);
                                _apiStatus = await widget.chatHistoryProvider!
                                    .postRejectedOffer(
                                        holder.toMap(), widget.sendByUserId);

                                if (_apiStatus.data != null) {
                                  setState(() {
// _isOffer = _apiStatus.data.isOffer;
                                  });
                                }
                              }

                              final String makeOfferMessae =
                                  '${widget.itemData!.itemCurrency!.currencySymbol} $price';
                              await widget.insertDataToFireBase(
                                  '',
                                  false,
                                  false,
                                  widget.itemData!.id,
                                  makeOfferMessae,
                                  PsConst.CHAT_STATUS_OFFER,
                                  widget.sendByUserId,
                                  widget.sessionId,
                                  PsConst.CHAT_TYPE_OFFER);

                              PsProgressDialog.dismissDialog();
                            },
                          );
                        });
                  },
                  child: widget.chatFlag != PsConst.CHAT_FROM_BUYER &&
                          widget.itemData!.isSoldOut == PsConst.ZERO &&
                          _showOffer
                      ? Container(
                          width: PsDimens.space72,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: PsColors.activeColor,
                            borderRadius:
                                BorderRadius.circular(PsDimens.space4),
                            border: Border.all(
                                color: Utils.isLightMode(context)
                                    ? Colors.grey[200]!
                                    : Colors.black87),
                          ),
                          child: Ink(
                            color: PsColors.backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(PsDimens.space8),
                              child: Text(
                                Utils.getString(context,
                                    'chat_view__make_offer_button_name'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium?.copyWith(color: PsColors.baseColor),
                              ),
                            ),
                          ),
                        )
                      : Container());
            })
          ],
        ),
      ),
    );
  }
}

class _ChatMakeOfferSenderBoxWidget extends StatelessWidget {
  const _ChatMakeOfferSenderBoxWidget({
    required this.messageObj,
    required this.itemDetail,
    required this.psValueHolder
  });
  final Message messageObj;
  final Product? itemDetail;
  final PsValueHolder psValueHolder;
  @override
  Widget build(BuildContext context) {
    print(
        '******Make Offer time ${Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp)}');
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          child: Text(
            Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PsDimens.space4),
              color: Colors.yellow[200]),
          padding: const EdgeInsets.all(PsDimens.space12),
          child: Column(
            children: <Widget>[
              Text(
                Utils.getString(context, 'chat_view__make_offer_message'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
              ),
              const SizedBox(height: PsDimens.space12),
              Text(
                itemDetail!.price != '0'
                    ? Utils.getChatPriceFormat(messageObj.message!, psValueHolder.priceFormat!)
                    : Utils.getString(context, 'item_price_free'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge?.copyWith(color: PsColors.textPrimaryColorForLight),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// class _ChatMakeOfferReceiverBoxWidget extends StatelessWidget {
//   const _ChatMakeOfferReceiverBoxWidget({@required this.messageObj});
//   final Message messageObj;
//   @override
//   Widget build(BuildContext context) {
//     print(
//         '******Make Offer time ${Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp)}');
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: <Widget>[
//         Container(
//           alignment: Alignment.center,
//           margin: const EdgeInsets.only(
//               left: PsDimens.space8,
//               right: PsDimens.space8,
//               top: PsDimens.space16),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(PsDimens.space4),
//               color: Colors.yellow[200]),
//           padding: const EdgeInsets.all(PsDimens.space12),
//           child: Column(
//             children: <Widget>[
//               Text(
//                 Utils.getString(context, 'chat_view__make_offer_message'),
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context)
//                     .textTheme
//                     .subtitle1
//                     .copyWith(color: PsColors.textPrimaryColorForLight),
//               ),
//               const SizedBox(height: PsDimens.space12),
//               Text(
//                 messageObj.message,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context)
//                     .textTheme
//                     .headline6
//                     .copyWith(color: PsColors.textPrimaryColorForLight),
//               ),
//             ],
//           ),
//         ),
//         Text(
//           Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
//           style: Theme.of(context).textTheme.caption,
//         ),
//       ],
//     );
//   }
// }

class _ChatAcceptedOrRejectedOfferReceiverBoxWidget extends StatelessWidget {
  const _ChatAcceptedOrRejectedOfferReceiverBoxWidget({
    required this.messageObj,
    required this.itemDetail,
    required this.psValueHolder
  });
  final Message messageObj;
  final Product? itemDetail;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PsDimens.space4),
              color: messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT
                  ? Colors.lightGreen[100]
                  : Colors.red[100]),
          padding: const EdgeInsets.all(PsDimens.space12),
          child: Column(
            children: <Widget>[
              Text(
                messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT
                    ? Utils.getString(
                        context, 'chat_view__accept_offer_message')
                    : Utils.getString(
                        context, 'chat_view__reject_offer_message'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
              ),
              const SizedBox(height: PsDimens.space12),
              Text(
                itemDetail!.price != '0'
                    ? Utils.getChatPriceFormat(messageObj.message!, psValueHolder.priceFormat!)
                    : Utils.getString(context, 'item_price_free'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge?.copyWith(color: PsColors.textPrimaryColorForLight),
              ),
            ],
          ),
        ),
        Text(
          Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ChatAcceptedOrRejectedOfferSenderBoxWidget extends StatelessWidget {
  const _ChatAcceptedOrRejectedOfferSenderBoxWidget({
    required this.messageObj,
    required this.itemDetail,
    required this.psValueHolder,
  });
  final Message messageObj;
  final Product? itemDetail;
  final PsValueHolder psValueHolder;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PsDimens.space4),
              color: messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT
                  ? Colors.green[200]
                  : Colors.red[100]),
          padding: const EdgeInsets.all(PsDimens.space12),
          child: Column(
            children: <Widget>[
              Text(
                messageObj.offerStatus == PsConst.CHAT_STATUS_ACCEPT
                    ? Utils.getString(
                        context, 'chat_view__accept_offer_message')
                    : Utils.getString(
                        context, 'chat_view__reject_offer_message'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium?.copyWith(color: PsColors.textPrimaryColorForLight),
              ),
              const SizedBox(height: PsDimens.space12),
              Text(
                itemDetail!.price != '0'
                    ? Utils.getChatPriceFormat(messageObj.message!, psValueHolder.priceFormat!)
                    : Utils.getString(context, 'item_price_free'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge?.copyWith(color: PsColors.textPrimaryColorForLight),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
