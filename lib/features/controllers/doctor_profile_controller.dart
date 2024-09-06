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

  void getDays(String userId) async{
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("doctorList").doc(userId).get();
    if(data.exists)
      {
        log(data['mon'].toString());
        log(data['tue'].toString());
        log(data['wed'].toString());
        log(data['thurs'].toString());
        log(data['fri'].toString());
        log(data['sat'].toString());
        log(data['sun'].toString());
        mon.value  = data['mon'] ?? 0;
        tue.value  = data['tue'] ?? 0;
        wed.value  = data['wed'] ?? 0;
        thu.value  = data['thurs'] ?? 0;
        fri.value  = data['fri'] ?? 0;
        sat.value  = data['sat'] ?? 0;
        sun.value  = data['sun'] ?? 0;
      }
    if (mon != null && mon!.value != 0) {
      isMon.value = false;
    }
    if (tue != null && tue!.value != 0) {
      isTues.value = false;
    }
    if (wed != null && wed!.value != 0) {
      isWed.value = false;
    }
    if (thu != null && thu!.value != 0) {
      isThurs.value = false;
    }
    if (fri != null && fri!.value != 0) {
      isFri.value = false;
    }
    if (sat != null && sat!.value != 0) {
      isSat.value = false;
    }
    if (sun != null && sun!.value != 0) {
      isSun.value = false;
    }


  }


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