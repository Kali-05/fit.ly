import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DataBaseService {
  final String uid;
  DataBaseService({required this.uid});

  // Collection reference
  final CollectionReference fitlyCollection =
      FirebaseFirestore.instance.collection('fitlys');

  Future updateUserData(
      DateTime date, String height, String weight, bool gender) async {
    String genderString = gender ? 'Male' : 'Female';
    return await fitlyCollection.doc(uid).set({
      'date': date,
      'Height': height,
      'Weight': weight,
      'Gender': genderString,
    });
  }

  Future<void> addNoteData(DateTime date, String note) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return await fitlyCollection
        .doc(uid)
        .collection('notes')
        .doc(formattedDate)
        .set({
      'notes': FieldValue.arrayUnion([
        {'note': note, 'timestamp': DateTime.now().toString()}
      ])
    }, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>> getWorkouts(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await fitlyCollection
        .doc(uid)
        .collection('workouts')
        .doc(formattedDate)
        .get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      return data != null
          ? List<Map<String, dynamic>>.from(data['workouts'])
          : [];
    } else {
      return [];
    }
  }
}
