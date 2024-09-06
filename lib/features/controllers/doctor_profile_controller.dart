import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DocProfileController extends GetxController{
  RxBool isMon = true.obs;
  RxBool isTues = true.obs;
  RxBool isWed = true.obs;
  RxBool isThurs = true.obs;
  RxBool isFri = true.obs;
  RxBool isSat = true.obs;
  RxBool isSun = true.obs;

  RxInt mon = 0.obs;
  RxInt tue = 0.obs;
  RxInt wed = 0.obs;
  RxInt thu = 0.obs;
  RxInt fri = 0.obs;
  RxInt sat = 0.obs;
  RxInt sun = 0.obs;

  updateDay({required String docId, required String day,required int value,}) async{
   await FirebaseFirestore.instance.collection("doctorList").doc(docId).update(
       {
         day : value
       }).whenComplete(() {
         log("Removed $day");
       },).onError((error, stackTrace) {
         log(error.toString());
       },);
  }
}