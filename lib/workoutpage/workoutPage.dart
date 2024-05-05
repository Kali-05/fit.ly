import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:workout_fitness/view/exercise/exercise_view_2.dart';

class MyWorkoutPage extends StatefulWidget {
  // Pass selected workouts from previous screen
  final String userId;
  const MyWorkoutPage({required this.userId});
  @override
  State<MyWorkoutPage> createState() => _MyWorkoutPageState();
}

class _MyWorkoutPageState extends State<MyWorkoutPage> {
  List<String> selectedWorkouts = [];
  late Timer _timer;
  int _start = 0;

  // Function to get current date and time
  DateTime getCurrentDateTime() {
    return DateTime.now();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        _start++;
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  void resetTimer() {
    setState(() {
      _start = 0;
    });
  }

  void _addWorkouts(List<String> workouts) {
    setState(() {
      selectedWorkouts.addAll(workouts);
    });
    // Save selected workouts to Firestore
    //
    // _saveWorkoutsToFirestore(selectedWorkouts, widget.user?.uid);
  }

  // Function to save workouts to Firestore
  Future<void> saveWorkoutsToFirestore(List<String> workouts) async {
    try {
      // Get current date and time
      DateTime now = getCurrentDateTime();

      // Format date and time for use in Firestore
      String formattedDate = "${now.year}-${now.month}-${now.day}";
      String formattedTime = "${now.hour}:${now.minute}:${now.second}";

      // Reference to the workouts collection for the user
      CollectionReference userWorkoutsCollection = FirebaseFirestore.instance
          .collection('fitlys/${widget.userId}/workouts');

      // Add workouts to Firestore under a document named with current date and time
      await userWorkoutsCollection
          .doc(formattedDate + "_" + formattedTime)
          .set({
        'workouts': workouts,
        // You can add more fields as needed, such as duration, etc.
      });
      print('Workouts saved to Firestore for user ${widget.userId}');
    } catch (e) {
      print('Error saving workouts to Firestore: $e');
    }
  }

  // Future<void> _saveWorkoutsToFirestore(
  //     List<String> workouts, String? userId) async {
  //   if (userId != null) {
  //     final CollectionReference workoutCollection =
  //         FirebaseFirestore.instance.collection('workouts');

  //     // Get the current count of workout documents for the user
  //     QuerySnapshot snapshot = await workoutCollection
  //         .doc(userId)
  //         .collection('workout_instances')
  //         .get();
  //     int slNo =
  //         snapshot.size + 1; // Increment by 1 to get the next serial number

  //     // Add workouts to a document with the serial number
  //     try {
  //       await workoutCollection
  //           .doc(userId)
  //           .collection('workout_instances')
  //           .doc('instance$slNo')
  //           .set({
  //         'workouts': workouts,
  //         // You can add more fields as needed
  //       });
  //       print(
  //           'Workouts saved to Firestore for user $userId with serial number $slNo');
  //     } catch (e) {
  //       print('Error saving workouts to Firestore: $e');
  //     }
  //   } else {
  //     print('User ID is null, unable to save workouts to Firestore.');
  //   }
  // }
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Center(
                child: Text(
              "Time: $_start",
            )),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
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
                          userId: widget.userId,
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
                return _buildWorkoutTile(selectedWorkouts[index]);
              },
            ),
          ),
          // Add a "Finish" button at the bottom
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                stopTimer();
                // When the "Finish" button is clicked, save workouts to Firestore
                saveWorkoutsToFirestore(selectedWorkouts);
              },
              child: Text('Finish'),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildWorkoutTile(String workout) {
    bool isFinished = false;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 4.0,
          color: Colors.black12,
        ),
      ),
      child: ListTile(
        title: Text(workout),
        tileColor: Colors.white, // Change color based on finish status
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  selectedWorkouts.remove(workout);
                });
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tileColor:
                  Colors.black;
                });
              },
              child: Text(isFinished
                  ? 'Undo'
                  : 'Finish'), // Change button text based on finish status
            )
          ],
        ),
      ),
    );
  }
}
