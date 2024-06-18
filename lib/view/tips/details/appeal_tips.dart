import 'package:flutter/material.dart';
import 'package:workout_fitness/view/tips/details/tip_detail_base.dart';

class AppealTipsView extends StatelessWidget {
  const AppealTipsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TipDetailBase(
      title: "Appeal Tips",
      content: "Details about appeal tips...",
    );
  }
}
