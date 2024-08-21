import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:psychiatrist_project/model.dart/doctor_model.dart';

class DoctorController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var doctorList = <DoctorModel>[].obs;
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchDoctorList();
  }

void fetchDoctorList() async {
  try {
    isLoading.value = true;
    QuerySnapshot querySnapshot = await _firestore.collection('doctorList').get();
    
    if (querySnapshot.docs.isEmpty) {
      print("No documents found in doctorList.");
    } else {
      print("Documents fetched: ${querySnapshot.docs.length}");
      for (var doc in querySnapshot.docs) {
        print("Document data: ${doc.data()}");
      }
    }
    
    doctorList.value = querySnapshot.docs
        .map((doc) =>
            DoctorModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    
    if (doctorList.isEmpty) {
      print("Doctor list is empty after mapping.");
    } else {
      print("Doctor list fetched successfully.");
    }
  } catch (e) {
    print("Error fetching doctorList: $e");
  } finally {
    isLoading.value = false;
  }
}

}
