import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String uid;
  DataBaseService({required this.uid});

  //collection reference
  final CollectionReference fitlyCollection =
      FirebaseFirestore.instance.collection('fitlys');
  String gender = '';

  Future updateUserData(
      DateTime date, String Height, String weight, bool Gender) async {
    if (Gender == true) {
      gender = 'Male';
    } else {
      gender = 'female';
    }
    return await fitlyCollection.doc(uid).set({
      'date': date,
      'Height': Height,
      'weight': weight,
      'Gender': gender,
    });
  }

  // Future updateWorkoutData()async{
  //   return await fitlyCollection
  // }
}
