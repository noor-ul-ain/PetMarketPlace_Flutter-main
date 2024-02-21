
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/provider/item_location/item_location_provider.dart';
import 'package:flutterbuyandsell/repository/item_location_repository.dart';
import 'package:flutterbuyandsell/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/search_bar_view.dart';
import 'item_entry_location_list_view_item.dart';

class ItemEntryLocationView extends StatefulWidget {
  // const ItemEntryLocationView({@required this.categoryId});

  @override
  State<StatefulWidget> createState() {
    return ItemEntryLocationViewState();
  }
}

class ItemEntryLocationViewState extends State<ItemEntryLocationView>
    with TickerProviderStateMixin {

  ItemEntryLocationViewState() {

    searchBar = SearchBarView(
        inBar: true,
        controller: searchTextController,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print('cleared');
        },
        closeOnSubmit: false,
        onClosed: resetDataList);
  }

  final ScrollController _scrollController = ScrollController();

  late ItemLocationProvider _itemLocationProvider;
  AnimationController? animationController;
  Animation<double>? animation;
  PsValueHolder? valueHolder;
  late TextEditingController searchTextController = TextEditingController();
  late SearchBarView searchBar;

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
        _itemLocationProvider.nextItemLocationList(
            _itemLocationProvider.latestLocationParameterHolder.toMap(),
            _itemLocationProvider.psValueHolder!.loginUserId);
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

    AppBar buildAppBar(BuildContext context) {
    searchTextController.clear();
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
      ),
      backgroundColor: PsColors.baseColor,
      iconTheme:
          Theme.of(context).iconTheme.copyWith(color: PsColors.iconColor),
      title:  Text( Utils.getString(context, 'item_entry__location'),style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)
              .copyWith(color: PsColors.textColor2)),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search, color: PsColors.iconColor),
          onPressed: () {
            searchBar.beginSearch(context);
          },
        ),
      ],
      elevation: 0,
    );
  }

  void resetDataList() {
      _itemLocationProvider.latestLocationParameterHolder.keyword = '';
      _itemLocationProvider.resetItemLocationList(
          _itemLocationProvider.latestLocationParameterHolder.toMap(),
          Utils.checkUserLoginId(valueHolder!));

  }

    void onSubmitted(String value) {
 
      _itemLocationProvider.latestLocationParameterHolder.keyword = value;
      _itemLocationProvider.resetItemLocationList(
          _itemLocationProvider.latestLocationParameterHolder.toMap(),
          Utils.checkUserLoginId(valueHolder!));
  }


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

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<ItemLocationProvider?>(
              lazy: false,
              create: (BuildContext context) {
                final ItemLocationProvider provider = ItemLocationProvider(
                    repo: repo1, psValueHolder: valueHolder, limit: valueHolder!.defaultLoadingLimit!);

             provider.latestLocationParameterHolder.keyword = '';
                 provider.loadItemLocationList(
                     provider.latestLocationParameterHolder.toMap(),
                     Utils.checkUserLoginId(provider.psValueHolder!));
                 _itemLocationProvider = provider;
                 return _itemLocationProvider;

              }),

        ],
     child: Consumer<ItemLocationProvider>(
          builder:
              (BuildContext context, ItemLocationProvider provider, Widget? child) {
    return  WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
         appBar: searchBar.build(context),
        body: Stack(children: <Widget>[
                Container(
                    child: RefreshIndicator(
                  child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: provider.itemLocationList.data!.length,
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
                              provider.itemLocationList.data!.length;
                          animationController!.forward();
                          return FadeTransition(
                              opacity: animation!,
                              child: ItemEntryLocationListViewItem(
                                itemLocation:
                                    provider.itemLocationList.data![index],
                                onTap: () {
                                  Navigator.pop(context,
                                      provider.itemLocationList.data![index]);
                                  print(provider
                                      .itemLocationList.data![index].name);
                                  // if (index == 0) {
                                  //   Navigator.pushNamed(
                                  //     context,
                                  //     RoutePaths.searchCategory,
                                  //   );
                                  // }
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
                        provider.psValueHolder!.loginUserId);
                  },
                )),
                PSProgressIndicator(provider.itemLocationList.status)
              ])
      ));
              }));
  }
}
