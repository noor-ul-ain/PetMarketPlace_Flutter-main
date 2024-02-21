import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/category/category_provider.dart';
import 'package:flutterbuyandsell/repository/category_repository.dart';
import 'package:flutterbuyandsell/ui/category/item/category_vertical_list_item.dart';
import 'package:flutterbuyandsell/ui/common/dialog/filter_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/common/search_bar_view.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class CategorySortingListView extends StatefulWidget {
  @override
  _CategorySortingListViewState createState() {
    return _CategorySortingListViewState();
  }
}

class _CategorySortingListViewState extends State<CategorySortingListView>
    with SingleTickerProviderStateMixin {

  _CategorySortingListViewState() {
    searchBar = SearchBarView(
        inBar: true,
        controller: searchTextController,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        closeOnSubmit: false,
        onCleared: () {
          print('cleared');
        },
        onClosed: () {
          _categoryProvider!.categoryParameterHolder.keyword = '';
          _categoryProvider!.resetCategoryList(
              _categoryProvider!.categoryParameterHolder.toMap(), psValueHolder!.loginUserId);
        });
  }
  final ScrollController _scrollController = ScrollController();
  CategoryProvider? _categoryProvider;
  late SearchBarView searchBar;
  late TextEditingController searchTextController = TextEditingController();
  AnimationController? animationController;

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  void onSubmitted(String value) {
    _categoryProvider!.categoryParameterHolder.keyword = value;
     _categoryProvider!.resetCategoryList(
              _categoryProvider!.categoryParameterHolder.toMap(), Utils.checkUserLoginId(_categoryProvider!.psValueHolder!));
  }

  AppBar buildAppBar(BuildContext context) {
    if (_categoryProvider != null) {
      _categoryProvider!.categoryParameterHolder.keyword = '';
          _categoryProvider!.resetCategoryList(
              _categoryProvider!.categoryParameterHolder.toMap(), Utils.checkUserLoginId(_categoryProvider!.psValueHolder!));
    }
    searchTextController.clear();
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
      ),
      backgroundColor: PsColors.baseColor,
      iconTheme: Theme.of(context).iconTheme.copyWith(
        color: PsColors.iconColor
      ),
          // color: Utils.isLightMode(context)
          //     ? PsColors.primary500
          //     : PsColors.primaryDarkWhite),
      title: Text(Utils.getString(context, 'dashboard__category_list'),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)
              .copyWith(
                color: PsColors.textColor2)
                  // color: Utils.isLightMode(context)
                  //     ? PsColors.primary500
                  //     : PsColors.primaryDarkWhite)
                      ),
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

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _categoryProvider!.nextCategoryList(
            _categoryProvider!.categoryParameterHolder.toMap(),
            Utils.checkUserLoginId(_categoryProvider!.psValueHolder!));
      }
    });
  }

  CategoryRepository? repo1;
  PsValueHolder? psValueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && psValueHolder!.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    repo1 = Provider.of<CategoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
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

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: searchBar.build(context),
        body: ChangeNotifierProvider<CategoryProvider?>(
            lazy: false,
            create: (BuildContext context) {
              final CategoryProvider provider = CategoryProvider(
                  repo: repo1, psValueHolder: psValueHolder);
              _categoryProvider = provider;
              _categoryProvider!.loadCategoryList(_categoryProvider!.categoryParameterHolder.toMap(),
                Utils.checkUserLoginId(_categoryProvider!.psValueHolder!));

              return _categoryProvider;
            },
            child: Consumer<CategoryProvider>(builder: (BuildContext context,
                                            CategoryProvider provider, Widget? child) {
              return Container(
              color: PsColors.baseColor,
              child: Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(
                    admobSize: AdSize.banner,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(
                        width: PsDimens.space1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: PsDimens.space20, top: PsDimens.space16),
                        child: InkWell(
                          onTap: () {
                          showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return FilterDialog(
                              onAscendingTap: () async {
                                _categoryProvider!.categoryParameterHolder.orderBy =
                                    PsConst.FILTERING_CAT_NAME;
                                _categoryProvider!.categoryParameterHolder.orderType =
                                    PsConst.FILTERING__ASC;
                                _categoryProvider!.resetCategoryList(
                                    _categoryProvider!.categoryParameterHolder.toMap(),
                                    Utils.checkUserLoginId(
                                        _categoryProvider!.psValueHolder!));
                              },
                              onDescendingTap: () {
                                _categoryProvider!.categoryParameterHolder.orderBy =
                                    PsConst.FILTERING_CAT_NAME;
                                _categoryProvider!.categoryParameterHolder.orderType =
                                    PsConst.FILTERING__DESC;
                                _categoryProvider!.resetCategoryList(
                                    _categoryProvider!.categoryParameterHolder.toMap(),
                                    Utils.checkUserLoginId(
                                        _categoryProvider!.psValueHolder!));
                              },
                            );
                          });
                          },
                          child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.sort_by_alpha_rounded,
                                  color: PsColors.textColor2,
                                  size: 12,
                                ),
                                const SizedBox(
                                  width: PsDimens.space4,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Text(Utils.getString(context, 'Sort'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: 16,
                                              // color: widget.searchProductProvider!
                                              //             .productParameterHolder.catId ==
                                              //         ''
                                              //     ? Utils.isLightMode(context)
                                              //         ? PsColors.secondary400
                                              //         : PsColors.primaryDarkWhite
                                              //     : PsColors.textColor1
                                                  )),
                                ),
                              ],
                            ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Stack(children: <Widget>[
                      Container(
                          margin: const EdgeInsets.all(PsDimens.space8),
                          child: RefreshIndicator(
                            child: CustomScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: false,
                                slivers: <Widget>[
                                  SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 100.0,
                                            childAspectRatio: 0.8),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        if (provider.categoryList.data != null ||
                                            provider
                                                .categoryList.data!.isNotEmpty) {
                                          final int count =
                                              provider.categoryList.data!.length;
                                          return CategoryVerticalListItem(
                                            animationController:
                                                animationController,
                                            animation: Tween<double>(
                                                    begin: 0.0, end: 1.0)
                                                .animate(CurvedAnimation(
                                              parent: animationController!,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            )),
                                            category: provider
                                                .categoryList.data![index],
                                            onTap: () {
                                              if (Utils.showUI(psValueHolder!.subCatId)) {
                                                Navigator.pushNamed(context,
                                                    RoutePaths.subCategoryGrid,
                                                    arguments: provider
                                                        .categoryList
                                                        .data![index]);
                                              } else {
                                                final ProductParameterHolder
                                                    productParameterHolder =
                                                    ProductParameterHolder()
                                                        .getLatestParameterHolder();
                                                productParameterHolder.mile = psValueHolder!.mile;        
                                                productParameterHolder.catId =
                                                    provider.categoryList
                                                        .data![index].catId;
                                                Navigator.pushNamed(context,
                                                    RoutePaths.filterProductList,
                                                    arguments:
                                                        ProductListIntentHolder(
                                                      appBarTitle: provider
                                                          .categoryList
                                                          .data![index]
                                                          .catName,
                                                      productParameterHolder:
                                                          productParameterHolder,
                                                    ));
                                              }
                                            },
                                          );
                                        } else {
                                          return null;
                                        }
                                      },
                                      childCount:
                                          provider.categoryList.data!.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              return provider.resetCategoryList(
                                  _categoryProvider!.categoryParameterHolder
                                      .toMap(),
                                  Utils.checkUserLoginId(
                                      _categoryProvider!.psValueHolder!));
                            },
                          )),
                      PSProgressIndicator(provider.categoryList.status)
                    ]),
                  )
                ],
              ));
            }),
          ),
      ));

    // return WillPopScope(
    //   onWillPop: _requestPop,
    //   child: PsWidgetWithAppBar<CategoryProvider>(
    //       appBarTitle: Utils.getString(context, 'dashboard__category_list'),
    //       actions: <Widget>[
    //         IconButton(
    //           icon: Icon(Icons.search, color: PsColors.iconColor),
    //           onPressed: () {
    //             searchBar.beginSearch(context);
    //           },
    //     ),
            // IconButton(
            //   icon: Icon(
            //       FontAwesome.filter, //MaterialCommunityIcons.filter_remove_outline,
            //       color: PsColors.activeColor),// PsColors.primary500),
            //   onPressed: () {
            //     showDialog<dynamic>(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return FilterDialog(
            //             onAscendingTap: () async {
            //               _categoryProvider.categoryParameterHolder.keyword = 'comput';
            //               _categoryProvider.categoryParameterHolder.orderBy =
            //                   PsConst.FILTERING_CAT_NAME;
            //               _categoryProvider.categoryParameterHolder.orderType =
            //                   PsConst.FILTERING__ASC;
            //               _categoryProvider.resetCategoryList(
            //                   _categoryProvider.categoryParameterHolder.toMap(),
            //                   Utils.checkUserLoginId(
            //                       _categoryProvider.psValueHolder!));
            //             },
            //             onDescendingTap: () {
            //               _categoryProvider.categoryParameterHolder.keyword = 'music';
            //               _categoryProvider.categoryParameterHolder.orderBy =
            //                   PsConst.FILTERING_CAT_NAME;
            //               _categoryProvider.categoryParameterHolder.orderType =
            //                   PsConst.FILTERING__DESC;
            //               _categoryProvider.resetCategoryList(
            //                   _categoryProvider.categoryParameterHolder.toMap(),
            //                   Utils.checkUserLoginId(
            //                       _categoryProvider.psValueHolder!));
            //             },
            //           );
            //         });
            //   },
            // )
    //       ],
    //       initProvider: () {
    //         return CategoryProvider(repo: repo1, psValueHolder: psValueHolder);
    //       },
    //       onProviderReady: (CategoryProvider provider) {
    //         provider.loadCategoryList(provider.categoryParameterHolder.toMap(),
    //             Utils.checkUserLoginId(provider.psValueHolder!));

    //         _categoryProvider = provider;
    //       },
    //       builder:
    //           (BuildContext context, CategoryProvider provider, Widget? child) {
    //         return Container(
    //           color: PsColors.baseColor,
    //           child: Column(
    //             children: <Widget>[
    //               const PsAdMobBannerWidget(
    //                 admobSize: AdSize.banner,
    //               ),
    //               Expanded(
    //                 child: Stack(children: <Widget>[
    //                   Container(
    //                       margin: const EdgeInsets.all(PsDimens.space8),
    //                       child: RefreshIndicator(
    //                         child: CustomScrollView(
    //                             controller: _scrollController,
    //                             scrollDirection: Axis.vertical,
    //                             physics: const AlwaysScrollableScrollPhysics(),
    //                             shrinkWrap: false,
    //                             slivers: <Widget>[
    //                               SliverGrid(
    //                                 gridDelegate:
    //                                     const SliverGridDelegateWithMaxCrossAxisExtent(
    //                                         maxCrossAxisExtent: 100.0,
    //                                         childAspectRatio: 0.8),
    //                                 delegate: SliverChildBuilderDelegate(
    //                                   (BuildContext context, int index) {
    //                                     if (provider.categoryList.data != null ||
    //                                         provider
    //                                             .categoryList.data!.isNotEmpty) {
    //                                       final int count =
    //                                           provider.categoryList.data!.length;
    //                                       return CategoryVerticalListItem(
    //                                         animationController:
    //                                             animationController,
    //                                         animation: Tween<double>(
    //                                                 begin: 0.0, end: 1.0)
    //                                             .animate(CurvedAnimation(
    //                                           parent: animationController!,
    //                                           curve: Interval(
    //                                               (1 / count) * index, 1.0,
    //                                               curve: Curves.fastOutSlowIn),
    //                                         )),
    //                                         category: provider
    //                                             .categoryList.data![index],
    //                                         onTap: () {
    //                                           if (PsConfig.isShowSubCategory) {
    //                                             Navigator.pushNamed(context,
    //                                                 RoutePaths.subCategoryGrid,
    //                                                 arguments: provider
    //                                                     .categoryList
    //                                                     .data![index]);
    //                                           } else {
    //                                             final ProductParameterHolder
    //                                                 productParameterHolder =
    //                                                 ProductParameterHolder()
    //                                                     .getLatestParameterHolder();
    //                                             productParameterHolder.catId =
    //                                                 provider.categoryList
    //                                                     .data![index].catId;
    //                                             Navigator.pushNamed(context,
    //                                                 RoutePaths.filterProductList,
    //                                                 arguments:
    //                                                     ProductListIntentHolder(
    //                                                   appBarTitle: provider
    //                                                       .categoryList
    //                                                       .data![index]
    //                                                       .catName,
    //                                                   productParameterHolder:
    //                                                       productParameterHolder,
    //                                                 ));
    //                                           }
    //                                         },
    //                                       );
    //                                     } else {
    //                                       return null;
    //                                     }
    //                                   },
    //                                   childCount:
    //                                       provider.categoryList.data!.length,
    //                                 ),
    //                               ),
    //                             ]),
    //                         onRefresh: () {
    //                           return provider.resetCategoryList(
    //                               _categoryProvider.categoryParameterHolder
    //                                   .toMap(),
    //                               Utils.checkUserLoginId(
    //                                   _categoryProvider.psValueHolder!));
    //                         },
    //                       )),
    //                   PSProgressIndicator(provider.categoryList.status)
    //                 ]),
    //               )
    //             ],
    //           ),
    //         );
    //       }),
    // );
  }
}
