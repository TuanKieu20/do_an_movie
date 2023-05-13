import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/styles.dart';
import '../../../controllers/admin_controller.dart';
import '../../helpers/helper.dart';

class UserManager extends StatelessWidget {
  const UserManager({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();
    return GetBuilder<AdminController>(builder: (builder) {
      return Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Quản Lý Người Dùng',
            style: mikado500.copyWith(color: Colors.black, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
                itemCount: controller.listUser.length,
                itemBuilder: ((context, index) {
                  var user = controller.listUser[index];
                  return Container(
                      color: index % 2 == 0 ? Colors.black12 : Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: InkWell(
                        onTap: () {
                          if (user.isAdmin) {
                            Helper.showDialogFuntionLoss(
                                text: 'Bạn đã làm admin của ứng dụng rồi.');
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Xác nhận'),
                                  content: const Text(
                                      'Bạn có chắc chắn đặt quyền Admin cho người dùng này không ?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Hủy'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Đồng ý'),
                                      onPressed: () {
                                        controller.setUserIsAdmin(user);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: CachedNetworkImageProvider(
                                user.avatar,
                                errorListener: () => Image.asset(
                                  'assets/images/image_error.jpeg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Helper.formatEmail(user.email),
                                  style: mikado500.copyWith(
                                      fontSize: 18, color: Colors.black),
                                ),
                                Text(
                                  user.email,
                                  style:
                                      mikado400.copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                if (user.isVip)
                                  Tooltip(
                                    message: 'User vip',
                                    child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        iconSize: 28,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Thông báo'),
                                                content: !controller
                                                        .checkUserVipCancel(
                                                            user.email)
                                                    ? Text(
                                                        'Tài khoản này hết hạn vào ngày ${controller.getTimeExpried(user.email)}')
                                                    : const Text(
                                                        'Tài khoản đã hết hạn vui lòng chọn đồng ý để huỷ gói của người dùng!'),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('Đồng ý'),
                                                    onPressed: () {
                                                      if (!controller
                                                          .checkUserVipCancel(
                                                              user.email)) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else {
                                                        controller
                                                            .updateUserVip(
                                                                user.id);
                                                        controller.getAllUser();
                                                        Get.back();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.workspace_premium_rounded,
                                          color: Colors.red,
                                        )),
                                  ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Xác nhận'),
                                            content: const Text(
                                                'Bạn có chắc chắn muốn xoá người dùng này không ?'),
                                            actions: [
                                              TextButton(
                                                child: const Text('Hủy'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Đồng ý'),
                                                onPressed: () {
                                                  controller.deleteUser(user);
                                                  Navigator.of(context).pop();
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
                              ],
                            ),
                          ],
                        ),
                      )
                      // child: ListTile(
                      //   onTap: () {
                      //     if (user.isAdmin) {
                      //       Helper.showDialogFuntionLoss(
                      //           text: 'Bạn đã làm admin của ứng dụng rồi.');
                      //     } else {
                      //       showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return AlertDialog(
                      //             title: const Text('Xác nhận'),
                      //             content: const Text(
                      //                 'Bạn có chắc chắn đặt quyền Admin cho người dùng này không ?'),
                      //             actions: [
                      //               TextButton(
                      //                 child: const Text('Hủy'),
                      //                 onPressed: () {
                      //                   Navigator.of(context).pop();
                      //                 },
                      //               ),
                      //               TextButton(
                      //                 child: const Text('Đồng ý'),
                      //                 onPressed: () {
                      //                   controller.setUserIsAdmin(user);
                      //                   Navigator.of(context).pop();
                      //                 },
                      //               ),
                      //             ],
                      //           );
                      //         },
                      //       );
                      //     }
                      //   },
                      //   trailing: IconButton(
                      //       onPressed: () {
                      //         showDialog(
                      //           context: context,
                      //           builder: (BuildContext context) {
                      //             return AlertDialog(
                      //               title: const Text('Xác nhận'),
                      //               content: const Text(
                      //                   'Bạn có chắc chắn muốn xoá người dùng này không ?'),
                      //               actions: [
                      //                 TextButton(
                      //                   child: const Text('Hủy'),
                      //                   onPressed: () {
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                 ),
                      //                 TextButton(
                      //                   child: const Text('Đồng ý'),
                      //                   onPressed: () {
                      //                     controller.deleteUser(user);
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                 ),
                      //               ],
                      //             );
                      //           },
                      //         );
                      //       },
                      //       icon: const Icon(
                      //         Icons.delete,
                      //         size: 28,
                      //       )),
                      //   leading: CircleAvatar(
                      //     radius: 30,
                      //     backgroundImage: CachedNetworkImageProvider(
                      //       user.avatar,
                      //       errorListener: () => Image.asset(
                      //         'assets/images/image_error.jpeg',
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //   ),
                      //   title: Text(
                      //     Helper.formatEmail(user.email),
                      //     style: mikado500.copyWith(
                      //         fontSize: 18, color: Colors.black),
                      //   ),
                      //   subtitle: Text(
                      //     user.email,
                      //     style: mikado400.copyWith(color: Colors.black),
                      //   ),
                      // ),
                      );
                })),
          ),
        ],
      );
    });
  }
}
