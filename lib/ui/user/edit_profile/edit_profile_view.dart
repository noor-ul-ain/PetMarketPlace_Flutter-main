import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/success_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_textfield_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/profile_update_view_holder.dart';
import 'package:flutterbuyandsell/viewobject/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository? userRepository;
  UserProvider? userProvider;
  PsValueHolder? psValueHolder;
  late AnimationController animationController;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  bool bindDataFirstTime = true;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
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

    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBar<UserProvider>(
            appBarTitle: Utils.getString(context, 'edit_profile__title'),
            initProvider: () {
              return UserProvider(
                  repo: userRepository, psValueHolder: psValueHolder);
            },
            onProviderReady: (UserProvider provider) async {
              await provider.getUser(provider.psValueHolder!.loginUserId);
              return provider;
            },
            builder: (BuildContext context, UserProvider userProvider,
                Widget? child) {
              if (userProvider.user.data != null) {
                if (bindDataFirstTime) {
                  userNameController.text = userProvider.user.data!.userName!;
                  emailController.text = userProvider.user.data!.userEmail!;
                  cityController.text = userProvider.user.data!.city!;
                  addressController.text = userProvider.user.data!.userAddress!;
                  phoneController.text = userProvider.user.data!.userPhone!;
                  aboutMeController.text = userProvider.user.data!.userAboutMe!;

                  bindDataFirstTime = false;
                }

                return Container(
                  color: PsColors.baseColor,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _ImageWidget(userProvider: userProvider),
                        _UserFirstCardWidget(
                            userNameController: userNameController,
                            emailController: emailController,
                            phoneController: phoneController,
                            aboutMeController: aboutMeController,
                            addressController: addressController,
                            cityController: cityController,
                            userProvider: userProvider),
                        const SizedBox(
                          height: PsDimens.space8,
                        ),
                        // EmailCheckboxWidget(),
                        // PhoneNoCheckboxWidget(),
                        const SizedBox(
                          height: PsDimens.space16,
                        ),
                        _TwoButtonWidget(
                          userProvider: userProvider,
                          userNameController: userNameController,
                          emailController: emailController,
                          phoneController: phoneController,
                          aboutMeController: aboutMeController,
                          addressController: addressController,
                          cityController: cityController,
                        ),
                        const SizedBox(
                          height: PsDimens.space20,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Stack(
                  children: <Widget>[
                    Container(),
                    PSProgressIndicator(userProvider.user.status)
                  ],
                );
              }
            }));
  }
}

class _TwoButtonWidget extends StatelessWidget {
  const _TwoButtonWidget({
    required this.userProvider,
    required this.userNameController,
    required this.emailController,
    required this.phoneController,
    required this.aboutMeController,
    required this.addressController,
    required this.cityController,
  });

  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController aboutMeController;
  final TextEditingController addressController;
  final TextEditingController cityController;

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12, right: PsDimens.space12),
          child: PSButtonWidget(
            colorData: PsColors.buttonColor,
            hasShadow: true,
            width: double.infinity,
            titleText: Utils.getString(context, 'edit_profile__save'),
            onPressed: () async {
              if (userNameController.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'edit_profile__name_error'),
                      );
                    });
              } else if (emailController.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'edit_profile__email_error'),
                      );
                    });
              } else {
                if (await Utils.checkInternetConnectivity()) {
                  final ProfileUpdateParameterHolder
                      profileUpdateParameterHolder =
                      ProfileUpdateParameterHolder(
                          userId: userProvider.user.data!.userId,
                          userName: userNameController.text,
                          userEmail: emailController.text.trim(),
                          userPhone: phoneController.text,
                          userAboutMe: aboutMeController.text,
                          isShowEmail: userProvider.user.data!.isShowEmail,
                          isShowPhone: userProvider.user.data!.isShowPhone,
                          userAddress: addressController.text,
                          city: cityController.text,
                          deviceToken: userProvider.psValueHolder!.deviceToken);
                  // final ProgressDialog progressDialog = loadingDialog(context);
                  // progressDialog.show();
                  await PsProgressDialog.showDialog(context);
                  final PsResource<User> _apiStatus = await userProvider
                      .postProfileUpdate(profileUpdateParameterHolder.toMap());
                  if (_apiStatus.data != null) {
                    // progressDialog.dismiss();
                    PsProgressDialog.dismissDialog();
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext contet) {
                          return SuccessDialog(
                            message: Utils.getString(
                                context, 'edit_profile__success'),
                            onPressed: () {},
                          );
                        });
                  } else {
                    // progressDialog.dismiss();
                    PsProgressDialog.dismissDialog();

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
              }
            },
          ),
        ),
        const SizedBox(
          height: PsDimens.space12,
        ),
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              right: PsDimens.space12,
              bottom: PsDimens.space20),
          child: PSButtonWidget(
            hasShadow: false,
            colorData: PsColors.buttonColor,
            width: double.infinity,
            titleText:
                Utils.getString(context, 'edit_profile__password_change'),
            onPressed: () {
              Navigator.pushNamed(
                context,
                RoutePaths.user_update_password,
              );
            },
          ),
        )
      ],
    );
  }
}

class EmailCheckboxWidget extends StatefulWidget {
  @override
  _EmailCheckboxState createState() => _EmailCheckboxState();
}

class _EmailCheckboxState extends State<EmailCheckboxWidget> {
  void toggleCheckbox(UserProvider userProvider, bool value) {
    if (value) {
      userProvider.user.data!.isShowEmail = '1';
    } else {
      userProvider.user.data!.isShowEmail = '0';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    bool isChecked = false;

    if (userProvider.user.data != null) {
      isChecked = userProvider.user.data!.isShowEmail == '1';
    }
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12, right: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    toggleCheckbox(userProvider, value!);
                  },
                  activeColor: PsColors.activeColor ,//PsColors.primary500,
                  checkColor: Colors.white,
                  tristate: false,
                ),
              ),
              Expanded(
                child: Text(
                  Utils.getString(context, 'edit_profile__show_email'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PhoneNoCheckboxWidget extends StatefulWidget {
  @override
  _PhoneNoCheckboxState createState() => _PhoneNoCheckboxState();
}

class _PhoneNoCheckboxState extends State<PhoneNoCheckboxWidget> {
  bool isPhoneChecked = true;

  void toggleCheckbox(UserProvider userProvider, bool value) {
    if (value) {
      userProvider.user.data!.isShowPhone = '1';
    } else {
      userProvider.user.data!.isShowPhone = '0';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    bool isChecked = false;

    if (userProvider.user.data != null) {
      isChecked = userProvider.user.data!.isShowPhone == '1';
    }
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12, right: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    toggleCheckbox(userProvider, value!);
                  },
                  activeColor: PsColors.activeColor,// PsColors.primary500,
                  checkColor: Colors.white,
                  tristate: false,
                ),
              ),
              Expanded(
                child: Text(
                  Utils.getString(context, 'edit_profile__show_phone_no'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImageWidget extends StatefulWidget {
  const _ImageWidget({this.userProvider});
  final UserProvider? userProvider;

  @override
  __ImageWidgetState createState() => __ImageWidgetState();
}

XFile? pickedImage;
List<XFile> images = <XFile>[];
XFile? defaultAssetImage;

class __ImageWidgetState extends State<_ImageWidget> {
  Future<bool> requestGalleryPermission() async {
    // final Map<Permission, PermissionStatus> permissionss =
    //     await PermissionHandler()
    //         .requestPermissions(<Permission>[Permission.photos]);
    // if (permissionss != null &&
    //     permissionss.isNotEmpty &&
    //     permissionss[Permission.photos] == PermissionStatus.granted) {
    const Permission _photos = Permission.photos;
    final PermissionStatus permissionss = await _photos.request();

    if (permissionss == PermissionStatus.granted) {
      return true;
    } else  {
     return openAppSettings();
     // return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

      try {
        pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
        );
      } on Exception catch (e) {
        e.toString();
      }


      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) {
        return;
      }
      // images = resultList;
      setState(() {});

    //  if (images.isNotEmpty) {
        if (pickedImage!.name.contains('.webp')) {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: Utils.getString(context, 'error_dialog__webp_image'),
                );
              });
        } else {
          PsProgressDialog.dismissDialog();
          final PsResource<User> _apiStatus = await widget.userProvider!
              .postImageUpload(
                  widget.userProvider!.psValueHolder!.loginUserId!,
                  PsConst.PLATFORM,
                  await Utils.getImageFileFromAssets(
                      pickedImage!, widget.userProvider!.psValueHolder!.chatImageSize!));
          if (_apiStatus.data != null) {
            setState(() {
              widget.userProvider!.user.data = _apiStatus.data;
            });
          }
          PsProgressDialog.dismissDialog();
        }
     // }
    }

    final Widget _imageWidget =
        widget.userProvider!.user.data!.userProfilePhoto != null
            ? PsNetworkImageWithUrlForUser(
                photoKey: '',
                imagePath: widget.userProvider!.user.data!.userProfilePhoto,
                width: double.infinity,
                height: PsDimens.space200,
                boxfit: BoxFit.cover,
                imageAspectRation: PsConst.Aspect_Ratio_3x,
                onTap: () {},
              )
            : InkWell(
                onTap: () {},
                child: Ink(
                    child:
                        Image.file(File(pickedImage!.path), width: 100, height: 160)),
              );

    final Widget _editWidget = Container(
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: PsDimens.space2),
        iconSize: PsDimens.space24,
        icon: Icon(
          Icons.edit,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () async {
          if (await Utils.checkInternetConnectivity()) {
            requestGalleryPermission().then((bool status) async {
              if (status) {
                await _pickImage();
              }
            });
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
      width: PsDimens.space32,
      height: PsDimens.space32,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: PsColors.primary500),
        color: PsColors.baseColor, //backgroundColor
        borderRadius: BorderRadius.circular(PsDimens.space28),
      ),
    );

    final Widget _imageInCenterWidget = Positioned(
        top: 110,
        child: Stack(
          children: <Widget>[
            Container(
                width: 90,
                height: 90,
                child: CircleAvatar(
                  child: PsNetworkCircleImageForUser(
                    photoKey: '',
                    imagePath: widget.userProvider!.user.data!.userProfilePhoto,
                    width: double.infinity,
                    height: PsDimens.space200,
                    boxfit: BoxFit.cover,
                    onTap: () async {
                      if (await Utils.checkInternetConnectivity()) {
                        requestGalleryPermission().then((bool status) async {
                          if (status) {
                            await _pickImage();
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
                  ),
                )),
            Positioned(
              top: 1,
              right: 1,
              child: _editWidget,
            ),
          ],
        ));

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
            width: double.infinity,
            height: PsDimens.space160,
            child: _imageWidget),
        Container(
          color: PsColors.white.withAlpha(100),
          width: double.infinity,
          height: PsDimens.space160,
        ),
        Container(
          // color: Colors.white38,
          width: double.infinity,
          height: PsDimens.space220,
        ),
        _imageInCenterWidget,
      ],
    );
  }
}

class ProfileImageWidget extends StatefulWidget {
  const ProfileImageWidget({
    Key? key,
    required this.images,
    required this.selectedImage,
    this.onTap,
  }) : super(key: key);

  final Function? onTap;

  final XFile images;
  final String selectedImage;
  @override
  State<StatefulWidget> createState() {
    return ProfileImageWidgetState();
  }
}

class ProfileImageWidgetState extends State<ProfileImageWidget> {
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (widget.selectedImage != null) {
      return InkWell(
        onTap: widget.onTap as void Function()?,
        child: PsNetworkCircleImageForUser(
          photoKey: '',
          width: double.infinity,
          height: PsDimens.space200,
          imagePath: widget.selectedImage,
          boxfit: BoxFit.cover,
        ),
      );
    } else {
      // ignore: unnecessary_null_comparison
      if (widget.images != null) {
        final XFile asset = widget.images;
        return InkWell(
          onTap: widget.onTap as void Function()?,
          child: Image.file(
           File(asset.path),
            width: 300,
            height: 300,
          ),
          // ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10000.0),
          child: InkWell(
            onTap: widget.onTap as void Function()?,
            child: Image.asset(
              'assets/images/user_default_photo.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }
  }
}

class _UserFirstCardWidget extends StatefulWidget {
  const _UserFirstCardWidget(
      {required this.userNameController,
      required this.emailController,
      required this.phoneController,
      required this.aboutMeController,
      required this.addressController,
      required this.cityController,
      required this.userProvider});
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController aboutMeController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final UserProvider userProvider;

  @override
  __UserFirstCardWidgetState createState() => __UserFirstCardWidgetState();
}

class __UserFirstCardWidgetState extends State<_UserFirstCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.baseColor,//PsColors.backgroundColor,
      padding:
          const EdgeInsets.only(left: PsDimens.space8, right: PsDimens.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: PsDimens.space16,
          ),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__user_name'),
              hintText: Utils.getString(context, 'edit_profile__user_name'),
              textAboutMe: false,
              textEditingController: widget.userNameController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__email'),
              hintText: Utils.getString(context, 'edit_profile__email'),
              keyboardType: TextInputType.emailAddress,
              textAboutMe: false,
              textEditingController: widget.emailController),
          // Row(
          //   children: <Widget>[
          //     Expanded(
          //       flex: 5,
          //       child: PsTextFieldWidget(
          //           titleText: Utils.getString(context, 'edit_profile__phone'),
          //           textAboutMe: false,
          //           isEnable: false,
          //           keyboardType: TextInputType.phone,
          //           hintText: Utils.getString(context, 'edit_profile__phone'),
          //           textEditingController: widget.phoneController),
          //     ),
          //     Expanded(
          //       flex: 1,
          //       child: IconButton(
          //         alignment: Alignment.bottomCenter,
          //         padding: const EdgeInsets.only(bottom: PsDimens.space2),
          //         iconSize: PsDimens.space24,
          //         icon: Icon(
          //           Icons.edit,
          //           color: Theme.of(context).iconTheme.color,
          //         ),
          //         onPressed: () async {
          //           final dynamic returnEditPhone = await Navigator.pushNamed(
          //               context, RoutePaths.edit_phone_signin_container);
          //           if (returnEditPhone != null && returnEditPhone is String) {
          //             widget.phoneController.text = returnEditPhone;
          //           }
          //         },
          //       ),
          //     )
          //   ],
          // ),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__address'),
              hintText: Utils.getString(context, 'edit_profile__address'),
              textAboutMe: false,
              textEditingController: widget.addressController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__city_name'),
              textAboutMe: false,
              hintText: Utils.getString(context, 'edit_profile__city_name'),
              textEditingController: widget.cityController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__about_me'),
              height: PsDimens.space120,
              keyboardType: TextInputType.multiline,
              textAboutMe: true,
              hintText: Utils.getString(context, 'edit_profile__about_me'),
              textEditingController: widget.aboutMeController),
          const SizedBox(
            height: PsDimens.space12,
          )
        ],
      ),
    );
  }
}

// class TextFieldWidget extends StatelessWidget {
//   const TextFieldWidget(
//       {this.textEditingController,
//       this.titleText = '',
//       this.hintText,
//       this.textAboutMe = false,
//       this.height = PsDimens.space44,
//       this.showTitle = true,
//       this.keyboardType = TextInputType.text,
//       this.isStar = false,
//       this.isEnable = true});

//   final TextEditingController? textEditingController;
//   final String titleText;
//   final String? hintText;
//   final double height;
//   final bool textAboutMe;
//   final TextInputType keyboardType;
//   final bool showTitle;
//   final bool isStar;
//   final bool isEnable;

//   @override
//   Widget build(BuildContext context) {
//     final Widget _productTextWidget =
//         Text(titleText, style: Theme.of(context).textTheme.bodyText2);

//     return Column(
//       children: <Widget>[
//         if (showTitle)
//           Container(
//             margin: const EdgeInsets.only(
//                 left: PsDimens.space12,
//                 top: PsDimens.space12,
//                 right: PsDimens.space12),
//             child: Row(
//               children: <Widget>[
//                 if (isStar)
//                   Row(
//                     children: <Widget>[
//                       Text(titleText,
//                           style: Theme.of(context).textTheme.bodyText2),
//                       Text(' *',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyText2!
//                               .copyWith(color: PsColors.primary500))
//                     ],
//                   )
//                 else
//                   _productTextWidget
//               ],
//             ),
//           )
//         else
//           Container(
//             height: 0,
//           ),
//         Container(
//             width: double.infinity,
//             height: height,
//             margin: const EdgeInsets.all(PsDimens.space12),
//             decoration: BoxDecoration(
//               color: PsColors.primary50,
//               borderRadius: BorderRadius.circular(PsDimens.space10),
//              // border: Border.all(color: PsColors.mainDividerColor),
//             ),
//             child: TextField(
//                 keyboardType: keyboardType,
//                 maxLines: null,
//                 textDirection: TextDirection.ltr,
//                 textAlign: Directionality.of(context) == TextDirection.ltr
//                     ? TextAlign.left
//                     : TextAlign.right,
//                 controller: textEditingController,
//                 style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                   color: PsColors.secondary400
//                 ),
//                 enabled: isEnable,
//                 decoration: textAboutMe
//                     ? InputDecoration(
//                         contentPadding: const EdgeInsets.only(
//                           left: PsDimens.space12,
//                           bottom: PsDimens.space8,
//                           top: PsDimens.space10,
//                         ),
//                         border: InputBorder.none,
//                         hintText: hintText,
//                         hintStyle: Theme.of(context)
//                             .textTheme
//                             .bodyText2!
//                             .copyWith(color: PsColors.textPrimaryLightColor),
//                       )
//                     : InputDecoration(
//                         contentPadding: const EdgeInsets.only(
//                           left: PsDimens.space12,
//                           bottom: PsDimens.space8,
//                         ),
//                         border: InputBorder.none,
//                         hintText: hintText,
//                         hintStyle: Theme.of(context)
//                             .textTheme
//                             .bodyText2!
//                             .copyWith(color: PsColors.textPrimaryLightColor),
//                       ))),
//       ],
//     );
//   }
// }
