import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/models/user.dart';
import 'package:ctrl_r/screens/pages/change_password_screen.dart';
import 'package:ctrl_r/screens/pages/edit_profile_screen.dart';
import 'package:ctrl_r/screens/pages/on_boarding_screen.dart';
import 'package:ctrl_r/screens/widgets/card_profile_widget.dart';
import 'package:ctrl_r/services/local_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    User? getUser = await LocalService.getUserData();
    setState(() {
      user = getUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: user == null
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Column(
              children: [
                Container(
                  height: context.heightPercent(35),
                  width: context.width,
                  padding:
                      EdgeInsets.symmetric(horizontal: context.widthPercent(2)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: context.heightPercent(2),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profile",

                            style: TextStyle(
                                color: Colors.white,
                                fontSize: context.t1,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.white.withOpacity(0.3)),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: ((context) =>
                                            const EditProfileScreen())));
                              },
                              child: const Text(
                                "Edit profile",
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: context.widthPercent(30),
                              height: context.heightPercent(20),
                              padding: EdgeInsets.all(context.heightPercent(1)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  // borderRadius: BorderRadius.circular(12),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.3), 
                                      spreadRadius:
                                          5,
                                      blurRadius: 7, 
                                      offset: const Offset(0,
                                          3),
                                    ),
                                  ]),
                              child: Center(
                                child: Text(
                                  "👮‍♂",
                                  style: TextStyle(
                                      fontSize: context.heightPercent(7)),
                                ),
                              ),
                            ),
                            Text(
                              user!.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: context.t2,
                              ),
                            ),
                            Text(
                              "Matricule : ${user!.matricule}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: context.t4,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: context.heightPercent(60),
                  width: context.width,
                  padding: EdgeInsets.all(context.heightPercent(2)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CardProfileWidget(
                          icon: HeroIcons.envelope, text: user!.email),
                      CardProfileWidget(
                          icon: HeroIcons.phone, text: user!.contact),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    const ChangePasswordScreen()),
                          );
                        },
                        child: CardProfileWidget(
                            icon: HeroIcons.pencil,
                            text: "Modifier mon mot de passe"),
                      ),
                      InkWell(
                        onTap: () {
                          LocalService.deleteAllUserPreferences();
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const OnBoardingScreen()),
                          );
                        },
                        child: CardProfileWidget(
                            icon: HeroIcons.arrowRightStartOnRectangle,
                            text: "Se deconnecter"),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
