import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/color_extension.dart';
import '../../services/database.dart';
import 'bmiresult.dart';

double? bmi;
class CheckProgress extends StatefulWidget {
  const CheckProgress({Key? key}) : super(key: key);

  @override
  State<CheckProgress> createState() => _CheckProgressState();
}

class _CheckProgressState extends State<CheckProgress> {
  TextEditingController _weightController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _heightEditingController = TextEditingController();
  TextEditingController _ageEditingController = TextEditingController();
  double? weight, height;
  int? age;
  String? bmiAnalysis;
  bool checkBMI = false;
  String userId = ''; // Provide user ID here
  Gemini gemini = Gemini.instance;
  // Variable to store the BMI value

  Future<String?> _getBMIAnalysis(double height, double weight, int age) async {
    final prompt =
        "You are an expert nutritionist & dietitian; Get a detailed analysis of the height, weight and the BMI given below. Height = $height, Weight = $weight, BMI = ${(weight / (height * height))}, Age = $age";
    final response = await gemini.text(prompt);
    if (response != null &&
        response.content != null &&
        response.content!.parts != null &&
        response.content!.parts!.isNotEmpty) {
      print(response);
      return response.content!.parts!.last.text;
    } else {
      return null; // Return null if response is not valid
    }
  }

  @override
  void initState() {
    super.initState();
    // Example: Assigning a document ID based on the authenticated user
    // Replace this with your actual logic to determine the document ID
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0.1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "assets/img/black_white.png",
            width: 25,
            height: 25,
          ),
        ),
        title: Text(
          "Weight",
          style: TextStyle(
            color: TColor.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Your Current Weight',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _heightEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Your Current Height',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _ageEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Your Current Age',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Enter the Date (yyyy-mm-dd)',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1999),
                    lastDate: DateTime(2025),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: () async {
                  print(_weightController.text);
                  print(_heightEditingController.text);
                  print(_ageEditingController.text);
                  weight = double.parse(_weightController.text);
                  height = double.parse(_heightEditingController.text);
                  age = int.parse(_ageEditingController.text);

                  // Retrieve gender from database
                  DocumentSnapshot<Map<String, dynamic>> snapshot =
                      await FirebaseFirestore.instance
                          .collection('fitlys')
                          .doc(userId)
                          .get();
                  bool? gender = snapshot.data()?['Gender'] == 'Male';

                  await DataBaseService(uid: userId).updateUserData(
                    DateTime
                        .now(), // Assuming you want to update the current date
                    height!.toString(),
                    weight!.toString(),
                    gender ?? false, // or false, depending on the gender
                  );

                  // Calculate BMI and store it in the variable
                  bmi = weight! / (height! * height!);

                  bmiAnalysis = await _getBMIAnalysis(height!, weight!, age!);
                  setState(() {
                    checkBMI = true;
                  });

                  // Navigate to the new screen to display BMI
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BmiResultScreen(
                        bmi: bmi!,
                        bmiAnalysis: bmiAnalysis!,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(color: TColor.primary),
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'Get BMI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      color: TColor.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
