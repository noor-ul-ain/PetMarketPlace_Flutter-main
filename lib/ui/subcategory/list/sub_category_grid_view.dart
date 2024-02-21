import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/subcategory/sub_category_provider.dart';
import 'package:flutterbuyandsell/repository/sub_category_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/filter_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/success_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/common/search_bar_view.dart';
import 'package:flutterbuyandsell/ui/subcategory/item/sub_category_grid_item.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/subscribe_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/sub_category.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SubCategoryGridView extends StatefulWidget {
  const SubCategoryGridView({this.category});
  final Category? category;
  @override
  _ModelGridViewState createState() {
    return _ModelGridViewState();
  }
}

class _ModelGridViewState extends State<SubCategoryGridView>
    with SingleTickerProviderStateMixin {

      _ModelGridViewState() {
        searchBar = SearchBarView(
        inBar: true,
        controller: searchTextController,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        closeOnSubmit: false,
        onSubmitted: onSubmitted,
        onCleared: () {
          print('cleared');
        },
        onClosed: () {
          _subCategoryProvider!.subCategoryParameterHolder.keyword = '';
          _subCategoryProvider!.resetSubCategoryList(
              _subCategoryProvider!.subCategoryParameterHolder.toMap(), Utils.checkUserLoginId(
                                _subCategoryProvider!.psValueHolder!),);
        });
      }
  bool bindDataFirstTime = true;
  final ScrollController _scrollController = ScrollController();
  SubCategoryProvider? _subCategoryProvider;
  late SearchBarView searchBar;
  late TextEditingController searchTextController = TextEditingController();
  AnimationController? animationController;
  Animation<double>? animation;
    bool subscribeNoti = false;
  List<String?> subscribeList = <String?>[];
  List<String?> unsubscribeListWithMB = <String?>[];
  List<String?> tempList = <String?>[];
  bool needToAdd = true;

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  void onSubmitted(String value) {
    _subCategoryProvider!.subCategoryParameterHolder.keyword = value;
     _subCategoryProvider!.resetSubCategoryList(
              _subCategoryProvider!.subCategoryParameterHolder.toMap(), Utils.checkUserLoginId(
                                _subCategoryProvider!.psValueHolder!),
              );
  }

  AppBar buildAppBar(BuildContext context) {
    if (_subCategoryProvider != null) {
      _subCategoryProvider!.subCategoryParameterHolder.keyword = '';
      _subCategoryProvider!.resetSubCategoryList(
              _subCategoryProvider!.subCategoryParameterHolder.toMap(), Utils.checkUserLoginId(
                                _subCategoryProvider!.psValueHolder!),
              );
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
      title: Text(widget.category!.catName!,
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
        if (valueHolder!.isSubCatSubscribe == PsConst.ONE && !subscribeNoti)
          IconButton(
            icon: Icon(Icons.notification_add, color: PsColors.iconColor),
            onPressed: () async{
              if (await Utils.checkInternetConnectivity()) {
                Utils.navigateOnUserVerificationView( 
                  _subCategoryProvider, context, () {
                      setState(() {
                        subscribeNoti = true;
                      });
                });
              }
            },
          ),
        if (valueHolder!.isSubCatSubscribe == PsConst.ONE && subscribeNoti)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () async {
                if (subscribeList.isNotEmpty) {
                  final List<String?> subscribeListWithMB = <String?>[];
                  for (String? temp in subscribeList) {
                    subscribeListWithMB.add(temp! + '_MB');
                  }

                  final SubscribeParameterHolder holder = SubscribeParameterHolder(
                  userId: valueHolder!.loginUserId!,
                  catId: widget.category!.catId!,
                  selectedsubCatId: subscribeListWithMB,
                   );

                await PsProgressDialog.showDialog(context);
                final PsResource<ApiStatus> subscribeStatus =
                    await _subCategoryProvider!.postSubCategorySubscribe(
                        holder.toMap());
                PsProgressDialog.dismissDialog();

                if (subscribeStatus.status == PsStatus.SUCCESS) {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext contet) {
                        return SuccessDialog(
                          message: Utils.getString(
                              context, 'Successful Subscription'),
                          onPressed: () {},
                        );
                      });

                  //substract unscribed_topics from subscribed_topics (subscribe - unsubscribe)
                  Utils.subscribeToModelTopics(List<String>.from(
                        Set<String>.from(subscribeListWithMB)
                        .difference(Set<String>.from(unsubscribeListWithMB))
                    ));
                  Utils.unSubsribeFromModelTopics(unsubscribeListWithMB);      

                  setState(() {
                    subscribeNoti = false;
                    subscribeList.clear();
                    unsubscribeListWithMB.clear();
                  });    
                  _subCategoryProvider!.resetSubCategoryList(
                            _subCategoryProvider!.subCategoryParameterHolder
                                .toMap(),
                            Utils.checkUserLoginId(
                                _subCategoryProvider!.psValueHolder!),
                          );
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext contet) {
                        return ErrorDialog(
                          message: Utils.getString(
                              context, 'subscribe failed.'),
                        );
                      });
                }
                } else {
                  setState(() {
                    subscribeNoti = false;
                });
                }      
              },
              child: Center(
                child: Text(Utils.getString(context, 'Done'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: PsColors.iconColor)),
              ),
            ),
          )
      ],
      elevation: 0,
    );
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final String? categId = widget.category!.catId;
        Utils.psPrint('CategoryId number is $categId');

        _subCategoryProvider!.nextSubCategoryList(
            _subCategoryProvider!.subCategoryParameterHolder.toMap(),
            Utils.checkUserLoginId(valueHolder!),
            );
      }
    });
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  SubCategoryRepository? repo1;
  PsValueHolder? valueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && valueHolder!.isShowAdmob!) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    repo1 = Provider.of<SubCategoryRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    if (!isConnectedToInternet && valueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    


    return Scaffold(
       appBar: searchBar.build(context),
        body: ChangeNotifierProvider<SubCategoryProvider?>(
            lazy: false,
            create: (BuildContext context) {
              _subCategoryProvider =
                  SubCategoryProvider(repo: repo1, psValueHolder: valueHolder);
                  _subCategoryProvider!.subCategoryParameterHolder.catId = widget.category!.catId;
              _subCategoryProvider!.categoryId = widget.category!.catId!;    
              _subCategoryProvider!.loadAllSubCategoryList(
                _subCategoryProvider!.subCategoryParameterHolder.toMap(),
                Utils.checkUserLoginId(_subCategoryProvider!.psValueHolder!)         
              );
              return _subCategoryProvider;
            },
            child: Consumer<SubCategoryProvider>(builder: (BuildContext context,
                SubCategoryProvider provider, Widget? child) {
              return Container(
                height: double.infinity,
                color: PsColors.baseColor,
                child: Column(
                  children: <Widget>[
                    const PsAdMobBannerWidget(
                      admobSize: AdSize.banner,
                    ),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                      const SizedBox(
                        width: PsDimens.space1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: PsDimens.space20, top: PsDimens.space16),
                        child: InkWell(
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
                                              fontSize: 16,)),
                                ),
                              ],
                            ),
                          onTap: () {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return FilterDialog(
                        onAscendingTap: () async {
                          _subCategoryProvider!.subCategoryParameterHolder
                              .orderBy = PsConst.FILTERING_SUBCAT_NAME;
                          _subCategoryProvider!.subCategoryParameterHolder
                              .orderType = PsConst.FILTERING__ASC;
                          _subCategoryProvider!.resetSubCategoryList(
                            _subCategoryProvider!.subCategoryParameterHolder
                                .toMap(),
                            Utils.checkUserLoginId(
                                _subCategoryProvider!.psValueHolder!),
                          );
                        },
                        onDescendingTap: () {
                          _subCategoryProvider!.subCategoryParameterHolder
                              .orderBy = PsConst.FILTERING_SUBCAT_NAME;
                          _subCategoryProvider!.subCategoryParameterHolder
                              .orderType = PsConst.FILTERING__DESC;
                          _subCategoryProvider!.resetSubCategoryList(
                            _subCategoryProvider!.subCategoryParameterHolder
                                .toMap(),
                            Utils.checkUserLoginId(
                                _subCategoryProvider!.psValueHolder!),
                          );
                        },
                      );
                    });
              }, ),
                      ),
                                     ],
                                   ),
                    Expanded(
                      child: Stack(children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(PsDimens.space8),
                            child: RefreshIndicator(
                          onRefresh: () {
                            return _subCategoryProvider!.resetSubCategoryList(
                                _subCategoryProvider!.subCategoryParameterHolder
                                    .toMap(),
                                Utils.checkUserLoginId(valueHolder!),
                                );
                          },
                          child: CustomScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: false,
                              slivers: <Widget>[
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 100.0,
                                          childAspectRatio: 0.80),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.subCategoryList.status ==
                                          PsStatus.BLOCK_LOADING) {
                                        return Shimmer.fromColors(
                                            baseColor: PsColors.grey,
                                            highlightColor: PsColors.white,
                                            child:
                                                const Column(children: <Widget>[
                                              FrameUIForLoading(),
                                              FrameUIForLoading(),
                                              FrameUIForLoading(),
                                              FrameUIForLoading(),
                                              FrameUIForLoading(),
                                              FrameUIForLoading(),
                                            ]));
                                      } else
                                       if(provider.subCategoryList.data != null ||
                                            provider.subCategoryList.data!.isNotEmpty){
                                        final int count = provider.subCategoryList.data!.length; 
                                      final SubCategory? subCategory = provider.subCategoryList.data![index];    

                                      if (subCategory?.isSubscribe != null && subCategory!.isSubscribe == PsConst.ONE 
                                              && !tempList.contains(subCategory.id) && needToAdd) {
                                        tempList.add(subCategory.id);
                                      }   
                                      return SubCategoryGridItem(
                                        subScribeNoti: subscribeNoti,
                                        tempList: tempList,
                                        subCategory: subCategory!,
                                        onTap: () {
                                          if (subscribeNoti) {
                                              setState(() {
                                                
                                                if (tempList.contains(subCategory.id)) {
                                                  tempList.remove(subCategory.id);
                                                  unsubscribeListWithMB.add(subCategory.id! + '_MB');
                                                }
                                                else {
                                                  tempList.add(subCategory.id);
                                                  unsubscribeListWithMB.remove(subCategory.id! + '_MB');
                                                }
                                                            

                                                if (subscribeList
                                                    .contains(subCategory.id))
                                                  subscribeList
                                                      .remove(subCategory.id);
                                                else
                                                  subscribeList
                                                      .add(subCategory.id);
                                                needToAdd = false;      
                                              });
                                          } 
                                                  else {
                                                  provider.subCategoryByCatIdParamenterHolder.mile = 
                                                              valueHolder!.mile;  
                                                          provider.subCategoryByCatIdParamenterHolder
                                                                  .catId =
                                                      provider.subCategoryList
                                                          .data![index].catId;
                                                  provider.subCategoryByCatIdParamenterHolder
                                                          .subCatId =
                                                      provider.subCategoryList
                                                          .data![index].id;
                                                  provider.subCategoryByCatIdParamenterHolder
                                                          .itemLocationId =
                                                      valueHolder!.locationId;
                                                  provider.subCategoryByCatIdParamenterHolder
                                                          .itemLocationName =
                                                      valueHolder!.locactionName;
                                                  if (valueHolder!.isSubLocation ==
                                                      PsConst.ONE) {
                                                    provider.subCategoryByCatIdParamenterHolder
                                                            .itemLocationTownshipId =
                                                        valueHolder!.locationTownshipId;
                                                    provider.subCategoryByCatIdParamenterHolder
                                                            .itemLocationTownshipName =
                                                        valueHolder!
                                                            .locationTownshipName;
                                                  }
                                                  Navigator.pushNamed(context,
                                                      RoutePaths.filterProductList,
                                                      arguments: ProductListIntentHolder(
                                                          appBarTitle: provider
                                                              .subCategoryList
                                                              .data![index]
                                                              .name,
                                                          productParameterHolder: provider
                                                              .subCategoryByCatIdParamenterHolder));
                                                }
                                                },
                                                animationController:
                                                    animationController,
                                                animation:
                                                    Tween<double>(begin: 0.0, end: 1.0)
                                                        .animate(CurvedAnimation(
                                                  parent: animationController!,
                                                  curve: Interval(
                                                      (1 / count) * index, 1.0,
                                                      curve: Curves.fastOutSlowIn),
                                                )),
                                             
                                        );
                                      } 
                                      else {
                                        return Container();
                                       }
                                    },
                                    childCount:
                                        provider.subCategoryList.data!.length,
                                  ),
                                ),
                              ]),
                        )),
                        // Positioned(
                        //   child: Text('dadf')),

                        PSProgressIndicator(
                          provider.subCategoryList.status,
                          message: provider.subCategoryList.message,
                        )
                      ]),
                    )
                  ],
                ),
              );
            }))
        // )
        );
  }
}

void updateCheckBox(BuildContext context,SubCategoryProvider provider) {

  if (provider.isChecked) {
   provider.isChecked = false;
  } else {
  provider. isChecked = true;
  }
 }

class FrameUIForLoading extends StatelessWidget {
  const FrameUIForLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.all(PsDimens.space16),
            decoration: BoxDecoration(color: PsColors.grey)),
        Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
              height: 15,
              margin: const EdgeInsets.all(PsDimens.space8),
              decoration: BoxDecoration(color: Colors.grey[300])),
          Container(
              height: 15,
              margin: const EdgeInsets.all(PsDimens.space8),
              decoration: const BoxDecoration(color: Colors.grey)),
        ]))
      ],
    );
  }
}
