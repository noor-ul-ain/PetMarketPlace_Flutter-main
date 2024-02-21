import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

import 'login_view.dart';

class LoginContainerView extends StatefulWidget {
  @override
  _CityLoginContainerViewState createState() => _CityLoginContainerViewState();
}

class _CityLoginContainerViewState extends State<LoginContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider? userProvider;
  UserRepository? userRepo;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    Future<bool> _requestPop() {
      if (valueHolder.isForceLogin!) {
        return showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ConfirmDialogView(
                  description:
                      Utils.getString(context, 'home__quit_dialog_description'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () {
                    Navigator.pop(context);
                  });
            }).then((dynamic value) {
          SystemNavigator.pop();
          return value;
        });
      } else {
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
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    print(
        '............................Build UI Again ............................');
    userRepo = Provider.of<UserRepository>(context);
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: PsColors.baseColor,
              width: double.infinity,
              height: double.maxFinite,
            ),
            CustomScrollView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                slivers: <Widget>[
                  _SliverAppbar(
                    title: Utils.getString(context, 'login__title'),
                    scaffoldKey: scaffoldKey,
                  ),
                  LoginView(
                    animationController: animationController,
                    animation: animation,
                  ),
                ])
          ],
        ),
      ),
    );
  }
}

class _SliverAppbar extends StatefulWidget {
  const _SliverAppbar({
    Key? key,
    required this.title,
    this.scaffoldKey,
  }) : super(key: key);
  final String title;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  // final Drawer? menuDrawer;
  @override
  _SliverAppbarState createState() => _SliverAppbarState();
}

class _SliverAppbarState extends State<_SliverAppbar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
      ),
      iconTheme:
          Theme.of(context).iconTheme.copyWith(color: PsColors.backArrowColor),
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontWeight: FontWeight.bold)
            .copyWith(color: PsColors.primaryDarkWhite),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notifications_none,
              color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutePaths.notiList,
            );
          },
        ),
        IconButton(
          icon: Icon(FontAwesome5.book_open, //Feather.book_open,
              color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutePaths.blogList,
            );
          },
        )
      ],
      //backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
