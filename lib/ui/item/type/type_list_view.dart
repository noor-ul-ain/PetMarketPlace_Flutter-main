import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/provider/product/item_type_provider.dart';
import 'package:flutterbuyandsell/repository/item_type_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/item/type/type_list_view_item.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TypeListView extends StatefulWidget {
   const TypeListView(
      {Key? key, this.showAllText = false})
      : super(key: key);

  final bool showAllText;

  @override
  State<StatefulWidget> createState() {
    return TypeListViewState();
  }
}

class TypeListViewState extends State<TypeListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late ItemTypeProvider _itemTypeProvider;
  late AnimationController animationController;
  Animation<double>? animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _itemTypeProvider.nextItemTypeList();
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController);
    super.initState();
  }

  ItemTypeRepository? repo1;

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
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

    repo1 = Provider.of<ItemTypeRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemTypeProvider>(
          appBarTitle: Utils.getString(context, 'item_entry__type'),
          initProvider: () {
            return ItemTypeProvider(
              repo: repo1,
            );
          },
          onProviderReady: (ItemTypeProvider provider) {
            provider.loadItemTypeList();
            _itemTypeProvider = provider;
          },
          builder:
              (BuildContext context, ItemTypeProvider provider, Widget? child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: widget.showAllText
                      ? provider.itemTypeList.data!.length + 1
                      : provider.itemTypeList.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemTypeList.status ==
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
                        final int count = provider.itemTypeList.data!.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation!,
                            child: TypeListViewItem(
                              itemType: index == 0
                               ? Utils.getString(
                                      context, 'product_list__category_all')
                              :  provider.itemTypeList.data![index - 1].name,
                              onTap: () {
                                if (index == 0) {
                                  Navigator.pop(context, true);
                                } else {
                                Navigator.pop(context,
                                    provider.itemTypeList.data![index - 1]);
                                print(provider.itemTypeList.data![index].name);
                                }
                              },
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetItemTypeList();
                },
              )),
              PSProgressIndicator(provider.itemTypeList.status)
            ]);
          }),
    );
  }
}
