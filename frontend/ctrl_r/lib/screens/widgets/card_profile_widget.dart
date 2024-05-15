import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

// ignore: must_be_immutable
class CardProfileWidget extends StatelessWidget {
  HeroIcons icon;
  String text;
  CardProfileWidget({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.heightPercent(7),
      margin: EdgeInsets.symmetric(vertical: context.heightPercent(1)),
      padding: EdgeInsets.all(context.heightPercent(2)),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          HeroIcon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            width: context.widthPercent(4),
          ),
          Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: context.t4),
          )
        ],
      ),
    );
  }
}
