import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

import '../constants/logger.dart';
import '../models/movie_model.dart';
import '../models/user_model.dart';
import '../views/helpers/helper.dart';
import '../views/widgets/custom_loading.dart';

class AdminController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final keyForm = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final authorController = TextEditingController();
  final desController = TextEditingController();
  final typeController = TextEditingController();
  final isKid = false.obs;
  final isSub = false.obs;

  var listUser = [];
  List<MovieModel> movies = [];
  var reciepts = [];

  CollectionReference col = FirebaseFirestore.instance.collection('users');
  CollectionReference ref = FirebaseFirestore.instance.collection('movies');
  CollectionReference refReciept =
      FirebaseFirestore.instance.collection('reciept');
  final firebaseStorage = FirebaseStorage.instance.ref().child('images');
  final firebaseStorageVideo = FirebaseStorage.instance.ref().child('video');

  var indexPage = (-1).obs;
  File? fileVideo;
  File? fileThumnail;
  String poster = '';
  String urlVideo = '';

  List cardList = [
    {'icon': Icons.paypal_rounded, 'text': 'Paypal', 'value': 0},
    {'icon': Icons.g_mobiledata, 'text': 'Google Pay', 'value': 1},
    {'icon': Icons.apple_rounded, 'text': 'Apple Pay', 'value': 2},
  ];

  final List<SortPopupMenuItem> sortOptions = [
    SortPopupMenuItem(title: 'Theo gói 1 tháng', sortBy: 'package1'),
    SortPopupMenuItem(title: 'Theo gói 1 năm', sortBy: 'package2'),
    SortPopupMenuItem(title: 'Theo ngày gần hết hạn', sortBy: 'dayRemail'),
    SortPopupMenuItem(title: 'Đã hết hạn', sortBy: 'expired'),
    SortPopupMenuItem(title: 'Tất cả', sortBy: 'all'),
  ];
  late String sortOption;
  var listRecieptTemp = [];

  @override
  void onInit() {
    // sortOption = sortOptions[5].sortBy;
    getAllUser();
    getMovies();
    getAllReciept();
    super.onInit();
  }

  void changeSortOption(String value) {
    sortOption = value;
    update();
  }

  void changeIsKid(bool value) {
    isKid(value);
    update();
  }

  void changeIsSub(bool value) {
    isSub(value);
    update();
  }

  void changeIndexPage(int value) {
    indexPage(value);
    update();
  }

  void getAllUser() async {
    try {
      showLoadingOverlay();
      var res = await col.get();
      var listTemp = res.docs.map((userTemp) {
        return UserModel.fromJson(userTemp.data() as Map<String, dynamic>,
            idDoc: userTemp.reference.id);
      }).toList();
      listUser = listTemp;

      update();
      hideLoadingOverlay();
    } catch (e) {
      hideLoadingOverlay();
      logger.e(e);
    }
  }

  void deleteUser(UserModel user) async {
    try {
      // await FirebaseAuth.instance.currentUser!.delete();
      bool isAdmin = user.isAdmin == null ? false : user.isAdmin!;
      if (isAdmin) {
        Helper.showDialogFuntionLoss(
            text: 'Đây là tài khoản admin không thể xoá !');
      } else {
        await col.doc(user.id).delete();
        getAllUser();
        update();
      }
    } catch (e) {
      logger.e(e);
    }
  }

  void setUserIsAdmin(UserModel user) {
    try {
      col.doc(user.id).update({'isAdmin': true});
      getAllUser();
      Helper.showDialogFuntionLoss(
          text: 'Đặt quyền Admin thành công cho ${user.email}');
    } catch (e) {
      logger.e(e);
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
      update();
      return listTemp;
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> removeMovie(String id) async {
    try {
      showLoadingOverlay();
      ref.doc(id).delete();
      getMovies();
      Helper.showDialogFuntionLoss(text: 'Phim đã được xoá thành công !');
      update();
      hideLoadingOverlay();
    } catch (e) {
      hideLoadingOverlay();
      logger.e(e);
    }
  }

  Future<void> pickVideo() async {
    final picker = ImagePicker();
    try {
      showLoadingOverlay();
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile == null) {
        hideLoadingOverlay();
        return;
      }
      final file = File(pickedFile.path);
      fileVideo = file;
      generateThumbnail(file);
      generateVideo(file);
      var nameUniqueImage = DateTime.now().millisecondsSinceEpoch.toString();
      var upload = await firebaseStorage
          .child(nameUniqueImage)
          .putFile(File(fileThumnail!.path));
      var imageUrl = await upload.ref.getDownloadURL();
      poster = imageUrl;
      var uploadVideo = await firebaseStorageVideo
          .child(nameUniqueImage)
          .putFile(File(fileVideo!.path));
      var videoUrl = await uploadVideo.ref.getDownloadURL();
      urlVideo = videoUrl;
      update();
      logger.d(poster);
      logger.d(urlVideo);
      hideLoadingOverlay();
    } catch (e) {
      hideLoadingOverlay();
      logger.e(e);
    }
  }

  void generateThumbnail(File file) async {
    final thumbnailfile =
        await VideoCompress.getFileThumbnail(file.path, quality: 50);
    fileThumnail = thumbnailfile;
    update();
  }

  void generateVideo(File file) async {
    final info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    fileVideo = info!.file;
    update();
  }

  void addMovie() async {
    final CollectionReference col =
        FirebaseFirestore.instance.collection('movies');
    var data = {
      'author': authorController.text,
      'category': typeController.text,
      "comments": [
        {
          'author': 'TuanKieu',
          'avatar':
              'https://firebasestorage.googleapis.com/v0/b/do-an-movie.appspot.com/o/images%2F1682498031241?alt=media&token=228cdfe5-9e89-4fb5-b6a6-e7a61f720d61',
          'likes': '920',
          'data': 'Phim hay lắm !'
        }
      ],
      'description': desController.text,
      'isFullHD': true,
      'isKid': isKid.value,
      'isSub': isSub.value,
      'linkUrl': urlVideo,
      'name': nameController.text,
      'poster': poster,
      'rating':
          double.parse((Random().nextDouble() * 7.0 + 2.0).toStringAsFixed(2)),
      'releaseYear': 2021,
      'time': (Random().nextInt(100) + 50).toString(),
      'trailer':
          'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
    };
    try {
      showLoadingOverlay();
      col.add(data);
      hideLoadingOverlay();

      Get.back();
      clearAll();

      Helper.showDialogFuntionLoss(text: 'Thêm thành công');
    } catch (e) {
      logger.e(e);
    }
  }

  void clearAll() {
    nameController.clear();
    // nameController.dispose();
    authorController.clear();
    // authorController.dispose();
    desController.clear();
    // desController.dispose();
    isKid(false);
    isSub(false);
    if (fileVideo != null) {
      fileVideo!.delete();
    }
    if (fileThumnail != null) {
      fileThumnail!.delete();
    }

    poster = '';
    urlVideo = '';
  }

  void getAllReciept() async {
    var listTemp = [];
    try {
      var res = await refReciept.get();
      res.docs.map((reciept) {
        listTemp.add(reciept.data());
      }).toList();
      reciepts = listTemp;
      update();
    } catch (e) {
      logger.e(e);
    }
  }

  String? getTimeExpried(String email) {
    try {
      for (var reciept in reciepts) {
        if (reciept['user'] == email) {
          return Helper.convertDateExpried(
              reciept['time'], int.parse(reciept['timeType']));
        }
      }
      return null;
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  bool checkUserVipCancel(String email) {
    return Helper.dateTimeToFormattedString(DateTime.now().toString()) ==
        getTimeExpried(email);
  }

  void updateUserVip(String idUser) async {
    try {
      await col.doc(idUser).update({'isVip': false});
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> updateMovie(String idMovie) async {
    try {
      ref.doc(idMovie).update({
        'author': authorController.text,
        'name': nameController.text,
        'description': desController.text,
        'isKid': isKid.value,
        'isSub': isSub.value,
        'category': typeController.text
      });
      await getMovies();
    } catch (e) {
      logger.e(e);
    }
  }
}

class SortPopupMenuItem {
  final String title;
  final String sortBy;
  SortPopupMenuItem({required this.title, required this.sortBy});
}
