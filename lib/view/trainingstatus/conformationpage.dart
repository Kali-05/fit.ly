import 'package:flutter/material.dart';
import 'package:workout_fitness/view/menu/menu_view.dart';

class ConfirmationPage extends StatelessWidget {
  final String userId;

  const ConfirmationPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuView(userId: userId)),
            );
          },
        ),
        title: Text('Workout Added'),
      ),
      body: Center(
        child: Text(
          'Your workout has been added successfully!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
