

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/user/edit_profile/sign_in/edit_phone_sign_in_view.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:provider/provider.dart';

class EditPhoneSignInContainerView extends StatefulWidget {
  @override
  _EditPhoneSignInContainerViewState createState() =>
      _EditPhoneSignInContainerViewState();
}

class _EditPhoneSignInContainerViewState
    extends State<EditPhoneSignInContainerView>
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

    print(
        '............................Build UI Again ............................');
    userRepo = Provider.of<UserRepository>(context);
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          body: Stack(children: <Widget>[
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
                    title: Utils.getString(context, 'home_phone_signin'),
                    scaffoldKey: scaffoldKey,
                  ),
                  EditPhoneSignInView(
                    animationController: animationController,
                  ),
                ])
          ]),
        ));
  }
}

class _SliverAppbar extends StatefulWidget {
  const _SliverAppbar(
      {Key? key, required this.title, this.scaffoldKey,})
      : super(key: key);
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
             systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),  
      iconTheme:   Theme.of(context).iconTheme.copyWith(
              color: Utils.isLightMode(context)
                  ? PsColors.primary500
                  : PsColors.primaryDarkWhite),
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontWeight: FontWeight.bold)
            .copyWith(color: PsColors.primaryDarkWhite),
      ),
      elevation: 0,
    );
  }
}
