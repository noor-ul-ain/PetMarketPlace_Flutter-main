

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/user.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/apple_sign_in_button.dart' as apple;

class LoginView extends StatefulWidget {
  const LoginView({
    Key? key,
    this.animationController,
    this.animation,
    this.onProfileSelected,
    this.onForgotPasswordSelected,
    this.onSignInSelected,
    this.onPhoneSignInSelected,
    this.onFbSignInSelected,
    this.onGoogleSignInSelected,
  }) : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;
  final Function? onProfileSelected,
      onForgotPasswordSelected,
      onSignInSelected,
      onPhoneSignInSelected,
      onFbSignInSelected,
      onGoogleSignInSelected;
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserRepository? repo1;
  PsValueHolder? psValueHolder;

  @override
  Widget build(BuildContext context) {
    widget.animationController!.forward();
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space28,
    );

    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<UserProvider>(
      lazy: false,
      create: (BuildContext context) {
        final UserProvider provider =
            UserProvider(repo: repo1, psValueHolder: psValueHolder);
        print(provider.getCurrentFirebaseUser());
        return provider;
      },
      child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider provider, Widget? child) {
        return Container(
        //  color: PsColors.primaryDarkWhite,
          child: AnimatedBuilder(
            animation: widget.animationController!,
            child: Column(
              children: <Widget>[
                _HeaderIconAndTextWidget(),
                _TextFieldAndSignInButtonWidget(
                  provider: provider,
                  text: Utils.getString(context, 'login__submit'),
                  onProfileSelected: widget.onProfileSelected,
                ),
                // _spacingWidget,
                
                const SizedBox(
                  height: PsDimens.space10,
                ),
           
                _ForgotPasswordAndRegisterWidget(
                  provider: provider,
                  animationController: widget.animationController,
                  onForgotPasswordSelected: widget.onForgotPasswordSelected,
                  onSignInSelected: widget.onSignInSelected,
                ),
                // const SizedBox(
                //   height: PsDimens.space8,
                // ),
                _DividerORWidget(),
                  const SizedBox(
                  height: PsDimens.space14,
                ),
                     _TermsAndConCheckbox(
                  provider: provider,
                  onCheckBoxClick: () {
                    setState(() {
                      updateCheckBox(context, provider);
                    });
                  },
                ),
                 const SizedBox(
                  height: PsDimens.space10,
                ),
                if (psValueHolder!.showPhoneLogin!)
                  _LoginWithPhoneWidget(
                    onPhoneSignInSelected: widget.onPhoneSignInSelected,
                    provider: provider,
                  ),
                if (psValueHolder!.showFacebookLogin!)
                  _LoginWithFbWidget(
                      userProvider: provider,
                      onFbSignInSelected: widget.onFbSignInSelected),
                if (psValueHolder!.showGoogleLogin!)
                  _LoginWithGoogleWidget(
                      userProvider: provider,
                      onGoogleSignInSelected: widget.onGoogleSignInSelected),
                if (Utils.isAppleSignInAvailable == 1 && Platform.isIOS)
                  _LoginWithAppleIdWidget(
                      onAppleIdSignInSelected: widget.onGoogleSignInSelected),
                _spacingWidget,

                _spacingWidget,
              ],
            ),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation!,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - widget.animation!.value), 0.0),
                      child: SingleChildScrollView(child: child)));
            },
          ),
        );
      }),
    ));
  }
}

class _TermsAndConCheckbox extends StatefulWidget {
  const _TermsAndConCheckbox(
      {required this.provider, required this.onCheckBoxClick});

  final UserProvider provider;
  final Function onCheckBoxClick;

  @override
  __TermsAndConCheckboxState createState() => __TermsAndConCheckboxState();
}

class __TermsAndConCheckboxState extends State<_TermsAndConCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: PsDimens.space20,
        ),
        Checkbox(
           side: BorderSide(color: PsColors.primary500),
          checkColor: PsColors.baseColor,
          activeColor: PsColors.activeColor,
          value: widget.provider.isCheckBoxSelect,
          onChanged: (bool? value) {
            widget.onCheckBoxClick();
          },
        ),
        Expanded(
          child: InkWell(
            child: Text(
              Utils.getString(context, 'login__agree_privacy'),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: PsColors.textColor2
              ),
            ),
            onTap: () {
              widget.onCheckBoxClick();
            },
          ),
        ),
      ],
    );
  }
}

void updateCheckBox(BuildContext context, UserProvider provider) {
  if (provider.isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
  } else {
    provider.isCheckBoxSelect = true;

    Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 1);
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      Utils.getString(context, 'app_name'),
      style: Theme.of(context)
          .textTheme
          .headlineSmall!
          .copyWith(fontWeight: FontWeight.bold, color: PsColors.textColor1),
    );

    final Widget _imageWidget = Container(
      width: 80,
      height: 80,
      child: Image.asset(
        'assets/images/flutter_buy_and_sell_logo.png',
      ),
    );
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space32,
        ),
        _imageWidget,
        const SizedBox(
          height: PsDimens.space8,
        ),
        _textWidget,
        const SizedBox(
          height: PsDimens.space52,
        ),
      ],
    );
  }
}

class _TextFieldAndSignInButtonWidget extends StatefulWidget {
  const _TextFieldAndSignInButtonWidget({
    required this.provider,
    required this.text,
    this.onProfileSelected,
  });

  final UserProvider provider;
  final String text;
  final Function? onProfileSelected;

  @override
  __CardWidgetState createState() => __CardWidgetState();
}

class __CardWidgetState extends State<_TextFieldAndSignInButtonWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetsforCard = EdgeInsets.only(
        left: PsDimens.space28,
        right: PsDimens.space28,
        top: PsDimens.space4,
        bottom: PsDimens.space4);
    return Column(
      children: <Widget>[
        // Card(
        //   elevation: 0.3,
        //   margin: const EdgeInsets.only(
        //       left: PsDimens.space32, right: PsDimens.space32),
        //   child: Column(
        //     children: <Widget>[

              Container(
                margin: _marginEdgeInsetsforCard,
                child: TextField(
                  controller: emailController,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration( 
                      // border: InputBorder.none,
                   border: const OutlineInputBorder(
                          borderRadius:  BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide.none,
                          
                        ),
                      filled: true,
                      fillColor: PsColors.cardBackgroundColor,
                      hintText: Utils.getString(context, 'login__email'),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Utils.isLightMode(context)? PsColors.textPrimaryLightColor: PsColors.primaryDarkGrey),
                      prefixIcon: Icon(Icons.email,
                          color: Theme.of(context).iconTheme.color)),
                ),
              ),
              const SizedBox(
                height: PsDimens.space10,
              ),
              Container(
                margin: _marginEdgeInsetsforCard,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(),
                  decoration: InputDecoration(
                               border: const OutlineInputBorder(
                          borderRadius:  BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide.none,                          
                        ),
                      filled: true,
                      fillColor: PsColors.cardBackgroundColor,
                      hintText: Utils.getString(context, 'login__password'),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color:  Utils.isLightMode(context)? PsColors.textPrimaryLightColor: PsColors.primaryDarkGrey),
                      prefixIcon: Icon(Icons.lock,
                          color: Theme.of(context).iconTheme.color)),
                  // keyboardType: TextInputType.number,
                ),
              ),
        //     ],
        //   ),
        // ),
        const SizedBox(
          height: PsDimens.space8,
        ),
        Container(
          height: 50,
          margin: const EdgeInsets.only(
              left: PsDimens.space32, right: PsDimens.space32),
          child: PSButtonWidget(
            colorData: PsColors.buttonColor,
            hasShadow: false,
            width: double.infinity,
            titleText: Utils.getString(context, 'login__sign_in'),
            onPressed: () async {
              if (emailController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_email'));
              } else if (passwordController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_password'));
              } else {
                if (Utils.checkEmailFormat(emailController.text.trim())!) {
                  await widget.provider.loginWithEmailId(
                      context,
                      emailController.text.trim(),
                      passwordController.text,
                      widget.onProfileSelected);
                } else {
                  callWarningDialog(context,
                      Utils.getString(context, 'warning_dialog__email_format'));
                }
              }
            },
          ),
        ),
      ],
    );
  }
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

class _DividerORWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _dividerWidget = Expanded(
      child: Divider(
        height: PsDimens.space2,
        color: Utils.isLightMode(context)? PsColors.secondary400 : PsColors.primaryDarkWhite,
      ),
    );

    const Widget _spacingWidget = SizedBox(
      width: PsDimens.space8,
    );

    final Widget _textWidget = Text(
      'OR',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Utils.isLightMode(context)? PsColors.secondary400 : PsColors.primaryDarkWhite,
          ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _dividerWidget,
        _spacingWidget,
        _textWidget,
        _spacingWidget,
        _dividerWidget,
      ],
    );
  }
}

class _LoginWithPhoneWidget extends StatefulWidget {
  const _LoginWithPhoneWidget(
      {required this.onPhoneSignInSelected, required this.provider});
  final Function? onPhoneSignInSelected;
  final UserProvider provider;

  @override
  __LoginWithPhoneWidgetState createState() => __LoginWithPhoneWidgetState();
}

class __LoginWithPhoneWidgetState extends State<_LoginWithPhoneWidget> {
  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: PSButtonWithIconWidget(
        titleText: Utils.getString(context, 'login__phone_signin'),
        icon: Icons.phone,
        colorData: widget.provider.isCheckBoxSelect
            ? PsColors.primary500
            : PsColors.primary500,
        onPressed: () async {
          if (widget.provider.isCheckBoxSelect) {
            if (widget.onPhoneSignInSelected != null) {
              widget.onPhoneSignInSelected!();
            } else {
              if(valueHolder.isForceLogin!){
                
            await  Navigator.pushNamed(
                context,
                RoutePaths.user_phone_signin_container,
              );
              }else{
            await  Navigator.pushReplacementNamed(
                context,
                RoutePaths.user_phone_signin_container,
              );
              }
            }
          } else {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return WarningDialog(
                    message: Utils.getString(
                        context, 'login__warning_agree_privacy'),
                    onPressed: () {},
                  );
                });
          }
        },
      ),
    );
  }
}

class _LoginWithFbWidget extends StatefulWidget {
  const _LoginWithFbWidget(
      {required this.userProvider, required this.onFbSignInSelected});
  final UserProvider userProvider;
  final Function? onFbSignInSelected;

  @override
  __LoginWithFbWidgetState createState() => __LoginWithFbWidgetState();
}

class __LoginWithFbWidgetState extends State<_LoginWithFbWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32,
          top: PsDimens.space8,
          right: PsDimens.space32),
      child: PSButtonWithIconWidget(
          titleText: Utils.getString(context, 'login__fb_signin'),
          icon: FontAwesome.facebook_official, //FontAwesome.facebook_official,
          colorData: widget.userProvider.isCheckBoxSelect == false
              ? PsColors.facebookLoginButtonColor
              : PsColors.facebookLoginButtonColor,
          onPressed: () async {
            await widget.userProvider
                .loginWithFacebookId(context, widget.onFbSignInSelected);
          }),
    );
  }
}

class _LoginWithGoogleWidget extends StatefulWidget {
  const _LoginWithGoogleWidget(
      {required this.userProvider, required this.onGoogleSignInSelected});
  final UserProvider userProvider;
  final Function? onGoogleSignInSelected;

  @override
  __LoginWithGoogleWidgetState createState() => __LoginWithGoogleWidgetState();
}

class __LoginWithGoogleWidgetState extends State<_LoginWithGoogleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32,
          top: PsDimens.space8,
          right: PsDimens.space32),
      child: PSButtonWithIconWidget(
        titleText: Utils.getString(context, 'login__google_signin'),
        icon: FontAwesome.google, //FontAwesome.google,
        colorData: widget.userProvider.isCheckBoxSelect
            ? PsColors.googleLoginButtonColor
            : PsColors.googleLoginButtonColor,
        onPressed: () async {
          await widget.userProvider
              .loginWithGoogleId(context, widget.onGoogleSignInSelected);
        },
      ),
    );
  }
}

class _LoginWithAppleIdWidget extends StatelessWidget {
  const _LoginWithAppleIdWidget({required this.onAppleIdSignInSelected});

  final Function? onAppleIdSignInSelected;

  @override
  Widget build(BuildContext context) {
    final UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);

    return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space32,
            top: PsDimens.space8,
            right: PsDimens.space32),
        child: Directionality(
          // add this
          textDirection: TextDirection.ltr,
          child: apple.AppleSignInButton(
            style: apple.ButtonStyle.black, // style as needed
            type: apple.ButtonType.signIn, // style as needed

            onPressed: () async {
              await _userProvider.loginWithAppleId(
                  context, onAppleIdSignInSelected);
            },
          ),
        ));
  }
}

class _ForgotPasswordAndRegisterWidget extends StatefulWidget {
  const _ForgotPasswordAndRegisterWidget(
      {Key? key,
      this.provider,
      this.animationController,
      this.onForgotPasswordSelected,
      this.onSignInSelected})
      : super(key: key);

  final AnimationController? animationController;
  final Function? onForgotPasswordSelected;
  final Function? onSignInSelected;
  final UserProvider? provider;

  @override
  __ForgotPasswordAndRegisterWidgetState createState() =>
      __ForgotPasswordAndRegisterWidgetState();
}

class __ForgotPasswordAndRegisterWidgetState
    extends State<_ForgotPasswordAndRegisterWidget> {
  @override
  Widget build(BuildContext context) {
     final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    return Container(
      padding: const EdgeInsets.only(bottom: PsDimens.space4),
      margin: const EdgeInsets.all(PsDimens.space12),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: (){
             if (widget.onForgotPasswordSelected != null) {
                  widget.onForgotPasswordSelected!();
                } else {
                  if (valueHolder.isForceLogin!) {
                      Navigator.pushNamed(
                        context,
                        RoutePaths.user_forgot_password_container,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.user_forgot_password_container,
                      );
                    }
                }
            },
            child: Text(
                  Utils.getString(context, 'login__forgot_password'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: PsColors.textColor3,
                      ))),
        const SizedBox(
          height: PsDimens.space10,),
           InkWell(
             onTap: ()  async{
                if (widget.onSignInSelected != null) {
                  widget.onSignInSelected!();
                } else {
                   dynamic returnData ;
                  if (valueHolder.isForceLogin!) {
                    await Navigator.pushNamed(
                      context,
                      RoutePaths.user_register_container,
                    );
                  } else {
                    await Navigator.pushReplacementNamed(
                      context,
                      RoutePaths.user_register_container,
                    );
                  }
                  if (returnData is User) {
                    final User user = returnData;
                    widget.provider!.psValueHolder =
                        Provider.of<PsValueHolder>(context, listen: false);
                    widget.provider!.psValueHolder!.loginUserId = user.userId;
                    widget.provider!.psValueHolder!.userIdToVerify = '';
                    widget.provider!.psValueHolder!.userNameToVerify = '';
                    widget.provider!.psValueHolder!.userEmailToVerify = '';
                    widget.provider!.psValueHolder!.userPasswordToVerify = '';
                    Navigator.pop(context, user);
                  }
                }
            },
             child: Text(
                    Utils.getString(context, 'login__sign_up'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: PsColors.textColor3,
                        )),
           ),
        ],
      )
    );
  }
}
