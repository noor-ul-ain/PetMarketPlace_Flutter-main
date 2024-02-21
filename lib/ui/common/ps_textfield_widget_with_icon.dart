import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';

class PsTextFieldWidgetWithIcon extends StatelessWidget {
  const PsTextFieldWidgetWithIcon(
      {this.textEditingController,
      this.hintText,
      this.height = PsDimens.space44,
      this.keyboardType = TextInputType.text,
      this.psValueHolder,
      this.clickEnterFunction,
      this.clickSearchButton});

  final TextEditingController? textEditingController;
  final String? hintText;
  final double height;
  final TextInputType keyboardType;
  final PsValueHolder? psValueHolder;
  final Function? clickEnterFunction;
  final Function? clickSearchButton;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextFieldWidget = TextField(
      keyboardType: TextInputType.text,
      maxLines: null,
      controller: textEditingController,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: PsDimens.space12,
          bottom: PsDimens.space8,
          top: PsDimens.space10,
        ),
        border: InputBorder.none,
        hintText: hintText,
        prefixIcon: InkWell(
            child: Icon(
              Icons.search,
              color: Utils.isLightMode(context)
                  ? PsColors.secondary400
                  : PsColors.primaryDarkAccent,
            ),
            onTap: () {
              clickSearchButton!();
              // productParameterHolder.searchTerm = textEditingController.text;
              // Utils.psPrint(productParameterHolder.searchTerm);
              // Navigator.pushNamed(context, RoutePaths.filterProductList,
              //     arguments: ProductListIntentHolder(
              //         appBarTitle: Utils.getString(
              //             context, 'home_search__app_bar_title'),
              //         productParameterHolder: productParameterHolder));
            }),
      ),
      onSubmitted: (String value) {
        clickEnterFunction!();
      },
    );

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: height,
          margin: const EdgeInsets.all(PsDimens.space12),
          decoration: BoxDecoration(
            color: Utils.isLightMode(context) ? PsColors.primary50 : Colors.black54,
            borderRadius: BorderRadius.circular(PsDimens.space12),
            // border: Border.all(
            //     color: Utils.isLightMode(context)
            //         ? Colors.grey[200]!
            //         : Colors.black87),
          ),
          child: _productTextFieldWidget,
        ),
      ],
    );
  }
}


class PsTextFieldWidgetWithIcon2 extends StatelessWidget {
  const PsTextFieldWidgetWithIcon2(
      {this.textEditingController,
      this.hintText,
      this.height = PsDimens.space44,
      this.keyboardType = TextInputType.text,
      this.psValueHolder,
      this.clickEnterFunction,
      this.onTap,
      this.clickSearchButton});

  final TextEditingController? textEditingController;
  final String? hintText;
  final double height;
  final TextInputType keyboardType;
  final PsValueHolder? psValueHolder;
  final Function? clickEnterFunction;
  final Function? clickSearchButton;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextFieldWidget =
    Container(
        padding: const EdgeInsets.only(left: PsDimens.space10,top: PsDimens.space10,right: 55),
        child: Text(
         textEditingController!.text == ''
             ? hintText!
             : textEditingController!.text,
         style: textEditingController!.text == ''
             ? Theme.of(context).textTheme.bodyLarge!.copyWith(
               //  color: PsColors.textPrimaryLightColor
                 )
             : Theme.of(context).textTheme.bodyLarge,
    ));
    
    return Column(
      children: <Widget>[
        Stack(
          children:<Widget> [
             Container(
                width: double.infinity,
                height: height,
                margin: const EdgeInsets.only(left:PsDimens.space12),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context) ? PsColors.primary50 : Colors.black54,
                  borderRadius: BorderRadius.circular(PsDimens.space12),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]!
                          : Colors.black87),
                ),
                child: _productTextFieldWidget,
              ),
      
             Positioned(
               right: 1,
               child: Container(
                 width: 50,
                  height: height,
                 // margin: const EdgeInsets.all(PsDimens.space12),
                  decoration: BoxDecoration(
                    color: Utils.isLightMode(context) ? PsColors.primary500 : Colors.black54,
                    borderRadius: BorderRadius.circular(PsDimens.space12),
                    border: Border.all(
                        color: Utils.isLightMode(context)
                            ? Colors.grey[200]!
                            : Colors.black87)
                            ),
                 child: InkWell(
                   onTap: onTap,
                   child: Icon(
                    Icons.book,
                    color: Utils.isLightMode(context)
                        ? PsColors.primaryDarkWhite
                        : PsColors.primaryDarkAccent,
            ),
                 ),
               ),
             )
          ],
        ),
      ],
    );
  }
}
