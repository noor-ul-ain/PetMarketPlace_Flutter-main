import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/product/search_product_provider.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_native_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/item/item/product_vertical_list_item.dart';
import 'package:flutterbuyandsell/ui/item/list_with_filter/product_filter_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class ProductListWithFilterView extends StatefulWidget {
  const ProductListWithFilterView(
      {Key? key,
      required this.productParameterHolder,
      required this.animationController,
      this.changeAppBarTitle})
      : super(key: key);

  final ProductParameterHolder productParameterHolder;
  final AnimationController? animationController;
  final String? changeAppBarTitle;

  @override
  _ProductListWithFilterViewState createState() =>
      _ProductListWithFilterViewState();
}

class _ProductListWithFilterViewState extends State<ProductListWithFilterView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TextEditingController searchTextController = TextEditingController();
  SearchProductProvider? _searchProductProvider;
  ProductRepository? repo1;
  PsValueHolder? valueHolder;
  late SearchBar searchBar;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final String? loginUserId = Utils.checkUserLoginId(valueHolder!);
        _searchProductProvider!.nextProductListByKey(
            loginUserId, _searchProductProvider!.productParameterHolder);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<ProductRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    print(
        '............................Build UI Again ............................');
    return ChangeNotifierProvider<SearchProductProvider?>(
        lazy: false,
        create: (BuildContext context) {
          final SearchProductProvider provider = SearchProductProvider(
              repo: repo1,
              psValueHolder: valueHolder,
              limit: valueHolder!.defaultLoadingLimit!);

          if (valueHolder!.isSubLocation == PsConst.ONE) {
            widget.productParameterHolder.itemLocationTownshipId =
                valueHolder!.locationTownshipId;
          }
          final String? loginUserId = Utils.checkUserLoginId(valueHolder!);
          provider.loadProductListByKey(
              loginUserId, widget.productParameterHolder);

          _searchProductProvider = provider;
          _searchProductProvider!.productParameterHolder =
              widget.productParameterHolder;

          return _searchProductProvider;
        },
        child: Consumer<SearchProductProvider>(builder: (BuildContext context,
            SearchProductProvider provider, Widget? child) {
          return Column(
            children: <Widget>[
              ProductFilterWidget(
                searchProductProvider: _searchProductProvider,
              ),
              Expanded(
                child: Container(
                  color: PsColors.baseColor,
                  // color: Utils.isLightMode(context)
                  //     ? PsColors.white
                  //     : PsColors.black,
                  child: Stack(children: <Widget>[
                    if (provider.productList.data!.isNotEmpty &&
                        provider.productList.data != null)
                      Container(
                          color: PsColors.baseColor,
                          // color: Utils.isLightMode(context)
                          //     ? PsColors.white
                          //     : PsColors.black,
                          margin: const EdgeInsets.only(
                              left: PsDimens.space8,
                              right: PsDimens.space8,
                              top: PsDimens.space4,
                              bottom: PsDimens.space4),
                          child: RefreshIndicator(
                            child: CustomScrollView(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                slivers: <Widget>[
                                  SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 280.0,
                                            childAspectRatio: 0.70),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        if (provider.productList.data != null ||
                                            provider
                                                .productList.data!.isNotEmpty) {
                                          final int count =
                                              provider.productList.data!.length;
                                          print(
                                              'adtype::: ${provider.productList.data![index].adType}');
                                          if (provider.productList.data![index]
                                                  .adType! ==
                                              PsConst.GOOGLE_AD_TYPE) {
                                            return const PsAdMobNativeWidget();
                                          } else {
                                            return ProductVeticalListItem(
                                              coreTagKey:
                                                  provider.hashCode.toString() +
                                                      provider.productList
                                                          .data![index].id!,
                                              animationController:
                                                  widget.animationController,
                                              animation: Tween<double>(
                                                      begin: 0.0, end: 1.0)
                                                  .animate(
                                                CurvedAnimation(
                                                  parent: widget
                                                      .animationController!,
                                                  curve: Interval(
                                                      (1 / count) * index, 1.0,
                                                      curve:
                                                          Curves.fastOutSlowIn),
                                                ),
                                              ),
                                              product: provider
                                                  .productList.data![index],
                                              onTap: () {
                                                final Product product = provider
                                                    .productList.data!.reversed
                                                    .toList()[index];
                                                final ProductDetailIntentHolder
                                                    holder =
                                                    ProductDetailIntentHolder(
                                                        productId: provider
                                                            .productList
                                                            .data![index]
                                                            .id,
                                                        heroTagImage: provider
                                                                .hashCode
                                                                .toString() +
                                                            product.id! +
                                                            PsConst
                                                                .HERO_TAG__IMAGE,
                                                        heroTagTitle: provider
                                                                .hashCode
                                                                .toString() +
                                                            product.id! +
                                                            PsConst
                                                                .HERO_TAG__TITLE);
                                                Navigator.pushNamed(context,
                                                    RoutePaths.productDetail,
                                                    arguments: holder);
                                              },
                                            );
                                          }
                                        } else {
                                          return null;
                                        }
                                      },
                                      childCount:
                                          provider.productList.data!.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              final String? loginUserId =
                                  Utils.checkUserLoginId(valueHolder!);
                              return provider.resetLatestProductList(
                                  loginUserId,
                                  _searchProductProvider!
                                      .productParameterHolder);
                            },
                          ))
                    else if (provider.productList.status !=
                            PsStatus.PROGRESS_LOADING &&
                        provider.productList.status != PsStatus.BLOCK_LOADING &&
                        provider.productList.status != PsStatus.NOACTION)
                      Align(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/baseline_empty_item_grey_24.png',
                                height: 100,
                                width: 150,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                height: PsDimens.space32,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: PsDimens.space20,
                                    right: PsDimens.space20),
                                child: Text(
                                  Utils.getString(
                                      context, 'procuct_list__no_result_data'),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(),
                                ),
                              ),
                              const SizedBox(
                                height: PsDimens.space20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    PSProgressIndicator(provider.productList.status),
                  ]),
                ),
              ),
              const PsAdMobBannerWidget(
                admobSize: AdSize.banner,
              ),
            ],
          );
        }));
    //   ),
    // );
  }
}
