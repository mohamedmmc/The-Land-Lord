import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_land_lord_website/models/dto/property_detail_dto.dart';
import 'package:photo_view/photo_view.dart';
import 'package:the_land_lord_website/services/theme/theme.dart';
import 'package:the_land_lord_website/widgets/custom_buttons.dart';

import '../../../helpers/buildables.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class AllPhotoScreen extends StatelessWidget {
  static const String routeName = '/all-photos';

  final List<ImageDTO> images;
  const AllPhotoScreen({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Buildables.customAppBar(),
      // TODO Use for mobile device
      // bottomNavigationBar: AppBottomNavigation(),
      body: DecoratedBox(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: kNeutralLightColor, width: 0.5))),
        child: SingleChildScrollView(
          // controller: controller.scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1, vertical: Paddings.extraLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButtons.icon(
                  onPressed: Get.back,
                  child: const SizedBox(
                    width: 170,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: Paddings.regular),
                      minVerticalPadding: 0,
                      dense: true,
                      title: Text('Back to Property', style: AppFonts.x14Bold),
                      leading: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ),
                const SizedBox(height: Paddings.large),
                GridView.extent(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  maxCrossAxisExtent: 400.0,
                  mainAxisSpacing: Paddings.extraLarge,
                  crossAxisSpacing: Paddings.extraLarge,
                  children: images.map((item) {
                    return InkWell(
                      onTap: () => Get.bottomSheet(
                        backgroundColor: kBlackColor,
                        barrierColor: kBlackColor.withOpacity(0.9),
                        isScrollControlled: true,
                        Center(child: PhotoView(initialScale: PhotoViewComputedScale.covered, imageProvider: NetworkImage(item.url))),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: item.thumbnail,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                        errorWidget: (context, url, error) => Image.asset("assets/images/no_image.jpg", fit: BoxFit.cover),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
