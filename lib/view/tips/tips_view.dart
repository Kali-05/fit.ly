import 'package:flutter/material.dart';

import 'package:workout_fitness/view/tips/details/abouttraining.dart';
import 'package:workout_fitness/view/tips/details/appeal_tips.dart';
import 'package:workout_fitness/view/tips/details/become_stronger.dart';
import 'package:workout_fitness/view/tips/details/drink_water.dart';
import 'package:workout_fitness/view/tips/details/how_many_times_to_eat.dart';
import 'package:workout_fitness/view/tips/details/introducing_meal_plan.dart';
import 'package:workout_fitness/view/tips/details/shoes_to_training.dart';
import 'package:workout_fitness/view/tips/details/water_and_food.dart';
import 'package:workout_fitness/view/tips/details/weightloss.dart';

import 'package:workout_fitness/view/tips/tips_details_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/tip_row.dart';

class TipsView extends StatefulWidget {
  const TipsView({super.key});

  @override
  State<TipsView> createState() => _TipsViewState();
}

class _TipsViewState extends State<TipsView> {
  List tipsArr = [
    {"name": "About Training"},
    {"name": "How to weight loss ?"},
    {"name": "Introducing about meal plan "},
    {"name": "Water and Food"},
    {"name": "Drink water"},
    {"name": "How many times a day to eat"},
    {"name": "Become stronger"},
    {"name": "Shoes To Training"},
    {"name": "Appeal Tips"}
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0.1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              "assets/img/black_white.png",
              width: 25,
              height: 25,
            )),
        title: Text(
          "Tips",
          style: TextStyle(
              color: TColor.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemBuilder: (context, index) {
            var tObj = tipsArr[index] as Map? ?? {};
            return TipRow(
              tObj: tObj,
              isActive: index == 0,
              onPressed: () {
                switch (index) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutTrainingView(),
                      ),
                    );
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HowToWeightLossView(),
                      ),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IntroducingMealPlanView(),
                      ),
                    );
                    break;
                  case 3:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WaterAndFoodView(),
                      ),
                    );
                    break;
                  case 4:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DrinkWaterView(),
                      ),
                    );
                    break;
                  case 5:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HowManyTimesToEatView(),
                      ),
                    );
                    break;
                  case 6:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BecomeStrongerView(),
                      ),
                    );
                    break;
                  case 7:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShoesToTrainingView(),
                      ),
                    );
                    break;
                  case 8:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppealTipsView(),
                      ),
                    );
                    break;
                  default:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TipsDetailView(tObj: tObj),
                      ),
                    );
                    break;
                }
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.black26,
              height: 1,
            );
          },
          itemCount: tipsArr.length),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {},
                child: Image.asset("assets/img/menu_running.png",
                    width: 25, height: 25),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset("assets/img/menu_meal_plan.png",
                    width: 25, height: 25),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset("assets/img/menu_home.png",
                    width: 25, height: 25),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset("assets/img/menu_weight.png",
                    width: 25, height: 25),
              ),
              InkWell(
                onTap: () {},
                child:
                    Image.asset("assets/img/more.png", width: 25, height: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
