import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/common/smooth_star_rating_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/user.dart';
import 'package:provider/provider.dart';

class SearchUserVerticalListItem extends StatelessWidget {
  const SearchUserVerticalListItem(
      {Key? key,
      required this.user,
      required this.currentUser,
      this.onTap,
      this.onFollowBtnTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final User user;
  final String? currentUser;
  final Function? onTap;
  final Function? onFollowBtnTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();

    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: PsDimens.space88,
            decoration: BoxDecoration(
            color: PsColors.cardBackgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space10)),
              ),
            margin: const EdgeInsets.only(bottom: PsDimens.space12,left: PsDimens.space14,right: PsDimens.space14),
            child: Padding(
                  padding: const EdgeInsets.only(
                    top:PsDimens.space4, bottom: PsDimens.space4, 
                    left: PsDimens.space16, right: PsDimens.space12),
                  child: UserWidget(user: user, currentUser: currentUser, onFollowBtnTap: onFollowBtnTap)
                  ),
            
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation!.value), 0.0),
                  child: child));
        });
  }
}

class UserWidget extends StatelessWidget {
  const UserWidget({
    Key? key,
    required this.user,
    required this.currentUser,
    this.onFollowBtnTap,
  }) : super(key: key);

  final User? user;
  final String? currentUser;
  final Function? onFollowBtnTap;

  @override
  Widget build(BuildContext context) {
    // const Widget _spacingWidget = SizedBox(
    //   height: PsDimens.space8,
    // );

    // final Widget _imageWidget = PsNetworkCircleImageForUser(
    //   photoKey: '',
    //   imagePath: user.userProfilePhoto,
    //   width: PsDimens.space76,
    //   height: PsDimens.space80,
    //   boxfit: BoxFit.cover,
    //   onTap: () {
    //     onTap();
    //   },
    // );
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // _imageWidget,
        Container(
          width: PsDimens.space44,
          height: PsDimens.space44,
          child: PsNetworkCircleImageForUser(
            photoKey: '',
            imagePath: user?.userProfilePhoto ?? '',
            // width: PsDimens.space76,
            // height: PsDimens.space80,
            boxfit: BoxFit.cover,
            
          ),
        ),
        const SizedBox(
          width: PsDimens.space12,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                        child: Text(
                          user?.userName == ''
                              ? Utils.getString(context, 'default__user_name')
                              : user?.userName ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    if (user?.isVerifyBlueMark == PsConst.ONE)
                      Container(
                        margin: const EdgeInsets.only(left: PsDimens.space2),
                        child: Icon(
                          Icons.check_circle,
                          color: PsColors.bluemarkColor,
                          size: valueHolder.bluemarkSize,
                        ),
                      )
                  ],
                ),
                if (user!.userAboutMe != '')
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      user!.userAboutMe!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: PsColors.textColor2,
                      ),
                    ),
                  ),
                _RatingWidget(
                  data: user!,
                ),
              ],
            ),
          ),
        ),


        Visibility(
          visible: currentUser != user!.userId,
          child: MaterialButton(
          color: PsColors.buttonColor,
          height: 32,
          shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),

          onPressed: onFollowBtnTap as void Function()?,
          child: Text(
            user!.isFollowed == PsConst.ZERO ? Utils.getString(context, 'profile__follow') : Utils.getString(context, 'profile__following'),
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Colors.white),
          ),
          ),
        )
      ],
    );
  }
}

class _RatingWidget extends StatelessWidget {
  const _RatingWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final User data;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: PsDimens.space8,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.ratingList,
                arguments: data.userId);
          },
          child: SmoothStarRating(
              key: Key(data.ratingDetail!.totalRatingValue!),
              rating: double.parse(data.ratingDetail!.totalRatingValue!),
              allowHalfRating: false,
              isReadOnly: true,
              starCount: 5,
              size: PsDimens.space16,
              color: PsColors.activeColor,
              borderColor: PsColors.iconColor,
              onRated: (double? v) {},
              spacing: 0.0),
        ),
        const SizedBox(
          width: PsDimens.space8,
        ),
        Text(
          data.overallRating!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
