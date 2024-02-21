// ignore_for_file: prefer_single_quotes

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/blog.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogView extends StatefulWidget {
  const BlogView({Key? key, required this.blog, required this.heroTagImage})
      : super(key: key);

  final Blog blog;
  final String? heroTagImage;

  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  bool isReadyToShowAppBarIcons = false;

  @override
  Widget build(BuildContext context) {
    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isReadyToShowAppBarIcons = true;
        });
      });
    }

    return Scaffold(
        backgroundColor: PsColors.baseColor,
        body: CustomScrollView(
          shrinkWrap: true,
          slivers: <Widget>[
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
              ),
              iconTheme: Theme.of(context).iconTheme.copyWith(
                  color: Utils.isLightMode(context)
                      ? PsColors.primary500
                      : PsColors.primaryDarkWhite),
            ),
            SliverToBoxAdapter(
                child: Container(
              //          color: PsColors.primaryDarkWhite,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: PsDimens.space12,
                    right: PsDimens.space12,
                    bottom: PsDimens.space12),
                child: Text(
                  widget.blog.name!,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            )),
            SliverToBoxAdapter(
              child: PsNetworkImage(
                photoKey: widget.heroTagImage,
                height: PsDimens.space300,
                width: double.infinity,
                defaultPhoto: widget.blog.defaultPhoto,
                imageAspectRation: PsConst.Aspect_Ratio_full_image,
                boxfit: BoxFit.cover,
              ),
            ),
            SliverToBoxAdapter(
              child: TextWidget(
                blog: widget.blog,
              ),
            )
          ],
        ));
  }
}

class TextWidget extends StatefulWidget {
  const TextWidget({
    Key? key,
    required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  late PsValueHolder psValueHolder;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && psValueHolder.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context, listen: false);
    if (!isConnectedToInternet && psValueHolder.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    return Container(
      //  color: PsColors.baseColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.all(PsDimens.space12),
            //   child: Text(
            //     widget.blog.name!,
            //     style: Theme.of(context)
            //         .textTheme
            //         .headline6!
            //         .copyWith(fontWeight: FontWeight.bold),
            //   ),
            // ),
            Padding(
                padding: const EdgeInsets.only(
                    left: PsDimens.space6,
                    right: PsDimens.space6,
                    bottom: PsDimens.space12),
                child: Html(
                  data: widget.blog.description!,
                  // ignore: always_specify_types
                  style: {
                    "table": Style(
                      backgroundColor: PsColors.baseLightColor,
                      //  width: MediaQuery.of(context).size.width,
                    ),
                    "tr": Style(
                      border: const Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    "th": Style(
                      padding: HtmlPaddings.all(6),
                      backgroundColor: Colors.grey,
                    ),
                    "td": Style(
                      padding: HtmlPaddings.all(6),
                      alignment: Alignment.center,
                      width: Width(120),
                    ),
                  },
                  onLinkTap: (String? url, _, __) async {
                    if (url != null && await canLaunchUrl(Uri.parse(url)))
                      await launchUrl(Uri.parse(url));
                    else // can't launch url, there is some error
                      throw 'Could not launch $url';
                  },
                  // ignore: always_specify_types
                  // customRender: {
                  //   "table": (RenderContext context, Widget child) {
                  //     return SingleChildScrollView(
                  //       scrollDirection: Axis.horizontal,
                  //       child: (context.tree as TableLayoutElement)
                  //           .toWidget(context),
                  //     );
                  //   },
                  //   "bird": (RenderContext context, Widget child) {
                  //     return const TextSpan(text: "🐦");
                  //   },
                  //   "flutter": (RenderContext context, Widget child) {
                  //     return FlutterLogo(
                  //       style:
                  //           (context.tree.element!.attributes['horizontal'] !=
                  //                   null)
                  //               ? FlutterLogoStyle.horizontal
                  //               : FlutterLogoStyle.markOnly,
                  //       textColor: context.style.color!,
                  //       size: context.style.fontSize!.size! * 5,
                  //     );
                  //   },
                  // },
                  // ignore: always_specify_types
                  //   style: {
                  //   '#': Style(
                  //    // maxLines: 3,
                  //     fontWeight: FontWeight.normal,
                  //    // textOverflow: TextOverflow.ellipsis,
                  //   ),
                  // },
                )
                //  Text(
                //   widget.blog.description,
                //   style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.5),
                // ),
                ),
            const PsAdMobBannerWidget(
              admobSize: AdSize.banner,
            ),
          ],
        ),
      ),
    );
  }
}
