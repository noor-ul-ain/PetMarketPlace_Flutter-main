

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetyTipsView extends StatefulWidget {
  const SafetyTipsView({
    Key? key,
    required this.animationController,
    required this.safetyTips,
  }) : super(key: key);

  final AnimationController? animationController;
  final String? safetyTips;
  @override
  _SafetyTipsViewState createState() => _SafetyTipsViewState();
}

class _SafetyTipsViewState extends State<SafetyTipsView> {
  @override
  Widget build(BuildContext context) {
    // final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
    //     .animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController!.forward();
    return Scaffold(
        appBar: AppBar(
            systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),  
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: Utils.isLightMode(context)? PsColors.primary500 : PsColors.primaryDarkWhite),
          title: Text(
            Utils.getString(context, 'safety_tips__app_bar_name'),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(PsDimens.space10),
          child: SingleChildScrollView(
            child: Html(
                  data: widget.safetyTips ?? '',
                  // ignore: always_specify_types
                  style: {
                    'table': Style(
                      backgroundColor: PsColors.baseLightColor,
                      //  width: MediaQuery.of(context).size.width,
                    ),
                    'tr': Style(
                      border: const Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    'th': Style(
                      padding: HtmlPaddings.all(6),
                      backgroundColor: Colors.grey,
                    ),
                    'td': Style(
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
                  //   'table': (RenderContext context, Widget child) {
                  //     return SingleChildScrollView(
                  //       scrollDirection: Axis.horizontal,
                  //       child: (context.tree as TableLayoutElement)
                  //           .toWidget(context),
                  //     );
                  //   },
                  //   'bird': (RenderContext context, Widget child) {
                  //     return const TextSpan(text: '🐦');
                  //   },
                  //   'flutter': (RenderContext context, Widget child) {
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
                ),
            // child: Text(
            // widget.safetyTips ?? '',
            // style: Theme.of(context).textTheme.bodyText1,
            // )
          ),
        )
      );
    //  AnimatedBuilder(
    //   animation: widget.animationController,
    //   builder: (BuildContext context, Widget child) {
    //     return FadeTransition(
    //       opacity: animation,
    //       child: Transform(
    //         transform: Matrix4.translationValues(
    //             0.0, 100 * (1.0 - animation.value), 0.0),
    //         child: Padding(
    //           padding: const EdgeInsets.all(PsDimens.space10),
    //           child: SingleChildScrollView(
    //             child: Text(
    //               widget.safetyTips ?? '',
    //               style: Theme.of(context).textTheme.bodyText1,
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // ));
  }
}
