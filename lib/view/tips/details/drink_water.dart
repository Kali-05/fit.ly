import 'package:flutter/material.dart';
import 'package:workout_fitness/view/tips/details/tip_detail_base.dart';

class DrinkWaterView extends StatelessWidget {
  const DrinkWaterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TipDetailBase(
      title: "Drink Water",
      content: "Details about drinking water...",
    );
  }
}
