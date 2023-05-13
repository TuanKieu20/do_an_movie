import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/logger.dart';

class PaymentController extends GetxController {
  var optionMethod = 0.obs;
  var currentPrice = 0.0.obs;
  var currenMonth = 0.obs;
  CollectionReference ref = FirebaseFirestore.instance.collection('reciept');
  List cardList = [
    {'icon': Icons.paypal_rounded, 'text': 'Paypal', 'value': 0},
    {'icon': Icons.g_mobiledata, 'text': 'Google Pay', 'value': 1},
    {'icon': Icons.apple_rounded, 'text': 'Apple Pay', 'value': 2},
  ];
  final keyLogin = TextEditingController();

  void changeOptionMethod(int value) {
    optionMethod(value);
    update();
  }

  void changeCurrentPrice(double value) {
    currentPrice(value);
    update();
  }

  void changeCurrentMonth(int value) {
    currenMonth(value);
    update();
  }

  void addPayment() async {
    var col = FirebaseFirestore.instance.collection('users');
    try {
      ref.add({
        'user': FirebaseAuth.instance.currentUser!.email,
        'time': DateTime.now().toString(),
        'type': optionMethod.toString(),
        'price': currentPrice.toString(),
        'timeType': currenMonth.toString()
      });
      col.get().then((value) {
        for (var user in value.docs) {
          if ((user.data())['email'].toString().toLowerCase().contains(
              FirebaseAuth.instance.currentUser!.email!.toLowerCase())) {
            col.doc(user.id).update({
              'isVip': true,
            });
          }
        }
      });
    } catch (e) {
      logger.e(e);
    }
  }

  void updateKeyLogin() async {
    var col = FirebaseFirestore.instance.collection('users');
    try {
      col.get().then((value) {
        for (var user in value.docs) {
          if ((user.data())['email'].toString().toLowerCase().contains(
              FirebaseAuth.instance.currentUser!.email!.toLowerCase())) {
            col.doc(user.id).update({
              'keyLogin': keyLogin.text,
            });
          }
        }
      });
    } catch (e) {
      logger.e(e);
    }
  }
}
