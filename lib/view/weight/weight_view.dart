import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workout_fitness/main.dart';
import 'package:workout_fitness/view/weight/check_progress.dart';
import '../../common/color_extension.dart';
import '../../common_widget/border_button.dart';

class WeightView extends StatefulWidget {
  const WeightView({Key? key}) : super(key: key);

  @override
  State<WeightView> createState() => _WeightViewState();
}

class _WeightViewState extends State<WeightView> {
  List<Map<String, String>> myWeightArr = [
    {"name": "Sunday, AUG 19", "image": "assets/img/4_p.png"},
    {"name": "Sunday, AUG 26", "image": "assets/img/4_p.png"},
    {"name": "Sunday, AUG 26", "image": "assets/img/4_p.png"},
  ];

  String userId = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      userId = user.uid;
    }
    _scheduleWeeklyNotification();
  }

  Future<void> _scheduleWeeklyNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'weekly_notification_channel_id',
      'Weekly Notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Upload your progress photo',
      'It\'s time to upload a new progress photo',
      RepeatInterval.weekly,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().toIso8601String()}.png';
      final imageFile = File(pickedFile.path);
      await imageFile.copy(imagePath);

      // Get the current date and format it
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Store image path in Firestore under the respective user's document inside 'fitlys' collection
      await FirebaseFirestore.instance
          .collection('fitlys')
          .doc(userId)
          .collection('images')
          .doc(formattedDate)
          .set({'image': imagePath});

      setState(() {
        myWeightArr.insert(0, {"name": formattedDate, "image": imagePath});
        if (myWeightArr.length > 3) {
          myWeightArr.removeLast();
        }
      });
    }
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload your progress photo'),
          content: Text('It\'s time to upload a new progress photo'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _takePhoto();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
          ),
        ),
        title: Text(
          "Check your progress",
          style: TextStyle(
            color: TColor.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: BorderButton(
                          title: "Check Progress",
                          type: BorderButtonType.inactive,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckProgress(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('fitlys')
                              .doc(userId)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return BorderButton(
                                title: "My Weight",
                                onPressed: () {},
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Text(
                    "Add more photos to control your progress",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: media.width,
                    height: media.width * 0.9,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        autoPlay: false,
                        aspectRatio: 0.5,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.65,
                        enlargeFactor: 0.4,
                        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                      ),
                      itemCount: myWeightArr.length,
                      itemBuilder:
                          (BuildContext context, int itemIndex, int index) {
                        var dObj = myWeightArr[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.file(
                                    File(dObj["image"].toString()),
                                    width: double.maxFinite,
                                    height: double.maxFinite,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    dObj["name"]!,
                                    style: TextStyle(
                                      color: TColor.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('fitlys')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasData && snapshot.data!.exists) {
                      var weightData = snapshot.data!.get('weight');
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        width: 160,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: TColor.gray.withOpacity(0.5),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "$weightData kg",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    } else {
                      return Text('No data available');
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _takePhoto,
              child: Icon(Icons.camera_alt),
              backgroundColor: TColor.primary,
            ),
          ),
        ],
      ),
    );
  }
}
