import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'workout_detail_page.dart';

class TrainingStatusPage extends StatelessWidget {
  final String userId;
  const TrainingStatusPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Status'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('fitlys/$userId/workouts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var workouts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              var workout = workouts[index];
              var timestamp = workout['timestamp'].toDate();
              var formattedDate =
                  "${timestamp.year}-${timestamp.month}-${timestamp.day}";

              return Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text('Workout on $formattedDate'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutDetailPage(
                          workoutData: workout,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
