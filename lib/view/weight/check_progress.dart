import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';

class WeightData {
  final String date;
  final String weight;

  WeightData(this.date, this.weight);
}

class CheckProgress extends StatefulWidget {
  const CheckProgress({Key? key}) : super(key: key);

  @override
  State<CheckProgress> createState() => _CheckProgressState();
}

class _CheckProgressState extends State<CheckProgress> {
  TextEditingController _weightController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  List<WeightData> _weightDataList = [];

  TextEditingController _heightEditingController = TextEditingController();
  TextEditingController _ageEditingController = TextEditingController();
  double? weight, height;
  int? age;
  String? bmiAnalysis;
  bool checkBMI = false;

  Gemini gemini = Gemini.instance;

  Future<String?> _getBMIAnalysis(height, weight, age) async {
    final prompt =
        "You are an expert neutritan & dietecian; Get a detailed analysis of the height, weight and the BMI given below. Height = $height, Weight = $weight, BMI = ${(weight / (height * height))}, Age = $age";
    final response = await gemini.text(prompt);
    print(response);
    return response!.content!.parts!.last.text;
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
      body: Center(
      
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Current Weight',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _heightEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Current Height',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _ageEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Current Age',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    print(_weightController.text);
                    print(_heightEditingController.text);
                    print(_ageEditingController.text);
                    weight = double.parse(_weightController.text);
                    height = double.parse(_heightEditingController.text);
                    age = int.parse(_ageEditingController.text);
          
                    bmiAnalysis = await _getBMIAnalysis(height, weight, age);
                    setState(() {
                      checkBMI = true;
                    });
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
              ),
              
                Expanded(
                  // child: ListView.separated(
                  //   itemBuilder: (ctx, index) {
                  //     final item = _weightDataList[index];
                  //     return Card(
                  //       child: ListTile(
                  //         leading: Text(item.date),
                  //         title: Text(item.weight, style: TextStyle(fontSize: 20)),
                  //         subtitle: Text('Kg'),
                  //       ),
                  //     );
                  //   },
                  //   separatorBuilder: (ctx, index) {
                  //     return SizedBox(height: 10);
                  //   },
                  //   itemCount: _weightDataList.length,
                  // ),
                  child: checkBMI?Column(children: [
                    Text("Your BMI is ${weight!/(height!*height!)}"),
                    SizedBox(height: 10,),
                    SingleChildScrollView(child: Text(bmiAnalysis!)),
                  ],):Container()
                ),
            ],
          ),
        
      ),
    );
  }
}
