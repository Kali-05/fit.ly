import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutDetailPage extends StatelessWidget {
  final DocumentSnapshot workoutData;
  const WorkoutDetailPage({required this.workoutData});

  @override
  Widget build(BuildContext context) {
    var workouts = List<String>.from(workoutData['workouts']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workouts:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(workouts[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
