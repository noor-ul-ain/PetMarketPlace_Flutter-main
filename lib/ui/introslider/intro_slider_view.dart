import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/item_location/item_location_provider.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

class IntroSliderView extends StatefulWidget {
  const IntroSliderView({required this.settingSlider});
  final int settingSlider;
  @override
  @override
  _IntroSliderViewState createState() => _IntroSliderViewState();
}

class _IntroSliderViewState extends State<IntroSliderView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    _controller = TabController(vsync: this, length: 3);
    super.initState();
  }


  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider? userProvider;
  UserRepository? userRepo;
  PsValueHolder? psValueHolder;
  TabController? _controller;
  int currentIndex = 0;
  List<String> pictureList = <String>[
    'assets/images/slider_1.svg',
    'assets/images/slider_2.svg',
    'assets/images/slider_3.svg'
  ];

  List<String> titleList = <String>[
    'intro_slider1_title',
    'intro_slider2_title',
    'intro_slider3_title'
  ];
  List<String> descriptionList = <String>[
    'intro_slider1_description',
    'intro_slider2_description',
    'intro_slider3_description'
  ];

  @override
  Widget build(BuildContext context) {
    // final ItemLocationProvider _provider = Provider.of(context, listen: false);
    print(
        '............................Build UI Again ............................');
    userRepo = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    _controller!.animateTo(0);

    final Widget activeDot = Container(
        width: 18.0,
        padding: const EdgeInsets.only(
            left: PsDimens.space2, right: PsDimens.space2),
        child: MaterialButton(
          height: 8.0,
          color: PsColors.activeColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          onPressed: () {},
        ));
    final Widget inactiveDot = Container(
        width: 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: PsColors.grey));
    return ChangeNotifierProvider<UserProvider?>(
        lazy: false,
        create: (BuildContext context) {
          userProvider =
              UserProvider(repo: userRepo, psValueHolder: psValueHolder);
          return userProvider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget? child) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
                body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: PsColors.baseColor,
              ),
              child: GestureDetector(
                child: Container(
                  color: PsColors.baseColor,
                  child: OrientationBuilder(
                      builder: (BuildContext context, Orientation orientation) {
                    return Stack(children: <Widget>[
                      Positioned.fill(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if (orientation == Orientation.portrait)
                              Container(
                                  child: SvgPicture.asset(
                                pictureList[currentIndex],
                              ))
                            else
                              Container(
                                  width: 135,
                                  height: 135,
                                  child: SvgPicture.asset(
                                    pictureList[currentIndex],
                                  )),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: PsDimens.space16),
                              child: Text(
                                Utils.getString(
                                    context, titleList[currentIndex]),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: PsColors.activeColor,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.only(top: PsDimens.space16),
                              child: Text(
                                Utils.getString(
                                    context, descriptionList[currentIndex]),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: PsColors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              margin: (orientation == Orientation.portrait)
                                  ? const EdgeInsets.only(top: PsDimens.space48)
                                  : const EdgeInsets.only(
                                      bottom: PsDimens.space48),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (currentIndex == 0)
                                    activeDot
                                  else
                                    inactiveDot,
                                  if (currentIndex == 1)
                                    activeDot
                                  else
                                    inactiveDot,
                                  if (currentIndex == 2)
                                    activeDot
                                  else
                                    inactiveDot,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: (currentIndex < pictureList.length - 1)
                            ? (orientation == Orientation.portrait)
                                ? PsDimens.space68
                                : PsDimens.space40
                            : -PsDimens.space200,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          alignment: Alignment.center,
                          child: MaterialButton(
                            height: 35,
                            minWidth: 230,
                            color: PsColors.activeColor,
                            child: Text(
                              Utils.getString(context, 'intro_slider_next'),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      color: PsColors.baseColor,
                                      fontWeight: FontWeight.bold),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () {
                              //  controller!.animateTo(1);
                              if (currentIndex != pictureList.length - 1) {
                                setState(() {
                                  ++currentIndex;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: (currentIndex < pictureList.length - 1)
                            ? (orientation == Orientation.portrait)
                                ? PsDimens.space40
                                : PsDimens.space20
                            : -PsDimens.space200,
                        width: MediaQuery.of(context).size.width,
                        child: InkWell(
                            hoverColor: PsColors.black,
                            onTap: ()async {
                              if (psValueHolder!.isForceLogin == true &&
                                  Utils.checkUserLoginId(psValueHolder!) ==
                                      'nologinuser') {
                                Navigator.pushReplacementNamed(
                                    context, RoutePaths.login_container);
                              } else {
                                if (psValueHolder!.isLanguageConfig == true &&
                                    Utils.checkUserLoginId(psValueHolder!) ==
                                        'nologinuser') {
                                  Navigator.pushReplacementNamed(
                                      context, RoutePaths.languagesetting);
                                } else {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      RoutePaths.home,
                                    );
                                  }
                                }
                              },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(
                                top: PsDimens.space18,
                              ),
                              child: Text(
                                Utils.getString(context, 'intro_slider_skip'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: PsColors.activeColor,
                                    ),
                              ),
                            )),
                      ),
                      Positioned(
                        bottom: (currentIndex == pictureList.length - 1)
                            ? orientation == Orientation.portrait
                                ? PsDimens.space40
                                : PsDimens.space12
                            : -PsDimens.space200,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Checkbox(
                                      //  fillColor: Utils.isLightMode(context)? PsColors.white : Colors.black45,
                                      activeColor: PsColors.activeColor,
                                      value: provider.isCheckBoxSelect,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          updateCheckBox(context, provider,
                                              provider.isCheckBoxSelect);
                                        });
                                      }),
                                  Text(
                                    Utils.getString(context,
                                        'intro_slider_do_not_show_again'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: PsColors.activeColor,
                                        ),
                                  ),
                                  const SizedBox(
                                    width: PsDimens.space60,
                                  )
                                ]),
                            Container(
                              alignment: Alignment.center,
                              child: MaterialButton(
                                height: 35,
                                minWidth: 230,
                                color: PsColors.activeColor,
                                child: Text(Utils.getString(
                                      context, 'intro_slider_lets_explore'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          color: PsColors.baseColor,
                                          fontWeight: FontWeight.bold),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                onPressed: () async {
                                  if (provider.isCheckBoxSelect) {
                                    await provider
                                        .replaceIsToShowIntroSlider(false);
                                  } else {
                                    await provider
                                        .replaceIsToShowIntroSlider(true);
                                  }
                                  if (widget.settingSlider == 1) {
                                    Navigator.pop(context);
                                  } else {
                                    if (psValueHolder!.isForceLogin == true &&
                                        Utils.checkUserLoginId(
                                                psValueHolder!) ==
                                            'nologinuser') {
                                      Navigator.pushReplacementNamed(
                                          context, RoutePaths.login_container);
                                    } else {
                                      if (psValueHolder!.isLanguageConfig ==
                                              true &&
                                          Utils.checkUserLoginId(
                                                  psValueHolder!) ==
                                              'nologinuser') {
                                        Navigator.pushReplacementNamed(context,
                                            RoutePaths.languagesetting);
                                      } else {
                                        // if (psValueHolder!.locationId != null) {
                                          Navigator.pushNamed(
                                            context,
                                            RoutePaths.home,
                                          );
                                        // } else {
                                        //   Navigator.pushNamed(
                                        //     context,
                                        //     RoutePaths.itemLocationList,
                                        //   );
                                        // }
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }),
                ),
                onHorizontalDragEnd: (DragEndDetails endDetails) {
                  if (endDetails.primaryVelocity! < 0) {
                    // right to left
                    if (currentIndex != pictureList.length - 1) {
                      setState(() {
                        ++currentIndex;
                      });
                    }
                  } else if (endDetails.primaryVelocity! > 0) {
                    //left to right
                    if (currentIndex != 0) {
                      setState(() {
                        --currentIndex;
                      });
                    }
                  }
                },
              ),
            )),
          );
        }));
  }
}

Future<void> updateCheckBox(
    BuildContext context, UserProvider provider, bool isCheckBoxSelect) async {
  if (isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
  } else {
    provider.isCheckBoxSelect = true;
  }
}

