import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:workout_fitness/view/weight/check_progress.dart';

class Dietplanai extends StatefulWidget {
  const Dietplanai({super.key});

  @override
  _DietplanaiState createState() => _DietplanaiState();
}

class _DietplanaiState extends State<Dietplanai> {
  String dietPlan = "Loading diet plan...";

  @override
  void initState() {
    super.initState();
    _fetchDietPlan();
  }

  Future<void> _fetchDietPlan() async {
    final Gemini gemini = Gemini.instance;
    final prompt = "Generate a good diet plan for a person with a BMI of $bmi.";
    final response = await gemini.text(prompt);

    if (response != null &&
        response.content != null &&
        response.content!.parts != null &&
        response.content!.parts!.isNotEmpty) {
      setState(() {
        dietPlan = response.content!.parts!.last.text!;
      });
    } else {
      setState(() {
        dietPlan = "Unable to generate a diet plan at this time.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Personal Diet Plan '),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            dietPlan,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
