import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/screens/pages/admin/add_alert_screen.dart';
import 'package:ctrl_r/screens/pages/admin/admin_alert_screen.dart';
import 'package:ctrl_r/screens/pages/admin/admin_controle_screen.dart';
import 'package:ctrl_r/screens/pages/profile_screen.dart';
import 'package:ctrl_r/services/controle_service.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int pageIndex = 0;
  List<Widget> appbars = [];
  List<Widget> pages = [
    const AdminHome(),
    const AdminControleScreen(),
    const AdminAlertScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return InternetConnectivityListener(
      connectivityListener: (BuildContext context, bool hasInternetAccess) {
        if (hasInternetAccess) {
          showBanner(
              'Vous êtes connecté à Internet', Colors.green, hasInternetAccess);
        } else {
          showBanner('Vous n\'êtes pas connecté à Internet', Colors.red,
              hasInternetAccess);
        }
      },
      child: Scaffold(
          body: SafeArea(child: pages[pageIndex]),
          floatingActionButton: pageIndex == 2
              ? FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddAlertScreen()));
                  },
                  child: const HeroIcon(HeroIcons.plus),
                )
              : null,
          bottomNavigationBar: BottomAppBar(
            height: context.heightPercent(9),
            elevation: 0,
            notchMargin: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeroIcon(HeroIcons.home,
                          style: pageIndex == 0
                              ? HeroIconStyle.solid
                              : HeroIconStyle.outline,
                          color: pageIndex == 0 ? Colors.black : Colors.grey),
                      Text(
                        "Acceiul",
                        style: TextStyle(
                            color: pageIndex == 0 ? Colors.black : Colors.grey),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeroIcon(HeroIcons.queueList,
                          style: pageIndex == 1
                              ? HeroIconStyle.solid
                              : HeroIconStyle.outline,
                          color: pageIndex == 1 ? Colors.black : Colors.grey),
                      Text(
                        "Contrôls",
                        style: TextStyle(
                            color: pageIndex == 1 ? Colors.black : Colors.grey),
                      )
                    ],
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     setState(() {
                //       pageIndex = 2;
                //     });
                //   },
                //   child: Container(
                //     width: 40,
                //     height: context.heightPercent(6),
                //     padding: EdgeInsets.all(context.heightPercent(1)),
                //     decoration: BoxDecoration(
                //         color: Theme.of(context).primaryColor,
                //         shape: BoxShape.circle),
                //     child: const Icon(Icons.add, color: Colors.white),
                //   ),
                // ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      pageIndex = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeroIcon(HeroIcons.bell,
                          style: pageIndex == 2
                              ? HeroIconStyle.solid
                              : HeroIconStyle.outline,
                          color: pageIndex == 2 ? Colors.black : Colors.grey),
                      Text(
                        "Alerts",
                        style: TextStyle(
                            color: pageIndex == 2 ? Colors.black : Colors.grey),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      pageIndex = 3;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeroIcon(HeroIcons.user,
                          style: pageIndex == 3
                              ? HeroIconStyle.solid
                              : HeroIconStyle.outline,
                          color: pageIndex == 3 ? Colors.black : Colors.grey),
                      Text(
                        "Profile",
                        style: TextStyle(
                            color: pageIndex == 3 ? Colors.black : Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  showBanner(String text, Color color, bool isConnect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        duration: isConnect ? Duration.zero : const Duration(days: 1),
        action: isConnect
            ? null
            : SnackBarAction(
                label: 'Fermer',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
        backgroundColor: color, // Change background color as needed
      ),
    );
  }
}

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Map<String, dynamic> bilan = {};
  List<PieChartSectionData> _generatePieChartData(Map<String, dynamic> data) {
    print(data);
    int vehiclesInRule = data['vehicles_in_rule'] ?? 0;
    int vehiclesNotInRule = data['vehicles_not_in_rule'] ?? 0;
    int totalVehicles = data['total_vehicles'] ?? 0;

    if (totalVehicles == 0) {
      // Gérer le cas où le total des véhicules est zéro
      return [];
    }

    double percentageInRule = vehiclesInRule / totalVehicles;
    double percentageNotInRule = vehiclesNotInRule / totalVehicles;

    return [
      PieChartSectionData(
        value: double.parse((percentageInRule * 100).toStringAsFixed(2)),
        color: const Color.fromARGB(255, 159, 231, 108),
        radius: 30,
      ),
      PieChartSectionData(
        value: double.parse((percentageNotInRule * 100).toStringAsFixed(2)),
        color: const Color.fromARGB(255, 235, 126, 126),
        radius: 30,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    Map<String, dynamic>? data = await ControleService.getBilan();
    print(data);
    setState(() {
      bilan = data!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPercent(2)),
      child: bilan.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.heightPercent(2)),
                Text("Bilan",
                    style: TextStyle(
                        fontSize: context.t1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: context.heightPercent(2),
                ),
                SizedBox(
                  height: context.heightPercent(20),
                  width: context.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: PieChart(PieChartData(
                          centerSpaceRadius: 55,
                          sections: _generatePieChartData(bilan),
                        )),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Contrôle Total: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                bilan["total_vehicles"].toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: context.heightPercent(1),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Contrôle en regle: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                bilan["vehicles_in_rule"].toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: context.heightPercent(1),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Contrôle en infraction: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                bilan["vehicles_not_in_rule"].toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: context.heightPercent(3),
                ),
                Container(
                  padding: EdgeInsets.all(context.heightPercent(2)),
                  width: double.infinity,
                  height: context.heightPercent(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        )
                      ]),
                  child: Column(
                    children: [
                      const Text(
                        "Effectifs des agents",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: context.heightPercent(1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Center(
                                child: Text(
                                  "👮‍♂",
                                  style: TextStyle(
                                      fontSize: context.heightPercent(5)),
                                ),
                              ),
                              Text("ADMIN: 10",
                                  style: TextStyle(
                                      fontSize: context.t3,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              Center(
                                child: Text(
                                  "👮‍♂",
                                  style: TextStyle(
                                      fontSize: context.heightPercent(5)),
                                ),
                              ),
                              Text("OFFICER: 20",
                                  style: TextStyle(
                                      fontSize: context.t3,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
