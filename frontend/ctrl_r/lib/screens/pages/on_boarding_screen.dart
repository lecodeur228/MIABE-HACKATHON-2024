import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/screens/pages/choose_profile_screen.dart';
import 'package:ctrl_r/screens/widgets/on_boarding_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Expanded(
            child: PageView.builder(
                itemCount: 3,
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                controller: _pageController,
                itemBuilder: (context, index) => OnBoardingWidget(
                    image: "assets/images/${index + 1}.png",
                    title: "Find the item you're\n been looking for",
                    description:
                        "Here you will see rich variette of goods, carefulll classic"))),
        Row(
          children: [
            ...List.generate(
                3,
                (index) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: DotIndicator(isActive: index == _pageIndex),
                    )),
            const Spacer(),
            InkWell(
              onTap: () {
                if (_pageIndex == 2) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const ChooseProfileScreen())));
                } else {
                  _pageController.nextPage(
                      duration: const Duration(microseconds: 500),
                      curve: Curves.ease);
                }
              },
              child: Container(
                height: 50,
                width: 50,
                margin: EdgeInsets.all(context.heightPercent(2)),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.forward,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    )));
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({super.key, required this.isActive});
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }
}
