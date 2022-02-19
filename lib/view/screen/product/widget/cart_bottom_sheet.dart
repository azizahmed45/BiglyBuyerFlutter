import 'package:flutter/material.dart';
import 'package:bigly24/data/model/response/cart_model.dart';
import 'package:bigly24/data/model/response/product_model.dart';
import 'package:bigly24/helper/price_converter.dart';
import 'package:bigly24/localization/language_constrants.dart';
import 'package:bigly24/provider/auth_provider.dart';
import 'package:bigly24/provider/cart_provider.dart';
import 'package:bigly24/provider/product_details_provider.dart';
import 'package:bigly24/provider/seller_provider.dart';
import 'package:bigly24/provider/splash_provider.dart';
import 'package:bigly24/provider/theme_provider.dart';
import 'package:bigly24/utill/color_resources.dart';
import 'package:bigly24/utill/custom_themes.dart';
import 'package:bigly24/utill/dimensions.dart';
import 'package:bigly24/utill/images.dart';
import 'package:bigly24/view/basewidget/button/custom_button.dart';
import 'package:bigly24/view/basewidget/show_custom_snakbar.dart';
import 'package:provider/provider.dart';

class CartBottomSheet extends StatefulWidget {
  final Product product;
  final Function callback;

  CartBottomSheet({@required this.product, this.callback});

  @override
  _CartBottomSheetState createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  route(bool isRoute, String message) async {
    if (isRoute) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .initData(widget.product);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child: Consumer<ProductDetailsProvider>(
            builder: (context, details, child) {
              // Variation _variation;
              // String _variantName = widget.product.colors.length != 0
              //     ? widget.product.colors[details.variantIndex].name
              //     : null;
              // List<String> _variationList = [];
              // for (int index = 0;
              //     index < widget.product.choiceOptions.length;
              //     index++) {
              //   _variationList.add(widget.product.choiceOptions[index]
              //       .options[details.variationIndex[index]]
              //       .trim());
              // }
              // String variationType = '';
              // if (_variantName != null) {
              //   variationType = _variantName;
              //   _variationList.forEach(
              //       (variation) => variationType = '$variationType-$variation');
              // } else {
              //   bool isFirst = true;
              //   _variationList.forEach((variation) {
              //     if (isFirst) {
              //       variationType = '$variationType$variation';
              //       isFirst = false;
              //     } else {
              //       variationType = '$variationType-$variation';
              //     }
              //   });
              // }
              // double price = widget.product.unitPrice;
              // int _stock = widget.product.currentStock;
              // for (Variation variation in widget.product.variation) {
              //   if (variation.type == variationType) {
              //     price = variation.price;
              //     _variation = variation;
              //     _stock = variation.qty;
              //     break;
              //   }
              // }
              // double priceWithDiscount = PriceConverter.convertWithDiscount(
              //     context,
              //     price,
              //     widget.product.discount,
              //     widget.product.discountType);
              // double priceWithQuantity = priceWithDiscount * details.quantity;
              //

              int _stock = 100000000;
              double priceWithQuantity =
                  widget.product.unitPrice * details.quantity;

              TextEditingController textEditingController =
                  TextEditingController(text: Provider.of<ProductDetailsProvider>(context, listen: false).quantity.toString());

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close Button
                    Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).highlightColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[
                                        Provider.of<ThemeProvider>(context)
                                                .darkTheme
                                            ? 700
                                            : 200],
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                  )
                                ]),
                            child: Icon(Icons.clear,
                                size: Dimensions.ICON_SIZE_SMALL),
                          ),
                        )),

                    // Product details
                    Row(children: [
                      Container(
                        width: 100,
                        height: 100,
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                          color: ColorResources.getImageBg(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder,
                          image: '${widget.product.thumbnail}',
                          imageErrorBuilder: (c, o, s) =>
                              Image.asset(Images.placeholder),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.product.name ?? '',
                                  style: titilliumSemiBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                PriceConverter.convertPrice(
                                    context, widget.product.unitPrice,
                                    discountType: widget.product.discountType,
                                    discount: widget.product.discount),
                                style: titilliumBold.copyWith(
                                    color: ColorResources.getPrimary(context),
                                    fontSize: 16),
                              ),
                              widget.product.discount != null &&
                                      widget.product.discount > 0
                                  ? Text(
                                      PriceConverter.convertPrice(
                                          context, widget.product.unitPrice),
                                      style: titilliumRegular.copyWith(
                                          color: Theme.of(context).hintColor,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    )
                                  : SizedBox(),
                            ]),
                      ),
                      Expanded(child: SizedBox.shrink()),
                      widget.product.discount != null &&
                              widget.product.discount > 0
                          ? Container(
                              height: 20,
                              margin: EdgeInsets.only(
                                  top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2,
                                    color: ColorResources.getPrimary(context)),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                PriceConverter.percentageCalculation(
                                    context,
                                    widget.product.unitPrice,
                                    widget.product.discount,
                                    widget.product.discountType),
                                style: titilliumRegular.copyWith(
                                    color: Theme.of(context).hintColor,
                                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                              ),
                            )
                          : SizedBox(),
                    ]),

                    // Quantity
                    Row(children: [
                      Text(getTranslated('quantity', context),
                          style: robotoBold),
                      QuantityButton(
                          isIncrement: false, quantity: details.quantity),
                      Container(
                        width: 100,
                        height: 30,
                        alignment: Alignment.center,
                        child: Focus(
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 5, left: 10),
                              border: OutlineInputBorder(),
                            ),
                            controller: textEditingController,
                            maxLines: 1,
                            // keyboardType: TextInputType.number,
                          ),

                          onFocusChange: (focus) {
                            if (!focus) {
                              Provider.of<ProductDetailsProvider>(context,
                                      listen: false)
                                  .setQuantity(int.parse(
                                      textEditingController.value.text));
                            }
                          },
                        ),
                      ),
                      QuantityButton(
                        isIncrement: true,
                        quantity: details.quantity,
                      ),
                    ]),

                    // Variant
                    widget.product.colors != null &&
                            widget.product.colors.length > 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(getTranslated('select_variant', context),
                                    style: robotoBold),
                                SizedBox(
                                  height: 25,
                                  child: ListView.builder(
                                    itemCount: widget.product.colors.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      String colorString = '0xff' +
                                          widget.product.colors[index].code
                                              .substring(1, 7);
                                      return InkWell(
                                        onTap: () {
                                          Provider.of<ProductDetailsProvider>(
                                                  context,
                                                  listen: false)
                                              .setCartVariantIndex(index);
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          margin: EdgeInsets.only(
                                              left: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color:
                                                Color(int.parse(colorString)),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey[
                                                      Provider.of<ThemeProvider>(
                                                                  context)
                                                              .darkTheme
                                                          ? 700
                                                          : 200],
                                                  spreadRadius: 1,
                                                  blurRadius: 5)
                                            ],
                                          ),
                                          child: details.variantIndex == index
                                              ? Icon(Icons.done_all,
                                                  color: ColorResources.WHITE,
                                                  size: 12)
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ])
                        : SizedBox(),
                    widget.product.colors != null &&
                            widget.product.colors.length > 0
                        ? SizedBox(height: Dimensions.PADDING_SIZE_SMALL)
                        : SizedBox(),

                    // Variation
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 0,
                      // itemCount: widget.product.choiceOptions.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.product.choiceOptions[index].title,
                                  style: robotoBold),
                              SizedBox(
                                  height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: (1 / 0.25),
                                ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: widget.product.choiceOptions[index]
                                    .options.length,
                                itemBuilder: (context, i) {
                                  return InkWell(
                                    onTap: () {
                                      Provider.of<ProductDetailsProvider>(
                                              context,
                                              listen: false)
                                          .setCartVariationIndex(index, i);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      decoration: BoxDecoration(
                                        color: details.variationIndex[index] !=
                                                i
                                            ? Theme.of(context).highlightColor
                                            : ColorResources.getPrimary(
                                                context),
                                        borderRadius: BorderRadius.circular(5),
                                        border: details.variationIndex[index] !=
                                                i
                                            ? Border.all(
                                                color:
                                                    Theme.of(context).hintColor,
                                                width: 2)
                                            : null,
                                      ),
                                      child: Text(
                                          widget.product.choiceOptions[index]
                                              .options[i],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: titilliumRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL,
                                            color:
                                                details.variationIndex[index] !=
                                                        i
                                                    ? Theme.of(context)
                                                        .hintColor
                                                    : Theme.of(context)
                                                        .highlightColor,
                                          )),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                  height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            ]);
                      },
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Row(children: [
                      Text(getTranslated('total_price', context),
                          style: robotoBold),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Text(
                        PriceConverter.convertPrice(context, priceWithQuantity),
                        style: titilliumBold.copyWith(
                            color: ColorResources.getPrimary(context),
                            fontSize: 16),
                      ),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    // Cart button
                    Provider.of<CartProvider>(context).isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        : CustomButton(
                            buttonText: getTranslated('add_to_cart', context),
                            onTap: () {
                              CartModel cart = CartModel(
                                widget.product.id,
                                widget.product.thumbnail,
                                widget.product.name,
                                "seller",
                                widget.product.unitPrice,
                                widget.product.unitPrice,
                                details.quantity,
                                _stock,
                                '',
                                '',
                                null,
                                widget.product.discount,
                                widget.product.discountType,
                                widget.product.tax,
                                widget.product.taxType,
                                1,
                                '',
                                widget.product.userId,
                                '',
                                widget.product.thumbnail,
                                '',
                                widget.product.choiceOptions,
                                Provider.of<ProductDetailsProvider>(context,
                                        listen: false)
                                    .variationIndex,
                              );

                              // cart.variations = _variation;

                              // if (Provider.of<AuthProvider>(context,
                              //         listen: false)
                              //     .isLoggedIn()) {
                              //   Provider.of<CartProvider>(context,
                              //           listen: false)
                              //       .addToCartAPI(
                              //     cart,
                              //     route,
                              //     context,
                              //     widget.product.choiceOptions,
                              //     Provider.of<ProductDetailsProvider>(context,
                              //             listen: false)
                              //         .variationIndex,
                              //   );
                              // } else {
                              //   Provider.of<CartProvider>(context,
                              //           listen: false)
                              //       .addToCart(cart);
                              //   Navigator.pop(context);
                              //   showCustomSnackBar(
                              //       getTranslated('added_to_cart', context),
                              //       context,
                              //       isError: false);
                              // }

                              Provider.of<CartProvider>(context, listen: false)
                                  .addToCart(cart);
                              Navigator.pop(context);
                              showCustomSnackBar(
                                  getTranslated('added_to_cart', context),
                                  context,
                                  isError: false);
                            }),
                  ]);
            },
          ),
        ),
      ],
    );
  }
}

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final int quantity;
  final bool isCartWidget;
  final int stock;

  QuantityButton({
    @required this.isIncrement,
    @required this.quantity,
    this.stock = 999999999, //unlimited stock
    this.isCartWidget = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!isIncrement && quantity > 1) {
          Provider.of<ProductDetailsProvider>(context, listen: false)
              .setQuantity(quantity - 1);
        } else if (isIncrement && quantity < stock) {
          Provider.of<ProductDetailsProvider>(context, listen: false)
              .setQuantity(quantity + 1);
        }
      },
      icon: Icon(
        isIncrement ? Icons.add_circle : Icons.remove_circle,
        color: isIncrement
            ? quantity >= stock
                ? ColorResources.getLowGreen(context)
                : ColorResources.getPrimary(context)
            : quantity > 1
                ? ColorResources.getPrimary(context)
                : ColorResources.getLowGreen(context),
        size: isCartWidget ? 26 : 20,
      ),
    );
  }
}
