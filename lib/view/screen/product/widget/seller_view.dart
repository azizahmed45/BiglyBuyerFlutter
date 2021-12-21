import 'package:flutter/material.dart';
import 'package:bigly24/localization/language_constrants.dart';
import 'package:bigly24/provider/auth_provider.dart';
import 'package:bigly24/provider/seller_provider.dart';
import 'package:bigly24/utill/color_resources.dart';
import 'package:bigly24/utill/custom_themes.dart';
import 'package:bigly24/utill/dimensions.dart';
import 'package:bigly24/utill/images.dart';
import 'package:bigly24/view/basewidget/animated_custom_dialog.dart';
import 'package:bigly24/view/basewidget/guest_dialog.dart';
import 'package:bigly24/view/basewidget/title_row.dart';
import 'package:bigly24/view/screen/chat/chat_screen.dart';
import 'package:bigly24/view/screen/seller/seller_screen.dart';
import 'package:provider/provider.dart';

class SellerView extends StatelessWidget {
  final String sellerId;
  SellerView({@required this.sellerId});

  @override
  Widget build(BuildContext context) {
    Provider.of<SellerProvider>(context, listen: false).initSeller(sellerId, context);

    return Consumer<SellerProvider>(
      builder: (context, seller, child) {
        return Container(
          margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          color: Theme.of(context).cardColor,
          child: Column(children: [
            TitleRow(title: getTranslated('seller', context), isDetailsPage: true),
            Row(children: [
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SellerScreen(seller: seller.sellerModel))),
                  child: Text(
                    seller.sellerModel != null ? '${seller.sellerModel.fName ?? ''} ${seller.sellerModel.lName ?? ''}' : '',
                    style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.SELLER_TXT),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if(!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                    showAnimatedDialog(context, GuestDialog(), isFlip: true);
                  }else if(seller.sellerModel != null) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(seller: seller.sellerModel)));
                  }
                },
                icon: Image.asset(Images.chat_image, color: ColorResources.SELLER_TXT, height: Dimensions.ICON_SIZE_DEFAULT),
              ),
            ]),
          ]),
        );
      },
    );
  }
}
