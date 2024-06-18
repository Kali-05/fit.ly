import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_extension.dart';
import '../../common_widget/response_row.dart';

class WorkoutDetailView extends StatefulWidget {
  const WorkoutDetailView({super.key});

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  List<Map<String, String>> workArr = [
    {"name": "Running", "image": "assets/img/1.png"},
    {"name": "Jumping", "image": "assets/img/2.png"},
    {"name": "Running", "image": "assets/img/5.png"},
    {"name": "Jumping", "image": "assets/img/3.png"},
  ];

  List<Map<String, String>> responseArr = [];
  final TextEditingController _controller = TextEditingController();
  late SharedPreferences prefs;
  final String commentsKey = 'workout_comments';

  @override
  void initState() {
    super.initState();
    _loadResponses();
  }

  Future<void> _loadResponses() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      responseArr = (prefs.getStringList(commentsKey) ?? [])
          .map((item) => Map<String, String>.from(json.decode(item)))
          .toList();
    });
  }

  Future<void> _addResponse(String message) async {
    final response = {
      "name": "User", // You can change this to the actual user's name
      "time": "Just now",
      "image": "assets/img/u2.png", // Placeholder image
      "message": message,
    };

    setState(() {
      responseArr.add(response);
    });

    await _saveResponses();
  }

  Future<void> _saveResponses() async {
    final List<String> responsesStringList =
        responseArr.map((response) => json.encode(response)).toList();
    await prefs.setStringList(commentsKey, responsesStringList);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
            )),
        title: Text(
          "Climbers",
          style: TextStyle(
              color: TColor.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                "assets/img/node_music.png",
                width: 25,
                height: 25,
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/img/1.png",
                    width: media.width,
                    height: media.width * 0.55,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        IgnorePointer(
                          ignoring: true,
                          child: RatingBar.builder(
                            initialRating: 4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 25,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: TColor.primary,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              "assets/img/like.png",
                              width: 20,
                              height: 20,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              "assets/img/share.png",
                              width: 20,
                              height: 20,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Text(
                      "Recommended",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.26,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: workArr.length,
                        itemBuilder: (context, index) {
                          var wObj = workArr[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            width: media.width * 0.28,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      wObj["image"].toString(),
                                      width: media.width,
                                      height: media.width * 0.15,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      width: media.width,
                                      height: media.width * 0.15,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 0),
                                  child: Text(
                                    wObj["name"]!,
                                    style: TextStyle(
                                        color: TColor.secondaryText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "${responseArr.length} Responses",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    shrinkWrap: true,
                    itemCount: responseArr.length,
                    itemBuilder: ((context, index) {
                      var rObj = responseArr[index];
                      return ResponsesRow(rObj: rObj);
                    }),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your response...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: TColor.primary),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _addResponse(_controller.text);
                      _controller.clear();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {},
                child: Image.asset("assets/img/menu_running.png",
                    width: 25, height: 25),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset("assets/img/menu_meal_plan.png",
                    width: 25, height: 25),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset("assets/img/menu_home.png",
                    width: 25, height: 25),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset("assets/img/menu_weight.png",
                    width: 25, height: 25),
              ),
              InkWell(
                onTap: () {},
                child:
                    Image.asset("assets/img/more.png", width: 25, height: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension SharedPreferencesExtension on SharedPreferences {
  Map<String, dynamic>? getStringMap(String key) {
    final String? jsonString = getString(key);
    if (jsonString != null) {
      return Map<String, dynamic>.from(json.decode(jsonString));
    }
    return null;
  }

  Future<void> setStringMap(String key, Map<String, dynamic> value) async {
    final String jsonString = json.encode(value);
    await setString(key, jsonString);
  }
}
