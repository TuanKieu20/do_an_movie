import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/logger.dart';
import '../constants/router.dart';
import '../models/response_model.dart';
import '../views/helpers/helper.dart';
import '../views/widgets/custom_loading.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final keyRegister = GlobalKey<FormState>();

  final imagePicker = ImagePicker();
  final firebaseStorage = FirebaseStorage.instance.ref().child('images');

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference col =
      FirebaseFirestore.instance.collection('users');

  var isEighteenAge = (-1).obs;
  var selectTopic = [false, false, false, false, false].obs;
  // khoa học - kinh dị - tình yêu - hành động - hoạt hình
  void changeAge(int value) {
    isEighteenAge(value);
    update();
  }

  void changeTopic(bool value, int index) {
    selectTopic()[index] = value;
    update();
  }

  // final XFile? imageFile;
  String imageFile = '';
  // ignore: prefer_typing_uninitialized_variables
  var _timer;
  var time = 5.obs;
  var checkShowDialog = false.obs;

  void changeShowDialog(value) {
    checkShowDialog(value);
    update();
  }

  void startTimeText() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      time--;
      if (time() == 0) {
        _timer.cancel();
        time(5);
        changeShowDialog(false);
        Get.offAllNamed(Routes.bottomNavigator);
      }
      update();
    });
    update();
    // if (time() == 0) _timer.cancel();
  }

  void updateInforUser() async {
    try {
      showLoadingOverlay();
      final currentUser = FirebaseAuth.instance.currentUser;
      col.get().then((value) {
        for (var user in value.docs) {
          if ((user.data() as Map)['email']
              .toString()
              .toLowerCase()
              .contains(currentUser!.email!.toLowerCase())) {
            col.doc(user.id).update({
              'higherEighteen': isEighteenAge.toInt(),
              'topic': selectTopic
            });
          }
        }
      });
      hideLoadingOverlay();
    } catch (e) {
      hideLoadingOverlay();
      logger.e(e);
    }
  }

  Future<ResponseModel> createEmailAndPassword({required String email}) async {
    try {
      UserCredential? user;
      showLoadingOverlay();
      var nameUniqueImage = DateTime.now().millisecondsSinceEpoch.toString();
      if (imageFile != '') {
        var upload = await firebaseStorage
            .child(nameUniqueImage)
            .putFile(File(imageFile));
        var imageUrl = await upload.ref.getDownloadURL();
        logger.e('image:$imageUrl');
        if (imageUrl != '') {
          user = await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: 'abc123456');
          await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
          await FirebaseAuth.instance.currentUser!
              .updateDisplayName(Helper.hideString(Helper.formatEmail(email)));
          col.add({
            'email': email,
            'avatar': imageUrl,
            'name': Helper.hideString(Helper.formatEmail(email))
          });
        } else {
          col.add({
            'email': email,
            'avatar': '',
            'name': Helper.hideString(Helper.formatEmail(email))
          });
        }
      } else {
        user = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: 'abc123456');
        col.add({'email': email, 'avatar': ''});
      }
      hideLoadingOverlay();
      return ResponseModel(
          isSuccess: true,
          message: 'Đăng ký tài khoản thành công!!!',
          data: user);
    } on FirebaseAuthException catch (e) {
      hideLoadingOverlay();
      if (e.code == 'weak-password') {
        return ResponseModel(isSuccess: false, message: 'Mật khẩu quá yếu');
      } else if (e.code == 'email-already-in-use') {
        return ResponseModel(
            isSuccess: false, message: 'Tài khoản đã tồn tại!');
      } else if (e.code == 'invalid-email') {
        return ResponseModel(
            isSuccess: false, message: 'Vui lòng viết tên không có dấu cách!');
      } else {
        logger.e(e.code);
        return ResponseModel(isSuccess: false, message: 'Vui lòng thử lại !');
      }
    } catch (e) {
      logger.e(e);
      hideLoadingOverlay();
      return ResponseModel(isSuccess: false, message: 'Vui lòng thử lại !');
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
