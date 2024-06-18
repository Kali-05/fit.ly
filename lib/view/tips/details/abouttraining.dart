import 'package:flutter/material.dart';
import 'package:workout_fitness/view/tips/details/tip_detail_base.dart';

class AboutTrainingView extends StatelessWidget {
  const AboutTrainingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TipDetailBase(
      title: "About Training",
      content: "Details about training...",
    );
  }
}
