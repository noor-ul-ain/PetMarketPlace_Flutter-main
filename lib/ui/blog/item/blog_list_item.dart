

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/viewobject/blog.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class BlogListItem extends StatelessWidget {
  const BlogListItem(
      {Key? key,
      required this.blog,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Blog blog;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: GestureDetector(
            onTap: onTap as void Function()?,
            child: Container(
                margin: const EdgeInsets.all(PsDimens.space8),
                child: BlogListItemWidget(blog: blog,onTap: onTap,))),
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

class BlogListItemWidget extends StatelessWidget {
  const BlogListItemWidget({
    Key? key,
    required this.blog,
    this.onTap,
  }) : super(key: key);

  final Blog blog;
   final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(PsDimens.space4),
          child: Container(
           height: MediaQuery.of(context).size.width / 4 * 1,
           width: MediaQuery.of(context).size.width / 4 * 1,
            child: PsNetworkImage(
              photoKey: blog.id,
              defaultPhoto: blog.defaultPhoto,
              boxfit: BoxFit.cover,
              imageAspectRation: PsConst.Aspect_Ratio_3x,
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 4 * 3 - 48,
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:10,right: 10),
                  child: Text(
                          blog.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                  ),
                ),         
                  Padding(
                    padding: const EdgeInsets.only(left:10,right: 10),
                    child: Html(
                       data: blog.description!,
                       // ignore: always_specify_types
                       style: {
                         '#': Style(
                           margin: Margins.only(top: -7.0),
                           maxLines: (MediaQuery.of(context).size.width / 150).round(),
                           fontWeight: FontWeight.normal,
                           textOverflow: TextOverflow.ellipsis,
                           lineHeight: LineHeight.em(1.3),
                         ),
                       },
                       ),
                  ),
                  Padding(
                       padding: const EdgeInsets.only(top: 4.0,right: 4),
                       child: Align(
                     alignment: Alignment.bottomRight,
                     child: InkWell(
                       onTap: onTap as void Function()?,
                    child:  Icon(
                        FontAwesome.angle_double_right,
                        size: 16,
                        color: PsColors.activeColor,)),
            ),
                     )
                       ],
              ),
            ),
            
          ],
        ),
      ],
    );
  }
}
