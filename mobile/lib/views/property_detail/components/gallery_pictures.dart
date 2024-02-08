import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../services/theme/theme.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/sizes.dart';
import '../../../widgets/custom_buttons.dart';

class GalleryPictures extends StatelessWidget {
  final List<String>? images;
  final double width;
  final double additionalHeight;
  final void Function()? onSeeAllPhotos;

  const GalleryPictures(this.images, {super.key, this.onSeeAllPhotos, required this.width, required this.additionalHeight});

  @override
  Widget build(BuildContext context) {
    const picturesSpacing = Paddings.small;
    return images != null && images!.length >= 5
        ? Stack(
            children: [
              ClipRRect(
                borderRadius: regularRadius,
                child: SizedBox(
                  height: 380 + additionalHeight,
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(flex: 2, child: _buildImage(images!.first, isBig: true)),
                      const SizedBox(width: picturesSpacing),
                      Flexible(
                        child: Column(
                          children: [
                            Expanded(child: _buildImage(images![1])),
                            const SizedBox(height: picturesSpacing),
                            Expanded(child: _buildImage(images![2])),
                          ],
                        ),
                      ),
                      const SizedBox(width: picturesSpacing),
                      Flexible(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
                          child: Column(
                            children: [
                              Expanded(child: _buildImage(images![3])),
                              const SizedBox(height: picturesSpacing),
                              Expanded(child: _buildImage(images![4])),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: CustomButtons.elevatePrimary(
                  buttonColor: kNeutralColor100,
                  borderSide: const BorderSide(color: kBlackColor, width: 0.8),
                  onPressed: onSeeAllPhotos ?? () {},
                  height: 40,
                  child: const Row(
                    children: [
                      Icon(Icons.apps_outlined),
                      SizedBox(width: Paddings.small),
                      Text('See all photos', style: AppFonts.x14Bold),
                    ],
                  ),
                ),
              ),
            ],
          )
        : const Text('No enough pictures');
  }

  Widget _buildImage(String image, {bool isBig = false}) => CachedNetworkImage(
        imageUrl: image,
        height: 380 + additionalHeight,
        width: isBig ? width / 2 : width / 4,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
        errorWidget: (context, url, error) => Image.asset("assets/images/no_image.jpg", height: 380 + additionalHeight, fit: BoxFit.cover),
      );
}
