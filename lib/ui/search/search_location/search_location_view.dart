import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/provider/item_location/item_location_provider.dart';
import 'package:flutterbuyandsell/repository/item_location_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/location_township/item_location_township_view.dart';
import 'package:flutterbuyandsell/ui/search/search_location/search_location_list_view_item.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SearchLocationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchLocationViewState();
  }
}

class SearchLocationViewState extends State<SearchLocationView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late ItemLocationProvider _itemLocationTownshipProvider;
  AnimationController? animationController;
  Animation<double>? animation;
  PsValueHolder? valueHolder;

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _itemLocationTownshipProvider.nextItemLocationList(
            _itemLocationTownshipProvider.latestLocationParameterHolder.toMap(),
            _itemLocationTownshipProvider.psValueHolder!.loginUserId);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController!);
    super.initState();
  }

  ItemLocationRepository? repo1;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
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

    repo1 = Provider.of<ItemLocationRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemLocationProvider>(
          appBarTitle:
              Utils.getString(context, 'item_entry__location_township'),
          initProvider: () {
            return ItemLocationProvider(
                repo: repo1, psValueHolder: valueHolder);
          },
          onProviderReady: (ItemLocationProvider provider) {
            provider.latestLocationParameterHolder.keyword =
                searchNameController.text;
            provider.loadItemLocationList(
                provider.latestLocationParameterHolder.toMap(),
                Utils.checkUserLoginId(provider.psValueHolder!));
            _itemLocationTownshipProvider = provider;
          },
          builder: (BuildContext context, ItemLocationProvider provider,
              Widget? child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.itemLocationList.data!.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemLocationList.status ==
                          PsStatus.BLOCK_LOADING) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.white,
                            child: const Column(children: <Widget>[
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                            ]));
                      } else {
                        final int count =
                            provider.itemLocationList.data!.length + 1;
                        animationController!.forward();
                        return FadeTransition(
                            opacity: animation!,
                            child: SearchLocationListViewItem(
                              itemLocationTownship: index == 0
                                  ? Utils.getString(
                                      context, 'product_list__category_all')
                                  : provider
                                      .itemLocationList.data![index - 1].name,
                              onTap: () {
                                if (index == 0) {
                                  Navigator.pop(context, true);
                                } else {
                                  Navigator.pop(
                                      context,
                                      provider
                                          .itemLocationList.data![index - 1]);
                                }
                              },
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetItemLocationList(
                      provider.latestLocationParameterHolder.toMap(),
                      Utils.checkUserLoginId(provider.psValueHolder!));
                },
              )),
              PSProgressIndicator(provider.itemLocationList.status)
            ]);
          }),
    );
  }
}
