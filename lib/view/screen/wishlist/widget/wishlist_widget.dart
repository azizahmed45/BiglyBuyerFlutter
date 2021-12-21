import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bigly24/data/model/response/product_model.dart';
import 'package:bigly24/helper/price_converter.dart';
import 'package:bigly24/localization/language_constrants.dart';
import 'package:bigly24/provider/splash_provider.dart';
import 'package:bigly24/provider/wishlist_provider.dart';
import 'package:bigly24/utill/color_resources.dart';
import 'package:bigly24/utill/custom_themes.dart';
import 'package:bigly24/utill/dimensions.dart';
import 'package:bigly24/utill/images.dart';
import 'package:bigly24/view/screen/product/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class WishListWidget extends StatelessWidget {
  final Product product;
  final int index;
  WishListWidget({this.product, this.index});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      margin: EdgeInsets.only(top: Dimensions.MARGIN_SIZE_SMALL),
      decoration: BoxDecoration(color: Theme.of(context).highlightColor, borderRadius: BorderRadius.circular(5)),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            FadeInImage.assetNetwork(
              placeholder: Images.placeholder, fit: BoxFit.scaleDown, width: 45, height: 45,
              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${product.thumbnail}',
              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.scaleDown, width: 45, height: 45),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: titilliumRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                            color: ColorResources.getPrimary(context),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Theme.of(context).hintColor,
                        radius: 10,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          alignment: Alignment.center,
                          icon: Icon(Icons.edit, color: Theme.of(context).highlightColor, size: 10),
                          onPressed: () {
                            showDialog(context: context, builder: (_) => new CupertinoAlertDialog(
                              title: new Text(getTranslated('ARE_YOU_SURE_WANT_TO_REMOVE_WISH_LIST', context)),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(getTranslated('YES', context)),
                                  onPressed: () {
                                    print(product.id);

                                    Provider.of<WishListProvider>(context, listen: false).removeWishList(product.id, index: index);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(getTranslated('NO', context)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Row(
                    children: [
                      Text(
                        PriceConverter.convertPrice(context, product.unitPrice),
                        style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                      ),
                      Expanded(
                        child: Text(
                          'x${product.minQty}',
                          style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        height: 20,
                        margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: ColorResources.getPrimary(context))),
                        child: Text(
                          PriceConverter.percentageCalculation(context, product.unitPrice, product.discount, product.discountType),
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getPrimary(context)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => CartBottomSheet(product: product));
                        },
                        child: Container(
                          height: 20,
                          margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 1), // changes position of shadow
                                ),
                              ],
                              gradient: LinearGradient(colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColor,
                              ]),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart, color: Colors.white, size: 10),
                              FittedBox(
                                child: Text(getTranslated('add_to_cart', context),
                                    style: titilliumBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
