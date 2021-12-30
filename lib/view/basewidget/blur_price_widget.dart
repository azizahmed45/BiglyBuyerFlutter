import 'dart:ui';

import 'package:bigly24/provider/auth_provider.dart';
import 'package:bigly24/utill/color_resources.dart';
import 'package:bigly24/utill/custom_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'animated_custom_dialog.dart';
import 'guest_dialog.dart';

class BlurPrice extends StatelessWidget {
  final String text;
  const BlurPrice({@required this.text,Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return GestureDetector(
      onTap: (){
        if (isGuestMode) {
          showAnimatedDialog(context, GuestDialog(), isFlip: true);
        }
      },
      child: Stack(
        children: [
          Text(
            text,
            style: robotoBold.copyWith(
                color: ColorResources.getPrimary(context)),
          ),
          ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2)),
                ),
              )),
        ],
      ),
    );
  }
}
