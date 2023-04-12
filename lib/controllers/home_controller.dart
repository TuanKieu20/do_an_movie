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

  List<MovieModel> movies = [];
  List<MovieModel> top10Movies = [];
  List<MovieModel> moviesNew = [];
  final scrollController = ScrollController();
  final commentController = TextEditingController();
  final scrollComment = ScrollController();

  MovieModel? movieTrending;

  final user = FirebaseAuth.instance.currentUser;

  var isShowMore = false.obs;
  var index = 0.obs;

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

  Future<dynamic> getMovies() async {
    try {
      List<MovieModel> listTemp = [];
      QuerySnapshot snapshot = await ref.get();
      listTemp = snapshot.docs.map((movie) {
        return MovieModel.fromJson(movie.data() as Map<String, dynamic>,
            idDoc: movie.reference.id);
      }).toList();
      movies = listTemp;
      getMoviesTop10();
      getMoviesNew();
      for (var movie in movies) {
        if (movie.name == 'Avatar: The Way of Water') {
          movieTrending = movie;
        }
      }
      return listTemp;
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> addComment({required String comment, required idMovie}) async {
    try {
      logger.d(idMovie);
      await ref.doc(idMovie).update({
        'comments': FieldValue.arrayUnion([
          {
            'author': Helper.formatEmail(user!.email ?? 'Người dùng'),
            'avatar': user!.photoURL,
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

  void getMoviesTop10() {
    movies
        .sort(((a, b) => a.rating!.compareTo(num.parse(b.rating.toString()))));
    for (int i = movies.length - 1; i >= movies.length - 12; i--) {
      top10Movies.add(movies[i]);
    }
  }

  void getMoviesNew() {
    movies.sort(((a, b) => a.releaseYear!.compareTo(b.releaseYear.toString())));
    for (int i = movies.length - 1; i >= movies.length - 12; i--) {
      moviesNew.add(movies[i]);
    }
  }

  List<MovieModel> filterByCategory({required String category}) {
    final List<MovieModel> listTemp = [];
    for (var movie in movies) {
      if (movie.category == category) {
        listTemp.add(movie);
      }
    }
    // logger.e(listTemp);
    return listTemp;
  }
}
