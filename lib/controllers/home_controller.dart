import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/logger.dart';
import '../models/movie_model.dart';
import '../views/helpers/helper.dart';

class HomeController extends GetxController {
  CollectionReference ref = FirebaseFirestore.instance.collection('movies');
  CollectionReference col = FirebaseFirestore.instance.collection('users');

  List<MovieModel> movies = [];
  List<MovieModel> top10Movies = [];
  List<MovieModel> moviesNew = [];
  List<MovieModel> moviesForYou = [];
  List<MovieModel> moviesFavorite = [];
  final scrollController = ScrollController();
  final commentController = TextEditingController();
  final scrollComment = ScrollController();

  MovieModel? movieTrending;

  final user = FirebaseAuth.instance.currentUser;
  dynamic userInforMore = {};

  var isShowMore = false.obs;
  var index = 0.obs;

  var isUserVip = false.obs;

  @override
  void onInit() async {
    await getMovies();
    super.onInit();
  }

  void scrollTo(value) {
    scrollController.animateTo(value,
        duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
    update();
  }

  void changeIndex(value) {
    index(value);
    update();
  }

  void changeShowMore(bool isShow) {
    isShowMore(isShow);
    update();
  }

  Future<dynamic> getInforUser() async {
    try {
      var res = await col.get();
      var listTemp = res.docs.map((userTemp) {
        return userTemp.data();
      }).toList();
      for (var userTemp in listTemp) {
        if ((userTemp as Map)['email'].toString().toLowerCase().contains(
            FirebaseAuth.instance.currentUser!.email!.toLowerCase())) {
          userInforMore = userTemp;
          // update();
          if (userInforMore['isVip'] == null ||
              userInforMore['isVip'] == false) {
            isUserVip.value = false;
          } else {
            isUserVip(userInforMore['isVip']);
          }
          update();
          return userTemp;
        }
      }
    } catch (e) {
      logger.e('err is not err =)))');
    }
  }

  Future<dynamic> getMovies({bool callAgain = false}) async {
    try {
      List<MovieModel> listTemp = [];
      QuerySnapshot snapshot = await ref.get();
      listTemp = snapshot.docs.map((movie) {
        return MovieModel.fromJson(movie.data() as Map<String, dynamic>,
            idDoc: movie.reference.id);
      }).toList();
      movies = listTemp;
      getAllMovies();
      return listTemp;
    } catch (e) {
      logger.e(e);
    }
  }

  void getAllMovies() {
    getMoviesTop10();
    getMoviesNew();
    for (var movie in movies) {
      if (userInforMore['higherEighteen'] == 0) {
        if (movie.name == 'Zootopia - Phi Vụ Động Trời') {
          movieTrending = movie;
        }
      } else {
        if (movie.name == 'Avatar: The Way of Water') {
          movieTrending = movie;
        }
      }
    }
  }

  Future<void> addComment({required String comment, required idMovie}) async {
    try {
      await ref.doc(idMovie).update({
        'comments': FieldValue.arrayUnion([
          {
            'author': userInforMore['name'] ?? 'Người dùng',
            'avatar': userInforMore['avatar'],
            'data': comment,
            'likes': '${Random().nextInt(100) + 900}'
          }
        ])
      });
      update();
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> addMovieFavorite({required idMovie}) async {
    try {
      CollectionReference ref =
          FirebaseFirestore.instance.collection('moviesFavorite');
      var snapshot = await ref.get();
      var check = false;
      for (var movie in (snapshot.docs)) {
        if (idMovie == (movie.data() as Map)['idMovie'] &&
            (movie.data() as Map)['user'] ==
                FirebaseAuth.instance.currentUser!.email) {
          check = true;
          break;
        } else {
          check = false;
        }
      }
      if (!check) {
        ref.add({
          'user': FirebaseAuth.instance.currentUser!.email,
          'idMovie': idMovie
        });
        Helper.showDialogFuntionLoss(
            text: 'Thêm thành công vào danh sách yêu thích của bạn !!!');
      } else {
        Helper.showDialogFuntionLoss(
            text: 'Bạn đã thêm phim này vào danh sách yêu thích rồi !!!');
      }
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> getMoviesFavorite() async {
    try {
      CollectionReference ref =
          FirebaseFirestore.instance.collection('moviesFavorite');
      List<MovieModel> listTemp = [];
      var snapshot = await ref.get();

      snapshot.docs.map((movieData) {
        for (var movie in movies) {
          if (movie.id == movieData['idMovie'] &&
              movieData['user'] == FirebaseAuth.instance.currentUser!.email) {
            listTemp.add(movie);
          }
        }
      }).toList();
      moviesFavorite = listTemp;
      update();
    } catch (e) {
      logger.e(e);
    }
  }

  void removeMovieFavorit(String idMovie) async {
    CollectionReference ref =
        FirebaseFirestore.instance.collection('moviesFavorite');
    try {
      var snapshot = await ref.get();

      snapshot.docs.map((movieData) {
        if (movieData['idMovie'] == idMovie &&
            movieData['user'] == FirebaseAuth.instance.currentUser!.email) {
          ref.doc(movieData.reference.id).delete();
        }
      }).toList();
    } catch (e) {
      logger.e(e);
    }
  }

  void getMoviesTop10() {
    List<MovieModel> listTemp = [];
    try {
      movies.sort(
          ((a, b) => a.rating!.compareTo(num.parse(b.rating.toString()))));
      for (int i = 0; i < 10; i++) {
        listTemp.add(movies[i]);
      }
      top10Movies = listTemp;
      top10Movies.reversed;
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> getMoviesForYou() async {
    await getInforUser();
    try {
      List<MovieModel> listTemp = [];
      if (userInforMore['higherEighteen'] == 0) {
        movies = movies.where((movie) => movie.isKid!).toList();
        getAllMovies();
      } else {
        movies = await getMovies();
      }
      if (userInforMore['topic'][0]) {
        for (var movie in movies) {
          if (movie.category!.toLowerCase().contains('khoa học')) {
            listTemp.add(movie);
          }
        }
      }
      if ((userInforMore['topic'] as List)[1]) {
        for (var movie in filterByCategory(category: 'Kinh dị')) {
          listTemp.add(movie);
        }
      }
      if ((userInforMore['topic'] as List)[2]) {
        for (var movie in filterByCategory(category: 'Tình yêu')) {
          listTemp.add(movie);
        }
      }
      if ((userInforMore['topic'] as List)[3]) {
        for (var movie in filterByCategory(category: 'Hành động')) {
          listTemp.add(movie);
        }
      }
      if ((userInforMore['topic'] as List)[4]) {
        for (var movie in filterByCategory(category: 'Hoạt hình')) {
          listTemp.add(movie);
        }
      }
      moviesForYou = listTemp;
    } catch (e) {
      logger.e(e);
    }
    update();
  }

  void getMoviesNew() {
    List<MovieModel> listTemp = [];
    try {
      movies
          .sort(((a, b) => a.releaseYear!.compareTo(b.releaseYear.toString())));
      for (int i = 0; i < 10; i++) {
        listTemp.add(movies[i]);
      }
      moviesNew = listTemp;
    } catch (e) {
      logger.e(e);
    }
  }

  List<MovieModel> filterByCategory({required String category}) {
    final List<MovieModel> listTemp = [];
    for (var movie in movies) {
      if (movie.category!.contains(category)) {
        listTemp.add(movie);
      }
    }
    // logger.e(listTemp);
    return listTemp;
  }

  // Future<int> getVideoDuration(String videoUrl) async {
  // try {
  //   // Gửi yêu cầu HTTP để tải video từ liên kết
  //   final response = await http.get(Uri.parse(videoUrl));

  //   // Chuyển đổi nội dung của video từ dạng byte sang Uint8List
  //   final Uint8List videoBytes = Uint8List.fromList(response.bodyBytes);

  //   // Phân tích nội dung của video để lấy thông tin thời lượng
  //   final Uint8List atom =
  //       utf8.encode('moov.udta.meta.ilst.\xa9nam') as Uint8List;
  //   final int atomIndex = videoBytes.indexOf(atom[0]);

  //   if (atomIndex != -1) {
  //     // Tìm thấy thông tin thời lượng trong nội dung của video
  //     final int durationIndex = atomIndex + atom.length + 8;
  //     final int duration = ByteData.view(
  //       videoBytes.buffer,
  //       durationIndex,
  //       4,
  //     ).getUint32(0, Endian.big);

  //     // Chuyển đổi thời lượng từ giây sang phút
  //     final int durationInMinutes = (duration / 60000).ceil();

  //     return durationInMinutes;
  //   } else {
  //     print('Không tìm thấy thông tin thời lượng của video');
  //     return 0; // Trả về giá trị mặc định là 0 nếu không tìm thấy thông tin thời lượng
  //   }
  // } catch (e) {
  //   print('Lỗi khi lấy thời lượng của video: $e');
  //   return 0; // Trả về giá trị mặc định là 0 nếu có lỗi xảy ra
  // }
  // }
}
