import 'package:flutter/material.dart';
import 'package:workout_fitness/view/tips/details/tip_detail_base.dart';

class WaterAndFoodView extends StatelessWidget {
  const WaterAndFoodView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TipDetailBase(
      title: "Water and Food",
      content: "Details about water and food...",
    );
  }
}
