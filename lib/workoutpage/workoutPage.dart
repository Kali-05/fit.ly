import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_fitness/view/exercise/exercise_view_2.dart';
import 'package:workout_fitness/view/trainingstatus/conformationpage.dart';
import 'package:workout_fitness/view/trainingstatus/trainingstatuspage.dart';

class MyWorkoutPage extends StatefulWidget {
  final String userId;
  const MyWorkoutPage({required this.userId});

  @override
  State<MyWorkoutPage> createState() => _MyWorkoutPageState();
}

class _MyWorkoutPageState extends State<MyWorkoutPage> {
  List<String> selectedWorkouts = [];
  late Timer _timer;
  int _start = 0;

  DateTime getCurrentDateTime() {
    return DateTime.now();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
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
  }

  Future<void> saveWorkoutsToFirestore(List<String> workouts) async {
    try {
      DateTime now = getCurrentDateTime();
      String formattedDate = "${now.year}-${now.month}-${now.day}";
      String formattedTime = "${now.hour}:${now.minute}:${now.second}";

      CollectionReference userWorkoutsCollection = FirebaseFirestore.instance
          .collection('fitlys/${widget.userId}/workouts');

      await userWorkoutsCollection
          .doc(formattedDate + "_" + formattedTime)
          .set({
        'workouts': workouts,
        'timestamp': now,
      });

      print('Workouts saved to Firestore for user ${widget.userId}');
    } catch (e) {
      print('Error saving workouts to Firestore: $e');
    }
  }

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
              child: Text("Time: $_start"),
            ),
          ),
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyRoutines(
                      onAddWorkouts: _addWorkouts,
                      userId: widget.userId,
                    ),
                  ),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  stopTimer();
                  saveWorkoutsToFirestore(selectedWorkouts).then((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ConfirmationPage(userId: widget.userId),
                      ),
                    );
                  });
                },
                child: const Text('Finish'),
              ),
            ),
          ],
        ),
      ),
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
        tileColor: Colors.white,
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
                  isFinished = !isFinished;
                });
              },
              child: Text(isFinished ? 'Undo' : 'Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
