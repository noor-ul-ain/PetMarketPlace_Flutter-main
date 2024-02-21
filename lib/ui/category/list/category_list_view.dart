

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/category/category_provider.dart';
import 'package:flutterbuyandsell/repository/category_repository.dart';
import 'package:flutterbuyandsell/ui/category/item/category_vertical_list_item.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/category_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class CategoryListView extends StatefulWidget {
  @override
  _CategoryListViewState createState() {
    return _CategoryListViewState();
  }
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CategoryProvider? _categoryProvider;
  final CategoryParameterHolder categoryParameterHolder =
      CategoryParameterHolder();

  AnimationController? animationController;
  Animation<double>? animation;

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
        _categoryProvider!.nextCategoryList(
            _categoryProvider!.categoryParameterHolder.toMap(),
            Utils.checkUserLoginId(_categoryProvider!.psValueHolder!));
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  CategoryRepository? repo1;
  PsValueHolder? psValueHolder;
  dynamic data;
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

    
    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child:
            // EasyLocalizationProvider(
            //     data: data,
            // child:
            ChangeNotifierProvider<CategoryProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  final CategoryProvider provider = CategoryProvider(
                      repo: repo1, psValueHolder: psValueHolder);
                  provider.loadCategoryList(
                      provider.categoryParameterHolder.toMap(),
                      Utils.checkUserLoginId(provider.psValueHolder!));
                  _categoryProvider = provider;
                  return _categoryProvider;
                },
                child: Consumer<CategoryProvider>(builder:
                    (BuildContext context, CategoryProvider provider,
                        Widget? child) {
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
                              //  color: PsColors.baseColor,
                                margin: const EdgeInsets.all(PsDimens.space8),
                                child: RefreshIndicator(
                                  child: CustomScrollView(
                                      controller: _scrollController,
                                      scrollDirection: Axis.vertical,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: false,
                                      slivers: <Widget>[
                                        SliverGrid(
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 100.0,
                                                  childAspectRatio: 0.8),
                                          delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                              if (provider.categoryList.data !=
                                                      null ||
                                                  provider.categoryList.data!
                                                      .isNotEmpty) {
                                                final int count = provider
                                                    .categoryList.data!.length;
                                                return CategoryVerticalListItem(
                                                  animationController:
                                                      animationController,
                                                  animation: Tween<double>(
                                                          begin: 0.0, end: 1.0)
                                                      .animate(CurvedAnimation(
                                                    parent: animationController!,
                                                    curve: Interval(
                                                        (1 / count) * index, 1.0,
                                                        curve:
                                                            Curves.fastOutSlowIn),
                                                  )),
                                                  category: provider
                                                      .categoryList.data![index],
                                                  onTap: () {
                                                    if (Utils.showUI(psValueHolder!.subCatId)) {
                                                      Navigator.pushNamed(
                                                          context,
                                                          RoutePaths
                                                              .subCategoryGrid,
                                                          arguments: provider
                                                              .categoryList
                                                              .data![index]);
                                                    } else {
                                                      final ProductParameterHolder
                                                          productParameterHolder =
                                                          ProductParameterHolder()
                                                              .getLatestParameterHolder();
                                                      productParameterHolder.mile = psValueHolder!.mile;        
                                                      productParameterHolder
                                                              .catId =
                                                          provider.categoryList
                                                              .data![index].catId;
                                                      Navigator.pushNamed(
                                                          context,
                                                          RoutePaths
                                                              .filterProductList,
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
                    ),
                  );
                })

                // )
                ));
  }
}
