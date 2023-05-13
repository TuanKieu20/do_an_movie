import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/color.dart';
import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/search_controller.dart';
import '../../../models/movie_model.dart';
import '../../helpers/helper.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  // final controller = Get.find<SearchController>();
  final controller = Get.put(SearchController());
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GetBuilder<SearchController>(builder: (builder) {
          return InkWell(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.searchController,
                          cursorColor: Colors.blue,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: ((value) {
                            controller.search(value.trimLeft().trimRight(),
                                homeController.movies);
                          }),
                          style: mikado400,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Colors.grey.shade900,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              hintText: 'Search',
                              hintStyle:
                                  mikado400.copyWith(color: AppColors.grayC9C9),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.grayC9C9,
                                size: 30,
                              )),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          showBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: ((context) {
                                return const ModelSoftFilter();
                              }));
                          // showModalBottomSheet(
                          //     backgroundColor: Colors.transparent,
                          //     context: context,
                          //     builder: ((context) {
                          //       return ModelSoftFilter();
                          //     }));
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15)),
                          child: const Icon(
                            Icons.format_list_bulleted_sharp,
                            color: Colors.red,
                            size: 28,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  controller.haveFilter()
                      ? SizedBox(
                          height: 40,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                if (controller.listOptionFilter[index] ==
                                    (-1)) {
                                  return const SizedBox();
                                }
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.red,
                                  ),
                                  child: Text(
                                    Helper.getValueFilter(
                                            controller.listOptionFilter[index],
                                            index) ??
                                        '',
                                    style:
                                        mikado400.copyWith(color: Colors.white),
                                  ),
                                );
                              }),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GetBuilder<SearchController>(builder: (builder) {
                      return BuildGridViewSearch(
                        movies: controller.haveFilter()
                            ? controller.moviesFiltered
                            : controller.state() == SearchState.init
                                ? homeController.movies
                                : controller.state() == SearchState.empty
                                    ? []
                                    : controller.moviesSearch,
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ModelSoftFilter extends StatelessWidget {
  const ModelSoftFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchController>();
    return GetBuilder<SearchController>(builder: (builder) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.8),
          ),
          Container(
            height: Get.height * 0.7,
            padding: const EdgeInsets.only(top: 2),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.grey,
            ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Color(0xff21222a),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Sort & Filter',
                      style:
                          mikado700.copyWith(color: Colors.red, fontSize: 18),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thể loại',
                              style: mikado500.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                ButtonContainer(
                                  text: 'Khoa học viễn tưởng',
                                  onTap: () {
                                    if (controller.listOptionFilter()[0] == 0) {
                                      controller.changeValueByType(
                                          type: 0, value: -1);
                                    } else {
                                      controller.changeValueByType(
                                          type: 0, value: 0);
                                    }
                                  },
                                  isClicked:
                                      controller.listOptionFilter()[0] == 0
                                          ? true
                                          : false,
                                ),
                                ButtonContainer(
                                  text: 'Kinh dị',
                                  onTap: () {
                                    if (controller.listOptionFilter()[0] == 1) {
                                      controller.changeValueByType(
                                          type: 0, value: -1);
                                    } else {
                                      controller.changeValueByType(
                                          type: 0, value: 1);
                                    }
                                  },
                                  isClicked:
                                      controller.listOptionFilter()[0] == 1
                                          ? true
                                          : false,
                                ),
                                ButtonContainer(
                                  text: 'Hành động',
                                  onTap: () {
                                    if (controller.listOptionFilter()[0] == 2) {
                                      controller.changeValueByType(
                                          type: 0, value: -1);
                                    } else {
                                      controller.changeValueByType(
                                          type: 0, value: 2);
                                    }
                                  },
                                  isClicked:
                                      controller.listOptionFilter()[0] == 2
                                          ? true
                                          : false,
                                ),
                                ButtonContainer(
                                  text: 'Hoạt hình',
                                  onTap: () {
                                    if (controller.listOptionFilter()[0] == 3) {
                                      controller.changeValueByType(
                                          type: 0, value: -1);
                                    } else {
                                      controller.changeValueByType(
                                          type: 0, value: 3);
                                    }
                                  },
                                  isClicked:
                                      controller.listOptionFilter()[0] == 3
                                          ? true
                                          : false,
                                ),
                                ButtonContainer(
                                  text: 'Tình cảm',
                                  onTap: () {
                                    if (controller.listOptionFilter()[0] == 4) {
                                      controller.changeValueByType(
                                          type: 0, value: -1);
                                    } else {
                                      controller.changeValueByType(
                                          type: 0, value: 4);
                                    }
                                  },
                                  isClicked:
                                      controller.listOptionFilter()[0] == 4
                                          ? true
                                          : false,
                                ),
                                ButtonContainer(
                                  text: 'Khoa học',
                                  onTap: () {
                                    if (controller.listOptionFilter()[0] == 5) {
                                      controller.changeValueByType(
                                          type: 0, value: -1);
                                    } else {
                                      controller.changeValueByType(
                                          type: 0, value: 5);
                                    }
                                  },
                                  isClicked:
                                      controller.listOptionFilter()[0] == 5
                                          ? true
                                          : false,
                                ),
                              ],
                            ),
                            Text(
                              'Xếp hạng',
                              style: mikado500.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                ButtonContainer(
                                  text: '0 - 2 ⭐',
                                  onTap: () {
                                    if (controller.listOptionFilter()[1] == 0) {
                                      controller.changeValueByType(
                                          type: 1, value: -1);
                                    } else {
                                      controller.changeValueByType(
                                          type: 1, value: 0);
                                    }
                                  },
                                  isClicked:
                                      controller.listOptionFilter()[1] == 0
                                          ? true
                                          : false,
                                ),
                                ButtonContainer(
                                  text: '2 - 4 ⭐',
                                  onTap: () {
                                    if (controller.listOptionFilter()[1] == 1) {
                                      controller.changeValueByType(
                                          type: 1, value: -1);
                                    } else {
                                      controller.changeValueByType(
                                          type: 1, value: 1);
                                    }
                                  },
                                  isClicked:
                                      controller.listOptionFilter()[1] == 1
                                          ? true
                                          : false,
                                ),
                                ButtonContainer(
                                  text: '4 - 5 ⭐',
                                  onTap: () {
                                    if (controller.listOptionFilter()[1] == 2) {
                                      controller.changeValueByType(
                                          type: 1, value: -1);
                                    } else {
                                      controller.changeValueByType(
                                          type: 1, value: 2);
                                    }
                                  },
                                  isClicked:
                                      controller.listOptionFilter()[1] == 2
                                          ? true
                                          : false,
                                ),
                              ],
                            ),
                            Text(
                              'Sắp xếp',
                              style: mikado500.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              children: [
                                ButtonContainer(
                                  text: 'Phổ biến',
                                  onTap: () {
                                    if (controller.listOptionFilter()[2] == 0) {
                                      controller.changeValueByType(
                                          type: 3, value: -1);
                                    } else {
                                      controller.changeValueByType(
                                          type: 3, value: 0);
                                    }
                                  },
                                  isClicked:
                                      controller.listOptionFilter()[2] == 0
                                          ? true
                                          : false,
                                ),
                                ButtonContainer(
                                  text: 'Mới nhất',
                                  onTap: () {
                                    if (controller.listOptionFilter()[2] == 1) {
                                      controller.changeValueByType(
                                          type: 3, value: -1);
                                    } else {
                                      controller.changeValueByType(
                                          type: 3, value: 1);
                                    }
                                  },
                                  isClicked:
                                      controller.listOptionFilter()[2] == 1
                                          ? true
                                          : false,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Divider(
                                color: Colors.grey,
                                thickness: 2,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ButtonContainer(
                                  text: 'Đặt lại',
                                  onTap: () {
                                    controller.cleaOptionFilter();
                                  },
                                  isClicked: false,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 8),
                                ),
                                ButtonContainer(
                                  text: 'Áp dụng',
                                  onTap: () {
                                    Get.back();
                                    controller.haveFilter(
                                        controller.checkHaveFilter());
                                    controller.filterMovie();
                                  },
                                  isClicked: false,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 8),
                                ),
                              ],
                            )

                            // SingleChildScrollView(
                            //   scrollDirection: Axis.horizontal,
                            //   child: Row(
                            //     children: [

                            //     ],
                            //   ),
                            // )
                          ],
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

class ButtonContainer extends StatelessWidget {
  const ButtonContainer(
      {Key? key,
      required this.text,
      required this.onTap,
      required this.isClicked,
      this.padding})
      : super(key: key);
  final String text;
  final VoidCallback onTap;
  final bool isClicked;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.red),
            borderRadius: BorderRadius.circular(30),
            color: isClicked ? Colors.red : Colors.transparent),
        child: Text(
          text,
          style:
              mikado400.copyWith(color: isClicked ? Colors.white : Colors.red),
        ),
      ),
    );
  }
}

class BuildGridViewSearch extends StatelessWidget {
  const BuildGridViewSearch({super.key, required this.movies});
  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchController>();
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // mainAxisExtent: 50,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2 / 3),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (() {
              Get.toNamed(Routes.detailMovie,
                  arguments: {'movie': movies[index]});
            }),
            child: Container(
              // margin: controller.state() == SearchState.init
              //     ? index == movies.length - 1
              //         ? const EdgeInsets.only(bottom: 20)
              //         : null
              //     : null,
              margin: controller.checkLengthListEven(movies)
                  ? (index == movies.length - 1 && index == movies.length - 2)
                      ? const EdgeInsets.only(bottom: 20)
                      : null
                  : index == movies.length - 1
                      ? const EdgeInsets.only(bottom: 20)
                      : null,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      // image: NetworkImage(data['movies'][index].poster),
                      image: CachedNetworkImageProvider(
                        movies[index].poster!,
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
                    movies[index].rating.toString(),
                    style: mikado400.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
