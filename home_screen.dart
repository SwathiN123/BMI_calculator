import 'dart:math';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart'; // Import this for PageTransition
import 'package:bmi_calculator_app/age_weight_widget.dart';
import 'package:bmi_calculator_app/gender_widget.dart';
import 'package:bmi_calculator_app/height_widget.dart';
import 'package:bmi_calculator_app/score_screen.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart'; // Import this for SwipeableButtonView

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _gender = 0;
  int _height = 150;
  int _age = 30;
  int _weight = 50;
  bool _isFinished = false;
  double _bmiScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("BMI Calculator"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Card(
              elevation: 12,
              shape: const RoundedRectangleBorder(),
              child: Column(
                children: [
                  GenderWidget(
                    onChange: (genderVal) {
                      setState(() {
                        _gender = genderVal;
                      });
                    },
                  ),
                  HeightWidget(
                    onChange: (heightVal) {
                      setState(() {
                        _height = heightVal;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AgeWeightWidget(
                          onChange: (ageVal) {
                            setState(() {
                              _age = ageVal;
                            });
                          },
                          title: "Age",
                          initValue: 30,
                          min: 0,
                          max: 100),
                      AgeWeightWidget(
                          onChange: (weightVal) {
                            setState(() {
                              _weight = weightVal;
                            });
                          },
                          title: "Weight(kg)",
                          initValue: 50,
                          min: 0,
                          max: 200),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 60),
                    child: SwipeableButtonView(
                      isFinished: _isFinished,
                      onFinish: () async {
                        await Navigator.push(
                          context,
                          PageTransition(
                            child: ScoreScreen(
                              bmiScore: _bmiScore,
                              age: _age,
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );
                        setState(() {
                          _isFinished = false;
                        });
                      },
                      onWaitingProcess: () {
                        calculateBmi();
                        Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            _isFinished = true;
                          });
                        });
                      },
                      activeColor: Colors.blue,
                      buttonWidget: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                      buttonText: "CALCULATE",
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void calculateBmi() {
    _bmiScore = _weight / pow(_height / 100, 2);
  }
}
