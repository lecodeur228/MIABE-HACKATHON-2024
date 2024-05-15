import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/providers/role_provider.dart';
import 'package:ctrl_r/screens/pages/login_screen.dart';
import 'package:ctrl_r/screens/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseProfileScreen extends StatefulWidget {
  const ChooseProfileScreen({super.key});

  @override
  State<ChooseProfileScreen> createState() => _ChooseProfileScreenState();
}

class _ChooseProfileScreenState extends State<ChooseProfileScreen> {
  int? choose;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'Quel est votre profile?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              height: context.heightPercent(3),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<RoleProvider>(context, listen: false)
                        .setRole("ADMIN");
                    setState(() {
                      choose = 1;
                    });
                  },
                  child: Container(
                    width: context.widthPercent(35),
                    height: context.heightPercent(23),
                    padding: EdgeInsets.all(context.heightPercent(1)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: choose == 1
                            ? Border.all(color: Theme.of(context).primaryColor)
                            : Border.all(color: Colors.transparent),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.3), // Couleur de l'ombre
                            spreadRadius: 5, // Rayon de dispersion de l'ombre
                            blurRadius: 7, // Flou de l'ombre
                            offset: const Offset(0,
                                3), // Position de l'ombre (horizontal, vertical)
                          ),
                        ]),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: choose == 1
                              ? Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).primaryColor,
                                )
                              : const Icon(Icons.check_circle_outline),
                        ),
                        Center(
                          child: Text(
                            "🧑‍✈",
                            style:
                                TextStyle(fontSize: context.heightPercent(10)),
                          ),
                        ),
                        Text("ADMIN",
                            style: TextStyle(
                                fontSize: context.t3,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Provider.of<RoleProvider>(context, listen: false)
                        .setRole("OFFICIER");
                    setState(() {
                      choose = 2;
                    });
                  },
                  child: Container(
                    width: context.widthPercent(35),
                    height: context.heightPercent(23),
                    padding: EdgeInsets.all(context.heightPercent(1)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: choose == 2
                            ? Border.all(color: Theme.of(context).primaryColor)
                            : Border.all(color: Colors.transparent),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.3), // Couleur de l'ombre
                            spreadRadius: 5, // Rayon de dispersion de l'ombre
                            blurRadius: 7, // Flou de l'ombre
                            offset: const Offset(0,
                                3), // Position de l'ombre (horizontal, vertical)
                          ),
                        ]),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: choose == 2
                              ? Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).primaryColor,
                                )
                              : const Icon(Icons.check_circle_outline),
                        ),
                        Center(
                          child: Text(
                            "👮‍♂",
                            style:
                                TextStyle(fontSize: context.heightPercent(10)),
                          ),
                        ),
                        Text("OFFICER",
                            style: TextStyle(
                                fontSize: context.t3,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            if (choose == 1 || choose == 2)
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: ButtonWidget(text: "Continuer"))
          ],
        ),
      )),
    );
  }
}
