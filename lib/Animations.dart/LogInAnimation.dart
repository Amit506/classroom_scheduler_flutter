import 'package:flutter/material.dart';

class LogInScreenAnimation {
  final AnimationController controller;
  final Animation<double> logo1;
  final Animation<double> logobakground;

  LogInScreenAnimation(this.controller)
      : logobakground = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.5, curve: Curves.fastOutSlowIn))),
        logo1 = Tween(begin: 0.0, end: 0.3).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.51, 0.67, curve: Curves.elasticOut),),);
}