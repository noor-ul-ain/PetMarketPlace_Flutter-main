import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/chat_history_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/chat_history.dart';
import 'package:flutterbuyandsell/viewobject/holder/chat_history_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/get_chat_history_parameter_holder.dart';

class SellerChatHistoryListProvider extends PsProvider {
  SellerChatHistoryListProvider({@required ChatHistoryRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('SellerChatHistoryListProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    chatHistoryListStream =
        StreamController<PsResource<List<ChatHistory>>>.broadcast();

    subscription = chatHistoryListStream!.stream
        .listen((PsResource<List<ChatHistory>> resource) {
      updateOffset(resource.data!.length);

      _chatHistoryList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  // PsResource<ChatHistory> _chatHistory =
  //     PsResource<ChatHistory>(PsStatus.NOACTION, '', null);
  // PsResource<ChatHistory> get chatHistory => _chatHistory;


  final ChatHistoryParameterHolder chatFromBuyerParameterHolder =
      ChatHistoryParameterHolder().getSellerHistoryList();

  bool showProgress = true;    

  ChatHistoryRepository? _repo;
  PsResource<List<ChatHistory>> _chatHistoryList =
      PsResource<List<ChatHistory>>(PsStatus.NOACTION, '', <ChatHistory>[]);

  PsResource<List<ChatHistory>> get chatHistoryList => _chatHistoryList;
  late StreamSubscription<PsResource<List<ChatHistory>>> subscription;
  StreamController<PsResource<List<ChatHistory>>>? chatHistoryListStream;
  dynamic daoSubscription;
  StreamController<PsResource<ChatHistory>>? chatHistoryStream;
  @override
  void dispose() {
    subscription.cancel();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('ChatSellerList Provider Dispose: $hashCode');
    super.dispose();
  }

  void resetShowProgress(bool show) {
    showProgress = show;
  }

  Future<dynamic> loadChatHistoryList(ChatHistoryParameterHolder holder) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    // daoSubscription =
    await _repo!.getChatHistoryList(chatHistoryListStream, isConnectedToInternet,
        limit, offset, PsStatus.PROGRESS_LOADING, holder);
  }

  Future<dynamic> loadChatHistoryListFromDB(
      ChatHistoryParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo!.getChatHistoryListFromDB(
        chatHistoryListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        holder);
  }

  Future<dynamic> nextChatHistoryList(ChatHistoryParameterHolder? holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageChatHistoryList(
          chatHistoryListStream,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          holder!);
    }
  }

  Future<void> resetChatHistoryList(ChatHistoryParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);
    await _repo!.getChatHistoryList(chatHistoryListStream, isConnectedToInternet,
        limit, offset, PsStatus.PROGRESS_LOADING, holder);

    isLoading = false;
  }

  Future<dynamic> resetUnreadMessageCount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;
    await _repo!.resetUnreadCount(chatHistoryListStream, jsonMap,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> getChatHistory(
    GetChatHistoryParameterHolder holder,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;
    daoSubscription = await _repo!.getChatHistory(chatHistoryListStream, holder,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }
}
