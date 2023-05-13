import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/payment_controller.dart';

class SubPremiumScreen extends StatelessWidget {
  const SubPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentController());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 32,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Đăng kí trả phí',
                style: mikado500.copyWith(color: Colors.red, fontSize: 28),
              ),
              const SizedBox(height: 10),
              Text(
                'Thưởng thức xem phim Full-HD, không có \nquảng cáo và hạn chế',
                textAlign: TextAlign.center,
                style: mikado400.copyWith(color: Colors.white, fontSize: 16),
              ),
              _buildItem(
                  price: '\$9.99',
                  onTap: () {
                    controller.changeCurrentMonth(1);
                    controller.changeCurrentPrice(9.99);
                    Get.toNamed(Routes.optionPayment);
                  },
                  month: ' /tháng'),
              _buildItem(
                  price: '\$99.99',
                  onTap: () {
                    controller.changeCurrentMonth(2);
                    controller.changeCurrentPrice(99.99);
                    Get.toNamed(Routes.optionPayment);
                  },
                  month: ' /năm')
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
      {required String price, required Function onTap, required String month}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        margin: const EdgeInsets.only(top: 20),
        height: 250,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color(0xff20232a),
            border: Border.all(
              width: 3,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: [
            Transform.scale(
              scale: 1.3,
              child: const Icon(
                Icons.workspace_premium_outlined,
                color: Colors.red,
                size: 48,
                // size: 32,
              ),
            ),
            const SizedBox(height: 20),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: price,
                style: mikado600.copyWith(color: Colors.white, fontSize: 26),
              ),
              TextSpan(
                text: month,
                style: mikado400.copyWith(color: Colors.white, fontSize: 14),
              ),
            ])),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.done,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Xem phim không chứa quảng cáo',
                          style: mikado400.copyWith(),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.done,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Xem trực tuyến 4k',
                          style: mikado400.copyWith(),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.done,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Chất lượng video tốt nhất',
                          style: mikado400.copyWith(),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


///TODO: add data
///// final CollectionReference col =
                    //     FirebaseFirestore.instance.collection('movies');
                    // var data = {
                    //   'author': 'Elaine Bogan, Ennio Torresan',
                    //   'category': 'Tình cảm',
                    //   "comments": [
                    //     {
                    //       'author': 'TuanKieu',
                    //       'avatar':
                    //           'https://firebasestorage.googleapis.com/v0/b/do-an-movie.appspot.com/o/images%2F1681275510175?alt=media&token=ab6cadee-f3f1-4fc7-8526-71aaf0cfb3d9',
                    //       'likes': '920',
                    //       'data': 'Phim hay lắm !'
                    //     }
                    //   ],
                    //   'description':
                    //       'Kể về Lucky Prescott, một cô bé tinh nghịch trở về Miradero, nơi cha cô đã từng làm việc, và cô đã kết bạn với một con ngựa hoang và cùng nhau đối mặt với nguy hiểm để bảo vệ mối quan hệ đặc biệt của họ.',
                    //   'isFullHD': true,
                    //   'isKid': true,
                    //   'isSub': true,
                    //   'linkUrl': '',
                    //   'name': 'Spirit Untamed',
                    //   'poster':
                    //       'https://m.media-amazon.com/images/M/MV5BOTYwYjM2M2UtNmFmNC00YjY1LThjMDQtNjg3NWUyMDAzZjk3XkEyXkFqcGdeQXVyNDI3NjU1NzQ@._V1_FMjpg_UX400_.jpg',
                    //   'rating': 2.6,
                    //   'releaseYear': 2021,
                    //   'time': '88',
                    //   'trailer':
                    //       'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
                    // };
                    // col.add(data);