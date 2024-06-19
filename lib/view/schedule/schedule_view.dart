import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import '../../common/color_extension.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  DateTime nowTime = DateTime.now();
  DateTime targetDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  List<Map<String, String>> notes = [];
  List<Map<String, dynamic>> workouts = [];
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchNotes();
    fetchWorkouts();
  }

  Future<void> fetchNotes() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection('fitlys')
              .doc(userId)
              .collection('notes')
              .doc(DateFormat('yyyy-MM-dd').format(selectedDate))
              .get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        setState(() {
          notes = data != null
              ? List<Map<String, String>>.from((data['notes'] as List)
                  .map((item) => Map<String, String>.from(item)))
              : [];
        });
      } else {
        setState(() {
          notes = [];
        });
      }
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  Future<void> fetchWorkouts() async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection('fitlys')
              .doc(userId)
              .collection('workouts')
              .doc(formattedDate)
              .get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        setState(() {
          workouts = data != null
              ? List<Map<String, dynamic>>.from(data['workouts'])
              : [];
        });
      } else {
        setState(() {
          workouts = [];
        });
      }
    } catch (e) {
      print('Error fetching workouts: $e');
    }
  }

  Future<void> addNote() async {
    TextEditingController noteController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Note'),
        content: TextField(
          controller: noteController,
          decoration: InputDecoration(hintText: 'Enter your note here'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (noteController.text.isNotEmpty) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(selectedDate);
                await FirebaseFirestore.instance
                    .collection('fitlys')
                    .doc(userId)
                    .collection('notes')
                    .doc(formattedDate)
                    .set({
                  'notes': FieldValue.arrayUnion([
                    {
                      'note': noteController.text,
                      'timestamp': DateTime.now().toString()
                    }
                  ])
                }, SetOptions(merge: true));
                fetchNotes();
              }
              Navigator.of(context).pop();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
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
          "Schedule",
          style: TextStyle(
              color: TColor.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat.MMMM().format(targetDate).toUpperCase(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            DateFormat.y().format(targetDate),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          targetDate =
                              DateTime(targetDate.year, targetDate.month - 1);
                          fetchNotes();
                          fetchWorkouts();
                        });
                      },
                      icon: Image.asset(
                        "assets/img/black_fo.png",
                        width: 15,
                        height: 15,
                        color: TColor.secondaryText.withOpacity(0.7),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          targetDate =
                              DateTime(targetDate.year, targetDate.month + 1);
                          fetchNotes();
                          fetchWorkouts();
                        });
                      },
                      icon: Image.asset(
                        "assets/img/next_go.png",
                        width: 15,
                        height: 15,
                        color: TColor.secondaryText.withOpacity(0.7),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Stack(
                children: [
                  CalendarCarousel(
                    todayButtonColor: Colors.blue,
                    todayBorderColor: Colors.blue,
                    selectedDayButtonColor: Colors.black.withOpacity(0.5),
                    selectedDayBorderColor: Colors.black.withOpacity(0.5),
                    onDayPressed: (DateTime date, List events) {
                      setState(() {
                        selectedDate = date;
                        fetchNotes();
                        fetchWorkouts();
                      });
                    },
                    onCalendarChanged: (date) {
                      setState(() {
                        targetDate = date;
                      });
                    },
                    selectedDayTextStyle: TextStyle(
                        color: TColor.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                    daysTextStyle: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                    weekDayFormat: WeekdayFormat.narrow,
                    weekdayTextStyle:
                        TextStyle(color: TColor.gray, fontSize: 20),
                    weekendTextStyle: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                    thisMonthDayBorderColor: Colors.transparent,
                    showHeader: false,
                    customDayBuilder: (
                      /// you can provide your own build function to make custom day containers
                      bool isSelectable,
                      int index,
                      bool isSelectedDay,
                      bool isToday,
                      bool isPrevMonthDay,
                      TextStyle textStyle,
                      bool isNextMonthDay,
                      bool isThisMonthDay,
                      DateTime day,
                    ) {
                      // Highlight the current date with a blue circle
                      if (isToday) {
                        return Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          child: Text(
                            day.day.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: TColor.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        );
                      }
                      // Highlight the selected date with a black transparent circle
                      if (isSelectedDay) {
                        return Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          child: Text(
                            day.day.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: TColor.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        );
                      }
                      return null;
                    },
                    weekFormat: false,
                    height: 340.0,
                    selectedDateTime: selectedDate,
                    targetDateTime: targetDate,
                    daysHaveCircularBorder: true,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 33),
                    child: Divider(
                      color: Colors.black26,
                      height: 1,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notes",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 35,
                        fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: addNote,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.grey),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (notes.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: notes.map((note) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey,
                      ),
                      child: Text(
                        note['note']!,
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Text(
                'Workouts',
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            if (workouts.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: workouts.map((workout) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey,
                      ),
                      child: Text(
                        workout[
                            'title'], // Adjust based on your workout data structure
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            if (notes.isEmpty && workouts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'No notes or workouts for this day.',
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
