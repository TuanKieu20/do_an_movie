import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/color.dart';
import '../../../../constants/router.dart';
import '../../../../constants/styles.dart';
import '../../../../controllers/home_controller.dart';
import '../../../../models/movie_model.dart';
import 'build_comments.dart';

class TabViewComment extends StatelessWidget {
  TabViewComment({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final MovieModel movie;
  final controller = Get.find<HomeController>();
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (builder) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${movie.comments!.length} Comments', style: mikado500),
                TextButton(
                    onPressed: () =>
                        Get.toNamed(Routes.allComments, arguments: movie),
                    child: Text(
                      'See all',
                      style: mikado500.copyWith(color: Colors.red),
                    ))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller.scrollComment,
              padding: const EdgeInsets.all(0),
              itemCount: movie.comments!.length,
              itemBuilder: ((context, index) {
                return BuildComments(movie: movie, index: index);
              }),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white38),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: _key,
                      child: TextFormField(
                        controller: controller.commentController,
                        cursorColor: Colors.blue,
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: ((value) {
                          return value!.trim().isEmpty
                              ? 'Vui lòng nhập nội dung bình luận'
                              : null;
                        }),
                        style: mikado400,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            fillColor: Colors.grey.shade900,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            hintText: 'Add comment...',
                            hintStyle:
                                mikado400.copyWith(color: AppColors.grayC9C9),
                            suffixIcon: const Icon(
                              Icons.add_reaction_rounded,
                              color: AppColors.grayC9C9,
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () async {
                      if (_key.currentState!.validate()) {
                        await controller.addComment(
                            comment: controller.commentController.text,
                            idMovie: movie.id);
                        controller.scrollComment.animateTo(
                            movie.comments!.length * 50.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.decelerate);

                        controller.commentController.clear();
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: Transform.rotate(
                        angle: -0.67,
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
