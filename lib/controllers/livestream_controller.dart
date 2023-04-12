import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/logger.dart';
import '../views/helpers/helper.dart';

class LivestreamControlelr extends GetxController {
  final db = FirebaseDatabase.instance.ref('movies');
  // final tabController = TabController(length: 3, vsync: this);
  final firebaseAuth = FirebaseAuth.instance;
  late ScrollController scrollController;
  final commentController = TextEditingController();
  var viewers = 0.obs;
  var idViewer = ''.obs;
  var isCommentEmpty = true.obs;

  var indexTab = 0.obs;
  var startTime = DateTime.now().obs;
  final FocusNode node = FocusNode();

  var isEndLive = false.obs;

  var isFocusNode = false.obs;

  @override
  void onInit() {
    node.addListener(() {
      changStatusFocus(node.hasFocus);
      update();
    });
    super.onInit();
  }

  void changeCommentEmpty(bool value) => isCommentEmpty(value);

  void changStatusFocus(bool value) => isFocusNode(value);

  void changeEndLive(bool value) => isEndLive(value);

  void changeStartTime(DateTime value) => startTime(value);

  void changeIndexTab(value) => indexTab(value);

  int getStartTime() {
    return Helper.calculateTimeDifferenceInSeconds(startTime(), DateTime.now());
  }

  void userJoinRoom({required String idMovie}) async {
    var ref = FirebaseDatabase.instance.ref('movies/$idMovie/users');
    final check = await rootFirebaseIsExists(ref);
    if (!check) {
      ref = FirebaseDatabase.instance.ref('movies/$idMovie').child('users');
    }
    final userName =
        Helper.formatEmail(firebaseAuth.currentUser!.email ?? 'Người dùng');
    try {
      var snapsshot = await ref.once().then((value) async {
        if (value.snapshot.value == null) {
          final newKey = ref.push().key;
          idViewer(newKey);
          await ref.child(newKey ?? 'users').set(userName);
        } else {
          return value.snapshot.value as Map;
        }
      });
      var list = snapsshot!.values.toList();
      if (!list.contains(userName)) {
        final newKey = ref.push().key;
        idViewer(newKey);
        await ref.child(newKey ?? 'users').set(userName);
      }
    } catch (e) {
      logger.e(e);
    }
  }

  void addComment({required String comment, required String idMovie}) async {
    var ref = FirebaseDatabase.instance.ref('movies/$idMovie/comments');
    final check = await rootFirebaseIsExists(ref);
    if (!check) {
      ref = FirebaseDatabase.instance.ref('movies/$idMovie').child('comments');
    }
    final userName =
        Helper.formatEmail(firebaseAuth.currentUser!.email ?? 'Người dùng');
    final avatar = FirebaseAuth.instance.currentUser!.photoURL;
    try {
      await ref.once().then((value) async {
        final newKey = ref.push().key;
        await ref.child(newKey ?? 'keyNull').set({
          'avatar': avatar.toString(),
          'data': comment,
          'id': userName,
          'time': DateTime.now().toString()
        });
        commentController.clear();
        logger.d('OK');
      });
    } catch (e) {
      logger.e(e);
    }
  }

  void deleteComments({required String idMovie}) {
    try {
      FirebaseDatabase.instance.ref('movies/$idMovie/comments').remove();
    } catch (e) {
      logger.e(e);
    }
  }

  void updateStartTime({required String idMovie}) async {
    final ref = FirebaseDatabase.instance.ref('movies/$idMovie');
    try {
      await ref.update({'startTime': DateTime.now().toString()});
    } catch (e) {
      logger.e(e);
    }
  }

  void getViewer({required String idMovie}) async {
    var ref = FirebaseDatabase.instance.ref('movies/$idMovie/users');
    final check = await rootFirebaseIsExists(ref);
    if (!check) {
      ref = FirebaseDatabase.instance.ref('movies/$idMovie').child('users');
      viewers(0);
    } else {
      var snapsshot = await ref.once().then((value) {
        return value.snapshot.value as Map;
      });
      var list = snapsshot.values.toList();
      viewers(list.length);
    }

    update();
  }

  void removeViewer({required String idMovie}) async {
    final ref = FirebaseDatabase.instance.ref('movies/$idMovie/users');
    try {
      if (idViewer() == '') {
      } else {
        await ref.child(idViewer.toString()).remove();
      }
    } catch (e) {
      logger.e(e);
    }
  }

  Future<bool> rootFirebaseIsExists(DatabaseReference databaseReference) async {
    var snapshot = await databaseReference.once();

    return snapshot.snapshot.value != null;
  }

  void scrollTo(value) {
    scrollController.animateTo(value,
        duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
    // update();
  }

  Stream<DatabaseEvent> getData() {
    final ref = db.onValue;
    try {} catch (e) {}
    return ref;
  }
}
