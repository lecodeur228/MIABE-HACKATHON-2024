
import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  String text;
   ButtonWidget({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
                  margin: EdgeInsets.only(bottom: context.heightPercent(3)),
                  padding:
                      EdgeInsets.symmetric(vertical: context.heightPercent(2)),
                  width: context.widthPercent(90),
                  height: context.heightPercent(7),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                     text,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: context.p1),
                    ),
                  ),
                );
  }
}