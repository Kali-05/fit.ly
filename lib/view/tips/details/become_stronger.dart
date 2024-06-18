import 'package:flutter/material.dart';
import 'package:workout_fitness/view/tips/details/tip_detail_base.dart';

class BecomeStrongerView extends StatelessWidget {
  const BecomeStrongerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TipDetailBase(
      title: "Become Stronger",
      content: "Details about becoming stronger...",
    );
  }
}
