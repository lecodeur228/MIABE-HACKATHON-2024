import 'package:ctrl_r/helpers/screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OnBoardingWidget extends StatelessWidget {
  OnBoardingWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.description});
  String title, image, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          image,
          height: context.heightPercent(25),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: context.heightPercent(2),
        ),
         Text(
          description,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
      ],
    );
  }
}
