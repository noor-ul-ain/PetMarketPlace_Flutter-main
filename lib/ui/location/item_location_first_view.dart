import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/item_location/item_location_provider.dart';
import 'package:flutterbuyandsell/repository/item_location_repository.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/common/search_bar_view.dart';
import 'package:flutterbuyandsell/ui/location/item_location_list_item.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/location_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/item_location.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ItemLocationFirstView extends StatefulWidget {

  @override
  _ItemLocationFirstViewState createState() => _ItemLocationFirstViewState();
}

class _ItemLocationFirstViewState extends State<ItemLocationFirstView>
    with TickerProviderStateMixin {

  _ItemLocationFirstViewState() {

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
  AnimationController? animationController;
  late ItemLocationProvider _itemLocationProvider;
  PsValueHolder? valueHolder;
  late TextEditingController searchTextController = TextEditingController();
  late SearchBarView searchBar;
  int i = 0;


  @override
  void dispose() {
    // animation = null;
    super.dispose();
  }

  AppBar buildAppBar(BuildContext context) {
    searchTextController.clear();
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
      ),
      backgroundColor: PsColors.baseColor,
      iconTheme:
          Theme.of(context).iconTheme.copyWith(color: PsColors.iconColor),
      title: const Text( '', ),
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
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _itemLocationProvider.nextItemLocationList(
            _itemLocationProvider.latestLocationParameterHolder.toMap(),
            Utils.checkUserLoginId(_itemLocationProvider.psValueHolder!));
      }
    });

    super.initState();
  }

  ItemLocationRepository? repo1;
  dynamic data;

  @override
  Widget build(BuildContext context) {
    // data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<ItemLocationRepository>(context);
    valueHolder = Provider.of<PsValueHolder?>(context);
    print(
        '............................Build Item Location UI Again ............................');

    // return PsWidgetWithAppBar<ItemLocationProvider>(
    //   appBarTitle: '',
    //   initProvider:
    //     () {
    //   return ItemLocationProvider(repo: repo1, psValueHolder: valueHolder);
    // }, onProviderReady: (ItemLocationProvider provider) {
    //   provider.latestLocationParameterHolder.keyword = '';
    //   provider.loadItemLocationList(
    //       provider.latestLocationParameterHolder.toMap(),
    //       Utils.checkUserLoginId(provider.psValueHolder!));
    //   _itemLocationProvider = provider;
    // }, builder:
    //     (BuildContext context, ItemLocationProvider provider, Widget? child) {
    //   return ItemLocationListViewWidget(
    //     scrollController: _scrollController,
    //    animationController: animationController,
    //   );
    // },
    // );

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
            return  Scaffold(
               appBar: searchBar.build(context),
              body: ItemLocationListViewWidget(
                scrollController: _scrollController,
                animationController: animationController,
               ),
            );
          }),
       );
  }
}

class ItemLocationListViewWidget extends StatefulWidget {
  const ItemLocationListViewWidget(
      {Key? key,
      required this.scrollController,
    required this.animationController
      })
      : super(key: key);

  final ScrollController scrollController;
 final AnimationController? animationController;

  @override
  _ItemLocationListViewWidgetState createState() =>
      _ItemLocationListViewWidgetState();
}

LocationParameterHolder locationParameterHolder =
    LocationParameterHolder().getDefaultParameterHolder();
//final TextEditingController searchNameController = TextEditingController();

class _ItemLocationListViewWidgetState
    extends State<ItemLocationListViewWidget> {
  Widget? _widget;
  late PsValueHolder valueHolder;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    final ItemLocationProvider _provider = Provider.of(context, listen: false);
    _widget ??= Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Consumer<ItemLocationProvider>(builder: (BuildContext context,
            ItemLocationProvider provider, Widget? child) {
          print('Refresh Progress Indicator');

          return PSProgressIndicator(provider.itemLocationList.status,
              message: provider.itemLocationList.message);
        }),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
                    Utils.getString(context, 'Seletct Your City'),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Utils.isLightMode(context) ? PsColors.secondary400 : PsColors.primaryDarkWhite)),
      ),
        Expanded(
          child: RefreshIndicator(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Selector<ItemLocationProvider, List<ItemLocation>?>(
                  child: Container(),
                  selector:
                      (BuildContext context, ItemLocationProvider provider) {
                    print(
                        'Selector ${provider.itemLocationList.data.toString()}');
                    return provider.itemLocationList.data;
                  },
                  builder: (BuildContext context, List<ItemLocation>? dataList,
                      Widget? child) {
                    print('Builder');
                    return ListView.builder(
                        controller: widget.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: dataList!.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = dataList.length + 1;
                          // ignore: unnecessary_null_comparison
                         // if (dataList != null || dataList.isNotEmpty) {
                            return ItemLocationListItem(
                              animationController: widget.animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: widget.animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              itemLocation: index == 0
                                  ? Utils.getString(
                                      context, 'product_list__category_all')
                                  : dataList[index - 1].name,
                              onTap: () async {
                                    // Navigator.pop(
                                    // context,
                                    // _provider
                                    //     .itemLocationList.data![index -1]);
                                      if (index == 0) {
                                  await _provider.replaceItemLocationData(
                                      '',
                                      Utils.getString(context,
                                          'product_list__category_all'),
                                      PsConst.INVALID_LAT_LNG,
                                      PsConst.INVALID_LAT_LNG);

                                  await _provider
                                      .replaceItemLocationTownshipData(
                                    '',
                                    '',
                                    Utils.getString(
                                        context, 'product_list__category_all'),
                                    PsConst.INVALID_LAT_LNG,
                                    PsConst.INVALID_LAT_LNG,
                                  );

                                  // if (valueHolder.isSubLocation ==
                                  //     PsConst.ONE) {
                                  //   Navigator.pushReplacementNamed(context,
                                  //       RoutePaths.itemLocationTownshipList,
                                  //       arguments: '');
                                  // } else {
                                  Navigator.pushReplacementNamed(
                                      context, RoutePaths.home);
                                  // }
                                } else {
                                    Navigator.pop(
                                    context,
                                    _provider
                                        .itemLocationList.data![index -1]);
                                  await _provider.replaceItemLocationData(
                                      dataList[index - 1].id,
                                      dataList[index - 1].name!,
                                      dataList[index - 1].lat!,
                                      dataList[index - 1].lng!);
                                //   // if (valueHolder.isSubLocation ==
                                //   //     PsConst.ONE) {
                                //   //   Navigator.pushReplacementNamed(context,
                                //   //       RoutePaths.itemLocationTownshipList,
                                //   //       arguments: dataList[index - 1].id);
                                //   // } else {
                                //     Navigator.pushReplacementNamed(
                                //         context, RoutePaths.itemLocationTownshipFirst,arguments:dataList[index - 1].id );
                                //  // }
                                }
                              },
                            );
                          // } else {
                          //   return Container();
                          // }
                        });
                  }),
            ),
            onRefresh: () {
              return _provider.resetItemLocationList(
                  _provider.latestLocationParameterHolder.toMap(),
                  _provider.psValueHolder!.loginUserId);
            },
          ),
        )
      ],
    );
    print('Widget ${_widget.hashCode}');
    return _widget!;
  }
}

