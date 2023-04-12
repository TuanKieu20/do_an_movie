import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/color.dart';
import '../../../constants/styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../models/movie_model.dart';
import '../detail_movie_screen/widgets/build_comments.dart';

class AllCommentsScreen extends StatelessWidget {
  AllCommentsScreen({super.key});
  final MovieModel movie = Get.arguments;

  final _key = GlobalKey<FormState>();
  final textController = TextEditingController();
  final _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: (() => Get.back()),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            centerTitle: false,
            title: Text(
              '${movie.comments!.length.toString()} Comments',
              style: mikado500.copyWith(fontSize: 20),
            ),
          ),
          backgroundColor: Colors.black,
          body: GetBuilder<HomeController>(builder: (controller) {
            return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('movies')
                    .doc(movie.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: Colors.transparent,
                    );
                  }
                  final movieTemp = MovieModel.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>,
                      idDoc: movie.id);
                  return Stack(
                    // alignment: Alignment.bottomCenter,
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          controller: _scroll,
                          itemCount: movieTemp.comments!.length,
                          itemBuilder: (context, index) {
                            return BuildComments(
                                movie: movieTemp, index: index);
                          }),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 120,
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.fromLTRB(0, 2, 00, 0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            // border: Border.all(width: 2, color: Colors.white38),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            // color: Colors.red,
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              // border: Border.all(width: 2, color: Colors.white38),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25)),
                            ),
                            height: 120,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Form(
                                    key: _key,
                                    child: TextFormField(
                                      controller: textController,
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
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          fillColor: Colors.grey.shade900,
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 15),
                                          hintText: 'Add comment...',
                                          hintStyle: mikado400.copyWith(
                                              color: AppColors.grayC9C9),
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
                                          comment: textController.text,
                                          idMovie: movie.id);
                                      // _scroll.animateTo(
                                      //     movie.comments!.length * 50.0,
                                      //     duration:
                                      //         const Duration(milliseconds: 300),
                                      //     curve: Curves.decelerate);

                                      textController.clear();
                                    }
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
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
                      ),
                    ],
                  );
                  //   return TabViewComment(
                  //       movie: MovieModel.fromJson(
                  //           snapshot.data!.data()
                  //               as Map<String,
                  //                   dynamic>,
                  //           idDoc:
                  //               movie['movie'].id));
                  // },),
                });
          })),
    );
  }
}
