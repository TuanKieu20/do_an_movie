import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/router.dart';
import '../../../../constants/styles.dart';
import '../../../../models/movie_model.dart';

class TabViewMoreLikeThis extends StatelessWidget {
  const TabViewMoreLikeThis({super.key, required this.movieCate});

  final List<MovieModel> movieCate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: GridView.builder(
          padding: const EdgeInsets.all(0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // mainAxisExtent: 50,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 2 / 3),
          itemCount: movieCate.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.back();
                Get.toNamed(Routes.detailMovie,
                    arguments: {'movie': movieCate[index]});
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                    image: DecorationImage(
                        // image: NetworkImage(movieCate[index].poster!),
                        image: CachedNetworkImageProvider(
                          movieCate[index].poster!,
                          errorListener: () => Image.asset(
                            'assets/images/image_error.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        fit: BoxFit.cover)),
                child: Align(
                  alignment: const Alignment(-0.8, -0.9),
                  child: Container(
                    // alignment: Alignment(1, -1),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      movieCate[index].rating.toString(),
                      style: mikado400.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
