import 'dart:io';
import 'dart:io' show Platform;

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/blog/blog_provider.dart';
import 'package:flutterbuyandsell/provider/category/category_provider.dart';
import 'package:flutterbuyandsell/provider/chat/user_unread_message_provider.dart';
import 'package:flutterbuyandsell/provider/product/discount_product_provider.dart';
import 'package:flutterbuyandsell/provider/product/item_list_from_followers_provider.dart';
import 'package:flutterbuyandsell/provider/product/nearest_product_provider.dart';
import 'package:flutterbuyandsell/provider/product/paid_ad_product_provider%20copy.dart';
import 'package:flutterbuyandsell/provider/product/popular_product_provider.dart';
import 'package:flutterbuyandsell/provider/product/recent_product_provider.dart';
import 'package:flutterbuyandsell/repository/Common/notification_repository.dart';
import 'package:flutterbuyandsell/repository/blog_repository.dart';
import 'package:flutterbuyandsell/repository/category_repository.dart';
import 'package:flutterbuyandsell/repository/item_location_repository.dart';
import 'package:flutterbuyandsell/repository/paid_ad_item_repository.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/repository/user_unread_message_repository.dart';
import 'package:flutterbuyandsell/ui/category/item/category_horizontal_list_item.dart';
import 'package:flutterbuyandsell/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/dialog/rating_dialog/core.dart';
import 'package:flutterbuyandsell/ui/common/dialog/rating_dialog/style.dart';
import 'package:flutterbuyandsell/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_textfield_widget_with_icon.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/widgets/blog_product_slider.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/widgets/home_discount_product_horizontal_list_widget.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/widgets/home_paid_ad_product_horizontal_list_widget.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/widgets/home_popular_product_horizontal_list_widget.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/widgets/my_header_widget.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/widgets/nearest_product_horizontal_list_widget.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/widgets/recent_product_horizontal_list_widget.dart';
import 'package:flutterbuyandsell/ui/item/item/product_horizontal_list_item.dart';
import 'package:flutterbuyandsell/ui/location/no_location_screen.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/blog.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:location/location.dart' as location;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:rate_my_app/rate_my_app.dart';

class HomeDashboardViewWidget extends StatefulWidget {
  const HomeDashboardViewWidget(
    this.scrollController,
    this.animationController,
    this.animationControllerForFab,
    this.context,
  );

  final ScrollController scrollController;
  final AnimationController animationController;
  final AnimationController animationControllerForFab;

  final BuildContext context;

  @override
  _HomeDashboardViewWidgetState createState() =>
      _HomeDashboardViewWidgetState();
}

class _HomeDashboardViewWidgetState extends State<HomeDashboardViewWidget> {
  PsValueHolder? valueHolder;
  CategoryRepository? repo1;
  late ProductRepository repo2;
  late BlogRepository repo3;
  ItemLocationRepository? repo4;
  NotificationRepository? notificationRepository;
  CategoryProvider? _categoryProvider;
  RecentProductProvider? _recentProductProvider;
  NearestProductProvider? _nearestProductProvider;
  PopularProductProvider? _popularProductProvider;
  DiscountProductProvider? _discountProductProvider;
  PaidAdProductProvider? _paidAdItemProvider;
  BlogProvider? _blogProvider;
  UserUnreadMessageProvider? _userUnreadMessageProvider;
  ItemListFromFollowersProvider? _itemListFromFollowersProvider;
  UserUnreadMessageRepository? userUnreadMessageRepository;
  PaidAdItemRepository? paidAdItemRepository;

  final int count = 8;
  // final CategoryParameterHolder trendingCategory = CategoryParameterHolder();
  // final CategoryParameterHolder categoryIconList = CategoryParameterHolder();
  // final FirebaseMessaging _fcm = FirebaseMessaging();
  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();
  final TextEditingController useraddressTextEditingController =
      TextEditingController();
  Position? _currentPosition;
  bool androidFusedLocation = true;
  bool locationIsGranted = false;
  bool isLoading = true;
  String _authStatus = 'Unknown';
  final RateMyApp _rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0,
      minLaunches: 1,
      remindDays: 5,
      remindLaunches: 1);

  @override
  void initState() {
    super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());
  initLocation();

    if (Platform.isAndroid && false) {
      _rateMyApp.init().then((_) {
        if (_rateMyApp.shouldOpenDialog) {
          _rateMyApp.showStarRateDialog(
            context,
            title: Utils.getString(context, 'home__menu_drawer_rate_this_app'),
            message: Utils.getString(context, 'rating_popup_dialog_message'),
            ignoreNativeDialog: true,
            actionsBuilder: (BuildContext context, double? stars) {
              return <Widget>[
                TextButton(
                  child: Text(
                    Utils.getString(context, 'dialog__ok'),
                  ),
                  onPressed: () async {
                    if (stars != null) {
                      // _rateMyApp.save().then((void v) => Navigator.pop(context));
                      Navigator.pop(context);
                      if (stars < 1) {
                      } else if (stars >= 1 && stars <= 3) {
                        await _rateMyApp
                            .callEvent(RateMyAppEventType.laterButtonPressed);
                        await showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmDialogView(
                                description: Utils.getString(
                                    context, 'rating_confirm_message'),
                                leftButtonText:
                                    Utils.getString(context, 'dialog__cancel'),
                                rightButtonText: Utils.getString(
                                    context, 'home__menu_drawer_contact_us'),
                                onAgreeTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    RoutePaths.contactUs,
                                  );
                                },
                              );
                            });
                      } else if (stars >= 4) {
                        await _rateMyApp
                            .callEvent(RateMyAppEventType.rateButtonPressed);
                        if (Platform.isIOS) {
                          Utils.launchAppStoreURL(
                              iOSAppId: valueHolder!.iosAppStoreId,
                              writeReview: true);
                        } else {
                          Utils.launchURL();
                        }
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                )
              ];
            },
            onDismissed: () =>
                _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
            dialogStyle: const DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 16.0),
            ),
            starRatingOptions: const StarRatingOptions(),
          );
        }
      });
    }
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // setState(() {
        //   _isVisible = false;
        //   //print('**** $_isVisible up');
        // });
        // if (widget.animationControllerForFab != null) {
        widget.animationControllerForFab.reverse();
        //}
      }
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // setState(() {
        //   _isVisible = true;
        //   //print('**** $_isVisible down');
        // });
        //if (widget.animationControllerForFab != null) {
        widget.animationControllerForFab.forward();
        //}
      }
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_authStatus', _authStatus));
  }

  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
         final TrackingStatus status =
              await AppTrackingTransparency.requestTrackingAuthorization();
          setState(() => _authStatus = '$status');
        }
    } on PlatformException {
      setState(() => _authStatus = 'PlatformException was thrown');
    }

    final String uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print('UUID: $uuid');
  }

  Future<void> initLocation()async{
   final LocationPermission permission = await Geolocator.checkPermission();
   final bool serviceStatus =await Geolocator.isLocationServiceEnabled();
    if(permission != LocationPermission.whileInUse && permission != LocationPermission.always){
      final LocationPermission permission = await Geolocator.requestPermission();
      if(permission != LocationPermission.whileInUse && permission != LocationPermission.always){
        bool? granted = await navigateToPermission(permission, serviceStatus);
        if(granted!=null&&granted){
          setState(() {
            isLoading=false;
          });
        }else{
          exit(0);
        }
      }else{
        try{
          _currentPosition=await Geolocator.getCurrentPosition();
          setState(() {
            isLoading=false;
          });
        }catch(e){
          bool? granted = await navigateToPermission(permission, serviceStatus);
          if(granted!=null&&granted){
            setState(() {
              isLoading=false;
            });
          }else{
            exit(0);
          }
        }
      }
    }else{
      try{
        _currentPosition=await Geolocator.getCurrentPosition();
        setState(() {
          isLoading=false;
        });
      }catch(e){
        bool? granted = await navigateToPermission(permission, serviceStatus);
        if(granted!=null&&granted){
          setState(() {
            isLoading=false;
          });
        }else{
          exit(0);
        }
      }
    }
  }

  Future<bool?> navigateToPermission(LocationPermission permission,bool isServiceEnabled)async{
    return await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context)=>
            NoLocationScreen(isPermanentDenied: permission == LocationPermission.deniedForever ,
              isServiceDisabled: isServiceEnabled,)));
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CategoryRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<BlogRepository>(context);
    repo4 = Provider.of<ItemLocationRepository>(context);
    paidAdItemRepository = Provider.of<PaidAdItemRepository>(context);
    userUnreadMessageRepository =
        Provider.of<UserUnreadMessageRepository>(context);

    notificationRepository = Provider.of<NotificationRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);

    return isLoading?const Center(
      child: CircularProgressIndicator(),
    ):
    MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<NearestProductProvider>(
              lazy: false,
              create: (BuildContext context){
                _nearestProductProvider = NearestProductProvider(
                    repo: repo2, limit: valueHolder!.recentItemLoadingLimit!);
                    final String? loginUserId = Utils.checkUserLoginId(valueHolder!);
                  _nearestProductProvider
                      ?.productNearestParameterHolder.mile = valueHolder!.mile;
                  _nearestProductProvider?.resetProductList(loginUserId!,
                    _nearestProductProvider!.productNearestParameterHolder,context
                  );
                return _nearestProductProvider!;
              }),
          ChangeNotifierProvider<CategoryProvider>(
              lazy: false,
              create: (BuildContext context) {
                _categoryProvider ??= CategoryProvider(
                    repo: repo1,
                    psValueHolder: valueHolder,
                    limit: valueHolder!.categoryLoadingLimit!);
                _categoryProvider!
                    .loadCategoryList(
                        _categoryProvider!.categoryParameterHolder.toMap(),
                        Utils.checkUserLoginId(
                            _categoryProvider!.psValueHolder!))
                    .then((dynamic value) {
                  // Utils.psPrint("Is Has Internet " + value);
                  final bool isConnectedToIntenet = value ?? bool;
                  if (!isConnectedToIntenet) {
                    Fluttertoast.showToast(
                        msg: 'No Internet Connectiion. Please try again !',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);
                  }
                });
                return _categoryProvider!;
              }),
          ChangeNotifierProvider<RecentProductProvider?>(
              lazy: false,
              create: (BuildContext context) {
                _recentProductProvider = RecentProductProvider(
                    repo: repo2, limit: valueHolder!.recentItemLoadingLimit!);
                    _recentProductProvider!.productRecentParameterHolder.mile = valueHolder!.mile;
                    _recentProductProvider?.productRecentParameterHolder.lat = _currentPosition?.latitude.toString();
                    _recentProductProvider?.productRecentParameterHolder.lng = _currentPosition?.longitude.toString();
                    _recentProductProvider!.productRecentParameterHolder.itemLocationId = valueHolder!.locationId;
                    _recentProductProvider!.productRecentParameterHolder.itemLocationName = valueHolder!.locactionName;
                    if (valueHolder!.isSubLocation == PsConst.ONE) {
                      _recentProductProvider!.productRecentParameterHolder.itemLocationTownshipId = valueHolder!.locationTownshipId;
                      _recentProductProvider!.productRecentParameterHolder.itemLocationTownshipName = valueHolder!.locationTownshipName;
                    }
                    final String? loginUserId = Utils.checkUserLoginId(valueHolder!);
                    _recentProductProvider!.loadProductList(loginUserId, _recentProductProvider!.productRecentParameterHolder);
                return _recentProductProvider;
              }),
          ChangeNotifierProvider<PopularProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _popularProductProvider = PopularProductProvider(
                    repo: repo2, limit: valueHolder!.populartItemLoadingLimit!);
                    _popularProductProvider!.productPopularParameterHolder.mile = valueHolder!.mile;
                    _popularProductProvider!.productPopularParameterHolder.mile = valueHolder!.mile;
                    _popularProductProvider!.productPopularParameterHolder.itemLocationId = valueHolder!.locationId;
                    _popularProductProvider!.productPopularParameterHolder.itemLocationName = valueHolder!.locactionName;
                    if (valueHolder!.isSubLocation == PsConst.ONE) {
                      _popularProductProvider!.productPopularParameterHolder.itemLocationTownshipId = valueHolder!.locationTownshipId;
                      _popularProductProvider!.productPopularParameterHolder.itemLocationTownshipName = valueHolder!.locationTownshipName;
                    }
                    final String? loginUserId = Utils.checkUserLoginId(valueHolder!);
                    _popularProductProvider!.loadProductList(loginUserId, _popularProductProvider!.productPopularParameterHolder);

                return _popularProductProvider!;
              }),
          ChangeNotifierProvider<DiscountProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _discountProductProvider = DiscountProductProvider(
                    repo: repo2, limit: valueHolder!.discountItemLoadingLimit!);
                _discountProductProvider!.productDiscountParameterHolder
                    .mile = valueHolder!.mile;
                _discountProductProvider!.productDiscountParameterHolder
                    .itemLocationId = valueHolder!.locationId;
                _discountProductProvider!.productDiscountParameterHolder
                    .itemLocationName = valueHolder!.locactionName;
                if (valueHolder!.isSubLocation == PsConst.ONE) {
                  _discountProductProvider!.productDiscountParameterHolder
                      .itemLocationTownshipId = valueHolder!.locationTownshipId;
                  _discountProductProvider!.productDiscountParameterHolder
                          .itemLocationTownshipName =
                      valueHolder!.locationTownshipName;
                }
                final String? loginUserId =
                    Utils.checkUserLoginId(valueHolder!);
                _discountProductProvider!.loadProductList(loginUserId,
                    _discountProductProvider!.productDiscountParameterHolder);
                return _discountProductProvider!;
              }),    
          ChangeNotifierProvider<PaidAdProductProvider?>(
              lazy: false,
              create: (BuildContext context) {
                _paidAdItemProvider = PaidAdProductProvider(
                    repo: repo2, limit: valueHolder!.featuredItemLoadingLimit!);
                Geolocator.getCurrentPosition().then((Position position) {
                  _paidAdItemProvider!.productPaidAdParameterHolder.mile = valueHolder!.mile;
                  _paidAdItemProvider!.productPaidAdParameterHolder.lat = position.latitude.toString();
                  _paidAdItemProvider!.productPaidAdParameterHolder.lng = position.longitude.toString();
                  _paidAdItemProvider!.productPaidAdParameterHolder
                      .itemLocationId = valueHolder!.locationId;
                  _paidAdItemProvider!.productPaidAdParameterHolder
                      .itemLocationName = valueHolder!.locactionName;
                  if (valueHolder!.isSubLocation == PsConst.ONE) {
                    _paidAdItemProvider!.productPaidAdParameterHolder
                        .itemLocationTownshipId = valueHolder!.locationTownshipId;
                    _paidAdItemProvider!.productPaidAdParameterHolder
                        .itemLocationTownshipName =
                        valueHolder!.locationTownshipName;
                  }
                  final String? loginUserId =
                  Utils.checkUserLoginId(valueHolder!);
                  _paidAdItemProvider!.loadProductList(loginUserId,
                      _paidAdItemProvider!.productPaidAdParameterHolder);
                });
                return _paidAdItemProvider;
              }),
          ChangeNotifierProvider<BlogProvider?>(
              lazy: false,
              create: (BuildContext context) {
                _blogProvider = BlogProvider(
                    repo: repo3, limit: valueHolder!.blockSliderLoadingLimit!);
                _blogProvider?.blogParameterHolder.cityId =
                    valueHolder?.locationId;
                final String? loginUserId =
                    Utils.checkUserLoginId(valueHolder!);
                _blogProvider?.loadBlogList(
                    loginUserId!, _blogProvider!.blogParameterHolder);

                return _blogProvider;
              }),
          ChangeNotifierProvider<UserUnreadMessageProvider?>(
              lazy: false,
              create: (BuildContext context) {
                _userUnreadMessageProvider = UserUnreadMessageProvider(
                    repo: userUnreadMessageRepository);

                if (valueHolder!.loginUserId != null &&
                    valueHolder!.loginUserId != '') {
                  _userUnreadMessageProvider!.userUnreadMessageHolder =
                      UserUnreadMessageParameterHolder(
                          userId: valueHolder!.loginUserId,
                          deviceToken: valueHolder!.deviceToken);
                  _userUnreadMessageProvider!.userUnreadMessageCount(
                      _userUnreadMessageProvider!.userUnreadMessageHolder);
                }
                return _userUnreadMessageProvider;
              }),
          ChangeNotifierProvider<ItemListFromFollowersProvider?>(
              lazy: false,
              create: (BuildContext context) {
                _itemListFromFollowersProvider = ItemListFromFollowersProvider(
                    repo: repo2,
                    psValueHolder: valueHolder,
                    limit: valueHolder!.followerItemLoadingLimit!);
                
                _itemListFromFollowersProvider!.followUserItemParameterHolder
                      .itemLocationId = valueHolder!.locationId;
                if (valueHolder!.isSubLocation == PsConst.ONE) {
                  _itemListFromFollowersProvider!.followUserItemParameterHolder
                      .itemLocationTownshipId = valueHolder!.locationTownshipId;
                }     

                _itemListFromFollowersProvider!.loadItemListFromFollowersList(
                  _itemListFromFollowersProvider!.followUserItemParameterHolder.toMap(),
                    Utils.checkUserLoginId(
                        _itemListFromFollowersProvider!.psValueHolder!));
                return _itemListFromFollowersProvider;
              }),
        ],
        child: Scaffold(
          backgroundColor: PsColors.baseColor,
          // floatingActionButton: FadeTransition(
          //   opacity: widget.animationControllerForFab,
          //   child: ScaleTransition(
          //     scale: widget.animationControllerForFab,
          //     child: FloatingActionButton.extended(
          //       onPressed: () async {
          //         if (await Utils.checkInternetConnectivity()) {
          //           Utils.navigateOnUserVerificationView(
          //               _categoryProvider, context, () async {
          //             final dynamic returnData = await Navigator.pushNamed(
          //                 context, RoutePaths.itemEntry,
          //                 arguments: ItemEntryIntentHolder(
          //                     flag: PsConst.ADD_NEW_ITEM, item: Product()));
          //             if (returnData == true) {
          //               _recentProductProvider!.resetProductList(
          //                   valueHolder!.loginUserId,
          //                   _recentProductProvider!
          //                       .productRecentParameterHolder);
          //             }
          //           });
          //         } else {
          //           showDialog<dynamic>(
          //               context: context,
          //               builder: (BuildContext context) {
          //                 return ErrorDialog(
          //                   message: Utils.getString(
          //                       context, 'error_dialog__no_internet'),
          //                 );
          //               });
          //         }
          //       },
          //       icon: Icon(Icons.camera_alt,
          //           color: Utils.isLightMode(context)
          //               ? PsColors.primaryDarkWhite
          //               : PsColors.baseColor),
          //       backgroundColor: Utils.isLightMode(context)
          //           ? PsColors.primary500
          //           : PsColors.primaryDarkAccent,
          //       label: Text(Utils.getString(context, 'dashboard__submit_ad'),
          //           style: Theme.of(context).textTheme.caption!.copyWith(
          //               color: Utils.isLightMode(context)
          //                   ? PsColors.primaryDarkWhite
          //                   : PsColors.baseColor)),
          //     ),
          //   ),
          // ),

          // floatingActionButton: AnimatedContainer(
          //   duration: const Duration(milliseconds: 300),
          //   child: FloatingActionButton.extended(
          //     onPressed: () async {
          //       if (await Utils.checkInternetConnectivity()) {
          //         Utils.navigateOnUserVerificationView(
          //             _categoryProvider, context, () async {
          //           Navigator.pushNamed(context, RoutePaths.itemEntry,
          //               arguments: ItemEntryIntentHolder(
          //                   flag: PsConst.ADD_NEW_ITEM, item: Product()));
          //         });
          //       } else {
          //         showDialog<dynamic>(
          //             context: context,
          //             builder: (BuildContext context) {
          //               return ErrorDialog(
          //                 message: Utils.getString(
          //                     context, 'error_dialog__no_internet'),
          //               );
          //             });
          //       }
          //     },
          //     icon: _isVisible ? const Icon(Icons.camera_alt) : null,
          //     backgroundColor: PsColors.primary500,
          //     label: _isVisible
          //         ? Text(Utils.getString(context, 'dashboard__submit_ad'),
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .caption
          //                 .copyWith(color: PsColors.white))
          //         : const Text(''),
          //   ),
          //   height: _isVisible ? PsDimens.space52 : 0.0,
          //   width: PsDimens.space200,
          // ),

          // FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
          body: Container(
            
            child: RefreshIndicator(
                onRefresh: () {
                  final String? loginUserId =
                      Utils.checkUserLoginId(valueHolder!);
                  _recentProductProvider!.resetProductList(loginUserId,
                      _recentProductProvider!.productRecentParameterHolder);

                  _popularProductProvider!.resetProductList(loginUserId,
                      _popularProductProvider!.productPopularParameterHolder);

                  _discountProductProvider!.resetProductList(loginUserId,
                      _discountProductProvider!.productDiscountParameterHolder);    

                  _nearestProductProvider!.resetProductList(loginUserId!,
                      _nearestProductProvider!.productNearestParameterHolder,context);

                  _paidAdItemProvider!.resetProductList(loginUserId,
                      _paidAdItemProvider!.productPaidAdParameterHolder);
                                            
                  _blogProvider!.resetBlogList(
                      loginUserId, _blogProvider!.blogParameterHolder);

                  if (valueHolder!.loginUserId != null &&
                      valueHolder!.loginUserId != '') {
                    _userUnreadMessageProvider!.userUnreadMessageCount(
                        _userUnreadMessageProvider!.userUnreadMessageHolder);
                  }

                  _itemListFromFollowersProvider!
                      .resetItemListFromFollowersList( _itemListFromFollowersProvider!.followUserItemParameterHolder.toMap(),Utils.checkUserLoginId(
                          _itemListFromFollowersProvider!.psValueHolder!));

                  return _categoryProvider!
                      .resetCategoryList(
                          _categoryProvider!.categoryParameterHolder.toMap(),
                          Utils.checkUserLoginId(
                              _categoryProvider!.psValueHolder!))
                      .then((dynamic value) {
                    // Utils.psPrint("Is Has Internet " + value);
                    final bool isConnectedToIntenet = value ?? bool;
                    if (!isConnectedToIntenet) {
                      Fluttertoast.showToast(
                          msg: 'No Internet Connectiion. Please try again !',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white);
                    }
                  });
                },
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  controller: widget.scrollController,
                  slivers: <Widget>[

                    _HomeHeaderWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 1, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                      psValueHolder: valueHolder,
                      itemNameTextEditingController:
                          userInputItemNameTextEditingController,
                    ),
                    _HomeBlogProductSliderListWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 5, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _HomeCategoryHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 2, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),

                    RecentProductHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 3, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    NearestProductHorizontalListWidget(
                      psValueHolder: valueHolder!,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 3, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    HomeDiscountProductHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    HomePopularProductHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    HomePaidAdProductHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController: widget.animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                    ),


                    _HomeItemListFromFollowersHorizontalListWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                  ],
                )),
          ),
        ));
  }
}

class _HomeBlogProductSliderListWidget extends StatelessWidget {
  const _HomeBlogProductSliderListWidget({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final AnimationController? animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const int count = 6;
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController!,
            curve: const Interval((1 / count) * 1, 1.0,
                curve: Curves.fastOutSlowIn)));

    return SliverToBoxAdapter(
      child: Consumer<BlogProvider>(builder:
          (BuildContext context, BlogProvider blogProvider, Widget? child) {
        return AnimatedBuilder(
            animation: animationController!,
            child:Container(
                        width: double.infinity,
                        child: BlogSliderView(
                          blogList: blogProvider.blogList.data,
                          onTap: (Blog blog) {
                            Navigator.pushNamed(context, RoutePaths.blogDetail,
                                arguments: blog);
                          },
                        ),
                      ),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child));
            });
      }),
    );
  }
}

class _HomeCategoryHorizontalListWidget extends StatefulWidget {
  const _HomeCategoryHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController? animationController;
  final Animation<double> animation;
  final PsValueHolder? psValueHolder;

  @override
  __HomeCategoryHorizontalListWidgetState createState() =>
      __HomeCategoryHorizontalListWidgetState();
}

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider categoryProvider,
          Widget? child) {
        return AnimatedBuilder(
            animation: widget.animationController!,
            child: (categoryProvider.categoryList.data != null &&
                    categoryProvider.categoryList.data!.isNotEmpty)
                ? Column(children: <Widget>[
                    MyHeaderWidget(
                      headerName:
                          Utils.getString(context, 'Are you looking for'),
                      headerDescription:
                          '',
                      viewAllClicked: () {
                        Navigator.pushNamed(context, RoutePaths.categoryList,
                            arguments: 'Categories');
                      },
                    ),
                    Container(
                      height: PsDimens.space100,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.only(left: PsDimens.space8, right: PsDimens.space8),
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryProvider.categoryList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (categoryProvider.categoryList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: const Row(children: <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return CategoryHorizontalListItem(
                                category:
                                    categoryProvider.categoryList.data![index],
                                onTap: () {

                                  if (Utils.showUI(widget.psValueHolder!.subCatId)) {
                                    Navigator.pushNamed(
                                        context, RoutePaths.subCategoryGrid,
                                        arguments: categoryProvider
                                            .categoryList.data![index]);
                                  } else {
                                    try{
                                      Geolocator.getCurrentPosition().then((Position position) {
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        print(categoryProvider.categoryList.data![index].defaultPhoto!.imgPath);
                                        final ProductParameterHolder productParameterHolder = ProductParameterHolder().getLatestParameterHolder();
                                        productParameterHolder.mile = widget.psValueHolder!.mile;
                                        productParameterHolder.lat = position.latitude.toString();
                                        productParameterHolder.lng = position.longitude.toString();
                                        productParameterHolder.catId = categoryProvider.categoryList.data![index].catId;
                                        productParameterHolder.itemLocationId = widget.psValueHolder!.locationId;
                                        productParameterHolder.itemLocationName = widget.psValueHolder!.locactionName;
                                        if (widget.psValueHolder!.isSubLocation == PsConst.ONE) {
                                          productParameterHolder.itemLocationTownshipId = widget.psValueHolder!.locationTownshipId;
                                          productParameterHolder.itemLocationTownshipName = widget.psValueHolder!.locationTownshipName;
                                        }
                                        Navigator.pushNamed(context, RoutePaths.filterProductList,
                                            arguments: ProductListIntentHolder(
                                              appBarTitle: categoryProvider.categoryList.data![index].catName,
                                              productParameterHolder: productParameterHolder,
                                            ));
                                      }).catchError((Object e) {});
                                    }catch(e){
                                      Geolocator.openLocationSettings();
                                      exit(0);
                                    }
                                  }
                                },
                              );
                            }
                          }),
                    )
                  ])
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    ));
  }
}

class _HomeItemListFromFollowersHorizontalListWidget extends StatelessWidget {
  const _HomeItemListFromFollowersHorizontalListWidget({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final AnimationController? animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<ItemListFromFollowersProvider>(
        builder: (BuildContext context,
            ItemListFromFollowersProvider itemListFromFollowersProvider,
            Widget? child) {
          return AnimatedBuilder(
            animation: animationController!,
            child: (itemListFromFollowersProvider.psValueHolder!.loginUserId !=
                        '' &&
                    itemListFromFollowersProvider
                            .itemListFromFollowersList.data !=
                        null &&
                    itemListFromFollowersProvider
                        .itemListFromFollowersList.data!.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'dashboard__item_list_from_followers'),
                        headerDescription: '',
                        viewAllClicked: () {

                          Navigator.pushNamed(
                              context, RoutePaths.itemListFromFollower,
                                  arguments: <String, dynamic>{
                                        'userId': itemListFromFollowersProvider
                                  .psValueHolder!.loginUserId,
                                        'holder': itemListFromFollowersProvider.followUserItemParameterHolder
                                      }
                                  );
                        },
                      ),
                      Container(
                          height: PsDimens.space280,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: itemListFromFollowersProvider
                                  .itemListFromFollowersList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (itemListFromFollowersProvider
                                        .itemListFromFollowersList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: const Row(children: <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  return ProductHorizontalListItem(
                                    coreTagKey: itemListFromFollowersProvider
                                            .hashCode
                                            .toString() +
                                        itemListFromFollowersProvider
                                            .itemListFromFollowersList
                                            .data![index]
                                            .id!,
                                    product: itemListFromFollowersProvider
                                        .itemListFromFollowersList.data![index],
                                    onTap: () {
                                      print(itemListFromFollowersProvider
                                          .itemListFromFollowersList
                                          .data![index]
                                          .defaultPhoto!
                                          .imgPath);
                                      final Product product =
                                          itemListFromFollowersProvider
                                              .itemListFromFollowersList
                                              .data!
                                              .reversed
                                              .toList()[index];
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                              productId:
                                                  itemListFromFollowersProvider
                                                      .itemListFromFollowersList
                                                      .data![index]
                                                      .id,
                                              heroTagImage:
                                                  itemListFromFollowersProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id! +
                                                      PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle:
                                                  itemListFromFollowersProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id! +
                                                      PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                  );
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeHeaderWidget extends StatefulWidget {
  const _HomeHeaderWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder,
      required this.itemNameTextEditingController})
      : super(key: key);

  final AnimationController? animationController;
  final Animation<double> animation;
  final PsValueHolder? psValueHolder;
  final TextEditingController itemNameTextEditingController;

  @override
  __HomeHeaderWidgetState createState() => __HomeHeaderWidgetState();
}

class __HomeHeaderWidgetState extends State<_HomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: AnimatedBuilder(
            animation: widget.animationController!,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _MyHomeHeaderWidget(
                  userInputItemNameTextEditingController:
                      widget.itemNameTextEditingController,
                  selectedLocation: () {
                    Navigator.pushNamed(context, RoutePaths.itemLocationList);
                  },
                  locationName: widget.psValueHolder!.isSubLocation ==
                          PsConst.ONE
                      ? (widget.psValueHolder!.locationTownshipName.isEmpty ||
                              widget.psValueHolder!.locationTownshipName ==
                                  Utils.getString(
                                      context, 'product_list__category_all'))
                          ? widget.psValueHolder!.locactionName
                          : widget.psValueHolder!.locationTownshipName
                      : widget.psValueHolder!.locactionName,
                  psValueHolder: widget.psValueHolder,
                )
              ],
            ),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            }));
  }
}

class _MyHomeHeaderWidget extends StatefulWidget {
  const _MyHomeHeaderWidget(
      {Key? key,
      required this.userInputItemNameTextEditingController,
      required this.selectedLocation,
      required this.locationName,
      required this.psValueHolder})
      : super(key: key);

  final Function selectedLocation;
  final String? locationName;
  final TextEditingController userInputItemNameTextEditingController;
  final PsValueHolder? psValueHolder;
  @override
  __MyHomeHeaderWidgetState createState() => __MyHomeHeaderWidgetState();
}

final ProductParameterHolder productParameterHolder =
    ProductParameterHolder().getLatestParameterHolder();

class __MyHomeHeaderWidgetState extends State<_MyHomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.only(
        //     left: PsDimens.space20,
        //    // top: PsDimens.space20,
        //     right: PsDimens.space20,
        //     bottom: PsDimens.space4,
        //   ),
         // child: 
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
              // Flexible(
              //   child: Text(
              //     Utils.getString(context, 'app_name'),
              //     maxLines: 1,
              //     overflow: TextOverflow.ellipsis,
              //     style: Theme.of(context)
              //         .textTheme
              //         .headline5!
              //         .copyWith(color: PsColors.textPrimaryDarkColor),
              //   ),
              // ),
              // const SizedBox(width: PsDimens.space20),
              // Text(
              //   Utils.getString(context, 'dashboard__your_location'),
              //   style: Theme.of(context).textTheme.bodyText1,
              // ),
          //   ],
          // ),
       // ),
        // Padding(
        //   padding: const EdgeInsets.only(
        //       left: PsDimens.space20,
        //       right: PsDimens.space20,
        //       bottom: PsDimens.space4),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: <Widget>[
        //       Expanded(
        //         child: Text(
        //           Utils.getString(context, 'dashboard__connect_with_our'),
        //           style: Theme.of(context).textTheme.bodyText1,
        //         ),
        //       ),
        //       Column(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         crossAxisAlignment: CrossAxisAlignment.end,
        //         children: <Widget>[
        //           InkWell(
        //             onTap: widget.selectedLocation as void Function()?,
        //             child: Text(
        //               widget.locationName!,
        //               textAlign: TextAlign.right,
        //               style: Theme.of(context)
        //                   .textTheme
        //                   .subtitle1!
        //                   .copyWith(color: PsColors.primary500),
        //             ),
        //           ),
        //           MySeparator(color: PsColors.grey),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(
             // top: PsDimens.space24, 
              bottom: PsDimens.space10),
          child: PsTextFieldWidgetWithIcon(
              hintText: Utils.getString(context, 'home__bottom_app_bar_search'),
              textEditingController:
                  widget.userInputItemNameTextEditingController,
              psValueHolder: widget.psValueHolder,
              clickSearchButton: () {
                productParameterHolder.itemLocationId =
                    widget.psValueHolder!.locationId;
                productParameterHolder.itemLocationName =
                    widget.psValueHolder!.locactionName;
                if (widget.psValueHolder!.isSubLocation == PsConst.ONE) {
                  productParameterHolder.itemLocationTownshipId =
                      widget.psValueHolder!.locationTownshipId;
                  productParameterHolder.itemLocationTownshipName =
                      widget.psValueHolder!.locationTownshipName;
                }
                productParameterHolder.searchTerm =
                    widget.userInputItemNameTextEditingController.text;
                Navigator.pushNamed(context, RoutePaths.filterProductList,
                    arguments: ProductListIntentHolder(
                        appBarTitle: Utils.getString(
                            context, 'home_search__app_bar_title'),
                        productParameterHolder: productParameterHolder));
              },
              clickEnterFunction: () {
                productParameterHolder.itemLocationId =
                    widget.psValueHolder!.locationId;
                productParameterHolder.itemLocationName =
                    widget.psValueHolder!.locactionName;
                if (widget.psValueHolder!.isSubLocation == PsConst.ONE) {
                  productParameterHolder.itemLocationTownshipId =
                      widget.psValueHolder!.locationTownshipId;
                  productParameterHolder.itemLocationTownshipName =
                      widget.psValueHolder!.locationTownshipName;
                }
                productParameterHolder.searchTerm =
                    widget.userInputItemNameTextEditingController.text;
                Navigator.pushNamed(context, RoutePaths.filterProductList,
                    arguments: ProductListIntentHolder(
                        appBarTitle: Utils.getString(
                            context, 'home_search__app_bar_title'),
                        productParameterHolder: productParameterHolder));
              }),
        )
        //),
      ],
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({this.height = 1, this.color});
  final double height;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // final double boxWidth = constraints.constrainWidth();
        const double dashWidth = 10.0;
        final double dashHeight = height;
        const int dashCount = 10; //(boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List<Widget>.generate(dashCount, (_) {
            return Padding(
              padding: const EdgeInsets.only(right: PsDimens.space2),
              child: SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
