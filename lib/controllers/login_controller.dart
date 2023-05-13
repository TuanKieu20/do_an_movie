import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/response_model.dart';
import '../views/widgets/custom_loading.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final keyLogin = GlobalKey<FormState>();

  final List<FocusNode> focusNodes = [FocusNode(), FocusNode()];

  var isEmailFocus = false.obs;
  var isPasswordFocus = false.obs;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference col =
      FirebaseFirestore.instance.collection('users');

  @override
  void onInit() {
    for (int index = 0; index < focusNodes.length; index++) {
      focusNodes[index].addListener(() {
        changeStatusFocus(index: index, isFoucus: focusNodes[index].hasFocus);
      });
    }
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailController.clear();
    super.onClose();
  }

  changeStatusFocus({required int index, required bool isFoucus}) {
    if (index == 0) {
      isEmailFocus(isFoucus);
    } else {
      isPasswordFocus(isFoucus);
    }
  }

  // Future<void> addUserToFirestore({required String email}) async {}

  Future<ResponseModel> signInWithEmailAndPassword(
      {required String email}) async {
    try {
      showLoadingOverlay();
      UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
          email: '$email@gmail.com', password: 'abc123456');
      final pref = Get.find<SharedPreferences>();
      if (pref.getBool('checkUpdateInf') == false) {
        pref.setBool('checkUpdateInf', true);
      }
      hideLoadingOverlay();
      return ResponseModel(
          isSuccess: true,
          message: 'Đăng ký tài khoản thành công!!!',
          data: user);
    } on FirebaseAuthException catch (e) {
      hideLoadingOverlay();
      if (e.code == 'wrong-password') {
        return ResponseModel(isSuccess: false, message: 'Vui lòng thử lại!');
      } else if (e.code == 'user-not-found') {
        return ResponseModel(
            isSuccess: false, message: 'Tài khoản không tồn tại!');
      } else {
        return ResponseModel(isSuccess: false, message: 'Vui lòng thử lại !');
      }
    } catch (e) {
      hideLoadingOverlay();
      return ResponseModel(isSuccess: false, message: 'Vui lòng thử lại !');
    }
  }

  bool checkUserLogin() {
    var user = firebaseAuth.currentUser;
    if (user != null) {
      return true;
    }
    return false;
  }
}
