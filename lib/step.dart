import 'package:flutter/material.dart';
import 'package:rupadana/stepper.dart';

class Step extends StatelessWidget {
  final Widget? child;
  final String? title;
  StepperMessage? Function()? validation;
  Step({this.title,this.validation, this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}
