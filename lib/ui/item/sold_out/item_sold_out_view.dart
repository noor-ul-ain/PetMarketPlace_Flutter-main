import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'item_sold_out_list_view.dart';

class ItemSoldOutView extends StatefulWidget {
  // const ItemDealOptionView({@required this.categoryId});

  @override
  State<StatefulWidget> createState() {
    return ItemSoldOutViewState();
  }
}

class ItemSoldOutViewState extends State<ItemSoldOutView>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  List<Product>?productSoldOutList;

  @override
  void dispose() {
    animationController.dispose();
    //animation = null;
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController);

    super.initState();
  }

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

    productSoldOutList = <Product>[
      Product(isSoldOut: '0'),
      Product(isSoldOut: '1'),
    ];

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBarWithNoProvider(
          appBarTitle: Utils.getString(context, 'item_entry__sold_out'),
          child: Stack(
            children: <Widget>[
              Container(
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: productSoldOutList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        //   final int count = soldOutList.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: ItemSoldOutListViewItem(
                              product: productSoldOutList![index],
                              onTap: () {
                                Navigator.pop(
                                    context, productSoldOutList![index]);
                                print(productSoldOutList![index].isSoldOut);
                              },
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Curves.fastOutSlowIn,
                                ),
                              ),
                            ));
                      })),
            ],
          ),
        ));
  }
}
