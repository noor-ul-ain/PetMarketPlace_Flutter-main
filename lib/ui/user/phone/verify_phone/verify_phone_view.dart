import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/success_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/phone_login_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/resend_code_holder.dart';
import 'package:flutterbuyandsell/viewobject/user.dart';
import 'package:provider/provider.dart';

class VerifyPhoneView extends StatefulWidget {
  const VerifyPhoneView(
      {Key? key,
      required this.userName,
      required this.phoneNumber,
      required this.phoneId,
      required this.animationController,
      this.onProfileSelected,
      this.onSignInSelected})
      : super(key: key);

  final String? userName;
  final String? phoneNumber;
  final String? phoneId;
  final AnimationController? animationController;
  final Function? onProfileSelected, onSignInSelected;
  @override
  _VerifyPhoneViewState createState() => _VerifyPhoneViewState();
}

class _VerifyPhoneViewState extends State<VerifyPhoneView> {
  UserRepository? repo1;
  PsValueHolder? valueHolder;
  Timer? _timer;
  int time = 300;
  @override
  void dispose() {
    super.dispose();
    if(_timer!=null){
      _timer!.cancel();
    }
  }
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    time = 300;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) {
        if (time == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            time--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.animationController!.forward();

    const Widget _dividerWidget = Divider(
      height: PsDimens.space1,
    );

    repo1 = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return ChangeNotifierProvider<UserProvider>(
      lazy: false,
      create: (BuildContext context) {
        final UserProvider provider =
            UserProvider(repo: repo1, psValueHolder: valueHolder);
        // provider.postUserRegister(userRegisterParameterHolder.toMap());
        return provider;
      },
      child: Consumer<UserProvider>(builder:
          (BuildContext context, UserProvider provider, Widget? child) {
        return SingleChildScrollView(
            child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
                color: PsColors.backgroundColor,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _dividerWidget,
                      _HeaderTextWidget(
                          userProvider: provider,
                          phoneNumber: widget.phoneNumber),
                      _TextFieldAndButtonWidget(
                        userName: widget.userName,
                        phoneNumber: widget.phoneNumber,
                        phoneId: widget.phoneId,
                        provider: provider,
                        onProfileSelected: widget.onProfileSelected,
                      ),
                      const SizedBox(height: 20,),
                      Text('OTP will expire in '
                          '${Duration(seconds: time).inMinutes.remainder(60).toString()}:${Duration(seconds: time).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey.shade700)),
                      const Column(
                        children: <Widget>[
                          SizedBox(
                            height: PsDimens.space16,
                          ),
                          Divider(
                            height: PsDimens.space1,
                          ),
                          SizedBox(
                            height: PsDimens.space32,
                          )
                        ],
                      ),
                      InkWell(
                          child: Container(
                            child: Ink(
                              color: PsColors.backgroundColor,
                              child: Text(
                                Utils.getString(
                                    context, 'phone_signin__back_login'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: PsColors.primary500),
                              ),
                            ),
                          ),
                          onTap: () {
                            if (widget.onSignInSelected != null) {
                              widget.onSignInSelected!();
                            } else {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                context,
                                RoutePaths.user_phone_signin_container,
                              );
                            }
                          })
                    ],
                  ),
                )),
            //_imageInCenterWidget,
          ],
        ));
      }),
    );
  }
}

class _TextFieldAndButtonWidget extends StatefulWidget {
  const _TextFieldAndButtonWidget({
    required this.userName,
    required this.phoneNumber,
    required this.phoneId,
    required this.provider,
    this.onProfileSelected,
    // @required this.userId,
  });

  final String? userName;
  final String? phoneNumber;
  final String? phoneId;
  final UserProvider provider;
  final Function? onProfileSelected;
  // final String userId;

  @override
  __TextFieldAndButtonWidgetState createState() =>
      __TextFieldAndButtonWidgetState();
}

dynamic callWarningDialog(BuildContext context, String text) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          message: Utils.getString(context, text),
          onPressed: () {},
        );
      });
}

dynamic gotoProfile(
    BuildContext context,
    String phoneId,
    String? userName,
    String? phoneNumber,
    UserProvider provider,
    Function? onProfileSelected) async {
  final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context, listen: false);
  if (await Utils.checkInternetConnectivity()) {
    final PhoneLoginParameterHolder phoneLoginParameterHolder =
        PhoneLoginParameterHolder(
      phoneId: phoneId,
      userName: userName,
      userPhone: phoneNumber,
      deviceToken: provider.psValueHolder!.deviceToken,
    );

    final PsResource<User> _apiStatus =
        await provider.postPhoneLogin(phoneLoginParameterHolder.toMap());

    if (_apiStatus.data != null) {
      await provider.replaceVerifyUserData('', '', '', '');
      await provider.replaceLoginUserId(_apiStatus.data!.userId!);
      await provider.replaceLoginUserName(_apiStatus.data!.userName!);

      if (onProfileSelected != null) {
        await provider.replaceVerifyUserData('', '', '', '');
        await provider.replaceLoginUserId(_apiStatus.data!.userId!);
        await provider.replaceLoginUserName(_apiStatus.data!.userName!);
        await onProfileSelected(_apiStatus.data!.userId);
      } else {
        if (psValueHolder.isForceLogin == true) {
          if (psValueHolder.isLanguageConfig == true) {
            Navigator.pushReplacementNamed(context, RoutePaths.languagesetting);
          } else {
            // if (psValueHolder.locationId != null) {
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
        } else {
          Navigator.pop(context, _apiStatus.data);
        }
      }
      print('you can go to profille');
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: _apiStatus.message,
            );
          });
    }
  } else {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: Utils.getString(context, 'error_dialog__no_internet'),
          );
        });
  }
}

class __TextFieldAndButtonWidgetState extends State<_TextFieldAndButtonWidget> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController userIdTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space40,
        ),
        TextField(
          textAlign: TextAlign.center,
          controller: codeController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: Utils.getString(
                context, 'email_verify__enter_verification_code'),
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: PsColors.textPrimaryLightColor),
          ),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: PsDimens.space16,
        ),
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space16, right: PsDimens.space16),
          child: PSButtonWidget(
            hasShadow: true,
            width: double.infinity,
            titleText: Utils.getString(context, 'email_verify__submit'),
            onPressed: () async {
              if (codeController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__code_require'));
              } else if (codeController.text.length != 6) {
                callWarningDialog(context, 'Verification OTP code is wrong');
              } else {
                final fb_auth.User? user =
                    fb_auth.FirebaseAuth.instance.currentUser;

                if (user != null) {
                  print('correct code');
                  await gotoProfile(
                      context,
                      user.uid,
                      widget.userName,
                      widget.phoneNumber,
                      widget.provider,
                      widget.onProfileSelected);
                } else {
                  final fb_auth.AuthCredential credential =
                      fb_auth.PhoneAuthProvider.credential(
                          verificationId: widget.phoneId!,
                          smsCode: codeController.text);

                  try {
                    await fb_auth.FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((fb_auth.UserCredential user) async {
                      print('correct code again');
                      await gotoProfile(
                          context,
                          user.user!.uid,
                          widget.userName,
                          widget.phoneNumber,
                          widget.provider,
                          widget.onProfileSelected);
                    });
                  } on Exception {
                    print('show error');
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(
                            message: Utils.getString(
                                context, 'error_dialog__code_wrong'),
                          );
                        });
                  }
                }
              }
            },
          ),
        )
      ],
    );
  }
}

class _HeaderTextWidget extends StatelessWidget {
  const _HeaderTextWidget(
      {required this.userProvider, required this.phoneNumber});
  final UserProvider userProvider;
  final String? phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: PsDimens.space200,
      width: double.infinity,
      child: Stack(children: <Widget>[
        Container(
            color: PsColors.primary500,
            padding: const EdgeInsets.only(
                left: PsDimens.space16, right: PsDimens.space16),
            height: PsDimens.space160,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: PsDimens.space28,
                ),
                Text(
                  Utils.getString(context, 'phone_signin__title1'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: PsColors.white),
                ),
                Text(
                  (phoneNumber == null) ? '' : phoneNumber!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: PsColors.white),
                ),
              ],
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 90,
            height: 90,
            child: const CircleAvatar(
              backgroundImage:
                  ExactAssetImage('assets/images/verify_email_icon.jpg'),
            ),
          ),
        )
      ]),
    );
  }
}

class _ChangeEmailAndRecentCodeWidget extends StatefulWidget {
  const _ChangeEmailAndRecentCodeWidget({
    required this.provider,
    required this.userEmailText,
    required this.onSignInSelected,
  });
  final UserProvider provider;
  final String userEmailText;
  final Function? onSignInSelected;

  @override
  __ChangeEmailAndRecentCodeWidgetState createState() =>
      __ChangeEmailAndRecentCodeWidgetState();
}

class __ChangeEmailAndRecentCodeWidgetState
    extends State<_ChangeEmailAndRecentCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        MaterialButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          height: 40,

          child: Text(Utils.getString(context, 'email_verify__change_email')),
          textColor: PsColors.primary500,
          onPressed: () {
            if (widget.onSignInSelected != null) {
              widget.onSignInSelected!();
            } else {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                RoutePaths.user_register_container,
              );
            }
          },
          // Material(
          //   child: InkWell(
          //     child: Text(
          //       'Change Email',
          //       style: Theme.of(context)
          //           .textTheme
          //           .button
          //           .copyWith(color: Colors.deepOrange),
          //     ),
          //     onTap: () {
        ),
        MaterialButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          height: 40,
          child: Text(Utils.getString(context, 'email_verify__resent_code')),
          textColor: PsColors.primary500,
          onPressed: () async {
            if (await Utils.checkInternetConnectivity()) {
              final ResendCodeParameterHolder resendCodeParameterHolder =
                  ResendCodeParameterHolder(
                userEmail: widget.provider.psValueHolder!.userEmailToVerify,
              );

              final PsResource<ApiStatus> _apiStatus = await widget.provider
                  .postResendCode(resendCodeParameterHolder.toMap());

              if (_apiStatus.data != null) {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return SuccessDialog(
                        message: _apiStatus.data!.message,
                        onPressed: () {},
                      );
                    });
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: _apiStatus.message,
                      );
                    });
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message:
                          Utils.getString(context, 'error_dialog__no_internet'),
                    );
                  });
            }
          },
        ),
      ],
    );
  }
}
