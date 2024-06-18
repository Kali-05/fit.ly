import 'package:flutter/material.dart';
import 'package:workout_fitness/view/tips/details/tip_detail_base.dart';

class ShoesToTrainingView extends StatelessWidget {
  const ShoesToTrainingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TipDetailBase(
      title: "Shoes To Training",
      content: "Details about shoes for training...",
    );
  }
}
