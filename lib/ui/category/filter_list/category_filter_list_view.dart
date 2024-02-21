import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/provider/category/category_provider.dart';
import 'package:flutterbuyandsell/repository/category_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../item/category_search_list_item.dart';

class CategoryFilterListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryFilterListViewState();
  }
}

class _CategoryFilterListViewState extends State<CategoryFilterListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late CategoryProvider _categoryProvider;
  // final CategoryParameterHolder categoryIconList = CategoryParameterHolder();
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
        _categoryProvider.nextCategoryList(
            _categoryProvider.categoryParameterHolder.toMap(),
            Utils.checkUserLoginId(_categoryProvider.psValueHolder!));
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

  CategoryRepository? repo1;

  @override
  Widget build(BuildContext context) {
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

    repo1 = Provider.of<CategoryRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<CategoryProvider>(
          appBarTitle:
              Utils.getString(context, 'category_search_list__app_bar_name'),
          initProvider: () {
            return CategoryProvider(
                repo: repo1,
                psValueHolder: Provider.of<PsValueHolder>(context));
          },
          onProviderReady: (CategoryProvider provider) {
            provider.loadCategoryList(provider.categoryParameterHolder.toMap(),
                Utils.checkUserLoginId(provider.psValueHolder!));
            _categoryProvider = provider;
          },
          builder:
              (BuildContext context, CategoryProvider provider, Widget? child) {
            return Stack(children: <Widget>[
              // Container(
              //     child:
              RefreshIndicator(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: provider.categoryList.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.categoryList.status ==
                          PsStatus.BLOCK_LOADING) {
                        return Shimmer.fromColors(
                            baseColor: PsColors.grey,
                            highlightColor: PsColors.white,
                            child: const Column(children: <Widget>[
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                            ]));
                      } else {
                        final int count = provider.categoryList.data!.length;
                        animationController!.forward();
                        return FadeTransition(
                            opacity: animation!,
                            child: CategoryFilterListItem(
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              category: provider.categoryList.data![index],
                              onTap: () {
                                final Category category =
                                    provider.categoryList.data![index];
                                Navigator.pop(context, category);

                                print(
                                    provider.categoryList.data![index].catName);
                              },
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetCategoryList(
                      _categoryProvider.categoryParameterHolder.toMap(),
                      Utils.checkUserLoginId(_categoryProvider.psValueHolder!));
                },
              ),
              // ),
              PSProgressIndicator(provider.categoryList.status)
            ]);
          }),
    );
  }
}
