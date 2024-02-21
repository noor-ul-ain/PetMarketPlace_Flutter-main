import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/viewobject/default_photo.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';

class GalleryGridItem extends StatelessWidget {
  const GalleryGridItem({
    Key? key,
    required this.image,
    this.onImageTap,
     required this.product,
  }) : super(key: key);

  final DefaultPhoto image;
  final Function? onImageTap;
  final Product product;


  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: image,
      width: MediaQuery.of(context).size.width,
      height: double.infinity,
      boxfit: BoxFit.cover,
      imageAspectRation: PsConst.Aspect_Ratio_2x,
      onTap: onImageTap,
    );
    return Container(
      margin: const EdgeInsets.all(PsDimens.space4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PsDimens.space8),
        child: _imageWidget,
      ),
    );
  }
}
