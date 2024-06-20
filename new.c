import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class Dietplanai extends StatefulWidget {
  final double bmi;

  const Dietplanai({required this.bmi, Key? key}) : super(key: key);

  @override
  _DietplanaiState createState() => _DietplanaiState();
}

class _DietplanaiState extends State<Dietplanai> {
  late Gemini gemini;
  String? dietPlan;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    gemini = Gemini.instance;
    _generateDietPlan();
  }

  @override
  void dispose() {
    // Dispose any resources if necessary
    super.dispose();
  }

  Future<void> _generateDietPlan() async {
    setState(() {
      isLoading = true;
    });

    final prompt = "Generate a diet plan based on BMI: ${widget.bmi}";
    final response = await gemini.text(prompt);

    if (response != null &&
        response.content != null &&
        response.content!.parts != null &&
        response.content!.parts!.isNotEmpty) {
      setState(() {
        dietPlan = response.content!.parts!.last.text;
        isLoading = false;
      });
    } else {
      setState(() {
        dietPlan = 'Unable to generate diet plan';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Plan'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your BMI is: ${widget.bmi.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 20),
              if (isLoading)
                CircularProgressIndicator(), // Show loading indicator
              if (!isLoading && dietPlan != null)
                Column(
                  children: [
                    Text(
                      'Generated Diet Plan:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      dietPlan!,
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              if (!isLoading && dietPlan == null)
                Text(
                  'Unable to generate diet plan',
                  style: TextStyle(fontSize: 16.0, color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

