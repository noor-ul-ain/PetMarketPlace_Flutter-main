
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/success_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_textfield_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/change_password_holder.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  UserRepository? userRepo;
  PsValueHolder? psValueHolder;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    userRepo = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    const Widget _largeSpacingWidget = SizedBox(
      height: PsDimens.space8,
    );
    return PsWidgetWithAppBar<UserProvider>(
        appBarTitle: Utils.getString(context, 'change_password__title'),
        initProvider: () {
          return UserProvider(repo: userRepo, psValueHolder: psValueHolder);
        },
        onProviderReady: (UserProvider provider) {
          return provider;
        },
        builder: (BuildContext context, UserProvider provider, Widget? child) {
          return SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.all(PsDimens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'change_password__password'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'change_password__password'),
                    textEditingController: passwordController),
                PsTextFieldWidget(
                    titleText: Utils.getString(
                        context, 'change_password__confirm_password'),
                    textAboutMe: false,
                    hintText: Utils.getString(
                        context, 'change_password__confirm_password'),
                    textEditingController: confirmPasswordController),
                Container(
                  margin: const EdgeInsets.all(PsDimens.space12),
                  width: double.infinity,
                  child: PsButtonWidget(
                    provider: provider,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                  ),
                ),
                _largeSpacingWidget,
              ],
            ),
          ));
        });
  }
}

class PsButtonWidget extends StatelessWidget {
  const PsButtonWidget({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.provider,
  });

  final TextEditingController passwordController, confirmPasswordController;
  final UserProvider provider;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: PsColors.primary500,
        textColor: Colors.white,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        // ignore: unnecessary_null_comparison
        child: provider != null
            ? provider.isLoading
                ? Text(
                    Utils.getString(context, 'login__loading'),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.white),
                  )
                : Text(
                    Utils.getString(context, 'change_password__save'),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.white),
                  )
            : Text(
                Utils.getString(context, 'login__sign_in'),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Colors.white),
              ),
        onPressed: () async {
          if (passwordController.text != '' &&
              confirmPasswordController.text != '') {
            if (passwordController.text == confirmPasswordController.text) {
              if (await Utils.checkInternetConnectivity()) {
                final ChangePasswordParameterHolder contactUsParameterHolder =
                    ChangePasswordParameterHolder(
                        userId: provider.psValueHolder!.loginUserId,
                        userPassword: passwordController.text);

                final PsResource<ApiStatus> _apiStatus = await provider
                        .postChangePassword(contactUsParameterHolder.toMap());

                if (_apiStatus.data != null) {
                  passwordController.clear();
                  confirmPasswordController.clear();

                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return SuccessDialog(
                          message: _apiStatus.data!.status,
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
                        message: Utils.getString(
                            context, 'error_dialog__no_internet'),
                      );
                    });
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: Utils.getString(
                          context, 'change_password__not_equal'),
                    );
                  });
            }
          } else {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message: Utils.getString(context, 'change_password__error'),
                  );
                });
          }
        });
  }
}
