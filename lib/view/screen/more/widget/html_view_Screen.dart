import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:bigly24/utill/dimensions.dart';
import 'package:bigly24/view/basewidget/custom_app_bar.dart';

class HtmlViewScreen extends StatelessWidget {
  final String title;
  final String url;
  HtmlViewScreen({@required this.url, @required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBar(title: title),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              physics: BouncingScrollPhysics(),
              child: Html(
                data: url,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
