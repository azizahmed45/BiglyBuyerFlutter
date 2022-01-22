import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:bigly24/provider/banner_provider.dart';
import 'package:bigly24/provider/splash_provider.dart';
import 'package:bigly24/utill/color_resources.dart';
import 'package:bigly24/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class BannersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<BannerProvider>(
          builder: (context, bannerProvider, child) {
            double _width = MediaQuery.of(context).size.width;
            return Container(
              width: _width,
              height: _width * 0.3,
              child: bannerProvider.mainBannerList != null
                  ? bannerProvider.mainBannerList.length != 0
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            CarouselSlider.builder(
                              options: CarouselOptions(
                                viewportFraction: .95,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                disableCenter: true,
                                onPageChanged: (index, reason) {
                                  Provider.of<BannerProvider>(context,
                                          listen: false)
                                      .setCurrentIndex(index);
                                },
                              ),
                              itemCount:
                                  bannerProvider.mainBannerList.length == 0
                                      ? 1
                                      : bannerProvider.mainBannerList.length,
                              itemBuilder: (context, index, _) {
                                return InkWell(
                                  onTap: () => _launchUrl(
                                      bannerProvider.mainBannerList[index].url),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder,
                                        fit: BoxFit.cover,
                                        image:
                                            '${bannerProvider.mainBannerList[index].photo}',
                                        imageErrorBuilder: (c, o, s) =>
                                            Image.asset(Images.placeholder,
                                                fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 5,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    bannerProvider.mainBannerList.map((banner) {
                                  int index = bannerProvider.mainBannerList
                                      .indexOf(banner);
                                  return TabPageSelectorIndicator(
                                    backgroundColor:
                                        index == bannerProvider.currentIndex
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                    borderColor:
                                        index == bannerProvider.currentIndex
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                    size: 10,
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        )
                      : Center(child: Text('No banner available'))
                  : Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: bannerProvider.mainBannerList == null,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorResources.WHITE,
                          )),
                    ),
            );
          },
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Consumer<BannerProvider>(
            builder: (context, footerBannerProvider, child) {
              return footerBannerProvider.footerBannerList != null &&
                      footerBannerProvider.footerBannerList.length != 0
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: (2 / 1),
                      ),
                      itemCount: footerBannerProvider.footerBannerList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () => _launchUrl(
                              footerBannerProvider.footerBannerList[index].url),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder,
                                  fit: BoxFit.cover,
                                  image:
                                      '${footerBannerProvider.footerBannerList[index].photo}',
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                      Images.placeholder,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: footerBannerProvider.footerBannerList == null,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorResources.WHITE,
                          )),
                    );
            },
          ),
        )
      ],
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
