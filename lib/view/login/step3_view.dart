import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workout_fitness/services/database.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/select_datetime.dart';
import '../../common_widget/select_picker.dart';
import '../menu/menu_view.dart';

class Step3View extends StatefulWidget {
  const Step3View({super.key, required this.userId});
  //StaringService({required this.uid});
  final String userId;
  @override
  State<Step3View> createState() => _Step3ViewState();
}

class _Step3ViewState extends State<Step3View> {
  bool isAppleHealth = true;
  DateTime? selectDate;
  String? selectHeight;
  String? selectWeight;
  bool isMale = true;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.white,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                "assets/img/back.png",
                width: 25,
                height: 25,
              )),
          title: Text(
            "Step 3 of 3",
            style: TextStyle(
                color: TColor.primary,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Personal Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Let us know about you to speed up the result, Get fit with your personal workout plan!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.secondaryText, fontSize: 16),
                ),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Apple Health",
                                style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Allow access to fill my parameters",
                                style: TextStyle(
                                    color: TColor.secondaryText, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        CupertinoSwitch(
                            activeColor: TColor.primary,
                            value: isAppleHealth,
                            onChanged: (newVal) {
                              setState(() {
                                isAppleHealth = newVal;
                              });
                            })
                      ],
                    ),
                    SizedBox(height: media.width * 0.05),
                    Divider(color: TColor.divider, height: 1),
                    SelectDateTime(
                      title: "Birthday",
                      didChange: (newDate) {
                        setState(() {
                          selectDate = newDate;
                        });
                      },
                      selectDate: selectDate,
                    ),
                    Divider(color: TColor.divider, height: 1),
                    SelectPicker(
                      allVal: List.generate(81, (index) => "${120 + index} cm"),
                      selectVal: selectHeight,
                      title: "Height",
                      didChange: (newVal) {
                        setState(() {
                          selectHeight = newVal;
                        });
                      },
                    ),
                    Divider(color: TColor.divider, height: 1),
                    SelectPicker(
                      allVal: List.generate(91, (index) => "${30 + index} kg"),
                      selectVal: selectWeight,
                      title: "Weight",
                      didChange: (newVal) {
                        setState(() {
                          selectWeight = newVal;
                        });
                      },
                    ),
                    Divider(color: TColor.divider, height: 1),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: media.width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Gender",
                            style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          CupertinoSegmentedControl(
                            groupValue: isMale,
                            selectedColor: TColor.primary,
                            unselectedColor: TColor.white,
                            borderColor: TColor.primary,
                            children: const {
                              true: Text(" Male ",
                                  style: TextStyle(fontSize: 18)),
                              false: Text(" Female ",
                                  style: TextStyle(fontSize: 18))
                            },
                            onValueChanged: (isMaleVal) {
                              setState(() {
                                isMale = isMaleVal;
                              });
                            },
                            padding: EdgeInsets.zero,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                child: RoundButton(
                  title: "Start",
                  onPressed: () async {
                    await DataBaseService(uid: widget.userId).updateUserData(
                        selectDate!, selectHeight!, selectWeight!, isMale);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MenuView(
                                  userId: widget.userId,
                                )),
                        (route) => false);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [1, 2, 3].map((pObj) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: 3 == pObj
                            ? TColor.primary
                            : TColor.gray.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6)),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ));
  }
}
