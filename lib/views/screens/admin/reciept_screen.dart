import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/styles.dart';
import '../../../controllers/admin_controller.dart';
import '../../helpers/helper.dart';

class RecieptScreen extends StatefulWidget {
  const RecieptScreen({super.key});

  @override
  State<RecieptScreen> createState() => _RecieptScreenState();
}

class _RecieptScreenState extends State<RecieptScreen> {
  final controller = Get.find<AdminController>();

  @override
  void initState() {
    controller.listRecieptTemp = controller.reciepts;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminController>(builder: ((controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 30),
              const Spacer(),
              Text(
                'Quản Lý Giao dịch',
                style: mikado500.copyWith(color: Colors.black, fontSize: 20),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(right: 20),
                width: 30,
                child: IconButton(
                    onPressed: () {
                      // Get.toNamed(Routes.addMovie, arguments: {'action': 'add'});
                      _showSortOptions(context);
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 32,
                    )),
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
              child: FutureBuilder(
            future: controller.refReciept.get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var reciepts = snapshot.data!.docs;
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                      // itemCount: reciepts.length,
                      itemCount: controller.listRecieptTemp.length,
                      itemBuilder: ((context, index) {
                        // logger.e(snapshot.data!.docs[index]['user']);
                        // var reciept = snapshot.data!.docs[index];
                        var reciept = controller.listRecieptTemp[index];
                        return Container(
                          // margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? Colors.grey[300]
                                  : Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.file_download_done_rounded,
                                color: Colors.black,
                                size: 28,
                              ),
                              const SizedBox(width: 30),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Center(
                                  //   child: Text(
                                  //     'Nâng cấp tài khoản',
                                  //     style: mikado500.copyWith(
                                  //         color: Colors.black, fontSize: 18),
                                  //   ),
                                  // ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Gói: ${reciept['timeType'] == '1' ? '1 tháng' : '1 năm'}',
                                    style:
                                        mikado400.copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    'Hình thức: ${controller.cardList[int.parse(reciept['type'])]['text']}',
                                    style:
                                        mikado400.copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    'Giá: \$${reciept['price']}',
                                    style:
                                        mikado400.copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    'Ngày đăng ký: ${Helper.dateTimeToFormattedString(reciept['time'])}',
                                    style:
                                        mikado400.copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    'Ngày hết hạn: ${Helper.convertDateExpried(reciept['time'], int.parse(reciept['timeType']))}',
                                    style:
                                        mikado400.copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    'Người dùng: ${reciept['user']}',
                                    style:
                                        mikado400.copyWith(color: Colors.black),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        );
                      }));
                } else {
                  return Center(
                    child: Text(
                      'Bạn chưa có giao dịch nào',
                      style: mikado500.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          fontStyle: FontStyle.italic),
                    ),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ))
        ],
      );
    }));
  }

  void _showSortOptions(BuildContext context) async {
    final result = await showMenu(
      context: context,
      position:
          RelativeRect.fromLTRB(Get.width - 30, kToolbarHeight + 50, 0, 0),
      items: controller.sortOptions.map((option) {
        return PopupMenuItem(
          value: option.sortBy,
          child: Text(option.title),
        );
      }).toList(),
    );

    if (result != null) {
      controller.changeSortOption(result);
      _sortData();
      // setState(() {
      //   _sortOption = result;
      //   _sortedData = _sortData(widget.data);
      // });
    }
  }

  List _sortData() {
    var _now = DateTime.now();
    controller.listRecieptTemp = controller.reciepts;
    switch (controller.sortOption) {
      case 'package1':
        var temp = controller.listRecieptTemp
            .where((item) => item['timeType'] == '1')
            .toList();
        return controller.listRecieptTemp = temp;

      case 'package2':
        var temp = controller.listRecieptTemp
            .where((item) => item['timeType'] == '2')
            .toList();
        return controller.listRecieptTemp = temp;

      case 'dayRemail':
        controller.listRecieptTemp.sort((a, b) {
          var timeA =
              Helper.convertdDateTime(a['time'], int.parse(a['timeType']));
          var timeB =
              Helper.convertdDateTime(b['time'], int.parse(b['timeType']));
          final remainingDaysA = timeA.difference(DateTime.now()).inDays;
          final remainingDaysB = timeB.difference(DateTime.now()).inDays;
          return remainingDaysA.compareTo(remainingDaysB);
        });
        return controller.listRecieptTemp;
      case 'expired':
        var temp = controller.listRecieptTemp
            .where((item) =>
                Helper.convertdDateTime(
                        item['time'], int.parse(item['timeType']))
                    .day ==
                0)
            .toList();
        return controller.listRecieptTemp = temp;

      case 'all':
        var temp = controller.listRecieptTemp;
        return controller.listRecieptTemp = temp;

      default:
        return [];
    }
  }
}
