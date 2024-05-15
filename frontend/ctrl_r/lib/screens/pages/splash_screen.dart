import 'dart:async';

import 'package:ctrl_r/databases/controle_database.dart';
import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/models/controle.dart';
import 'package:ctrl_r/models/user.dart';
import 'package:ctrl_r/providers/alert_provider.dart';
import 'package:ctrl_r/providers/controle_provider.dart';
import 'package:ctrl_r/screens/pages/admin/admin_home_screen.dart';
import 'package:ctrl_r/screens/pages/home_screen.dart';
import 'package:ctrl_r/screens/pages/on_boarding_screen.dart';
import 'package:ctrl_r/services/alert_service.dart';
import 'package:ctrl_r/services/check_connectivity.dart';
import 'package:ctrl_r/services/controle_service.dart';
import 'package:ctrl_r/services/local_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final database = ControleDatabase.instance;
  double progress = 0;
  List<Controle>? controleNotUplaod;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () async {
      String? token = await LocalService.getUserToken();
      User? user = await LocalService.getUserData();
      dynamic localData = await database.getAllControlesAdd();
      setState(() {
        controleNotUplaod = localData;
      });
      if (token != null) {
        if (await CheckConnecivity.checkInternet()) {
          database.deleteControleOnline();
          if (controleNotUplaod!.isNotEmpty) {
            int upladed = 0;
            for (var item in controleNotUplaod!) {
              await ControleService.addControls(item.toJson());
              upladed++;
              setState(() {
                progress = upladed / controleNotUplaod!.length;
              });
            }
          }

          dynamic response = await ControleService.getControls();
          for (var item in response) {
            database.createControleInApi(item);
          }
          Provider.of<ControleProvider>(context, listen: false)
              .loadControles(response);

          dynamic alerts = await AlertService.getAlerts();
          Provider.of<AlertProvider>(context, listen: false).loadAlerts(alerts);
        } else {
          dynamic response = await database.getAllControles();
          Provider.of<ControleProvider>(context, listen: false)
              .loadControles(response);
        }

        if (user!.role == "OFFICIER") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => const HomeScreen())));
        } else if (user.role == "ADMIN") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: ((context) => const AdminHomeScreen())));
        }
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: ((context) => const OnBoardingScreen())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controleNotUplaod == null
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : controleNotUplaod!.isNotEmpty
              ? Center(
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                            "Envoie des données ajouté en mode hors line"),
                        SizedBox(
                          height: context.heightPercent(2),
                        ),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                )),
    );
  }
}
