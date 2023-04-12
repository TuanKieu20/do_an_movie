import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/router.dart';
import '../../../constants/styles.dart';
import '../../../controllers/livestream_controller.dart';
import '../../../controllers/video_controller.dart';
import '../../../models/movie_model.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({super.key});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  final controller = Get.put(LivestreamControlelr());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 12.0,
          backgroundColor: Colors.black,
          centerTitle: false,
          leading: Image.asset(
            'assets/images/logo.png',
            width: 30,
            height: 30,
          ),
          title: Text(
            'Phim Đang Phát',
            style: mikado500.copyWith(fontSize: 24),
          ),
        ),
        body: GetBuilder<LivestreamControlelr>(builder: (builder) {
          return StreamBuilder(
              stream: FirebaseDatabase.instance.ref('movies').onValue,
              // stream: FirebaseDatabase.instance
              //     .ref('movies/gzLPKhtBlsLW7y42rgx9/comments')
              //     .onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<dynamic, dynamic> map =
                      snapshot.data!.snapshot.value as Map;
                  List<dynamic> list = [];
                  list = map.values.toList();
                  // var test = FirebaseDatabase.instance
                  //     .ref('movies/gzLPKhtBlsLW7y42rgx9/comments')
                  //     .onValue;
                  // logger.e(snapshot.data!.snapshot.child('hanhnhan').key);
                  return ListView.builder(
                      itemCount: snapshot.data!.snapshot.children.length,
                      itemBuilder: ((context, index) {
                        final movie = list[index];
                        return InkWell(
                          onTap: () {
                            controller.changeStartTime(
                                DateTime.parse(list[index]['startTime']));
                            controller.userJoinRoom(
                                idMovie: map.keys.toList()[index]);
                            controller.getViewer(
                                idMovie: map.keys.toList()[index]);
                            Get.put(VideoController())
                                .changeIsFullScreen(false);
                            Get.toNamed(Routes.customVideo, arguments: {
                              'movie': MovieModel(
                                  rating: double.parse(movie['rating']),
                                  comments: [],
                                  category: movie['category'],
                                  description: movie['description'],
                                  isSub: true,
                                  isFullHD: true,
                                  author: movie['author'],
                                  releaseYear: movie['releaseYear'].toString(),
                                  trailer: '',
                                  linkUrl: movie['linkUrl'],
                                  poster: movie['poster'],
                                  name: movie['name'],
                                  id: map.keys.toList()[index],
                                  time: ''),
                              'isTrailer': false,
                              'isLive': true,
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            height: 180,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: list[index]['poster'] == ''
                                            ? const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/image_error.jpeg'),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: NetworkImage(
                                                    list[index]['poster']),
                                                fit: BoxFit.cover,
                                                alignment:
                                                    Alignment.bottomCenter)),
                                    child: Align(
                                      alignment: const Alignment(-1, -1),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(20),
                                                topLeft: Radius.circular(10))),
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 15, 8),
                                        child: Text(
                                          'Trực tiếp',
                                          style:
                                              mikado500.copyWith(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[index]['name'] ?? 'Name Movie',
                                          style:
                                              mikado600.copyWith(fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.person_pin_rounded,
                                              color: Colors.white,
                                              size: 26,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              list[index]['author'],
                                              style: mikado400.copyWith(
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.remove_red_eye_rounded,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              (list[index]['users'] == null)
                                                  ? '0'
                                                  : (list[index]['users']
                                                          as Map)
                                                      .values
                                                      .toList()
                                                      .length
                                                      .toString(),
                                              style: mikado400.copyWith(
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        );
                      }));
                }
                return const SizedBox();
              });
        }));
  }
}
