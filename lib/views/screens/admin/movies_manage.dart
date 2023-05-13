import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/admin_controller.dart';
import '../../helpers/helper.dart';

class MoviesManage extends StatelessWidget {
  const MoviesManage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            const Spacer(),
            Text(
              'Quản Lý Phim',
              style: mikado500.copyWith(color: Colors.black, fontSize: 20),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(right: 20),
              width: 30,
              child: IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.addMovie, arguments: {'action': 'add'});
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 32,
                  )),
            )
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
              itemCount: controller.movies.length,
              itemBuilder: ((context, index) {
                var movie = controller.movies[index];
                return Container(
                  color: index % 2 == 0 ? Colors.black12 : Colors.white,
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  child: ListTile(
                    onTap: () {
                      Get.toNamed(Routes.addMovie,
                          arguments: {'action': 'update', 'movie': movie});
                      controller.nameController.text = movie.name!;
                      controller.authorController.text = movie.author!;
                      controller.desController.text = movie.description!;
                      controller.isKid(movie.isKid);
                      controller.isSub(movie.isSub);
                      controller.typeController.text = movie.category!;
                      controller.poster = movie.poster!;
                      controller.urlVideo = movie.linkUrl!;
                    },
                    trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Xác nhận'),
                                content: const Text(
                                    'Bạn có chắc chắn muốn xoá phim này không ?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Hủy'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Đồng ý'),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await controller.removeMovie(movie.id!);
                                      await controller.getMovies();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 28,
                        )),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: CachedNetworkImageProvider(
                        movie.poster!,
                        errorListener: () => Image.asset(
                          'assets/images/image_error.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      Helper.formatEmail(movie.name!),
                      style:
                          mikado500.copyWith(fontSize: 18, color: Colors.black),
                    ),
                    // subtitle: Text(
                    //   user.email,
                    //   style: mikado400.copyWith(color: Colors.black),
                    // ),
                  ),
                );
              })),
        ),
      ],
    );
  }
}
