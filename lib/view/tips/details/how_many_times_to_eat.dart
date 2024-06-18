import 'package:flutter/material.dart';
import 'package:workout_fitness/view/tips/details/tip_detail_base.dart';

class HowManyTimesToEatView extends StatelessWidget {
  const HowManyTimesToEatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TipDetailBase(
      title: "How Many Times a Day to Eat",
      content: "Details about meal frequency...",
    );
  }
}
