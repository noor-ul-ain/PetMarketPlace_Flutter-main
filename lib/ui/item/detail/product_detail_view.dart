import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/about_us/about_us_provider.dart';
import 'package:flutterbuyandsell/provider/app_info/app_info_provider.dart';
import 'package:flutterbuyandsell/provider/entry/item_entry_provider.dart';
import 'package:flutterbuyandsell/provider/gallery/gallery_provider.dart';
import 'package:flutterbuyandsell/provider/history/history_provider.dart';
import 'package:flutterbuyandsell/provider/product/favourite_item_provider.dart';
import 'package:flutterbuyandsell/provider/product/mark_sold_out_item_provider.dart';
import 'package:flutterbuyandsell/provider/product/product_provider.dart';
import 'package:flutterbuyandsell/provider/product/touch_count_provider.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/about_us_repository.dart';
import 'package:flutterbuyandsell/repository/app_info_repository.dart';
import 'package:flutterbuyandsell/repository/gallery_repository.dart';
import 'package:flutterbuyandsell/repository/history_repsitory.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutterbuyandsell/ui/common/dialog/choose_payment_type_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_expansion_tile.dart';
import 'package:flutterbuyandsell/ui/common/ps_hero.dart';
import 'package:flutterbuyandsell/ui/item/detail/product_detail_gallery_view.dart';
import 'package:flutterbuyandsell/ui/item/detail/views/faq_tile_view.dart';
import 'package:flutterbuyandsell/ui/item/detail/views/location_tile_view.dart';
import 'package:flutterbuyandsell/ui/item/detail/views/safety_tips_tile_view.dart';
import 'package:flutterbuyandsell/ui/item/detail/views/seller_info_tile_view.dart';
import 'package:flutterbuyandsell/ui/item/detail/views/static_tile_view.dart';
import 'package:flutterbuyandsell/ui/item/detail/views/terms_and_conditions_tile_view.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/default_photo.dart';
import 'package:flutterbuyandsell/viewobject/holder/favourite_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/mark_sold_out_item_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_block_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_delete_item_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_report_item_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const int maxFailedLoadAttempts = 3;

class ProductDetailView extends StatefulWidget {
  const ProductDetailView(
      {required this.productId,
        required this.heroTagImage,
        required this.heroTagTitle});

  final String? productId;
  final String? heroTagImage;
  final String? heroTagTitle;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  ProductRepository? productRepo;
  HistoryRepository? historyRepo;
  HistoryProvider? historyProvider;
  ItemDetailProvider? itemDetailProvider;
  TouchCountProvider? touchCountProvider;
  AppInfoProvider? appInfoProvider;
  GalleryProvider? galleryProvider;
  late GalleryRepository galleryRepository;
  AppInfoRepository? appInfoRepository;
  PsValueHolder? psValueHolder;
  AnimationController? animationController;
  AboutUsRepository? aboutUsRepo;
  AboutUsProvider? aboutUsProvider;
  MarkSoldOutItemProvider? markSoldOutItemProvider;
  MarkSoldOutItemParameterHolder? markSoldOutItemHolder;
  UserProvider? userProvider;
  UserRepository? userRepo;
  FavouriteItemProvider? favouriteProvider;
  bool isReadyToShowAppBarIcons = false;
  bool isAddedToHistory = false;
  bool isHaveVideo = false;
  DefaultPhoto? currentDefaultPhoto;
  int maxFailedLoadAttempts = 3;

  // static final AdRequest request = AdRequest(
  //   testDevices: <String>[Utils.getBannerAdUnitId()],
  //   keywords: <String>['foo', 'bar'],
  //   contentUrl: 'http://foo.com/bar.html',
  //   nonPersonalizedAds: true,
  // );

  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Utils.getInterstitialUnitId(),
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            _interstitialAd!.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isReadyToShowAppBarIcons = true;
        });
      });
    }
    psValueHolder = Provider.of<PsValueHolder>(context);

    historyRepo = Provider.of<HistoryRepository>(context);
    productRepo = Provider.of<ProductRepository>(context);
    aboutUsRepo = Provider.of<AboutUsRepository>(context);
    userRepo = Provider.of<UserRepository>(context);
    appInfoRepository = Provider.of<AppInfoRepository>(context);
    galleryRepository = Provider.of<GalleryRepository>(context);
    markSoldOutItemHolder =
        MarkSoldOutItemParameterHolder().markSoldOutItemHolder();
    markSoldOutItemHolder!.itemId = widget.productId;

    return PsWidgetWithMultiProvider(
        child: MultiProvider(
            providers: <SingleChildWidget>[
              ChangeNotifierProvider<ItemDetailProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  itemDetailProvider = ItemDetailProvider(
                      repo: productRepo, psValueHolder: psValueHolder);

                  final String? loginUserId =
                  Utils.checkUserLoginId(psValueHolder!);
                  itemDetailProvider!.loadProduct(widget.productId, loginUserId);

                  return itemDetailProvider;
                },
              ),
              ChangeNotifierProvider<HistoryProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  historyProvider = HistoryProvider(repo: historyRepo);
                  return historyProvider;
                },
              ),
              ChangeNotifierProvider<AboutUsProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  aboutUsProvider = AboutUsProvider(
                      repo: aboutUsRepo, psValueHolder: psValueHolder);
                  aboutUsProvider!.loadAboutUsList();
                  return aboutUsProvider;
                },
              ),
              ChangeNotifierProvider<MarkSoldOutItemProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  markSoldOutItemProvider =
                      MarkSoldOutItemProvider(repo: productRepo);

                  return markSoldOutItemProvider;
                },
              ),
              ChangeNotifierProvider<UserProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  userProvider =
                      UserProvider(repo: userRepo, psValueHolder: psValueHolder);
                  return userProvider;
                },
              ),
              ChangeNotifierProvider<TouchCountProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  touchCountProvider = TouchCountProvider(
                      repo: productRepo, psValueHolder: psValueHolder);
                  final String? loginUserId =
                  Utils.checkUserLoginId(psValueHolder!);

                  final TouchCountParameterHolder touchCountParameterHolder =
                  TouchCountParameterHolder(
                      itemId: widget.productId, userId: loginUserId);
                  touchCountProvider!
                      .postTouchCount(touchCountParameterHolder.toMap());
                  return touchCountProvider;
                },
              ),
              ChangeNotifierProvider<FavouriteItemProvider?>(
                  lazy: false,
                  create: (BuildContext context) {
                    favouriteProvider = FavouriteItemProvider(
                        repo: productRepo, psValueHolder: psValueHolder);
                    // provider.loadFavouriteList('prd9a3bfa2b7ab0f0693e84d834e73224bb');
                    return favouriteProvider;
                  }),
              ChangeNotifierProvider<AppInfoProvider?>(
                  lazy: false,
                  create: (BuildContext context) {
                    appInfoProvider = AppInfoProvider(
                        repo: appInfoRepository, psValueHolder: psValueHolder);

                    appInfoProvider!.loadDeleteHistorywithNotifier();

                    return appInfoProvider;
                  }),
              ChangeNotifierProvider<GalleryProvider?>(
                  lazy: false,
                  create: (BuildContext context) {
                    galleryProvider = GalleryProvider(repo: galleryRepository);
                    return galleryProvider;
                  }),
            ],
            child: Consumer<ItemDetailProvider>(
              builder: (BuildContext context, ItemDetailProvider provider,
                  Widget? child) {
                if (provider.itemDetail.data != null &&
                    markSoldOutItemProvider != null &&
                    userProvider != null) {
                  if (!isAddedToHistory) {
                    ///
                    /// Add to History
                    ///
                    historyProvider!.addHistoryList(provider.itemDetail.data);
                    isAddedToHistory = true;

                    if (psValueHolder != null &&
                        psValueHolder!.detailOpenCount != null &&
                        psValueHolder!.detailOpenCount! >
                            psValueHolder!.itemDetailViewCountForAds! &&
                        psValueHolder!.isShowAdsInItemDetail!) {
                      _createInterstitialAd();
                      itemDetailProvider!.replaceDetailOpenCount(0);
                      // if (_interstitialReady) {
                      //   _interstitialAd.show();
                      //   _interstitialReady = false;
                      // }
                    } else if (psValueHolder != null) {
                      if (psValueHolder!.detailOpenCount == null) {
                        itemDetailProvider!.replaceDetailOpenCount(1);
                      } else {
                        final int i = psValueHolder!.detailOpenCount! + 1;
                        itemDetailProvider!.replaceDetailOpenCount(i);
                      }
                    }
                  }

                  if (provider.itemDetail.data!.videoThumbnail!.imgPath != '') {
                    currentDefaultPhoto =
                        provider.itemDetail.data!.videoThumbnail;
                    isHaveVideo = true;
                  } else {
                    currentDefaultPhoto =
                        provider.itemDetail.data!.defaultPhoto;
                    isHaveVideo = false;
                  }

                  return Consumer<MarkSoldOutItemProvider>(builder:
                      (BuildContext context,
                      MarkSoldOutItemProvider markSoldOutItemProvider,
                      Widget? child) {
                    return Container(
                      color: PsColors.baseColor,
                      child: Stack(
                        children: <Widget>[
                          CustomScrollView(slivers: <Widget>[
                            SliverAppBar(
                              automaticallyImplyLeading: true,
                              systemOverlayStyle: SystemUiOverlayStyle(
                                statusBarIconBrightness:
                                Utils.getBrightnessForAppBar(context),
                              ),
                              expandedHeight: PsDimens.space300,
                              iconTheme: Theme.of(context)
                                  .iconTheme
                                  .copyWith(color: PsColors.primaryDarkWhite),
                              leading: PsBackButtonWithCircleBgWidget(
                                  isReadyToShow: isReadyToShowAppBarIcons),
                              floating: false,
                              pinned: false,
                              stretch: true,
                              actions: <Widget>[
                                Visibility(
                                  visible: isReadyToShowAppBarIcons,
                                  child: _PopUpMenuWidget(
                                      context: context,
                                      itemDetailProvider: provider,
                                      userProvider: userProvider,
                                      itemId: provider.itemDetail.data!.id,
                                      itemUserId: provider
                                          .itemDetail.data!.user!.userId,
                                      addedUserId:
                                      provider.itemDetail.data!.addedUserId,
                                      reportedUserId:
                                      psValueHolder!.loginUserId,
                                      loginUserId: psValueHolder!.loginUserId,
                                      itemTitle:
                                      provider.itemDetail.data!.title,
                                      itemImage: provider.itemDetail.data!
                                          .defaultPhoto!.imgPath),
                                ),
                              ],
                              backgroundColor: PsColors.primaryDarkDark,
                              flexibleSpace: FlexibleSpaceBar(
                                background: Container(
                                  color: PsColors.backgroundColor,
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: <Widget>[
                                      // PsNetworkImage(
                                      //   photoKey:
                                      //       widget.heroTagImage! + '_ignore',
                                      //   defaultPhoto: provider
                                      //       .itemDetail.data!.defaultPhoto,
                                      //   width: double.infinity,
                                      //   height: PsDimens.space300,
                                      //   boxfit: BoxFit.cover,
                                      //   imageAspectRation:
                                      //       PsConst.Aspect_Ratio_full_image,
                                      //   onTap: () {

                                      ProductDetailGalleryView(
                                        selectedDefaultImage:
                                        currentDefaultPhoto!,
                                        isHaveVideo: isHaveVideo,
                                        onImageTap: () {
                                          Navigator.pushNamed(
                                              context, RoutePaths.galleryGrid,
                                              arguments:
                                              provider.itemDetail.data);
                                        },
                                      ),
                                      // PsNetworkImage(
                                      //   photoKey: widget.heroTagImage + '_ignore',
                                      //   defaultPhoto:
                                      //       provider.itemDetail.data.defaultPhoto,
                                      //   width: double.infinity,
                                      //   height: PsDimens.space300,
                                      //   boxfit: BoxFit.cover,
                                      //   imageAspectRation:
                                      //       PsConst.Aspect_Ratio_full_image,
                                      //   onTap: () {
                                      //     Navigator.pushNamed(
                                      //         context, RoutePaths.galleryGrid,
                                      //         arguments:
                                      //             provider.itemDetail.data);
                                      //   },
                                      // ),
                                      if (provider.itemDetail.data!
                                          .addedUserId ==
                                          provider
                                              .psValueHolder!.loginUserId ||
                                          provider.itemDetail.data!
                                              .addedUserId !=
                                              provider
                                                  .psValueHolder!.loginUserId)
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: PsDimens.space12,
                                              right: PsDimens.space12),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              if (provider.itemDetail.data!
                                                  .paidStatus ==
                                                  PsConst.ADSPROGRESS &&
                                                  provider.itemDetail.data!
                                                      .addedUserId ==
                                                      provider.psValueHolder!
                                                          .loginUserId)
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                      color: PsColors
                                                          .paidAdsColor),
                                                  padding: const EdgeInsets.all(
                                                      PsDimens.space12),
                                                  child: Text(
                                                    Utils.getString(context,
                                                        'paid__ads_in_progress'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                        color:
                                                        PsColors.white),
                                                  ),
                                                )
                                              else if (provider.itemDetail.data!
                                                  .paidStatus ==
                                                  PsConst.ADS_REJECT &&
                                                  provider.itemDetail.data!
                                                      .addedUserId ==
                                                      provider.psValueHolder!
                                                          .loginUserId)
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                      color: Colors.red),
                                                  padding: const EdgeInsets.all(
                                                      PsDimens.space12),
                                                  child: Text(
                                                    Utils.getString(context,
                                                        'paid__ads_in_rejected'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                        color:
                                                        PsColors.white),
                                                  ),
                                                )
                                              else if (provider.itemDetail.data!
                                                    .paidStatus ==
                                                    PsConst
                                                        .ADS_WAITING_FOR_APPROVAL &&
                                                    provider.itemDetail.data!
                                                        .addedUserId ==
                                                        provider.psValueHolder!
                                                            .loginUserId)
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                        color: Colors.yellow),
                                                    padding: const EdgeInsets.all(
                                                        PsDimens.space12),
                                                    child: Text(
                                                      Utils.getString(context,
                                                          'paid__ads_waiting'),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                          color:
                                                          PsColors.white),
                                                    ),
                                                  )
                                                else if (provider.itemDetail.data!
                                                      .paidStatus ==
                                                      PsConst.ADSFINISHED &&
                                                      provider.itemDetail.data!
                                                          .addedUserId ==
                                                          provider.psValueHolder!
                                                              .loginUserId) ...<Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              PsDimens.space4),
                                                          color: PsColors.black),
                                                      padding: const EdgeInsets.all(
                                                          PsDimens.space12),
                                                      child: Text(
                                                        Utils.getString(context,
                                                            'paid__ads_in_completed'),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                            color:
                                                            PsColors.white),
                                                      ),
                                                    )
                                                  ] else if (provider.itemDetail
                                                      .data!.paidStatus ==
                                                      PsConst.ADSNOTYETSTART &&
                                                      provider.itemDetail.data!
                                                          .addedUserId ==
                                                          provider.psValueHolder!
                                                              .loginUserId) ...<Widget>[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              PsDimens.space4),
                                                          color: Colors.yellow),
                                                      padding: const EdgeInsets.all(
                                                          PsDimens.space12),
                                                      child: Text(
                                                        Utils.getString(context,
                                                            'paid__ads_is_not_yet_start'),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                            color:
                                                            PsColors.white),
                                                      ),
                                                    )
                                                  ] else ...<Widget>[
                                                    Container()
                                                  ],
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: PsDimens.space4,
                                                    bottom: PsDimens.space4),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  children: <Widget>[
                                                    if (provider.itemDetail
                                                        .data!.isSoldOut ==
                                                        '1')
                                                      provider.itemDetail.data!
                                                          .isSoldOut ==
                                                          '1'
                                                          ? Expanded(
                                                        child: Container(
                                                          margin: const EdgeInsets
                                                              .only(
                                                              right: PsDimens
                                                                  .space4),
                                                          child: Padding(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                left: PsDimens
                                                                    .space12,
                                                                right: PsDimens
                                                                    .space12),
                                                            child: Align(
                                                              alignment:
                                                              Alignment
                                                                  .center,
                                                              child: Text(
                                                                Utils.getString(
                                                                    context,
                                                                    'dashboard__sold_out'),
                                                                style: Theme.of(
                                                                    context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                    color: PsColors.white),
                                                              ),
                                                            ),
                                                          ),
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(PsDimens
                                                                  .space4),
                                                              color: PsColors
                                                                  .soldOutUIColor),
                                                        ),
                                                      )
                                                          : Container()
                                                    //   )
                                                    // ],
                                                    // )
                                                    // else if (provider.itemDetail
                                                    //         .data!.addedUserId ==
                                                    //     provider.psValueHolder!
                                                    //         .loginUserId)
                                                    //   Expanded(
                                                    //     child: InkWell(
                                                    //       onTap: () {
                                                    //         showDialog<dynamic>(
                                                    //             context: context,
                                                    //             builder:
                                                    //                 (BuildContext
                                                    //                     context) {
                                                    //               return ConfirmDialogView(
                                                    //                   description:
                                                    //                       Utils.getString(
                                                    //                           context,
                                                    //                           'item_detail__sold_out_item'),
                                                    //                   leftButtonText:
                                                    //                       Utils.getString(
                                                    //                           context,
                                                    //                           'item_detail__sold_out_dialog_cancel_button'),
                                                    //                   rightButtonText:
                                                    //                       Utils.getString(
                                                    //                           context,
                                                    //                           'item_detail__sold_out_dialog_ok_button'),
                                                    //                   onAgreeTap:
                                                    //                       () async {
                                                    //                     await PsProgressDialog
                                                    //                         .showDialog(
                                                    //                             context);
                                                    //                     await await markSoldOutItemProvider.loadmarkSoldOutItem(
                                                    //                         psValueHolder!
                                                    //                             .loginUserId,
                                                    //                         markSoldOutItemHolder);
                                                    //                     PsProgressDialog
                                                    //                         .dismissDialog();
                                                    //                     if (markSoldOutItemProvider
                                                    //                             .markSoldOutItem
                                                    //                             .data !=
                                                    //                         null) {
                                                    //                       setState(
                                                    //                           () {
                                                    //                         provider
                                                    //                             .itemDetail
                                                    //                             .data!
                                                    //                             .isSoldOut = markSoldOutItemProvider.markSoldOutItem.data!.isSoldOut;
                                                    //                       });
                                                    //                     }

                                                    //                     Navigator.of(
                                                    //                             context)
                                                    //                         .pop();
                                                    //                   });
                                                    //             });
                                                    //       },
                                                    //       child: Container(
                                                    //         margin:
                                                    //             const EdgeInsets
                                                    //                     .only(
                                                    //                 right: PsDimens
                                                    //                     .space4),
                                                    //         decoration: BoxDecoration(
                                                    //             borderRadius:
                                                    //                 BorderRadius
                                                    //                     .circular(
                                                    //                         PsDimens
                                                    //                             .space4),
                                                    //             color: PsColors
                                                    //                 .primary500),
                                                    //         padding:
                                                    //             const EdgeInsets
                                                    //                     .all(
                                                    //                 PsDimens
                                                    //                     .space12),
                                                    //         child: Text(
                                                    //           Utils.getString(
                                                    //               context,
                                                    //               'item_detail__mark_sold'),
                                                    //           style: Theme.of(
                                                    //                   context)
                                                    //               .textTheme
                                                    //               .bodyText2!
                                                    //               .copyWith(
                                                    //                   color: PsColors
                                                    //                       .white),
                                                    //         ),
                                                    //       ),
                                                    //     ),
                                                    //),
                                                    // InkWell(
                                                    //   child: Container(
                                                    //     decoration: BoxDecoration(
                                                    //         borderRadius:
                                                    //             BorderRadius
                                                    //                 .circular(
                                                    //                     PsDimens
                                                    //                         .space4),
                                                    //         color:
                                                    //             Colors.black45),
                                                    //     padding:
                                                    //         const EdgeInsets.all(
                                                    //             PsDimens.space12),
                                                    //     child: Row(
                                                    //       crossAxisAlignment:
                                                    //           CrossAxisAlignment
                                                    //               .end,
                                                    //       mainAxisAlignment:
                                                    //           MainAxisAlignment
                                                    //               .end,
                                                    //       mainAxisSize:
                                                    //           MainAxisSize.min,
                                                    //       children: <Widget>[
                                                    //         Icon(
                                                    //           Entypo.picture, //Ionicons.md_images,
                                                    //           color:
                                                    //               PsColors.white,
                                                    //         ),
                                                    //         const SizedBox(
                                                    //             width: PsDimens
                                                    //                 .space12),
                                                    //         Text(
                                                    //           '${provider.itemDetail.data!.photoCount}  ${Utils.getString(context, 'item_detail__photo')}',
                                                    //           style: Theme.of(
                                                    //                   context)
                                                    //               .textTheme
                                                    //               .bodyText2!
                                                    //               .copyWith(
                                                    //                   color: PsColors
                                                    //                       .white),
                                                    //         ),
                                                    //       ],
                                                    //     ),
                                                    //   ),
                                                    //   onTap: () {
                                                    //     Navigator.pushNamed(
                                                    //         context,
                                                    //         RoutePaths
                                                    //             .galleryGrid,
                                                    //         arguments: provider
                                                    //             .itemDetail.data);
                                                    //   },
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        Padding(
                                          padding: const EdgeInsets.all(
                                              PsDimens.space8),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              if (provider.itemDetail.data!
                                                  .paidStatus ==
                                                  PsConst.ADSPROGRESS &&
                                                  provider.itemDetail.data!
                                                      .addedUserId ==
                                                      provider.psValueHolder!
                                                          .loginUserId)
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                      color: PsColors
                                                          .paidAdsColor),
                                                  padding: const EdgeInsets.all(
                                                      PsDimens.space12),
                                                  child: Text(
                                                    Utils.getString(context,
                                                        'paid__ads_in_progress'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                        color:
                                                        PsColors.white),
                                                  ),
                                                )
                                              else if (provider.itemDetail.data!
                                                  .paidStatus ==
                                                  PsConst.ADSFINISHED &&
                                                  provider.itemDetail.data!
                                                      .addedUserId ==
                                                      provider.psValueHolder!
                                                          .loginUserId)
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                      color: PsColors.black),
                                                  padding: const EdgeInsets.all(
                                                      PsDimens.space12),
                                                  child: Text(
                                                    Utils.getString(context,
                                                        'paid__ads_in_completed'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                        color:
                                                        PsColors.white),
                                                  ),
                                                )
                                              else if (provider.itemDetail.data!
                                                    .paidStatus ==
                                                    PsConst.ADSNOTYETSTART &&
                                                    provider.itemDetail.data!
                                                        .addedUserId ==
                                                        provider.psValueHolder!
                                                            .loginUserId)
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                        color: Colors.yellow),
                                                    padding: const EdgeInsets.all(
                                                        PsDimens.space12),
                                                    child: Text(
                                                      Utils.getString(context,
                                                          'paid__ads_is_not_yet_start'),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                          color:
                                                          PsColors.white),
                                                    ),
                                                  )
                                                else
                                                  Container(),
                                              InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                      color: Colors.black45),
                                                  padding: const EdgeInsets.all(
                                                      PsDimens.space12),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    children: <Widget>[
                                                      Icon(
                                                        Entypo
                                                            .picture, //Ionicons.md_images,
                                                        color: PsColors.white,
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                          PsDimens.space12),
                                                      Text(
                                                        '${provider.itemDetail.data!.photoCount}  ${Utils.getString(context, 'item_detail__photo')}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                            color: PsColors
                                                                .white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      RoutePaths.galleryGrid,
                                                      arguments: provider
                                                          .itemDetail.data);
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate(<Widget>[
                                Container(
                                  color: PsColors.baseColor,
                                  child: Column(children: <Widget>[
                                    _HeaderBoxWidget(
                                      itemDetail: provider,
                                      galleryProvider: galleryProvider,
                                      product: provider.itemDetail.data,
                                      heroTagTitle: widget.heroTagTitle,
                                      favouriteProvider: favouriteProvider!,
                                    ),
                                  ]),
                                )
                              ]),
                            ),
                            SliverGrid.extent(
                                maxCrossAxisExtent: 300.0,
                                childAspectRatio: 3.1,
                                children: <Widget>[
                                  if (Utils.showUI(psValueHolder?.typeId) &&
                                      provider.itemDetail.data!.itemType!
                                          .name !=
                                          '')
                                    Container(
                                      color: PsColors.baseColor,
                                      padding: const EdgeInsets.only(
                                          left: PsDimens.space12,
                                          top: PsDimens.space4,
                                          right: PsDimens.space12,
                                          bottom: PsDimens.space4),
                                      child: _IconsAndTitleTextWidget(
                                        title: Utils.getString(
                                            context, 'item_entry__type'),
                                        name:
                                        '${provider.itemDetail.data!.itemType!.name}',
                                        isStatus: false,
                                      ),
                                    ),
                                  Container(
                                    color: PsColors.baseColor,
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space12,
                                        top: PsDimens.space4,
                                        right: PsDimens.space12,
                                        bottom: PsDimens.space4),
                                    child: _IconsAndTitleTextWidget(
                                      title: Utils.getString(context, 'Status'),
                                      name:
                                      provider.itemDetail.data!.isSoldOut ==
                                          '1'
                                          ? 'Sold Out'
                                          : 'Available',
                                      isStatus: true,
                                    ),
                                  ),
                                  if (provider.itemDetail.data!.addedDateStr !=
                                      '')
                                    Container(
                                      color: PsColors.baseColor,
                                      padding: const EdgeInsets.only(
                                          left: PsDimens.space12,
                                          top: PsDimens.space4,
                                          right: PsDimens.space12,
                                          bottom: PsDimens.space4),
                                      child: _IconsAndTitleTextWidget(
                                        title: Utils.getString(
                                            context, 'Posted On'),
                                        name:
                                        '${provider.itemDetail.data!.addedDateStr}',
                                        isStatus: false,
                                      ),
                                    ),
                                  if (Utils.showUI(
                                      psValueHolder?.conditionOfItemId) &&
                                      provider.itemDetail.data!.conditionOfItem!
                                          .name !=
                                          '')
                                    Container(
                                      color: PsColors.baseColor,
                                      padding: const EdgeInsets.only(
                                          left: PsDimens.space12,
                                          top: PsDimens.space4,
                                          right: PsDimens.space12,
                                          bottom: PsDimens.space4),
                                      child: _IconsAndTitleTextWidget(
                                        title: Utils.getString(context,
                                            'item_entry__item_condition'),
                                        name:
                                        '${provider.itemDetail.data!.conditionOfItem!.name}',
                                        isStatus: false,
                                      ),
                                    ),
                                  if (Utils.showUI(psValueHolder?.brand) &&
                                      provider.itemDetail.data!.brand != '')
                                    Container(
                                      color: PsColors.baseColor,
                                      padding: const EdgeInsets.only(
                                          left: PsDimens.space12,
                                          top: PsDimens.space4,
                                          right: PsDimens.space12,
                                          bottom: PsDimens.space4),
                                      child: _IconsAndTitleTextWidget(
                                        title:
                                        Utils.getString(context, 'Brand'),
                                        name:
                                        '${provider.itemDetail.data!.brand}',
                                        isStatus: false,
                                      ),
                                    ),
                                  if (Utils.showUI(
                                      psValueHolder?.dealOptionId) &&
                                      provider.itemDetail.data!.dealOption!
                                          .name !=
                                          '')
                                    Container(
                                      color: PsColors.baseColor,
                                      padding: const EdgeInsets.only(
                                          left: PsDimens.space12,
                                          top: PsDimens.space4,
                                          right: PsDimens.space12,
                                          bottom: PsDimens.space4),
                                      child: _IconsAndTitleTextWidget(
                                        title: Utils.getString(
                                            context, 'item_entry__deal_option'),
                                        name:
                                        '${provider.itemDetail.data!.dealOption!.name}',
                                        isStatus: false,
                                      ),
                                    ),
                                  if (Utils.showUI(
                                      psValueHolder?.dealOptionRemark) &&
                                      provider.itemDetail.data!
                                          .dealOptionRemark !=
                                          '')
                                    Container(
                                      color: PsColors.baseColor,
                                      padding: const EdgeInsets.only(
                                          left: PsDimens.space12,
                                          top: PsDimens.space4,
                                          right: PsDimens.space12,
                                          bottom: PsDimens.space4),
                                      child: _IconsAndTitleTextWidget(
                                        title: Utils.getString(
                                            context, 'item_entry__remark'),
                                        name:
                                        '${provider.itemDetail.data!.dealOptionRemark}',
                                        isStatus: false,
                                      ),
                                    )
                                ]),
                            SliverList(
                              delegate: SliverChildListDelegate(<Widget>[
                                Container(
                                  color: PsColors.baseColor,
                                  child: Column(children: <Widget>[
                                    _DetailWidget(itemDetail: provider),
                                    const SizedBox(
                                      height: PsDimens.space10,
                                    ),
                                    SellerInfoTileView(
                                      itemDetail: provider,
                                    ),
                                    // if (provider.itemDetail.data!.isOwner ==
                                    //         PsConst.ONE &&
                                    //     provider.itemDetail.data!.status ==
                                    //         PsConst.ONE &&
                                    //     (provider.itemDetail.data!.paidStatus ==
                                    //             PsConst.ADSNOTAVAILABLE ||
                                    //         provider.itemDetail.data!
                                    //                 .paidStatus ==
                                    //             PsConst.ADSFINISHED) &&
                                    //     appInfoProvider!.appInfo.data != null &&
                                    //     !isAllPaymentDisable(appInfoProvider!))
                                    //   PromoteTileView(
                                    //     animationController: animationController,
                                    //     product: provider.itemDetail.data,
                                    //     provider: provider,
                                    //   )
                                    // else
                                    //   Container(),
                                    SafetyTipsTileView(
                                        animationController:
                                        animationController),
                                    if (Utils.showUI(psValueHolder!.address))
                                      LocationTileView(
                                          item: provider.itemDetail.data),
                                    // GettingThisTileView(
                                    //     detailOption:
                                    //         provider.itemDetail.data!.dealOption,
                                    //     address:
                                    //         provider.itemDetail.data!.address),
                                    TermsAndConditionTileView(
                                        animationController:
                                        animationController),
                                    FAQTileView(
                                        animationController:
                                        animationController),
                                    if (provider.itemDetail.data!.addedUserId !=
                                        null &&
                                        provider.itemDetail.data!.addedUserId ==
                                            psValueHolder!.loginUserId)
                                      StatisticTileView(
                                        provider,
                                      ),
                                    const SizedBox(
                                      height: PsDimens.space80,
                                    ),
                                  ]),
                                )
                              ]),
                            ),
                          ]),
                          if (provider.itemDetail.data!.addedUserId != null &&
                              provider.itemDetail.data!.addedUserId ==
                                  psValueHolder!.loginUserId)
                            _EditAndDeleteButtonWidget(
                              provider: provider,
                              markSoldOutItemProvider: markSoldOutItemProvider,
                              appInfoprovider: appInfoProvider!,
                              product: provider.itemDetail.data,
                              markSoldOutItemHolder: markSoldOutItemHolder,
                            )
                          else
                            _CallAndChatButtonWidget(
                              provider: provider,
                              favouriteItemRepo: productRepo,
                              psValueHolder: psValueHolder,
                            ),
                        ],
                      ),
                    );
                  });
                } else {
                  return Container();
                }
              },
            )));
  }
}

dynamic isAllPaymentDisable(AppInfoProvider appInfoProvider) {
  if (appInfoProvider.appInfo.data!.inAppPurchasedEnabled == PsConst.ZERO &&
      appInfoProvider.appInfo.data!.stripeEnable == PsConst.ZERO &&
      appInfoProvider.appInfo.data!.paypalEnable == PsConst.ZERO &&
      appInfoProvider.appInfo.data!.payStackEnabled == PsConst.ZERO &&
      appInfoProvider.appInfo.data!.razorEnable == PsConst.ZERO &&
      appInfoProvider.appInfo.data!.offlineEnabled == PsConst.ZERO) {
    return true;
  } else {
    return false;
  }
}

class _PopUpMenuWidget extends StatelessWidget {
  const _PopUpMenuWidget(
      {required this.userProvider,
        required this.itemId,
        required this.itemUserId,
        required this.addedUserId,
        required this.reportedUserId,
        required this.loginUserId,
        required this.itemTitle,
        required this.itemImage,
        required this.context,
        required this.itemDetailProvider});
  final UserProvider? userProvider;
  final String? itemId;
  final String? addedUserId;
  final String? reportedUserId;
  final String? loginUserId;
  final String? itemUserId;
  final String? itemTitle;
  final String? itemImage;
  final BuildContext context;
  final ItemDetailProvider itemDetailProvider;

  Future<void> _onSelect(String value) async {
    switch (value) {
      case '1':
        showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialogView(
                description: Utils.getString(
                    context, 'item_detail__confirm_dialog_report_item'),
                leftButtonText: Utils.getString(context, 'dialog__cancel'),
                rightButtonText: Utils.getString(context, 'dialog__ok'),
                onAgreeTap: () async {
                  await PsProgressDialog.showDialog(context);

                  final UserReportItemParameterHolder
                  userReportItemParameterHolder =
                  UserReportItemParameterHolder(
                      itemId: itemId, reportedUserId: reportedUserId);

                  final PsResource<ApiStatus> _apiStatus = await userProvider!
                      .userReportItem(userReportItemParameterHolder.toMap());

                  if (_apiStatus.data != null &&
                      _apiStatus.data!.status != null) {
                    await itemDetailProvider.deleteLocalProductCacheById(
                        itemId, reportedUserId);
                  }

                  PsProgressDialog.dismissDialog();

                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(RoutePaths.home));
                });
          },
        );

        break;

      case '2':
        showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialogView(
                description: Utils.getString(
                    context, 'item_detail__confirm_dialog_block_user'),
                leftButtonText: Utils.getString(context, 'dialog__cancel'),
                rightButtonText: Utils.getString(context, 'dialog__ok'),
                onAgreeTap: () async {
                  await PsProgressDialog.showDialog(context);

                  final UserBlockParameterHolder userBlockItemParameterHolder =
                  UserBlockParameterHolder(
                      loginUserId: loginUserId, addedUserId: addedUserId);

                  final PsResource<ApiStatus> _apiStatus = await userProvider!
                      .blockUser(userBlockItemParameterHolder.toMap());

                  if (_apiStatus.data != null &&
                      _apiStatus.data!.status != null) {
                    await itemDetailProvider.deleteLocalProductCacheByUserId(
                        loginUserId, addedUserId);
                  }

                  PsProgressDialog.dismissDialog();

                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(RoutePaths.home));
                });
          },
        );
        break;

      case '3':
        final Size size = MediaQuery.of(context).size;
        if (itemDetailProvider.itemDetail.data!.dynamicLink != null) {
          Share.share(
            'Go to App:\n' + itemDetailProvider.itemDetail.data!.dynamicLink!,
            // +'Image:\n' + PsConfig.ps_app_image_url + itemImage,
            sharePositionOrigin:
            Rect.fromLTWH(0, 0, size.width, size.height / 2),
          );
        }
        // else{
        //   Share.share(
        //     'Go to App:\n Image:\n' + PsConfig.ps_app_image_url + itemImage,
        //     sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
        //   );
        // }

        // await FlutterShare.share(
        //     title: itemTitle,
        //     text: 'Go to App:\n' +
        //             itemDetailProvider.itemDetail.data.dynamicLink ??
        //         '',
        //     linkUrl: 'Image:\n' + PsConfig.ps_app_image_url + itemImage);

        // final HttpClientRequest request = await HttpClient()
        //     .getUrl(Uri.parse(PsConfig.ps_app_image_url + itemImage));
        // final HttpClientResponse response = await request.close();
        // final Uint8List bytes =
        //     await consolidateHttpClientResponseBytes(response);
        //     await Share.file(itemTitle, itemTitle + '.jpg', bytes, 'image/jpg',
        //     text: itemTitle + '\n' + itemDetailProvider.itemDetail.data.dynamicLink);
        break;
      default:
        print('English');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12, right: PsDimens.space12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: PsColors.black.withAlpha(100),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
              iconTheme:
              Theme.of(context).iconTheme.copyWith(color: PsColors.white)),
          child: PopupMenuButton<String>(
            onSelected: _onSelect,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                if (itemDetailProvider.psValueHolder!.loginUserId !=
                    itemUserId &&
                    itemDetailProvider.psValueHolder!.loginUserId != null &&
                    itemDetailProvider.psValueHolder!.loginUserId != '')
                  PopupMenuItem<String>(
                    value: '1',
                    child: Visibility(
                      visible: true,
                      child: Text(
                        Utils.getString(context, 'item_detail__report_item'),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                if (itemDetailProvider.psValueHolder!.loginUserId !=
                    itemUserId &&
                    itemDetailProvider.psValueHolder!.loginUserId != null &&
                    itemDetailProvider.psValueHolder!.loginUserId != '')
                  PopupMenuItem<String>(
                    value: '2',
                    child: Visibility(
                      visible: true,
                      child: Text(
                        Utils.getString(context, 'item_detail__block_user'),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                PopupMenuItem<String>(
                  value: '3',
                  child: Text(Utils.getString(context, 'item_detail__share'),
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ];
            },
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ));
  }
}

class _HeaderBoxWidget extends StatefulWidget {
  const _HeaderBoxWidget(
      {Key? key,
        required this.itemDetail,
        required this.galleryProvider,
        required this.favouriteProvider,
        required this.product,
        required this.heroTagTitle})
      : super(key: key);

  final ItemDetailProvider itemDetail;
  final GalleryProvider? galleryProvider;
  final FavouriteItemProvider favouriteProvider;
  final Product? product;
  final String? heroTagTitle;

  @override
  __HeaderBoxWidgetState createState() => __HeaderBoxWidgetState();
}

class __HeaderBoxWidgetState extends State<_HeaderBoxWidget> {
  bool showEditButton = true; //to wait images loading

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Widget? icon;
    final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context);

    if (widget.product != null && widget.itemDetail.itemDetail.data != null) {
      return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12,
            right: PsDimens.space12,
            bottom: PsDimens.space12),
        //   decoration: BoxDecoration(
        // //    color: PsColors.backgroundColor,
        //     borderRadius:
        //         const BorderRadius.all(Radius.circular(PsDimens.space8)),
        //   ),
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.end,
          //  crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space14,
                        right: PsDimens.space14,
                        top: PsDimens.space14,
                        bottom: PsDimens.space12),
                    child: PsHero(
                      tag: widget.heroTagTitle!,
                      child: Text(widget.itemDetail.itemDetail.data!.title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ),
                ),
                if (widget.itemDetail.itemDetail.data!.addedUserId != '' &&
                    widget.itemDetail.itemDetail.data!.addedUserId !=
                        psValueHolder.loginUserId)
                  GestureDetector(
                      onTap: () async {
                        if (await Utils.checkInternetConnectivity()) {
                          Utils.navigateOnUserVerificationView(
                              widget.itemDetail, context, () async {
                            if (widget
                                .itemDetail.itemDetail.data!.isFavourited ==
                                '0') {
                              setState(() {
                                widget.itemDetail.itemDetail.data!
                                    .isFavourited = '1';
                              });
                            } else {
                              setState(() {
                                widget.itemDetail.itemDetail.data!
                                    .isFavourited = '0';
                              });
                            }

                            final FavouriteParameterHolder
                            favouriteParameterHolder =
                            FavouriteParameterHolder(
                              userId: psValueHolder.loginUserId,
                              itemId: widget.product!.id,
                            );

                            final PsResource<Product> _apiStatus =
                            await widget.favouriteProvider.postFavourite(
                                favouriteParameterHolder.toMap());

                            if (_apiStatus.data != null) {
                              if (_apiStatus.status == PsStatus.SUCCESS) {
                                await widget.itemDetail.loadItemForFav(
                                    widget.product!.id!,
                                    psValueHolder.loginUserId);
                              }
                              if (widget.itemDetail.itemDetail.data != null) {
                                if (widget.itemDetail.itemDetail.data!
                                    .isFavourited ==
                                    PsConst.ONE) {
                                  icon = Container(
                                    padding: const EdgeInsets.only(
                                        top: PsDimens.space8,
                                        left: PsDimens.space8,
                                        right: PsDimens.space8,
                                        bottom: PsDimens.space6),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: PsColors.primary500,
                                            width: 1),
                                        shape: BoxShape.circle),
                                    child: Icon(Icons.favorite,
                                        color: PsColors.primary500),
                                  );
                                } else {
                                  icon = Container(
                                    padding: const EdgeInsets.only(
                                        top: PsDimens.space8,
                                        left: PsDimens.space8,
                                        right: PsDimens.space8,
                                        bottom: PsDimens.space6),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: PsColors.primary500,
                                            width: 1),
                                        shape: BoxShape.circle),
                                    child: Icon(Icons.favorite_border,
                                        color: PsColors.primary500),
                                  );
                                }
                              }
                            } else {
                              print('There is no comment');
                            }
                          });
                        } else {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ErrorDialog(
                                  message: Utils.getString(
                                      context, 'error_dialog__no_internet'),
                                );
                              });
                        }
                      },
                      child: (widget.itemDetail.itemDetail.data != null)
                          ? widget.itemDetail.itemDetail.data!.isFavourited ==
                          PsConst.ZERO
                          ? icon = Container(
                        padding: const EdgeInsets.only(
                            top: PsDimens.space8,
                            left: PsDimens.space8,
                            right: PsDimens.space8,
                            bottom: PsDimens.space6),
                        // decoration: BoxDecoration(
                        //     border: Border.all(
                        //         color: PsColors.secondary100,),
                        //     //shape: BoxShape.circle
                        //     ),
                        child: Icon(Icons.favorite_border,
                            color: PsColors.activeColor),
                      )
                          : icon = Container(
                        padding: const EdgeInsets.only(
                            top: PsDimens.space8,
                            left: PsDimens.space8,
                            right: PsDimens.space8,
                            bottom: PsDimens.space6),
                        // decoration: BoxDecoration(
                        //     border: Border.all(
                        //         color: PsColors.secondary100, width: 1),
                        //    // shape: BoxShape.circle
                        //     ),
                        child: Icon(Icons.favorite,
                            color: PsColors.activeColor),
                      )
                          : icon = Container())
                else
                  Visibility(
                    visible: showEditButton,
                    child: InkWell(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(right: PsDimens.space8),
                          child:
                          Icon(FontAwesome.edit, color: PsColors.iconColor),
                        ),
                        onTap: () async {
                          final dynamic entryData = await Navigator.pushNamed(
                              context, RoutePaths.itemEntry,
                              arguments: ItemEntryIntentHolder(
                                  flag: PsConst.EDIT_ITEM,
                                  item: widget.itemDetail.itemDetail.data));
                          if (entryData != null &&
                              entryData is bool &&
                              entryData) {
                            setState(() {
                              showEditButton = false;
                            });
                            await widget.galleryProvider!.loadImageList(
                                widget.itemDetail.itemDetail.data!.id,
                                PsConst.ITEM_TYPE);
                            widget.itemDetail.loadProduct(
                                widget.itemDetail.itemDetail.data!.id,
                                Utils.checkUserLoginId(
                                    widget.itemDetail.psValueHolder!));
                          }
                          setState(() {
                            showEditButton = true;
                          });
                        }),
                  ),
              ],
            ),
            // _IconsAndTwoTitleTextWidget(
            //     icon: Icons.schedule,
            //     title: '${widget.itemDetail.itemDetail.data!.addedDateStr}',
            //     color: PsColors.grey,
            //     itemProvider: widget.itemDetail),
            if (Utils.showUI(psValueHolder.priceTypeId) &&
                widget.itemDetail.itemDetail.data!.itemPriceType!.name != '')
              _PriceAndPriceTypeWidgetWithDiscount(
                // icon: Octicons.tag, //AntDesign.tago,
                  title: widget.itemDetail.itemDetail.data != null &&
                      (widget.itemDetail.itemDetail.data!.discountRate ==
                          '' ||
                          widget.itemDetail.itemDetail.data!.discountRate ==
                              '0')
                      ? widget.itemDetail.itemDetail.data!.price != '0' &&
                      widget.itemDetail.itemDetail.data!.price != ''
                      ? '${widget.itemDetail.itemDetail.data!.itemCurrency!.currencySymbol} ${Utils.getPriceFormat(widget.itemDetail.itemDetail.data!.price!, psValueHolder.priceFormat!)}'
                      : Utils.getString(context, 'item_price_free')
                      : '${widget.itemDetail.itemDetail.data!.itemCurrency!.currencySymbol} ${Utils.getPriceFormat(widget.itemDetail.itemDetail.data!.discountedPrice!, psValueHolder.priceFormat!)}',
                  subTitle:
                  '${widget.itemDetail.itemDetail.data!.itemPriceType!.name}',
                  discountRate:
                  widget.itemDetail.itemDetail.data!.discountRate!,
                  originalPrice:
                  '  ${widget.itemDetail.itemDetail.data!.itemCurrency!.currencySymbol} ${Utils.getPriceFormat(widget.itemDetail.itemDetail.data!.price!, psValueHolder.priceFormat!)}  ',
                  color: PsColors.textColor1)
            else
              _PriceAndPriceTypeWidgetWithDiscount(
                //  icon:Octicons.tag, //AntDesign.tago,
                  title: widget.itemDetail.itemDetail.data != null &&
                      (widget.itemDetail.itemDetail.data!.discountRate ==
                          '' ||
                          widget.itemDetail.itemDetail.data!.discountRate ==
                              '0')
                      ? widget.itemDetail.itemDetail.data!.price != '0' &&
                      widget.itemDetail.itemDetail.data!.price != ''
                      ? '${widget.itemDetail.itemDetail.data!.itemCurrency!.currencySymbol} ${Utils.getPriceFormat(widget.itemDetail.itemDetail.data!.price!, psValueHolder.priceFormat!)}'
                      : Utils.getString(context, 'item_price_free')
                      : '${widget.itemDetail.itemDetail.data!.itemCurrency!.currencySymbol} ${Utils.getPriceFormat(widget.itemDetail.itemDetail.data!.discountedPrice!, psValueHolder.priceFormat!)}',
                  subTitle: '',
                  discountRate:
                  widget.itemDetail.itemDetail.data!.discountRate!,
                  originalPrice:
                  '${widget.itemDetail.itemDetail.data!.itemCurrency!.currencySymbol} ${Utils.getPriceFormat(widget.itemDetail.itemDetail.data!.price!, psValueHolder.priceFormat!)}',
                  color: PsColors.textColor1
                // color: PsColors.primary500
              ),

            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 8, top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: PsColors.iconColor,
                    size: 23,
                  ),
                  const SizedBox(
                    width: PsDimens.space6,
                  ),
                  Text(
                    '${widget.itemDetail.itemDetail.data!.favouriteCount} ${Utils.getString(context, 'item_detail__like_count')}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 13),
                  )
                ],
              ),
            ),
            //),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _DescriptionWedget extends StatelessWidget {
  const _DescriptionWedget({Key? key, required this.description})
      : super(key: key);
  final String? description;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PsDimens.space16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Utils.getString(context, 'product_detail__product_description'),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14, color: PsColors.textColor3),
            ),
            const SizedBox(height: PsDimens.space2),
            Text(description!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    height: 1.3,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: PsColors.textColor2))
          ]),
    );
  }
}

class _IconsAndTitleTextWidget extends StatelessWidget {
  const _IconsAndTitleTextWidget({
    Key? key,
    //required this.icon,
    this.title,
    this.name,
    this.isStatus,
    //required this.color,
  }) : super(key: key);

  //final IconData icon;
  final String? title;
  final String? name;
  final bool? isStatus;
  //final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        //   bottom: PsDimens.space16
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Icon(
          //   icon,
          //   size: PsDimens.space18,
          // ),
          // const SizedBox(
          //   width: PsDimens.space16,
          // ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title ?? '',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: PsColors.textColor3) //PsColors.secondary400),
                ),
                Text(
                  name ?? '',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: isStatus!
                          ? PsColors.textColor1
                          : PsColors.textColor2),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailWidget extends StatelessWidget {
  const _DetailWidget({
    Key? key,
    required this.itemDetail,
  }) : super(key: key);
  final ItemDetailProvider itemDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //  mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        if (Utils.showUI(itemDetail.psValueHolder?.businessMode) &&
            itemDetail.itemDetail.data!.businessMode != '1')
          Padding(
            padding: const EdgeInsets.only(
                left: PsDimens.space16,
                bottom: PsDimens.space24,
                top: PsDimens.space8),
            child: Row(
              children: <Widget>[
                Icon(
                  FontAwesome5.store_slash,
                  color: PsColors.iconColor,
                  size: 18,
                ),
                const SizedBox(
                  width: PsDimens.space16,
                ),
                Text('Not shop. Available for only one item',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: PsColors.textColor1))
              ],
            ),
          ),
        if (Utils.showUI(itemDetail.psValueHolder?.highlightInfo) &&
            itemDetail.itemDetail.data!.highlightInformation != '')
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
                left: PsDimens.space20,
                right: PsDimens.space20,
                bottom: PsDimens.space8),
            child: Card(
              elevation: 0.0,
              shape: const BeveledRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(PsDimens.space8)),
              ),
              color: PsColors.cardBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  itemDetail.itemDetail.data!.highlightInformation!,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      letterSpacing: 0.8,
                      fontSize: 14,
                      height: 1.3,
                      color: PsColors.textColor2),
                ),
              ),
            ),
          )
        else
          Container(),
        if (itemDetail.itemDetail.data!.description != '')
          _DescriptionWedget(
            description: itemDetail.itemDetail.data!.description,
          )
        else
          Container(),
      ],
    );
  }
}

// class _IconsAndTwoTitleTextWidget extends StatelessWidget {
//   const _IconsAndTwoTitleTextWidget({
//     Key? key,
//     required this.icon,
//     required this.title,
//     required this.itemProvider,
//     required this.color,
//   }) : super(key: key);

//   final IconData icon;
//   final String title;
//   final ItemDetailProvider itemProvider;
//   final Color? color;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//           left: PsDimens.space16,
//           right: PsDimens.space16,
//           bottom: PsDimens.space16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Icon(
//             icon,
//             size: PsDimens.space18,
//           ),
//           const SizedBox(
//             width: PsDimens.space16,
//           ),
//           Text(
//             title,
//             style: color == null
//                 ? Theme.of(context).textTheme.bodyText1
//                 : Theme.of(context).textTheme.bodyText1!.copyWith(color: color),
//           ),
//           const SizedBox(
//             width: PsDimens.space8,
//           ),
//           InkWell(
//             onTap: () {
//               Navigator.pushNamed(context, RoutePaths.userDetail,
//                   // arguments: itemProvider.itemDetail.data.addedUserId
//                   arguments: UserIntentHolder(
//                       userId: itemProvider.itemDetail.data!.addedUserId,
//                       userName: itemProvider.itemDetail.data!.user!.userName));
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   itemProvider.itemDetail.data!.user!.userName == ''
//                       ? Utils.getString(context, 'default__user_name')
//                       : '${itemProvider.itemDetail.data!.user!.userName}',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyText2?.copyWith(color: PsColors.primary500),
//                 ),
//                 if (itemProvider.itemDetail.data!.user!.isVerifyBlueMark ==
//                     PsConst.ONE)
//                   Container(
//                     margin: const EdgeInsets.only(left: PsDimens.space2),
//                     child: Icon(
//                      Icons.check_circle,
//                       color: PsColors.bluemarkColor,
//                       size: PsConfig.blueMarkSize,
//                     ),
//                   )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _CallAndChatButtonWidget extends StatefulWidget {
  const _CallAndChatButtonWidget({
    Key? key,
    required this.provider,
    required this.favouriteItemRepo,
    required this.psValueHolder,
  }) : super(key: key);

  final ItemDetailProvider provider;
  final ProductRepository? favouriteItemRepo;
  final PsValueHolder? psValueHolder;

  @override
  __CallAndChatButtonWidgetState createState() =>
      __CallAndChatButtonWidgetState();
}

class __CallAndChatButtonWidgetState extends State<_CallAndChatButtonWidget> {
  FavouriteItemProvider? favouriteProvider;
  Widget? icon;
  @override
  Widget build(BuildContext context) {
    if (widget.provider.itemDetail.data != null) {
      return ChangeNotifierProvider<FavouriteItemProvider?>(
          lazy: false,
          create: (BuildContext context) {
            favouriteProvider = FavouriteItemProvider(
                repo: widget.favouriteItemRepo,
                psValueHolder: widget.psValueHolder);
            // provider.loadFavouriteList('prd9a3bfa2b7ab0f0693e84d834e73224bb');
            return favouriteProvider;
          },
          child: Consumer<FavouriteItemProvider>(builder: (BuildContext context,
              FavouriteItemProvider provider, Widget? child) {
            return Container(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: PsDimens.space72,
                child: Container(
                  decoration: BoxDecoration(
                    color: PsColors.baseColor,
                    border: Border.all(color: PsColors.backgroundColor),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(PsDimens.space12),
                        topRight: Radius.circular(PsDimens.space12)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: PsColors.backgroundColor,
                        blurRadius:
                        10.0, // has the effect of softening the shadow
                        spreadRadius:
                        0, // has the effect of extending the shadow
                        offset: const Offset(
                          0.0, // horizontal, move right 10
                          0.0, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: PsDimens.space16,
                        right: PsDimens.space16,
                        bottom: PsDimens.space16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if (widget.provider.itemDetail.data!.user!.userPhone !=
                            null &&
                            widget.provider.itemDetail.data!.user!.userPhone !=
                                '' &&
                            widget.provider.itemDetail.data!.user!
                                .isShowPhone ==
                                '1')
                          Visibility(
                              visible: true,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: PsDimens.space16,
                                    right: PsDimens.space16),
                                child: PSButtonWithIconWidget(
                                  colorData: PsColors.buttonColor,
                                  hasShadow: false,
                                  icon: Icons.call,
                                  iconColor: PsColors.textColor4,
                                  width: 150,
                                  titleText: Utils.getString(
                                      context, 'item_detail__call'),
                                  onPressed: () async {
                                    if (await canLaunchUrl(Uri.parse(
                                        'tel://${widget.provider.itemDetail.data!.user!.userPhone}'))) {
                                      await launchUrl(Uri.parse(
                                          'tel://${widget.provider.itemDetail.data!.user!.userPhone}'));
                                    } else {
                                      throw 'Could not Call Phone';
                                    }
                                  },
                                ),
                              ))
                        else
                          const SizedBox(
                            width: PsDimens.space16,
                          ),

                        Consumer<ItemDetailProvider>(builder:
                            (BuildContext context, ItemDetailProvider provider,
                            Widget? child) {
                          if (provider.itemDetail.data != null) {
                            return Expanded(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  PSButtonWithIconWidget(
                                    hasShadow: false,
                                    colorData: PsColors.buttonColor,
                                    icon: Icons.chat,
                                    iconColor: PsColors.textColor4,
                                    width: 185,
                                    titleText: Utils.getString(
                                        context, 'chat_on_whatsApp'),
                                    onPressed: () async {
                                      if (await Utils
                                          .checkInternetConnectivity()) {
                                        openWhatsApp(provider
                                            .itemDetail.data!.whatsappNumber!);
                                      }
                                    },
                                  ),
                                  PSButtonWithIconWidget(
                                    hasShadow: false,
                                    colorData: PsColors.buttonColor,
                                    // icon: Icons.chat,
                                    iconColor: PsColors.textColor4,
                                    width: 110,
                                    titleText:
                                    Utils.getString(context, 'copy_number'),
                                    onPressed: () async {
                                      if (await Utils
                                          .checkInternetConnectivity()) {
                                        await Clipboard.setData(ClipboardData(
                                            text: provider.itemDetail.data!
                                                .whatsappNumber!));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        })

                        // Expanded(
                        //   child:
                        //   Padding(
                        //      padding: const EdgeInsets.only(left: 20,right: 10),
                        //     child: PSButtonWithIconWidget(
                        //       hasShadow: false,
                        //       colorData: PsColors.buttonColor,
                        //       icon: Icons.chat,
                        //       iconColor: PsColors.textColor4,
                        //       width: double.infinity,
                        //       titleText:
                        //           Utils.getString(context, 'item_detail__chat'),
                        //       onPressed: () async {
                        //         if (await Utils.checkInternetConnectivity()) {
                        //           Utils.navigateOnUserVerificationView(
                        //               widget.provider, context, () async {
                        //             Navigator.pushNamed(
                        //                 context, RoutePaths.chatView,
                        //                 arguments: ChatHistoryIntentHolder(
                        //                   chatFlag: PsConst.CHAT_FROM_SELLER,
                        //                   itemId:
                        //                       widget.provider.itemDetail.data!.id,
                        //                   buyerUserId:
                        //                       widget.psValueHolder!.loginUserId,
                        //                   sellerUserId: widget.provider.itemDetail
                        //                       .data!.addedUserId,
                        //                 ));
                        //           });
                        //         }
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }));
    } else {
      return Container();
    }
  }
}

void openWhatsApp(String phoneNumber) async {
  String url = 'https://wa.me/$phoneNumber/?text=${Uri.encodeFull('Hi')}';

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch WhatsApp.');
  }
}

class _EditAndDeleteButtonWidget extends StatelessWidget {
  const _EditAndDeleteButtonWidget({
    Key? key,
    required this.provider,
    required this.markSoldOutItemProvider,
    required this.appInfoprovider,
    required this.product,
    required this.markSoldOutItemHolder,
  }) : super(key: key);

  final ItemDetailProvider provider;
  final MarkSoldOutItemProvider markSoldOutItemProvider;
  final AppInfoProvider appInfoprovider;
  final Product? product;
  final MarkSoldOutItemParameterHolder? markSoldOutItemHolder;
  @override
  Widget build(BuildContext context) {
    final PsValueHolder? psValueHolder = Provider.of<PsValueHolder>(context);

    if (provider.itemDetail.data != null) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: PsDimens.space12),
              SizedBox(
                width: double.infinity,
                height: PsDimens.space72,
                child: Container(
                  decoration: BoxDecoration(
                    color: PsColors.backgroundColor,
                    border: Border.all(color: PsColors.backgroundColor),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(PsDimens.space12),
                        topRight: Radius.circular(PsDimens.space12)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: PsColors.backgroundColor,
                        blurRadius:
                        10.0, // has the effect of softening the shadow
                        spreadRadius:
                        0, // has the effect of extending the shadow
                        offset: const Offset(
                          0.0, // horizontal, move right 10
                          0.0, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(PsDimens.space8),
                    child: ((provider.itemDetail.data!.isSoldOut == '1') &&
                        !(provider.itemDetail.data!.isOwner ==
                            PsConst.ONE &&
                            provider.itemDetail.data!.status ==
                                PsConst.ONE &&
                            (provider.itemDetail.data!.paidStatus ==
                                PsConst.ADSNOTAVAILABLE ||
                                provider.itemDetail.data!.paidStatus ==
                                    PsConst.ADSFINISHED) &&
                            appInfoprovider.appInfo.data != null &&
                            !isAllPaymentDisable(appInfoprovider)))
                        ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      child: PSButtonWithIconWidget(
                        hasShadow: false,
                        // width: PsDimens.space40,
                        //icon: Icons.delete,
                        colorData: PsColors.buttonColor,
                        titleText: Utils.getString(
                            context, 'item_detail__delete'),
                        onPressed: () async {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmDialogView(
                                    description: Utils.getString(context,
                                        'item_detail__delete_desc'),
                                    leftButtonText: Utils.getString(
                                        context, 'dialog__cancel'),
                                    rightButtonText: Utils.getString(
                                        context, 'dialog__ok'),
                                    onAgreeTap: () async {
                                      final UserDeleteItemParameterHolder
                                      userDeleteItemParameterHolder =
                                      UserDeleteItemParameterHolder(
                                        itemId:
                                        provider.itemDetail.data!.id,
                                      );
                                      await PsProgressDialog.showDialog(
                                          context);
                                      final PsResource<ApiStatus>
                                      _apiStatus =
                                      await (provider.userDeleteItem(
                                          userDeleteItemParameterHolder
                                              .toMap()) as FutureOr<
                                          PsResource<ApiStatus>>);
                                      PsProgressDialog.dismissDialog();
                                      if (_apiStatus.data!.status ==
                                          'success') {
                                        await provider
                                            .deleteLocalProductCacheById(
                                            provider
                                                .itemDetail.data!.id,
                                            psValueHolder!
                                                .loginUserId);
                                        Fluttertoast.showToast(
                                            msg: 'Item Deleated',
                                            toastLength:
                                            Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                            Colors.blueGrey,
                                            textColor: Colors.white);
                                        // Navigator.pop(context, true);
                                        Navigator.pushReplacementNamed(
                                          context,
                                          RoutePaths.home,
                                        );
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'Item is not Deleated',
                                            toastLength:
                                            Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                            Colors.blueGrey,
                                            textColor: Colors.white);
                                      }
                                    });
                              });
                        },
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        PSButtonWithIconWidget(
                          hasShadow: false,
                          width: PsDimens.space64,
                          icon: Icons.delete,
                          colorData: PsColors.buttonColor,
                          // titleText:
                          //     Utils.getString(context, 'item_detail__delete'),
                          onPressed: () async {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialogView(
                                      description: Utils.getString(
                                          context,
                                          'item_detail__delete_desc'),
                                      leftButtonText: Utils.getString(
                                          context, 'dialog__cancel'),
                                      rightButtonText: Utils.getString(
                                          context, 'dialog__ok'),
                                      onAgreeTap: () async {
                                        final UserDeleteItemParameterHolder
                                        userDeleteItemParameterHolder =
                                        UserDeleteItemParameterHolder(
                                          itemId: provider
                                              .itemDetail.data!.id,
                                        );
                                        await PsProgressDialog.showDialog(
                                            context);
                                        final PsResource<ApiStatus>
                                        _apiStatus =
                                        await provider.userDeleteItem(
                                            userDeleteItemParameterHolder
                                                .toMap());
                                        PsProgressDialog.dismissDialog();
                                        if (_apiStatus.data!.status ==
                                            'success') {
                                          await provider
                                              .deleteLocalProductCacheById(
                                              provider.itemDetail
                                                  .data!.id,
                                              psValueHolder!
                                                  .loginUserId);

                                          Fluttertoast.showToast(
                                              msg: 'Item Deleated',
                                              toastLength:
                                              Toast.LENGTH_SHORT,
                                              gravity:
                                              ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                              Colors.blueGrey,
                                              textColor: Colors.white);
                                          // Navigator.pop(context, true);
                                          Navigator.pushReplacementNamed(
                                            context,
                                            RoutePaths.home,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Item is not Deleated',
                                              toastLength:
                                              Toast.LENGTH_SHORT,
                                              gravity:
                                              ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                              Colors.blueGrey,
                                              textColor: Colors.white);
                                        }
                                      });
                                });
                          },
                        ),
                        const SizedBox(
                          width: PsDimens.space10,
                        ),
                        if (provider.itemDetail.data!.isSoldOut != '1')
                          Expanded(
                            child: PSButtonWithIconWidget(
                              hasShadow: false,
                              width: PsDimens.space40,
                              // icon: Icons.delete,
                              colorData: PsColors.buttonColor,
                              titleText: Utils.getString(
                                  context, 'item_detail__mark_sold'),
                              onPressed: () async {
                                showDialog<dynamic>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ConfirmDialogView(
                                          description: Utils.getString(
                                              context,
                                              'item_detail__sold_out_item'),
                                          leftButtonText: Utils.getString(
                                              context,
                                              'item_detail__sold_out_dialog_cancel_button'),
                                          rightButtonText: Utils.getString(
                                              context,
                                              'item_detail__sold_out_dialog_ok_button'),
                                          onAgreeTap: () async {
                                            await PsProgressDialog
                                                .showDialog(context);
                                            await await markSoldOutItemProvider
                                                .loadmarkSoldOutItem(
                                                psValueHolder!
                                                    .loginUserId,
                                                markSoldOutItemHolder);
                                            PsProgressDialog
                                                .dismissDialog();
                                            if (markSoldOutItemProvider
                                                .markSoldOutItem
                                                .data !=
                                                null) {
                                              //  setState(
                                              //      () {
                                              provider.itemDetail.data!
                                                  .isSoldOut =
                                                  markSoldOutItemProvider
                                                      .markSoldOutItem
                                                      .data!
                                                      .isSoldOut;
                                              // });
                                            }

                                            Navigator.of(context).pop();
                                          });
                                    });
                              },
                            ),
                          ),
                        const SizedBox(
                          width: PsDimens.space10,
                        ),
                        if (provider.itemDetail.data!.isOwner ==
                            PsConst.ONE &&
                            provider.itemDetail.data!.status ==
                                PsConst.ONE &&
                            (provider.itemDetail.data!.paidStatus ==
                                PsConst.ADSNOTAVAILABLE ||
                                provider.itemDetail.data!.paidStatus ==
                                    PsConst.ADSFINISHED) &&
                            appInfoprovider.appInfo.data != null &&
                            !isAllPaymentDisable(appInfoprovider))
                          Expanded(
                            child: PSButtonWithIconWidget(
                              hasShadow: false,
                              width: PsDimens.space40,
                              //icon: Icons.delete,
                              colorData: PsColors.buttonColor,
                              titleText: Utils.getString(
                                  context, 'item_detail__promte'),
                              onPressed: () async {
                                if (appInfoprovider.appInfo.data!
                                    .inAppPurchasedEnabled ==
                                    PsConst.ONE &&
                                    appInfoprovider
                                        .appInfo.data!.stripeEnable ==
                                        PsConst.ZERO &&
                                    appInfoprovider
                                        .appInfo.data!.paypalEnable ==
                                        PsConst.ZERO &&
                                    appInfoprovider.appInfo.data!
                                        .payStackEnabled ==
                                        PsConst.ZERO &&
                                    appInfoprovider
                                        .appInfo.data!.razorEnable ==
                                        PsConst.ZERO &&
                                    appInfoprovider.appInfo.data!
                                        .offlineEnabled ==
                                        PsConst.ZERO) {
                                  // InAppPurchase View
                                  final dynamic returnData =
                                  await Navigator.pushNamed(context,
                                      RoutePaths.inAppPurchase,
                                      arguments: <String, dynamic>{
                                        'productId': product!.id,
                                        'appInfo':
                                        appInfoprovider.appInfo.data
                                      });
                                  if (returnData == true ||
                                      returnData == null) {
                                    final String? loginUserId =
                                    Utils.checkUserLoginId(
                                        provider.psValueHolder!);
                                    provider.loadProduct(
                                        product!.id, loginUserId);
                                  }
                                } else if (appInfoprovider.appInfo.data!
                                    .inAppPurchasedEnabled ==
                                    PsConst.ZERO) {
                                  //Original Item Promote View
                                  final dynamic returnData =
                                  await Navigator.pushNamed(
                                      context, RoutePaths.itemPromote,
                                      arguments: product);
                                  if (returnData == true ||
                                      returnData == null) {
                                    final String? loginUserId =
                                    Utils.checkUserLoginId(
                                        provider.psValueHolder!);
                                    provider.loadProduct(
                                        product!.id, loginUserId);
                                  }
                                } else {
                                  //choose payment
                                  showDialog<dynamic>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ChoosePaymentTypeDialog(
                                          onInAppPurchaseTap: () async {
                                            final dynamic returnData =
                                            await Navigator.pushNamed(
                                                context,
                                                RoutePaths
                                                    .inAppPurchase,
                                                arguments: <String,
                                                    dynamic>{
                                                  'productId':
                                                  product!.id,
                                                  'appInfo':
                                                  appInfoprovider
                                                      .appInfo.data
                                                });
                                            if (returnData == true ||
                                                returnData == null) {
                                              final String? loginUserId =
                                              Utils.checkUserLoginId(
                                                  provider
                                                      .psValueHolder!);
                                              provider.loadProduct(
                                                  product!.id,
                                                  loginUserId);
                                            }
                                          },
                                          onOtherPaymentTap: () async {
                                            final dynamic returnData =
                                            await Navigator.pushNamed(
                                                context,
                                                RoutePaths
                                                    .itemPromote,
                                                arguments: product);
                                            if (returnData == true ||
                                                returnData == null) {
                                              final String? loginUserId =
                                              Utils.checkUserLoginId(
                                                  provider
                                                      .psValueHolder!);
                                              provider.loadProduct(
                                                  product!.id,
                                                  loginUserId);
                                            }
                                          },
                                        );
                                      });
                                }
                              },
                            ),
                          ),

                        // Expanded(
                        //   child:
                        //  RaisedButton(
                        //   child: Text(
                        //     Utils.getString(context, 'item_detail__edit'),
                        //     overflow: TextOverflow.ellipsis,
                        //     maxLines: 1,
                        //     textAlign: TextAlign.center,
                        //     softWrap: false,
                        //   ),
                        //   color: PsColors.primary500,
                        //   shape: const BeveledRectangleBorder(
                        //       borderRadius: BorderRadius.all(
                        //     Radius.circular(PsDimens.space8),
                        //   )),
                        //   textColor: Theme.of(context).textTheme.button.copyWith(color: PsColors.white).color,
                        //   onPressed: () async {
                        //     PSButtonWithIconWidget(
                        //   hasShadow: true,
                        //   width: double.infinity,
                        //   icon: Icons.edit,
                        //   titleText:
                        //       Utils.getString(context, 'item_detail__edit'),
                        //   onPressed: () async {
                        //     final dynamic entryData = await Navigator.pushNamed(
                        //         context, RoutePaths.itemEntry,
                        //         arguments: ItemEntryIntentHolder(
                        //             flag: PsConst.EDIT_ITEM,
                        //             item: provider.itemDetail.data));
                        //     if (entryData != null &&
                        //         entryData is bool &&
                        //         entryData) {
                        //       provider.loadProduct(
                        //           provider.itemDetail.data!.id,
                        //           Utils.checkUserLoginId(
                        //               provider.psValueHolder!));
                        //     }
                        //   },
                        // ),
                        //  ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class _PriceAndPriceTypeWidgetWithDiscount extends StatelessWidget {
  const _PriceAndPriceTypeWidgetWithDiscount({
    Key? key,
    // required this.icon,
    required this.title,
    required this.subTitle,
    required this.color,
    required this.discountRate,
    required this.originalPrice,
  }) : super(key: key);

  //final IconData icon;
  final String title;
  final String subTitle;
  final Color? color;
  final String discountRate;
  final String originalPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        //         bottom: PsDimens.space10
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Icon(
              //   icon,
              //   size: PsDimens.space18,
              // ),
              // const SizedBox(
              //   width: PsDimens.space16,
              // ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(title,
                      style: color == null
                          ? Theme.of(context).textTheme.bodyLarge
                          : Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: color,
                          fontSize: 21,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: PsDimens.space10,
                  ),
                  Text(
                    subTitle,
                    style: color == null
                        ? Theme.of(context).textTheme.bodyLarge
                        : Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: PsColors.textColor3,
                      fontSize: 13,
                    ),
                  )
                  // )
                ],
              )
            ],
          ),
          Visibility(
              visible: discountRate != '0',
              child: Row(
                children: <Widget>[
                  Text(
                    originalPrice,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Utils.isLightMode(context)
                            ? PsColors.textPrimaryLightColor
                            : PsColors.primaryDarkGrey,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12),
                  ),
                  const SizedBox(width: PsDimens.space6),
                  Text(
                    '-$discountRate%',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Utils.isLightMode(context)
                            ? PsColors.textPrimaryLightColor
                            : PsColors.primaryDarkGrey,
                        fontSize: 12),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class PromoteTileView extends StatefulWidget {
  const PromoteTileView({
    Key? key,
    required this.animationController,
    required this.product,
    required this.provider,
  }) : super(key: key);

  final AnimationController? animationController;
  final Product? product;
  final ItemDetailProvider provider;

  @override
  _PromoteTileViewState createState() => _PromoteTileViewState();
}

class _PromoteTileViewState extends State<PromoteTileView> {
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'item_detail__promote_your_item'),
        style: Theme.of(context).textTheme.titleMedium);

    final Widget _expansionTileLeadingIconWidget =
    Icon(Entypo.megaphone, //Ionicons.ios_megaphone,
        color: PsColors.primary500);

    return Consumer<AppInfoProvider>(builder:
        (BuildContext context, AppInfoProvider appInfoprovider, Widget? child) {
      if (appInfoprovider.appInfo.data == null) {
        return Container();
      } else {
        return Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              right: PsDimens.space12,
              bottom: PsDimens.space12),
          decoration: BoxDecoration(
            color: PsColors.primary50,
            borderRadius:
            const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: PsExpansionTile(
            initiallyExpanded: true,
            leading: _expansionTileLeadingIconWidget,
            title: _expansionTileTitleWidget,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    height: PsDimens.space1,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(PsDimens.space12),
                    child: Text(Utils.getString(
                        context, 'item_detail__promote_sub_title')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space12,
                        right: PsDimens.space12,
                        bottom: PsDimens.space12),
                    child: Text(Utils.getString(
                        context, 'item_detail__promote_description')),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(width: PsDimens.space2),
                      SizedBox(
                          width: PsDimens.space220,
                          child: PSButtonWithIconWidget(
                              hasShadow: false,
                              width: double.infinity,
                              icon: FontAwesome
                                  .megaphone, //Ionicons.ios_megaphone,
                              titleText: Utils.getString(
                                  context, 'item_detail__promte'),
                              onPressed: () async {
                                if (appInfoprovider.appInfo.data!
                                    .inAppPurchasedEnabled ==
                                    PsConst.ONE &&
                                    appInfoprovider
                                        .appInfo.data!.stripeEnable ==
                                        PsConst.ZERO &&
                                    appInfoprovider
                                        .appInfo.data!.paypalEnable ==
                                        PsConst.ZERO &&
                                    appInfoprovider
                                        .appInfo.data!.payStackEnabled ==
                                        PsConst.ZERO &&
                                    appInfoprovider.appInfo.data!.razorEnable ==
                                        PsConst.ZERO &&
                                    appInfoprovider
                                        .appInfo.data!.offlineEnabled ==
                                        PsConst.ZERO) {
                                  // InAppPurchase View
                                  final dynamic returnData =
                                  await Navigator.pushNamed(
                                      context, RoutePaths.inAppPurchase,
                                      arguments: <String, dynamic>{
                                        'productId': widget.product!.id,
                                        'appInfo': appInfoprovider.appInfo.data
                                      });
                                  if (returnData == true ||
                                      returnData == null) {
                                    final String? loginUserId =
                                    Utils.checkUserLoginId(
                                        widget.provider.psValueHolder!);
                                    widget.provider.loadProduct(
                                        widget.product!.id, loginUserId);
                                  }
                                } else if (appInfoprovider
                                    .appInfo.data!.inAppPurchasedEnabled ==
                                    PsConst.ZERO) {
                                  //Original Item Promote View
                                  final dynamic returnData =
                                  await Navigator.pushNamed(
                                      context, RoutePaths.itemPromote,
                                      arguments: widget.product);
                                  if (returnData == true ||
                                      returnData == null) {
                                    final String? loginUserId =
                                    Utils.checkUserLoginId(
                                        widget.provider.psValueHolder!);
                                    widget.provider.loadProduct(
                                        widget.product!.id, loginUserId);
                                  }
                                } else {
                                  //choose payment
                                  showDialog<dynamic>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ChoosePaymentTypeDialog(
                                          onInAppPurchaseTap: () async {
                                            final dynamic returnData =
                                            await Navigator.pushNamed(
                                                context,
                                                RoutePaths.inAppPurchase,
                                                arguments: <String,
                                                    dynamic>{
                                                  'productId':
                                                  widget.product!.id,
                                                  'appInfo': appInfoprovider
                                                      .appInfo.data
                                                });
                                            if (returnData == true ||
                                                returnData == null) {
                                              final String? loginUserId =
                                              Utils.checkUserLoginId(widget
                                                  .provider.psValueHolder!);
                                              widget.provider.loadProduct(
                                                  widget.product!.id,
                                                  loginUserId);
                                            }
                                          },
                                          onOtherPaymentTap: () async {
                                            final dynamic returnData =
                                            await Navigator.pushNamed(
                                                context,
                                                RoutePaths.itemPromote,
                                                arguments: widget.product);
                                            if (returnData == true ||
                                                returnData == null) {
                                              final String? loginUserId =
                                              Utils.checkUserLoginId(widget
                                                  .provider.psValueHolder!);
                                              widget.provider.loadProduct(
                                                  widget.product!.id,
                                                  loginUserId);
                                            }
                                          },
                                        );
                                      });
                                }
                              })),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: PsDimens.space18, bottom: PsDimens.space8),
                        child: Image.asset(
                          'assets/images/baseline_promotion_color_74.png',
                          width: PsDimens.space80,
                          height: PsDimens.space80,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      }
    });
  }
}