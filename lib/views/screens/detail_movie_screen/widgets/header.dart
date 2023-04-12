import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/movie_model.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
          image: DecorationImage(
              // image: NetworkImage(movie.poster!),
              image: CachedNetworkImageProvider(
                movie.poster!,
                errorListener: () => Image.asset(
                  'assets/images/image_error.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              fit: BoxFit.cover,
              alignment: Alignment.center)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: movie.poster!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
              placeholder: (context, url) => Image.asset(
                'assets/images/image_error.jpeg',
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // Image.network(
            //   movie.poster!,
            //   width: double.infinity,
            //   height: double.infinity,
            //   fit: BoxFit.contain,
            //   // color: Colors.red,
            // ),
            Align(
              alignment: const Alignment(-0.9, -0.75),
              child: InkWell(
                onTap: (() => Get.back()),
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
