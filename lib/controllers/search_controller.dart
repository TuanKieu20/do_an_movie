import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/movie_model.dart';
import 'home_controller.dart';

class SearchController extends GetxController {
  final searchController = TextEditingController();

  var state = SearchState.init.obs;

  List<MovieModel> moviesSearch = [];

  List<MovieModel> moviesFiltered = [];

  List<MovieModel> initMovie = [];

  final homeController = Get.find<HomeController>();

  var haveFilter = false.obs;

  var listOptionFilter = [-1, -1, -1].obs;

  var valueType1 = (-1).obs;
  var valueType2 = (-1).obs;
  var valueType3 = (-1).obs;

  @override
  void onInit() {
    initMovie = homeController.movies;
    super.onInit();
  }

  void search(String value, List<MovieModel> list) {
    List<MovieModel> listTemp = [];
    if (value.isNotEmpty) {
      for (MovieModel movie in list) {
        if (movie.name!.toLowerCase().contains(value.toLowerCase())) {
          listTemp.add(movie);
        }
      }
      if (listTemp.isEmpty) {
        state(SearchState.empty);
      } else {
        moviesSearch = listTemp;
        state(SearchState.success);
      }
      // if (value == '') {
      //   state(SearchState.init);
      // }
    } else {
      state(SearchState.init);
      // moviesSearch
    }
    update();
  }

  void cleaOptionFilter() {
    listOptionFilter([-1, -1, -1]);
    valueType1(-1);
    valueType2(-1);
    valueType3(-1);
    update();
  }

  bool checkHaveFilter() {
    bool check = listOptionFilter.every((element) => element == -1);
    if (check) {
      update();
      return false;
    }
    update();
    return true;
  }

  void filterMovie() {
    List<MovieModel> listTemp1 = [];
    List<MovieModel> listTemp2 = [];
    List<MovieModel> listTemp3 = [];
    if (!checkHaveFilter()) {
      moviesFiltered = homeController.movies;
    } else {
      if (listOptionFilter()[0] != (-1)) {
        listTemp1 = filterByType1(initMovie);
        if (listOptionFilter()[1] != (-1)) {
          listTemp1 = filterByType2(listTemp1);
          if (listOptionFilter()[2] != (-1)) {
            listTemp1 = filterByType3(listTemp1);
          }
        } else {
          if (listOptionFilter()[2] != (-1)) {
            listTemp1 = filterByType3(listTemp1);
          }
        }
        moviesFiltered = listTemp1;
        update();
      } else {
        if (listOptionFilter()[1] != (-1)) {
          listTemp2 = filterByType2(initMovie);
          if (listOptionFilter()[2] != (-1)) {
            listTemp2 = filterByType3(listTemp2);
          }
          moviesFiltered = listTemp2;
          update();
        } else {
          // listTemp3(fil)
          //filter type 3
          listTemp3 = filterByType3(initMovie);
          moviesFiltered = listTemp3;
          update();
        }
      }
    }
  }

  void changeValueByType({required int type, required int value}) {
    if (type == 0) {
      valueType1(value);
      listOptionFilter()[0] = value;
    } else if (type == 1) {
      // if (value != (-1)) {
      valueType2(value);
      listOptionFilter()[1] = value;
      // }else{

      // }
    } else {
      // if (value != (-1)) {
      valueType3(value);
      listOptionFilter()[2] = value;
      // }
    }
    update();
  }

  List<MovieModel> filterByType1(List<MovieModel> movies) {
    List<MovieModel> listTemp = [];
    for (var movie in movies) {
      if (valueType1() == 0) {
        if (movie.category!.contains('Khoa học viễn tưởng')) {
          listTemp.add(movie);
        }
      } else if (valueType1() == 1) {
        if (movie.category!.contains('Kinh dị')) {
          listTemp.add(movie);
        }
      } else if (valueType1() == 2) {
        if (movie.category!.contains('Hành động')) {
          listTemp.add(movie);
        }
      } else if (valueType1() == 3) {
        if (movie.category!.contains('Hoạt hình')) {
          listTemp.add(movie);
        }
      } else if (valueType1() == 4) {
        if (movie.category!.contains('Tình cảm')) {
          listTemp.add(movie);
        }
      } else {
        if (movie.category!.contains('Khoa học')) {
          listTemp.add(movie);
        }
      }
    }
    return listTemp;
  }

  List<MovieModel> filterByType2(List<MovieModel> movies) {
    List<MovieModel> listTemp = [];
    for (var movie in movies) {
      if (valueType2() == 0) {
        if (movie.rating!.toDouble() < 2.0 && movie.rating! > 0) {
          listTemp.add(movie);
        }
      } else if (valueType2() == 1) {
        if (movie.rating!.toDouble() >= 2.0 && movie.rating! < 4.0) {
          listTemp.add(movie);
        }
      } else {
        if (movie.rating! >= 4.0 && movie.rating! < 5.0) {
          listTemp.add(movie);
        }
      }
    }
    return listTemp;
  }

  List<MovieModel> filterByType3(List<MovieModel> movies) {
    List<MovieModel> listTemp = [];
    listTemp = movies;
    if (valueType3() == 0) {
      listTemp.sort(
          ((b, a) => a.rating!.toDouble().compareTo(b.rating!.toDouble())));
    } else {
      listTemp.sort(((b, a) => a.releaseYear!.compareTo(b.releaseYear!)));
    }
    return listTemp;
  }

  bool checkLengthListEven(list) {
    if (list.length % 2 == 0) {
      return true;
    } else {
      return false;
    }
  }
}

enum SearchState { init, empty, success }
