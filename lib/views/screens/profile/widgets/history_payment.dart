import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/logger.dart';
import '../../../../constants/styles.dart';
import '../../../../controllers/payment_controller.dart';
import '../../../helpers/helper.dart';

class HistoryPaymentScreen extends StatelessWidget {
  const HistoryPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentController());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'Lịch sử giao dịch',
          style: mikado500.copyWith(color: Colors.white, fontSize: 20),
        ),
      ),
      body: GetBuilder<PaymentController>(builder: (builder) {
        return FutureBuilder(
          future: controller.ref
              .where('user'.toLowerCase().toString(),
                  isEqualTo: FirebaseAuth.instance.currentUser!.email!
                      .toLowerCase()
                      .toString())
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var reciepts = snapshot.data!.docs;
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: reciepts.length,
                    itemBuilder: ((context, index) {
                      logger.e(snapshot.data!.docs[index]['user']);
                      var reciept = snapshot.data!.docs[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        decoration: const BoxDecoration(color: Colors.white70),
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
                                Center(
                                  child: Text(
                                    'Nâng cấp tài khoản',
                                    style: mikado500.copyWith(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Gói: ${reciept['timeType'] == 1 ? '1 tháng' : '1 năm'}',
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
        );
      }),
    );
  }
}
