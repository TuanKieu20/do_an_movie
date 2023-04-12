import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../constants/router.dart';
import '../../../../constants/styles.dart';

class TabTrailer extends StatelessWidget {
  const TabTrailer({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final dynamic movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        await SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
        );
        Get.toNamed(Routes.customVideo,
            arguments: {'movie': movie['movie'], 'isTrailer': true});
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: movie['movie'].poster,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        'assets/images/image_error.jpeg',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      // ima
                      // movie['movie'].poster,
                      // width: 200,
                      // height: 200,
                      // fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    color: Colors.black.withOpacity(0.48),
                    child: const Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Trailer: ${movie['movie'].name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: mikado500,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(double.parse(movie['movie'].time) / 60).toStringAsFixed(0)}m ${(double.parse(movie['movie'].time) / 3600).toString().substring(2, 4)}s',
                    style: mikado400,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
