import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/delete_user_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class MoreView extends StatefulWidget {
  const MoreView(
      {Key? key,
      required this.animationController,
      required this.closeMoreContainerView})
      : super(key: key);

  final AnimationController? animationController;
  final Function closeMoreContainerView;

  @override
  _MoreViewState createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  PsValueHolder? valueHolder;
  UserProvider? userProvider;
  UserRepository? userRepository;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && valueHolder!.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    if (!isConnectedToInternet && valueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    widget.animationController!.forward();

    return ChangeNotifierProvider<UserProvider?>(
        lazy: false,
        create: (BuildContext context) {
          userProvider =
              UserProvider(repo: userRepository, psValueHolder: valueHolder);
          return userProvider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider userProvider, Widget? child) {
          return AnimatedBuilder(
            animation: widget.animationController!,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _MorePostTitleWidget(),
                  _MorePendingPostWidget(
                    animationController: widget.animationController,
                    userId: userProvider.psValueHolder!.loginUserId,
                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.animationController!,
                        curve: const Interval((1 / 4) * 2, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    ),
                    headerTitle:
                        Utils.getString(context, 'more__pending_post_title'),
                    status: '0',
                  ),
                  const SizedBox(height: PsDimens.space4),
                  _MoreActivePostWidget(
                    animationController: widget.animationController,
                    userId: userProvider.psValueHolder!.loginUserId,
                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.animationController!,
                        curve: const Interval((1 / 4) * 2, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    ),
                    headerTitle:
                        Utils.getString(context, 'more__active_post_title'),
                    status: '1',
                  ),
                  const SizedBox(height: PsDimens.space4),
                  _MorePaidAdsWidget(),
                  const SizedBox(height: PsDimens.space4),
                  _MoreFavouriteWidget(),
                  const SizedBox(height: PsDimens.space8),
                 // _MoreActivityTitleWidget(),
                 // _MoreOfferWidget(),
                 // const SizedBox(height: PsDimens.space4),
                 // _MoreFollowerWidget(),
                 // const SizedBox(height: PsDimens.space4),
                 // _MoreFollowingWidget(),
                 // const SizedBox(height: PsDimens.space4),
                  _MoreHistoryWidget(),
                  _MoreSettingAndPrivacyTitleWidget(),
                  if (Utils.showUI(valueHolder!.blockedFeatureDisabled))
                    _MoreBlockUserWidget(),
                  const SizedBox(height: PsDimens.space4),
                  _MoreReportItemWidget(),
                  const SizedBox(height: PsDimens.space4),
                  _MoreDeactivateAccWidget(
                    userProvider: userProvider,
                    closeMoreContainerView: widget.closeMoreContainerView,
                  ),
                  const SizedBox(height: PsDimens.space4),
                  _MoreSettingWidget(),
                  const SizedBox(height: PsDimens.space4),
                  const PsAdMobBannerWidget(
                    admobSize: AdSize.mediumRectangle,
                    // admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  ),
                ],
              ),
            ),
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
        }));
  }
}

class _MorePostTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.baseColor,
      padding: const EdgeInsets.all(PsDimens.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Icon(Icons.format_list_bulleted, color: PsColors.primary500),
          // const SizedBox(
          //   width: PsDimens.space16,
          // ),
          Text(
            Utils.getString(context, 'more__post_title'),
            softWrap: false,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: PsColors.textColor2,
                //color: PsColors.secondary400,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _MorePendingPostWidget extends StatefulWidget {
  const _MorePendingPostWidget(
      {Key? key,
      required this.userId,
      required this.animationController,
      required this.headerTitle,
      required this.status,
      this.animation})
      : super(key: key);

  final String? userId;
  final AnimationController? animationController;
  final String headerTitle;
  final String status;
  final Animation<double>? animation;

  @override
  _MorePendingPostWidgetState createState() => _MorePendingPostWidgetState();
}

class _MorePendingPostWidgetState extends State<_MorePendingPostWidget> {
  UserProvider? userProvider;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.userItemListForProfile,
            arguments: ItemListIntentHolder(
                userId: widget.userId,
                status: widget.status,
                title: widget.headerTitle));
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(Utils.getString(context, 'more__pending_post_title'),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: PsColors.textColor1
                              //color: PsColors.primary500
                            )),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Text(
                      Utils.getString(context, 'more__pending_list'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreActivePostWidget extends StatefulWidget {
  const _MoreActivePostWidget(
      {Key? key,
      required this.userId,
      required this.animationController,
      required this.headerTitle,
      required this.status,
      this.animation})
      : super(key: key);

  final String? userId;
  final AnimationController? animationController;
  final String headerTitle;
  final String status;
  final Animation<double>? animation;

  @override
  _MoreActivePostWidgetState createState() => _MoreActivePostWidgetState();
}

class _MoreActivePostWidgetState extends State<_MoreActivePostWidget> {
  late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.userItemListForProfile,
            arguments: ItemListIntentHolder(
                userId: userProvider.psValueHolder!.loginUserId,
                status: widget.status,
                title: widget.headerTitle));
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Utils.getString(context, 'more__active_post_title'),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: PsColors.textColor1),
                    ),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Text(
                      Utils.getString(context, 'more__search_active_post'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MorePaidAdsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.paidAdItemList);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'more__paid_ads_title'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: PsColors.textColor1),
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__paid_ads_promote_list'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreFavouriteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.favouriteProductList);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'more__favourite_title'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: PsColors.textColor1),
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__favourite_post'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreActivityTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.baseColor,
      padding: const EdgeInsets.all(PsDimens.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            Utils.getString(context, 'more__activity_title'),
            softWrap: false,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: PsColors.textColor2, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _MoreOfferWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.offerList);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'more__offer_title'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: PsColors.textColor1),
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__offer_list'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreFollowerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.followerUserList);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'more__follower_title'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: PsColors.textColor1),
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__follower_user'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreFollowingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.followingUserList);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'more__following_title'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: PsColors.textColor1),
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__following_user'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreHistoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.historyList);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'more__history_title'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: PsColors.textColor1),
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__history_browse'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreSettingAndPrivacyTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.baseColor,
      padding: const EdgeInsets.all(PsDimens.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              Utils.getString(context, 'more__setting_and_privacy_title'),
              softWrap: false,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: PsColors.textColor2, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreBlockUserWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.blockUserList);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'more__block_user_title'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: PsColors.textColor1),
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__block_user_list'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreReportItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.reportItemList);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'more__report_item_title'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: PsColors.textColor1),
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__report_item_list'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreDeactivateAccWidget extends StatelessWidget {
  const _MoreDeactivateAccWidget(
      {required this.userProvider, required this.closeMoreContainerView});

  final UserProvider userProvider;
  final Function closeMoreContainerView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
          return ConfirmDialogView(
                  description: Utils.getString(
                      context, 'profile__deactivate_confirm_text'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () async {
                    Navigator.of(context).pop();
                    await PsProgressDialog.showDialog(context);
                    final DeleteUserHolder deleteUserHolder = DeleteUserHolder(
                        userId: userProvider.psValueHolder!.loginUserId);
                    final PsResource<ApiStatus> _apiStatus = await userProvider
                        .postDeleteUser(deleteUserHolder.toMap());
                    PsProgressDialog.dismissDialog();
                    if (_apiStatus.data != null) {
                      closeMoreContainerView();
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(message: _apiStatus.message);
                          });
                    }
                  });
            });
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Utils.getString(
                          context, 'more__deactivate_account_title'),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: PsColors.textColor1),
                    ),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Text(
                      Utils.getString(
                          context, 'more__recover_account_after_deactivate'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.setting);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'setting__toolbar_name'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: PsColors.textColor1),
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__app_setting'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
