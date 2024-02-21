import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/noti/noti_provider.dart';
import 'package:flutterbuyandsell/repository/noti_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar_no_app_bar_title.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/noti_parameter_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../item/noti_list_item.dart';

class NotiListView extends StatefulWidget {
  @override
  _NotiListViewState createState() {
    return _NotiListViewState();
  }
}

class _NotiListViewState extends State<NotiListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late NotiProvider _notiProvider;

  AnimationController? animationController;

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final String? loginUserId = Utils.checkUserLoginId(psValueHolder!);
        final GetNotiParameterHolder getNotiParameterHolder =
            GetNotiParameterHolder(
          userId: loginUserId,
          deviceToken: _notiProvider.psValueHolder!.deviceToken,
        );
        _notiProvider.nextNotiList(getNotiParameterHolder.toMap());
      }
    });
  }

  NotiRepository? repo1;
  PsValueHolder? psValueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  late PsValueHolder valueHolder;
  String? selected = '';

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && valueHolder.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    if (!isConnectedToInternet && valueHolder.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    timeDilation = 1.0;
    repo1 = Provider.of<NotiRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBarNoAppBarTitle<NotiProvider>(
          // appBarTitle: '',
          initProvider: () {
        return NotiProvider(repo: repo1, psValueHolder: psValueHolder);
      }, onProviderReady: (NotiProvider provider) {
        final String? loginUserId = Utils.checkUserLoginId(psValueHolder!);

        final GetNotiParameterHolder getNotiParameterHolder =
            GetNotiParameterHolder(
          userId: loginUserId,
          deviceToken: provider.psValueHolder!.deviceToken,
        );
        provider.getNotiList(getNotiParameterHolder.toMap());

        _notiProvider = provider;
      }, builder: (BuildContext context, NotiProvider provider, Widget? child) {
        if (provider.notiList.data != null &&
            provider.notiList.data!.isNotEmpty)
          return Container(
            color: PsColors.baseColor,
            child: Column(
              children: <Widget>[
                const PsAdMobBannerWidget(
                  admobSize: AdSize.banner,
                ),
                Expanded(
                  child: Stack(children: <Widget>[
                    Container(
                    //    color: PsColors.primaryDarkWhite,
                        child: RefreshIndicator(
                          child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              itemCount: provider.notiList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final int count = provider.notiList.data!.length;
                                return NotiListItem(
                                  animationController: animationController,
                                  animation:
                                      Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                    
                                  ),
                                  noti: provider.notiList.data![index],
                                  // onTapColor: selected == provider.notiList.data![index].id ? 
                                  //     PsColors.baseColor
                                  //     : PsColors.baseColor
                                  // ,
                                  onTap: () async {
                                    print(provider.notiList.data![index]
                                        .defaultPhoto!.imgPath);

                                    final dynamic retrunData =
                                        await Navigator.pushNamed(
                                      context,
                                      RoutePaths.noti,
                                      arguments: provider.notiList.data![index],
                                    );
                                    if (retrunData != null &&
                                        retrunData is PsValueHolder) {
                                      final String? loginUserId =
                                          Utils.checkUserLoginId(psValueHolder!);

                                      final GetNotiParameterHolder
                                          getNotiParameterHolder =
                                          GetNotiParameterHolder(
                                        userId: loginUserId,
                                        deviceToken:
                                            provider.psValueHolder!.deviceToken,
                                      );
                                      return provider.resetNotiList(
                                          getNotiParameterHolder.toMap());
                                    }
                                    if (retrunData != null && retrunData) {
                                      print('Return data ');
                                    } else {
                                      print('Return datafalse ');
                                    }
                                  },
                                );
                              }),
                          onRefresh: () async {
                            final GetNotiParameterHolder getNotiParameterHolder =
                                GetNotiParameterHolder(
                              userId: provider.psValueHolder!.loginUserId,
                              deviceToken: provider.psValueHolder!.deviceToken,
                            );

                            return provider
                                .resetNotiList(getNotiParameterHolder.toMap());
                          },
                        )),
                    PSProgressIndicator(provider.notiList.status)
                  ]),
                )
              ],
            ),
          );
        else
          return Container();
      }),
    );
  }
}
