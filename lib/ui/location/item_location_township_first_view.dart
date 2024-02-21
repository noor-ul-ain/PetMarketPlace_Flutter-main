import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/item_location_township/item_location_township_provider.dart';
import 'package:flutterbuyandsell/repository/item_location_township_repository.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/location/item_location_view.dart';
import 'package:flutterbuyandsell/ui/location_township/item_location_township_list_item.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/location_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/item_location_township.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../common/search_bar_view.dart';

class ItemLocationTownshipFirstView extends StatefulWidget {
  const ItemLocationTownshipFirstView(
      {Key? key, required this.cityId,  })
      : super(key: key);

  final String cityId;
  //final AnimationController? animationController;
  @override
  _ItemLocationTownshipFirstViewState createState() =>
      _ItemLocationTownshipFirstViewState();
}

class _ItemLocationTownshipFirstViewState extends State<ItemLocationTownshipFirstView>
    with TickerProviderStateMixin {

  _ItemLocationTownshipFirstViewState() {

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
  late ItemLocationTownshipProvider _itemLocationProvider;
  late TextEditingController searchTextController = TextEditingController();
  late SearchBarView searchBar;
  PsValueHolder? valueHolder;
  // Animation<double> animation;
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
      _itemLocationProvider.resetItemLocationTownshipListByCityId(
          _itemLocationProvider.latestLocationParameterHolder.toMap(),
          Utils.checkUserLoginId(valueHolder!),widget.cityId);

  }

    void onSubmitted(String value) {
 
      _itemLocationProvider.latestLocationParameterHolder.keyword = value;
      _itemLocationProvider.resetItemLocationTownshipListByCityId(
          _itemLocationProvider.latestLocationParameterHolder.toMap(),
          Utils.checkUserLoginId(valueHolder!),widget.cityId);
  }

  @override
  void initState() {
        animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _itemLocationProvider.nextItemLocationTownshipListByCityId(
            _itemLocationProvider.latestLocationParameterHolder.toMap(),
            _itemLocationProvider.psValueHolder!.loginUserId,
            widget.cityId);
      }
    });

    super.initState();
  }

  ItemLocationTownshipRepository? repo1;
  dynamic data;

  @override
  Widget build(BuildContext context) {
    // data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<ItemLocationTownshipRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build Item Location Township UI Again ............................');

    // return PsWidgetWithAppBar<ItemLocationTownshipProvider>(
    //    appBarTitle: '',
    //     initProvider: () {
    //   return ItemLocationTownshipProvider(
    //       repo: repo1, psValueHolder: valueHolder);
    // }, onProviderReady: (ItemLocationTownshipProvider provider) {
    //   provider.latestLocationParameterHolder.keyword =
    //       searchTownshipNameController.text;
    //   provider.loadItemLocationTownshipListByCityId(
    //       provider.latestLocationParameterHolder.toMap(),
    //       Utils.checkUserLoginId(provider.psValueHolder!),
    //       widget.cityId);
    //   _itemLocationProvider = provider;
    // }, builder: (BuildContext context, ItemLocationTownshipProvider provider,
    //         Widget? child) {
    //   return ItemLocationListViewWidget(
    //     cityId: widget.cityId,
    //     scrollController: _scrollController,
    //     animationController: animationController,
    //   );
    // });

            return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<ItemLocationTownshipProvider?>(
              lazy: false,
              create: (BuildContext context) {
                final ItemLocationTownshipProvider provider = ItemLocationTownshipProvider(
                    repo: repo1, psValueHolder: valueHolder, limit: valueHolder!.defaultLoadingLimit!);

                    provider.latestLocationParameterHolder.keyword =
                        searchTownshipNameController.text;
                    provider.loadItemLocationTownshipListByCityId(
                        provider.latestLocationParameterHolder.toMap(),
                        Utils.checkUserLoginId(provider.psValueHolder!),
                        widget.cityId);
                    _itemLocationProvider = provider;
                 return _itemLocationProvider;

              }),

        ],
        child: Consumer<ItemLocationTownshipProvider>(
          builder:
              (BuildContext context, ItemLocationTownshipProvider provider, Widget? child) {
            return  Scaffold(
               appBar: searchBar.build(context),
              body: ItemLocationListViewWidget(
                cityId: widget.cityId,
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
      required this.cityId,
      required this.scrollController,
      required this.animationController})
      : super(key: key);

  final String cityId;
  final ScrollController scrollController;
  final AnimationController? animationController;

  @override
  _ItemLocationListViewWidgetState createState() =>
      _ItemLocationListViewWidgetState();
}

LocationParameterHolder locationParameterHolder =
    LocationParameterHolder().getDefaultParameterHolder();


class _ItemLocationListViewWidgetState
    extends State<ItemLocationListViewWidget> {
  Widget? _widget;
  PsValueHolder? valueHolder;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    final ItemLocationTownshipProvider _provider =
        Provider.of(context, listen: false);
    _widget ??= Column(
      mainAxisSize: MainAxisSize.max,
       crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      
        Consumer<ItemLocationTownshipProvider>(builder: (BuildContext context,
            ItemLocationTownshipProvider provider, Widget? child) {
          print('Refresh Progress Indicator');

          return PSProgressIndicator(provider.itemLocationTownshipList.status,
              message: provider.itemLocationTownshipList.message);
        }),
              Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
                    Utils.getString(context, 'Seletct Your Township'),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Utils.isLightMode(context) ? PsColors.secondary400 : PsColors.primaryDarkWhite)),
      ),
        Expanded(
          child: 
          RefreshIndicator(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Selector<ItemLocationTownshipProvider,
                      List<ItemLocationTownship>?>(
                  child: Container(),
                  selector: (BuildContext context,
                      ItemLocationTownshipProvider provider) {
                    print(
                        'Selector ${provider.itemLocationTownshipList.data.hashCode}');
                    return provider.itemLocationTownshipList.data;
                  },
                  builder: (BuildContext context,
                      List<ItemLocationTownship>? dataList, Widget? child) {
                    print('Builder');
                    return ListView.builder(
                        controller: widget.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: dataList!.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = dataList.length + 1;
                          if (dataList.isNotEmpty) {
                            return ItemLocationTownshipListItem(
                              animationController: widget.animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: widget.animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              itemLocationTownship: index == 0
                                  ? Utils.getString(
                                      context, 'product_list__category_all')
                                  : dataList[index - 1].townshipName,
                              onTap: () async {
                                    //   await _provider
                                    //   .replaceItemLocationTownshipData(
                                    //       dataList[index - 1].id!,
                                    //       dataList[index - 1].cityId!,
                                    //       dataList[index - 1].townshipName!,
                                    //       dataList[index - 1].lat!,
                                    //       dataList[index - 1].lng!);
                                    // Navigator.pop(
                                    // context,
                                    // _provider
                                    //     .itemLocationTownshipList.data![index -1]);
                                if (index == 0) {
                                  await _provider
                                      .replaceItemLocationTownshipData(
                                    '',
                                    dataList[index].cityId!,
                                    Utils.getString(
                                        context, 'product_list__category_all'),
                                    dataList[index].lat!,
                                    dataList[index].lng!,
                                  );
                                  Navigator.pushReplacementNamed(
                                      context, RoutePaths.home);
                                } else {
                                  await _provider
                                      .replaceItemLocationTownshipData(
                                          dataList[index - 1].id!,
                                          dataList[index - 1].cityId!,
                                          dataList[index - 1].townshipName!,
                                          dataList[index - 1].lat!,
                                          dataList[index - 1].lng!);
                                  Navigator.pushReplacementNamed(
                                      context, RoutePaths.home);
                                }
                              },
                            );
                          } else {
                            return Container();
                          }
                        });
                  }),
            ),
            onRefresh: () {
              return _provider.resetItemLocationTownshipListByCityId(
                  _provider.latestLocationParameterHolder.toMap(),
                  Utils.checkUserLoginId(_provider.psValueHolder!),
                  widget.cityId);
            },
          ),
        )
      ],
    );
    print('Widget ${_widget.hashCode}');
    return _widget!;
  }
}

