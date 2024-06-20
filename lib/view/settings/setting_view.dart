import 'package:flutter/material.dart';
import 'package:workout_fitness/common_widget/setting_select_row.dart';
import 'package:workout_fitness/common_widget/setting_switch_row.dart';
import 'package:workout_fitness/view/settings/connect_view.dart';
import 'package:workout_fitness/view/settings/deitplanai.dart';
import 'package:workout_fitness/view/settings/select_language_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/tip_row.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0.1,
        title: Text(
          "Deit Plan",
          style: TextStyle(
              color: TColor.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dietplanai()));
              },
              child: Text("Generate Your Deit Plan"))),
    );
  }
}
