import 'package:flutter/material.dart';
import 'package:workout_fitness/view/tips/details/tip_detail_base.dart';

class IntroducingMealPlanView extends StatelessWidget {
  const IntroducingMealPlanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TipDetailBase(
      title: "Introducing about Meal Plan",
      content: "Details about the meal plan...",
    );
  }
}
