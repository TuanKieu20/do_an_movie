import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/logger.dart';
import '../views/helpers/helper.dart';
import '../views/widgets/custom_loading.dart';
import 'home_controller.dart';

class ProfileController extends GetxController {
  late TextEditingController nameTextController;
  late TextEditingController emailTextController;
  late TextEditingController numberTextController;
  late TextEditingController keyLoginController;

  final editKey = GlobalKey<FormState>();
  final currentUser = FirebaseAuth.instance.currentUser;
  final firebaseStorage = FirebaseStorage.instance.ref().child('images');
  final imagePicker = ImagePicker();
  String imageFile = '';

  var notiValue1 = false.obs;
  var notiValue2 = false.obs;
  var notiValue3 = false.obs;
  var notiValue4 = false.obs;
  var notiValue5 = false.obs;
  var notiValue6 = false.obs;

  var isDarkMode = true.obs;

  var homeController = Get.find<HomeController>();

  void changeDarkMode(bool value) {
    isDarkMode(value);
    update();
  }

  void changeNotiValue(index, value) {
    switch (index) {
      case 0:
        notiValue1(value);
        break;
      case 1:
        notiValue2(value);
        break;
      case 2:
        notiValue3(value);
        break;
      case 3:
        notiValue4(value);
        break;
      case 4:
        notiValue5(value);
        break;
      case 5:
        notiValue6(value);
        break;
      default:
    }
    update();
  }

  bool checkChangValue() {
    ///false if no the change else return true
    if (currentUser?.displayName == null
        ? nameTextController.text == homeController.userInforMore['name']
        : nameTextController.text == currentUser?.displayName &&
            emailTextController.text == currentUser!.email) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> updateInforUser() async {
    showLoadingOverlay();
    final ref = FirebaseFirestore.instance.collection('users');
    try {
      await currentUser!.updateDisplayName(nameTextController.text);
      var snap = await ref.where('email', isEqualTo: currentUser!.email).get();
      for (var temp in snap.docs) {
        await ref
            .doc(temp.id)
            .update({'phoneNumber': numberTextController.text});
      }

      if (imageFile != '') {
        var nameUniqueImage = DateTime.now().millisecondsSinceEpoch.toString();
        var upload = await firebaseStorage
            .child(nameUniqueImage)
            .putFile(File(imageFile));
        var imageUrl = await upload.ref.getDownloadURL();
        logger.e('image:$imageUrl');

        ref.get().then((value) {
          return value.docs.map((user) async {
            if (user.data()['email'].toString().toLowerCase() ==
                currentUser!.email!.toLowerCase()) {
              if (imageUrl != '') {
                await currentUser!.updatePhotoURL(imageUrl);
                ref.doc(user.id).update({
                  'avatar': imageUrl,
                });
              }
            }
          }).toList();
        });
      }
      await homeController.getInforUser();

      hideLoadingOverlay();
    } catch (e) {
      hideLoadingOverlay();
      logger.e(e);
    }
  }

  Future<void> getImage(context, {bool isCamera = false}) async {
    final permisstion = await (isCamera
            ? Permission.camera
            : Platform.isIOS
                ? Permission.photos
                : Permission.mediaLibrary)
        .request();

    if (permisstion.isGranted || permisstion.isLimited) {
      var image = await imagePicker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery);
      if (image == null) {
        return;
      } else {
        imageFile = image.path;
        update();
      }
    } else {
      Helper.showMissingPermission(context,
          'Để tiếp tục sử dụng tính năng vui lòng bật quyền truy cập ${isCamera ? 'camera' : 'thư viện ảnh'}');
    }
  }
}
