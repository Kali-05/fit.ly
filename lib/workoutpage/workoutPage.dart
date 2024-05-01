import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_fitness/models/user.dart';
import 'package:workout_fitness/view/exercise/exercise_view_2.dart';

class MyWorkoutPage extends StatefulWidget {
  final Userr? user;
  const MyWorkoutPage({this.user});
  @override
  State<MyWorkoutPage> createState() => _MyWorkoutPageState();
}

class _MyWorkoutPageState extends State<MyWorkoutPage> {
  List<String> selectedWorkouts = [];

  void _addWorkouts(List<String> workouts) {
    setState(() {
      selectedWorkouts.addAll(workouts);
    });
    // Save selected workouts to Firestore
    _saveWorkoutsToFirestore(selectedWorkouts, widget.user?.uid);
  }

  Future<void> _saveWorkoutsToFirestore(
      List<String> workouts, String? userId) async {
    if (userId != null) {
      final CollectionReference workoutCollection =
          FirebaseFirestore.instance.collection('workouts');

      // Get the current count of workout documents for the user
      QuerySnapshot snapshot = await workoutCollection
          .doc(userId)
          .collection('workout_instances')
          .get();
      int slNo =
          snapshot.size + 1; // Increment by 1 to get the next serial number

      // Add workouts to a document with the serial number
      try {
        await workoutCollection
            .doc(userId)
            .collection('workout_instances')
            .doc('instance$slNo')
            .set({
          'workouts': workouts,
          // You can add more fields as needed
        });
        print(
            'Workouts saved to Firestore for user $userId with serial number $slNo');
      } catch (e) {
        print('Error saving workouts to Firestore: $e');
      }
    } else {
      print('User ID is null, unable to save workouts to Firestore.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Text(
            'Quick Start',
            style: TextStyle(
                fontFamily: 'RNSPhysis',
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment(0, 0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 117, 213),
              ),
              height: 60,
              width: double.infinity,
              child: Text(
                'Add Exercise +',
                style: TextStyle(
                    fontFamily: 'RNSPhysis',
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyRoutines(
                          onAddWorkouts: _addWorkouts,
                        )),
              );
            },
          ),
          SizedBox(height: 16),
          Text(
            'Selected Workouts:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedWorkouts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(selectedWorkouts[index]),
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
