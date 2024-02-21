import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/product/search_product_provider.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_dropdown_base_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_special_check_text_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_textfield_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/condition_of_item.dart';
import 'package:flutterbuyandsell/viewobject/deal_option.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/item_location.dart';
import 'package:flutterbuyandsell/viewobject/item_location_township.dart';
import 'package:flutterbuyandsell/viewobject/item_price_type.dart';
import 'package:flutterbuyandsell/viewobject/item_type.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:flutterbuyandsell/viewobject/sub_category.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class HomeItemSearchView extends StatefulWidget {
  const HomeItemSearchView({
    required this.productParameterHolder,
    required this.animation,
    required this.animationController,
  });

  final ProductParameterHolder productParameterHolder;
  final AnimationController? animationController;
  final Animation<double> animation;

  @override
  _ItemSearchViewState createState() => _ItemSearchViewState();
}

class _ItemSearchViewState extends State<HomeItemSearchView> {
  ProductRepository? repo1;
  PsValueHolder? valueHolder;
  SearchProductProvider? _searchProductProvider;

  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();
  final TextEditingController userInputMaximunPriceEditingController =
      TextEditingController();
  final TextEditingController userInputMinimumPriceEditingController =
      TextEditingController();
  // final TextEditingController userInputItemLatitudeTextEditingController =
  //     TextEditingController();
  // final TextEditingController userInputItemLongitudeTextEditingController =
  //     TextEditingController();
  // final TextEditingController userInputItemMileTextEditingController =
  //     TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');

    final Widget _searchButtonWidget = PSButtonWidget(
      hasShadow: true,
      width: double.infinity,
      titleText: Utils.getString(context, 'home_search__search'),
      onPressed: () async {
        // _searchProductProvider.productParameterHolder.itemLocationId =
        //     _searchProductProvider.psValueHolder.locationId;

        _searchProductProvider!.productParameterHolder.isPaid =
            PsConst.PAID_ITEM_FIRST;
        if (userInputItemNameTextEditingController.text != '') {
          _searchProductProvider!.productParameterHolder.searchTerm =
              userInputItemNameTextEditingController.text;
        } else {
          _searchProductProvider!.productParameterHolder.searchTerm = '';
        }
        // ignore: unnecessary_null_comparison
        if (userInputMaximunPriceEditingController.text != null) {
          _searchProductProvider!.productParameterHolder.maxPrice =
              userInputMaximunPriceEditingController.text;
        } else {
          _searchProductProvider!.productParameterHolder.maxPrice = '';
        }
        // ignore: unnecessary_null_comparison
        if (userInputMinimumPriceEditingController.text != null) {
          _searchProductProvider!.productParameterHolder.minPrice =
              userInputMinimumPriceEditingController.text;
        } else {
          _searchProductProvider!.productParameterHolder.minPrice = '';
        }
        // if (userInputItemLatitudeTextEditingController.text != null &&
        //     userInputItemLatitudeTextEditingController.text != '') {
        //   _searchProductProvider.productParameterHolder.lat =
        //       userInputItemLatitudeTextEditingController.text;
        // } else {
        //   _searchProductProvider.productParameterHolder.lat = '';
        // }
        // if (userInputItemLongitudeTextEditingController.text != null &&
        //     userInputItemLongitudeTextEditingController.text != '') {
        //   _searchProductProvider.productParameterHolder.lng =
        //       userInputItemLongitudeTextEditingController.text;
        // } else {
        //   _searchProductProvider.productParameterHolder.lng = '';
        // }
        // if (userInputItemMileTextEditingController.text != null &&
        //     userInputItemMileTextEditingController.text != '') {
        //   _searchProductProvider.productParameterHolder.mile =
        //       userInputItemMileTextEditingController.text;
        // } else {
        //   _searchProductProvider.productParameterHolder.mile = '';
        // }

        if (_searchProductProvider!.locationId != null) {
          _searchProductProvider!.productParameterHolder.itemLocationId =
              _searchProductProvider!.locationId;
        }
        if (_searchProductProvider!.locationId != null) {
          _searchProductProvider!
                  .productParameterHolder.itemLocationTownshipId =
              _searchProductProvider!.locationTownshipId;
        }
        if (_searchProductProvider!.categoryId != null) {
          _searchProductProvider!.productParameterHolder.catId =
              _searchProductProvider!.categoryId;
        }
        if (_searchProductProvider!.subCategoryId != null) {
          _searchProductProvider!.productParameterHolder.subCatId =
              _searchProductProvider!.subCategoryId;
        }
        if (_searchProductProvider!.itemTypeId != null) {
          _searchProductProvider!.productParameterHolder.itemTypeId =
              _searchProductProvider!.itemTypeId;
        }
        if (_searchProductProvider!.itemConditionId != null) {
          _searchProductProvider!.productParameterHolder.conditionOfItemId =
              _searchProductProvider!.itemConditionId;
        }
        if (_searchProductProvider!.itemPriceTypeId != null) {
          _searchProductProvider!.productParameterHolder.itemPriceTypeId =
              _searchProductProvider!.itemPriceTypeId;
        }
        if (_searchProductProvider!.itemDealOptionId != null) {
          _searchProductProvider!.productParameterHolder.dealOptionId =
              _searchProductProvider!.itemDealOptionId;
        }
        if (_searchProductProvider!.itemIsSoldOut != null) {
          _searchProductProvider!.productParameterHolder.isSoldOut =
              _searchProductProvider!.itemIsSoldOut;
        }

        print('userInputText' + userInputItemNameTextEditingController.text);
        final dynamic result =
            await Navigator.pushNamed(context, RoutePaths.filterProductList,
                arguments: ProductListIntentHolder(
                  appBarTitle:
                      Utils.getString(context, 'home_search__app_bar_title'),
                  productParameterHolder:
                      _searchProductProvider!.productParameterHolder,
                ));
        if (result != null && result is ProductParameterHolder) {
          _searchProductProvider!.productParameterHolder = result;
        }
      },
    );

    repo1 = Provider.of<ProductRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<SearchProductProvider?>(
            lazy: false,
            create: (BuildContext content) {
              _searchProductProvider = SearchProductProvider(
                  repo: repo1, psValueHolder: valueHolder);
              _searchProductProvider!.productParameterHolder =
                  widget.productParameterHolder;
              _searchProductProvider!.locationId =
                  widget.productParameterHolder.itemLocationId;
              _searchProductProvider!.selectedLocationName =
                  widget.productParameterHolder.itemLocationName;
              _searchProductProvider!.locationTownshipId =
                  widget.productParameterHolder.itemLocationTownshipId;
              _searchProductProvider!.selectedLocationTownshipName =
                  widget.productParameterHolder.itemLocationTownshipName;
              final String? loginUserId = Utils.checkUserLoginId(valueHolder!);
              _searchProductProvider!.loadProductListByKey(
                  loginUserId, _searchProductProvider!.productParameterHolder);

              return _searchProductProvider;
            },
            child: Consumer<SearchProductProvider>(
              builder: (BuildContext context, SearchProductProvider provider,
                  Widget? child) {
                if (_searchProductProvider!.productList.data != null) {
                  widget.animationController!.forward();
                  return SingleChildScrollView(
                    child: AnimatedBuilder(
                        animation: widget.animationController!,
                        child: Container(
                          color: PsColors.baseColor,
                          child: Column(
                            children: <Widget>[
                              const PsAdMobBannerWidget(
                                admobSize: AdSize.banner,
                              ),
                              _ProductNameWidget(
                                userInputItemNameTextEditingController:
                                    userInputItemNameTextEditingController,
                              ),
                              _PriceWidget(
                                userInputMinimumPriceEditingController:
                                    userInputMinimumPriceEditingController,
                                userInputMaximunPriceEditingController:
                                    userInputMaximunPriceEditingController,
                              ),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__location'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedLocationName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic locationResult =
                                        await Navigator.pushNamed(context,
                                            RoutePaths.searchLocationList);

                                    if (locationResult != null &&
                                        locationResult is ItemLocation) {
                                      provider.locationId = locationResult.id;
                                      provider.locationTownshipId = '';

                                      if (mounted) {
                                        setState(() {
                                          provider.selectedLocationName =
                                              locationResult.name;
                                          provider.selectedLocationTownshipName =
                                              '';
                                        });
                                      }
                                    } else if (locationResult) {
                                      provider.locationId = '';
                                      provider.selectedLocationName =
                                          Utils.getString(context,
                                              'product_list__category_all');
                                    }
                                  }),
                              if (valueHolder!.isSubLocation == PsConst.ONE)
                                PsDropdownBaseWidget(
                                    title: Utils.getString(context,
                                        'item_entry__location_township'),
                                    selectedText:
                                        Provider.of<SearchProductProvider>(
                                                context,
                                                listen: false)
                                            .selectedLocationTownshipName,
                                    onTap: () async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      final SearchProductProvider provider =
                                          Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false);
                                      if (provider.locationId != '') {
                                        final dynamic townshipResult =
                                            await Navigator.pushNamed(
                                                context,
                                                RoutePaths
                                                    .searchLocationTownshipList,
                                                arguments: provider.locationId);
                                        if (townshipResult != null &&
                                            townshipResult
                                                is ItemLocationTownship) {
                                          provider.locationTownshipId =
                                              townshipResult.id;
                                          setState(() {
                                            provider.selectedLocationTownshipName =
                                                townshipResult.townshipName;
                                          });
                                        } else if (townshipResult) {
                                          provider.locationTownshipId = '';
                                          provider.selectedLocationTownshipName =
                                              Utils.getString(context,
                                                  'product_list__category_all');
                                        }
                                      } else {
                                        showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ErrorDialog(
                                                message: Utils.getString(
                                                    context,
                                                    'home_search__choose_city_first'),
                                              );
                                            });
                                      }
                                    })
                              else
                                Container(),

                              // _ProductLatitudeWidget(
                              //   userInputItemLatitudeTextEditingController:
                              //       userInputItemLatitudeTextEditingController,
                              // ),
                              // _ProductLongitudeWidget(
                              //   userInputItemLongitudeTextEditingController:
                              //       userInputItemLongitudeTextEditingController,
                              // ),
                              // _ProductMileWidget(
                              //   userInputItemMileTextEditingController:
                              //       userInputItemMileTextEditingController,
                              // ),

                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'search__category'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedCategoryName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic categoryResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.searchCategory);

                                    if (categoryResult != null &&
                                        categoryResult is Category) {
                                      provider.categoryId =
                                          categoryResult.catId;
                                      provider.subCategoryId = '';

                                      setState(() {
                                        provider.selectedCategoryName =
                                            categoryResult.catName;
                                        provider.selectedSubCategoryName = '';
                                      });
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'search__sub_category'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedSubCategoryName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);
                                    if (provider.categoryId != '') {
                                      final dynamic subCategoryResult =
                                          await Navigator.pushNamed(context,
                                              RoutePaths.searchSubCategory,
                                              arguments: provider.categoryId);
                                      if (subCategoryResult != null &&
                                          subCategoryResult is SubCategory) {
                                        provider.subCategoryId =
                                            subCategoryResult.id;
                                        setState(() {
                                          provider.selectedSubCategoryName =
                                              subCategoryResult.name;
                                        });
                                      }
                                    } else {
                                      showDialog<dynamic>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ErrorDialog(
                                              message: Utils.getString(context,
                                                  'home_search__choose_category_first'),
                                            );
                                          });
                                      const ErrorDialog(
                                          message: 'Choose Category first');
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__type'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedItemTypeName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic itemTypeResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemType);

                                    if (itemTypeResult != null &&
                                        itemTypeResult is ItemType) {
                                      provider.itemTypeId = itemTypeResult.id;

                                      setState(() {
                                        provider.selectedItemTypeName =
                                            itemTypeResult.name;
                                      });
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__item_condition'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedItemConditionName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic itemConditionResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemCondition);

                                    if (itemConditionResult != null &&
                                        itemConditionResult
                                            is ConditionOfItem) {
                                      provider.itemConditionId =
                                          itemConditionResult.id;

                                      setState(() {
                                        provider.selectedItemConditionName =
                                            itemConditionResult.name;
                                      });
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__price_type'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedItemPriceTypeName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic itemPriceTypeResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemPriceType);

                                    if (itemPriceTypeResult != null &&
                                        itemPriceTypeResult is ItemPriceType) {
                                      provider.itemPriceTypeId =
                                          itemPriceTypeResult.id;

                                      setState(() {
                                        provider.selectedItemPriceTypeName =
                                            itemPriceTypeResult.name;
                                      });
                                    }
                                  }),
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__deal_option'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedItemDealOptionName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic itemDealOptionResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemDealOption);

                                    if (itemDealOptionResult != null &&
                                        itemDealOptionResult is DealOption) {
                                      provider.itemDealOptionId =
                                          itemDealOptionResult.id;

                                      setState(() {
                                        provider.selectedItemDealOptionName =
                                            itemDealOptionResult.name;
                                      });
                                    }
                                  }),
                              //sold out filter
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'item_entry__sold_out'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedItemIsSoldOut,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic itemSoldOutResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemSoldOut);

                                    if (itemSoldOutResult != null &&
                                        itemSoldOutResult is Product) {
                                      provider.itemIsSoldOut =
                                          itemSoldOutResult.isSoldOut;
                                      setState(() {
                                        provider.selectedItemIsSoldOut =
                                            itemSoldOutResult.isSoldOut == '0'
                                                ? 'Not Sold Yet'
                                                : 'Sold Out';
                                      });
                                    }
                                  }),
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: PsDimens.space16,
                                      top: PsDimens.space16,
                                      right: PsDimens.space16,
                                      bottom: PsDimens.space40),
                                  child: _searchButtonWidget),
                            ],
                          ),
                        ),
                        builder: (BuildContext context, Widget? child) {
                          return FadeTransition(
                              opacity: widget.animation,
                              child: Transform(
                                  transform: Matrix4.translationValues(
                                      0.0,
                                      100 * (1.0 - widget.animation.value),
                                      0.0),
                                  child: child));
                        }),
                  );
                } else {
                  return Container();
                }
              },
            )));
  }
}

class _ProductNameWidget extends StatefulWidget {
  const _ProductNameWidget({this.userInputItemNameTextEditingController});

  final TextEditingController? userInputItemNameTextEditingController;

  @override
  __ProductNameWidgetState createState() => __ProductNameWidgetState();
}

class __ProductNameWidgetState extends State<_ProductNameWidget> {
  @override
  Widget build(BuildContext context) {
    print('*****' + widget.userInputItemNameTextEditingController!.text);
    return Column(
      children: <Widget>[
        PsTextFieldWidget(
            titleText: Utils.getString(context, 'home_search__product_name'),
            textAboutMe: false,
            hintText:
                Utils.getString(context, 'home_search__product_name_hint'),
            textEditingController:
                widget.userInputItemNameTextEditingController),
      ],
    );
  }
}

class _ProductLatitudeWidget extends StatefulWidget {
  const _ProductLatitudeWidget(
      {required this.userInputItemLatitudeTextEditingController});

  final TextEditingController userInputItemLatitudeTextEditingController;

  @override
  __ProductLatitudeWidgetState createState() => __ProductLatitudeWidgetState();
}

class __ProductLatitudeWidgetState extends State<_ProductLatitudeWidget> {
  @override
  Widget build(BuildContext context) {
    print('*****' + widget.userInputItemLatitudeTextEditingController.text);
    return Column(
      children: <Widget>[
        PsTextFieldWidget(
            titleText: Utils.getString(context, 'item_entry__latitude'),
            textAboutMe: false,
            keyboardType: TextInputType.number,
            hintText: Utils.getString(context, 'home_search__not_set'),
            textEditingController:
                widget.userInputItemLatitudeTextEditingController),
      ],
    );
  }
}

class _ProductLongitudeWidget extends StatefulWidget {
  const _ProductLongitudeWidget(
      {required this.userInputItemLongitudeTextEditingController});

  final TextEditingController userInputItemLongitudeTextEditingController;

  @override
  __ProductLongitudeWidgetState createState() =>
      __ProductLongitudeWidgetState();
}

class __ProductLongitudeWidgetState extends State<_ProductLongitudeWidget> {
  @override
  Widget build(BuildContext context) {
    print('*****' + widget.userInputItemLongitudeTextEditingController.text);
    return Column(
      children: <Widget>[
        PsTextFieldWidget(
            titleText: Utils.getString(context, 'item_entry__longitude'),
            textAboutMe: false,
            keyboardType: TextInputType.number,
            hintText: Utils.getString(context, 'home_search__not_set'),
            textEditingController:
                widget.userInputItemLongitudeTextEditingController),
      ],
    );
  }
}

class _ProductMileWidget extends StatefulWidget {
  const _ProductMileWidget({required this.userInputItemMileTextEditingController});

  final TextEditingController? userInputItemMileTextEditingController;

  @override
  __ProductMileWidgetState createState() => __ProductMileWidgetState();
}

class __ProductMileWidgetState extends State<_ProductMileWidget> {
  @override
  Widget build(BuildContext context) {
    print('*****' + widget.userInputItemMileTextEditingController!.text);
    return Column(
      children: <Widget>[
        PsTextFieldWidget(
            titleText: Utils.getString(context, 'item_entry_mile'),
            textAboutMe: false,
            keyboardType: TextInputType.number,
            hintText: Utils.getString(context, 'home_search__not_set'),
            textEditingController:
                widget.userInputItemMileTextEditingController),
      ],
    );
  }
}

class _ChangeRatingColor extends StatelessWidget {
  const _ChangeRatingColor({
    Key? key,
    required this.title,
    required this.checkColor,
  }) : super(key: key);

  final String title;
  final bool checkColor;

  @override
  Widget build(BuildContext context) {
    final Color? defaultBackgroundColor = PsColors.backgroundColor;
    return Container(
      width: MediaQuery.of(context).size.width / 5.5,
      height: PsDimens.space104,
      decoration: BoxDecoration(
        color: checkColor ? defaultBackgroundColor : PsColors.primary500,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              Icons.star,
              color: checkColor ? PsColors.iconColor : PsColors.white,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: checkColor ? PsColors.iconColor : PsColors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingRangeWidget extends StatefulWidget {
  @override
  __RatingRangeWidgetState createState() => __RatingRangeWidgetState();
}

class __RatingRangeWidgetState extends State<_RatingRangeWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchProductProvider provider =
        Provider.of<SearchProductProvider>(context);

    dynamic _firstRatingRangeSelected() {
      if (!provider.isfirstRatingClicked) {
        // isfirstRatingClicked = true;
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__one_and_higher'),
          checkColor: true,
        );
      } else {
        // isfirstRatingClicked = false;
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__one_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _secondRatingRangeSelected() {
      if (!provider.isSecondRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__two_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__two_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _thirdRatingRangeSelected() {
      if (!provider.isThirdRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__three_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__three_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _fouthRatingRangeSelected() {
      if (!provider.isfouthRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__four_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__four_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _fifthRatingRangeSelected() {
      if (!provider.isFifthRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__five'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString(context, 'home_search__five'),
          checkColor: false,
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString(context, 'home_search__rating_range'),
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isfirstRatingClicked) {
                    provider.isfirstRatingClicked = true;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _firstRatingRangeSelected(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(PsDimens.space4),
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isSecondRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = true;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _secondRatingRangeSelected(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isThirdRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = true;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _thirdRatingRangeSelected(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(PsDimens.space4),
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isfouthRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = true;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _fouthRatingRangeSelected(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(
                  // color: Colors.white,
                  ),
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (!provider.isFifthRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = true;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _fifthRatingRangeSelected(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

dynamic setAllRatingFalse(SearchProductProvider provider) {
  provider.isfirstRatingClicked = false;
  provider.isSecondRatingClicked = false;
  provider.isThirdRatingClicked = false;
  provider.isfouthRatingClicked = false;
  provider.isFifthRatingClicked = false;
}

class _PriceWidget extends StatelessWidget {
  const _PriceWidget(
      {this.userInputMinimumPriceEditingController,
      this.userInputMaximunPriceEditingController});
  final TextEditingController? userInputMinimumPriceEditingController;
  final TextEditingController? userInputMaximunPriceEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString(context, 'home_search__price'),
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        _PriceTextWidget(
            title: Utils.getString(context, 'home_search__lowest_price'),
            textField: TextField(
                maxLines: null,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: PsDimens.space8, bottom: PsDimens.space12),
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'home_search__not_set'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: PsColors.textPrimaryLightColor),
                ),
                keyboardType: TextInputType.number,
                controller: userInputMinimumPriceEditingController)),
        const Divider(
          height: PsDimens.space1,
        ),
        _PriceTextWidget(
            title: Utils.getString(context, 'home_search__highest_price'),
            textField: TextField(
                maxLines: null,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: PsDimens.space8, bottom: PsDimens.space12),
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'home_search__not_set'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: PsColors.textPrimaryLightColor),
                ),
                keyboardType: TextInputType.number,
                controller: userInputMaximunPriceEditingController)),
      ],
    );
  }
}

class _PriceTextWidget extends StatelessWidget {
  const _PriceTextWidget({
    Key? key,
    required this.title,
    required this.textField,
  }) : super(key: key);

  final String title;
  final TextField textField;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: PsColors.backgroundColor,
      child: Container(
        margin: const EdgeInsets.all(PsDimens.space12),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            Container(
                decoration: BoxDecoration(
                  color: PsColors.backgroundColor,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(color: PsColors.mainDividerColor),
                ),
                width: PsDimens.space120,
                height: PsDimens.space36,
                child: textField),
          ],
        ),
      ),
    );
  }
}

class _SpecialCheckWidget extends StatefulWidget {
  @override
  __SpecialCheckWidgetState createState() => __SpecialCheckWidgetState();
}

class __SpecialCheckWidgetState extends State<_SpecialCheckWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString(context, 'home_search__special_check'),
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        SpecialCheckTextWidget(
            title: Utils.getString(context, 'home_search__featured_product'),
            icon: FontAwesome5.gem, //FontAwesome5.gem,
            checkTitle: 1,
            size: PsDimens.space18),
        const Divider(
          height: PsDimens.space1,
        ),
        SpecialCheckTextWidget(
            title: Utils.getString(context, 'home_search__discount_price'),
            icon: FontAwesome5.percent, //Feather.percent,
            checkTitle: 2,
            size: PsDimens.space18),
        const Divider(
          height: PsDimens.space1,
        ),
      ],
    );
  }
}

class _SpecialCheckTextWidget extends StatefulWidget {
  const _SpecialCheckTextWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.checkTitle,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool checkTitle;

  @override
  __SpecialCheckTextWidgetState createState() =>
      __SpecialCheckTextWidgetState();
}

class __SpecialCheckTextWidgetState extends State<_SpecialCheckTextWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchProductProvider provider =
        Provider.of<SearchProductProvider>(context);

    return Container(
        width: double.infinity,
        height: PsDimens.space52,
        child: Container(
          margin: const EdgeInsets.all(PsDimens.space12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    widget.icon,
                    size: PsDimens.space20,
                    // color: ps_wtheme_icon_color,
                  ),
                  const SizedBox(
                    width: PsDimens.space10,
                  ),
                  Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              if (widget.checkTitle)
                Switch(
                  value: provider.isSwitchedFeaturedProduct,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedFeaturedProduct = value;
                    });
                  },
                  activeTrackColor: PsColors.primary500,
                  activeColor: PsColors.primary500,
                )
              else
                Switch(
                  value: provider.isSwitchedDiscountPrice,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedDiscountPrice = value;
                    });
                  },
                  activeTrackColor: PsColors.primary500,
                  activeColor: PsColors.primary500,
                ),
            ],
          ),
        ));
  }
}
