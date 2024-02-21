
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/provider/category/category_provider.dart';
import 'package:flutterbuyandsell/repository/category_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/ui/item/list_with_filter/filter/category/category_view_item.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'filter_expantion_tile_view.dart';

class FilterListView extends StatefulWidget {
  const FilterListView({this.selectedData});

  final dynamic selectedData;

  @override
  State<StatefulWidget> createState() => _FilterListViewState();
}

class _FilterListViewState extends State<FilterListView> {
  final ScrollController _scrollController = ScrollController();

  // final CategoryParameterHolder categoryIconList = CategoryParameterHolder();
  CategoryRepository? categoryRepository;
  PsValueHolder? psValueHolder;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSubCategoryClick(Map<String, String?> subCategory) {
    Navigator.pop(context, subCategory);
  }

  void onCategoryClick(Map<String, String?> category) {
    Navigator.pop(context, category);
  }

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
    categoryRepository = Provider.of<CategoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    
    return PsWidgetWithAppBar<CategoryProvider>(
        appBarTitle: Utils.getString(context, 'search__category'),
        initProvider: () {
          return CategoryProvider(
              repo: categoryRepository, psValueHolder: psValueHolder);
        },
        onProviderReady: (CategoryProvider provider) {
          provider.loadCategoryList(provider.categoryParameterHolder.toMap(),
              Utils.checkUserLoginId(provider.psValueHolder!));
        },
        actions: <Widget>[
          IconButton(
            icon: Icon(CommunityMaterialIcons.filter_remove_outline, //MaterialIcon.filter_list,
                color: PsColors.iconColor),
            onPressed: () {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[PsConst.CATEGORY_ID] = '';
              dataHolder[PsConst.SUB_CATEGORY_ID] = '';
              dataHolder[PsConst.CATEGORY_NAME] = '';
              onSubCategoryClick(dataHolder);
            },
          )
        ],
        builder:
            (BuildContext context, CategoryProvider provider, Widget? child) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(
                    admobSize: AdSize.banner,
                  ),
                  Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: provider.categoryList.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (provider.categoryList.data != null ||
                              provider.categoryList.data!.isEmpty) {
                            return Utils.showUI(psValueHolder!.subCatId) ? 
                              FilterExpantionTileView(
                                selectedData: widget.selectedData,
                                category: provider.categoryList.data![index],
                                onSubCategoryClick: onSubCategoryClick) 
                                : 
                              CategoryViewItem(
                                selectedData: widget.selectedData,
                                category: provider.categoryList.data![index],
                                onCategoryClick: onCategoryClick);
                          } else {
                            return Container();
                          }
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
