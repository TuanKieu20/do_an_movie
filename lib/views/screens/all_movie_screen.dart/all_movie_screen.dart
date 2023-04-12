import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/router.dart';
import '../../../constants/styles.dart';

class AllMovieScreen extends StatelessWidget {
  const AllMovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
            onPressed: (() => Get.back()),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            )),
        title: Text(
          data['title'],
          style: mikado500.copyWith(fontSize: 22),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search_outlined,
                size: 32,
              ))
        ],
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // mainAxisExtent: 50,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 2 / 3),
          itemCount: data['movies'].length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (() {
                Get.toNamed(Routes.detailMovie,
                    arguments: {'movie': data['movies'][index]});
              }),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                    image: DecorationImage(
                        // image: NetworkImage(data['movies'][index].poster),
                        image: CachedNetworkImageProvider(
                          data['movies'][index].poster,
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
                      data['movies'][index].rating.toString(),
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
