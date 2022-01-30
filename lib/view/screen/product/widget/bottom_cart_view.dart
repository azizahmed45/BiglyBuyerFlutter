import 'package:bigly24/provider/auth_provider.dart';
import 'package:bigly24/view/basewidget/animated_custom_dialog.dart';
import 'package:bigly24/view/basewidget/guest_dialog.dart';
import 'package:flutter/material.dart';
import 'package:bigly24/data/model/response/product_model.dart';
import 'package:bigly24/localization/language_constrants.dart';
import 'package:bigly24/provider/cart_provider.dart';
import 'package:bigly24/provider/theme_provider.dart';
import 'package:bigly24/utill/color_resources.dart';
import 'package:bigly24/utill/custom_themes.dart';
import 'package:bigly24/utill/dimensions.dart';
import 'package:bigly24/utill/images.dart';
import 'package:bigly24/view/basewidget/show_custom_snakbar.dart';
import 'package:bigly24/view/screen/cart/cart_screen.dart';
import 'package:bigly24/view/screen/product/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BottomCartView extends StatelessWidget {
  final Product product;
  BottomCartView({@required this.product});

  @override
  Widget build(BuildContext context) {
    bool isGuestMode =
        !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[
                  Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
              blurRadius: 15,
              spreadRadius: 1)
        ],
      ),
      child: Row(children: [
        Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Stack(children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CartScreen()));
                    },
                    child: Image.asset(Images.cart_image,
                        color: ColorResources.getPrimary(context))),
                Positioned(
                  top: 0,
                  right: 15,
                  child:
                      Consumer<CartProvider>(builder: (context, cart, child) {
                    return Container(
                      height: 17,
                      width: 17,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorResources.getPrimary(context),
                      ),
                      child: Text(
                        cart.cartList.length.toString(),
                        style: titilliumSemiBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                            color: Theme.of(context).highlightColor),
                      ),
                    );
                  }),
                )
              ]),
            )),
        // Expanded(flex: 6, child: InkWell(
        //   onTap: () {
        //     showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => CartBottomSheet(product: product, isBuy: true));
        //   },
        //   child: Container(
        //     height: 50,
        //     margin: EdgeInsets.only(left: 5),
        //     alignment: Alignment.center,
        //     decoration: BoxDecoration(
        //       border: Border.all(width: 2, color: ColorResources.getPrimary(context)),
        //       borderRadius: BorderRadius.circular(10),
        //       color: Theme.of(context).highlightColor,
        //     ),
        //     child: Text(
        //       getTranslated('buy_now', context),
        //       style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getPrimary(context)),
        //     ),
        //   ),
        // )),
        Expanded(
            flex: 11,
            child: InkWell(
              onTap: () {
                /*if(!Provider.of<CartProvider>(context, listen: false).isAddedInCart(product.id)) {
              showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => CartBottomSheet(product: product, isBuy: false, callback: (){
                showCustomSnackBar('Added to cart', context, isError: false);
              }));
            }else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('already_added', context)), backgroundColor: Colors.red));
            }*/
                if (isGuestMode) {
                  showAnimatedDialog(context, GuestDialog(), isFlip: true);
                  return;
                }
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (con) => CartBottomSheet(
                        product: product,
                        callback: () {
                          showCustomSnackBar(
                              getTranslated('added_to_cart', context), context,
                              isError: false);
                        }));
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorResources.getPrimary(context),
                ),
                child: Text(
                  getTranslated('add_to_cart', context),
                  style: titilliumSemiBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                      color: Theme.of(context).highlightColor),
                ),
              ),
            )),
      ]),
    );
  }
}
