import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/custom_alter.dart';
import '../../../constants/styles.dart';
import '../../../controllers/admin_controller.dart';
import '../../helpers/helper.dart';
import '../../widgets/custom_button.dart';

class AddMovie extends StatefulWidget {
  const AddMovie({super.key});

  @override
  State<AddMovie> createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  var action = Get.arguments['action'];
  var movie = Get.arguments['movie'] ?? {};
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: (() {
              Get.back();
              controller.clearAll();
            }),
            icon: const Icon(
              Icons.arrow_back,
              size: 28,
            )),
        title: Text(
          'Thêm phim mới',
          style: mikado500.copyWith(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GetBuilder<AdminController>(builder: (builder) {
              return Form(
                key: controller.keyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 80,
                      child: Row(
                        children: [
                          // teen phim
                          Flexible(
                            flex: 3,
                            child: TextFormField(
                              controller: controller.nameController,
                              // focusNode: controller.focusNodes[0],
                              cursorColor: Colors.black,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              // validator: ((value) {
                              //   return value!.isEmpty
                              //       ? 'Tên phim không được để trống'
                              //       : null;
                              // }),
                              style: mikado400.copyWith(color: Colors.black),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(20)),
                                  fillColor: Colors.grey,
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  hintText: 'Tên phim ...',
                                  hintStyle:
                                      mikado400.copyWith(color: Colors.black)),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // tac gia
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                              controller: controller.authorController,
                              // focusNode: controller.focusNodes[0],
                              cursorColor: Colors.black,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              // validator: ((value) {
                              //   return value!.isEmpty
                              //       ? 'Tên phim không được để trống'
                              //       : null;
                              // }),
                              style: mikado400.copyWith(color: Colors.black),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(20)),
                                  fillColor: Colors.grey,
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  hintText: 'Tên tác giả...',
                                  hintStyle:
                                      mikado400.copyWith(color: Colors.black)),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.desController,
                      // focusNode: controller.focusNodes[0],
                      cursorColor: Colors.black,
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      // validator: ((value) {
                      //   return value!.isEmpty
                      //       ? 'Tên phim không được để trống'
                      //       : null;
                      // }),
                      style: mikado400.copyWith(color: Colors.black),
                      maxLines: 6,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                          fillColor: Colors.grey,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          hintText: 'Mô tả phim ...',
                          hintStyle: mikado400.copyWith(color: Colors.black)),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: CheckboxListTile(
                              value: controller.isKid.value,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: ((value) {
                                controller.changeIsKid(!controller.isKid.value);
                              }),
                              title: Text(
                                'Phim cho trẻ em',
                                style: mikado400.copyWith(color: Colors.black),
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: controller.isSub.value,
                              onChanged: ((value) {
                                controller.changeIsSub(!controller.isSub.value);
                              }),
                              title: Text(
                                'Subtitle',
                                style: mikado400.copyWith(color: Colors.black),
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(height: 0),
                    Text(
                      'Thể loại',
                      style:
                          mikado500.copyWith(color: Colors.black, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.typeController,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        showCustomSlideDialog(
                            context: context,
                            showButton: false,
                            child: IntrinsicHeight(
                              child: Container(
                                width: double.infinity,
                                height: Get.height * 0.55,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12))),
                                child: ListView.builder(
                                    itemCount: listTypeMovie.length,
                                    itemBuilder: ((context, index) {
                                      return InkWell(
                                        onTap: () {
                                          controller.typeController.text =
                                              listTypeMovie[index];
                                          controller.update();
                                          Get.back();
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.blue)),
                                          child: Text(
                                            listTypeMovie[index],
                                            style: mikado500.copyWith(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                      );
                                    })),
                              ),
                            ));
                      },
                      cursorColor: Colors.black,
                      style: mikado400.copyWith(color: Colors.black),
                      focusNode: _AlwaysDisabledFocusNode(),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                          fillColor: Colors.grey,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: Icon(
                              Icons.arrow_drop_down_rounded,
                              size: 35,
                              color: Colors.black,
                            ),
                          ),
                          hintText: 'Thể loại phim ...',
                          hintStyle: mikado400.copyWith(color: Colors.black)),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: 150,
                        child: CustomButton(
                            onTap: () {
                              if (action == 'add') {
                                if (controller.nameController.text.isEmpty ||
                                    controller.authorController.text.isEmpty ||
                                    controller.desController.text.isEmpty ||
                                    controller.typeController.text.isEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return CustomAlert(
                                            labelText:
                                                'Vui lòng điền đầy đủ thông tin ',
                                            onPressed: () => Get.back());
                                      }));
                                } else {
                                  controller.pickVideo();
                                }
                              } else {
                                Helper.showDialogFuntionLoss();
                              }
                            },
                            color: Colors.white,
                            text: 'Chọn video',
                            backgroundColor: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (controller.fileThumnail != null)
                      Center(
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    controller.fileThumnail!,
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  )),
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
                      ),

                    //   if (controller.fileVideo != null)
                    // AspectRatio(
                    //   aspectRatio: 16 / 9,
                    //   child: VideoPlayer(),
                    // ),
                    const SizedBox(height: 30),
                    CustomButton(
                        onTap: () async {
                          if (action == 'add') {
                            if (controller.urlVideo == '' ||
                                controller.poster == '') {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return CustomAlert(
                                        labelText:
                                            'Vui lòng điền đầy đủ thông tin ',
                                        onPressed: () => Get.back());
                                  }));
                            } else {
                              controller.addMovie();
                            }
                          } else {
                            await controller.updateMovie(movie.id);
                            Get.back();
                            Helper.showDialogFuntionLoss(
                                text: 'Cập nhật thông tin thành công. ');
                          }
                        },
                        color: Colors.white,
                        text: action == 'add' ? 'Thêm' : 'Cập nhật',
                        backgroundColor: Colors.blue)
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

void showCustomSlideDialog({
  required BuildContext context,
  required Widget child,
  String? barrierLabel,
  String? buttonLabel,
  bool? barrierDismissible,
  Color? barrierColor,
  Color? buttonColor,
  Duration? transitionDuration,
  String? title,
  TextStyle? titleStyle,
  Function? onSubmitted,
  EdgeInsets? margin,
  EdgeInsets? padding,
  EdgeInsets? buttonMargin,
  EdgeInsets? buttonPadding,
  double? buttonWidth,
  bool showButton = true,
}) {
  showGeneralDialog(
    barrierLabel: 'customSlideDialog',
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.6),
    transitionDuration: const Duration(milliseconds: 300),
    context: context,
    pageBuilder: (context, _, __) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: IntrinsicHeight(
          child: Container(
              margin: MediaQuery.of(context).viewInsets,
              width: double.maxFinite,
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Material(
                color: Colors.white,
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          Text(title ?? '',
                              style: mikado600.copyWith(
                                  fontSize: 20, color: Colors.black)),
                          child,
                          SizedBox(height: showButton ? 20 : 10),
                        ],
                      ),
                    ),
                    const _CloseButton(),
                  ],
                ),
              )),
        ),
      );
    },
    transitionBuilder: (_, animation1, __, child) =>
        _slideAnimation(animation1, child),
  );
}

SlideTransition _slideAnimation(Animation<double> animation1, Widget child) {
  return SlideTransition(
    position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
        .animate(animation1),
    child: child,
  );
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => Get.back(),
          child: const Icon(
            Icons.close,
            color: Colors.black,
            size: 30,
          )),
    );
  }
}

var listTypeMovie = [
  'Khoa học viễn tưởng',
  'Kinh dị',
  'Hành động',
  'Hoạt hình',
  'Tình cảm',
  'Khoa học'
];
