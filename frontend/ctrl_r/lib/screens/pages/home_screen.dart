import 'package:ctrl_r/databases/controle_database.dart';
import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/models/controle.dart';
import 'package:ctrl_r/models/user.dart';
import 'package:ctrl_r/providers/controle_provider.dart';
import 'package:ctrl_r/screens/pages/add_control_screen.dart';
import 'package:ctrl_r/screens/pages/alert_screen.dart';
import 'package:ctrl_r/screens/pages/controle_screen.dart';
import 'package:ctrl_r/screens/pages/profile_screen.dart';
import 'package:ctrl_r/screens/pages/search_controle_screen.dart';
import 'package:ctrl_r/screens/widgets/controle_container_widget.dart';
import 'package:ctrl_r/services/check_connectivity.dart';
import 'package:ctrl_r/services/controle_service.dart';
import 'package:ctrl_r/services/local_service.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final database = ControleDatabase.instance;
  int pageIndex = 0;
  List<Widget> appbars = [];
  List<Widget> pages = [
    const Home(),
    const ControleScreen(),
    const AddControleScreen(),
    const AlertScreen(),
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
                InkWell(
                  onTap: () {
                    setState(() {
                      pageIndex = 2;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: context.heightPercent(6),
                    padding: EdgeInsets.all(context.heightPercent(1)),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.white),
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
                      HeroIcon(HeroIcons.bell,
                          style: pageIndex == 3
                              ? HeroIconStyle.solid
                              : HeroIconStyle.outline,
                          color: pageIndex == 3 ? Colors.black : Colors.grey),
                      Text(
                        "Alerts",
                        style: TextStyle(
                            color: pageIndex == 3 ? Colors.black : Colors.grey),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      pageIndex = 4;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeroIcon(HeroIcons.user,
                          style: pageIndex == 4
                              ? HeroIconStyle.solid
                              : HeroIconStyle.outline,
                          color: pageIndex == 4 ? Colors.black : Colors.grey),
                      Text(
                        "Profile",
                        style: TextStyle(
                            color: pageIndex == 4 ? Colors.black : Colors.grey),
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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Controle> controls = [];
  final database = ControleDatabase.instance;
  int choose = 0;
  User? user;
  List<String> options = [
    "Tous",
    "Permit de conduire",
    "visite technique",
    "Cart gris",
    "TVM",
    "Assurance"
  ];
  int? selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    // loadControls();
  }

  Future loadData() async {
    User? data = await LocalService.getUserData();
    setState(() {
      user = data;
    });
  }

  // Future<void> loadControls() async {
  //   if (await CheckConnecivity.checkInternet()) {
  //     dynamic response = await ControleService.getControls();
  //     setState(() {
  //       controls = response ?? [];
  //     });
  //     for (var item in controls) {
  //       database.createControleInApi(item);
  //     }
  //   } else {
  //     print("local");
  //     dynamic response = await database.getAllControles();
  //     setState(() {
  //       controls = response ?? [];
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final controleProvider = Provider.of<ControleProvider>(context);
    List<Controle> controls = controleProvider.controles;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPercent(2)),
      child: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () async {
          if (await CheckConnecivity.checkInternet()) {
            dynamic response = await ControleService.getControls();
            Provider.of<ControleProvider>(context, listen: false)
                .loadControles(response);
          } else {
            dynamic response = await database.getAllControles();
            Provider.of<ControleProvider>(context, listen: false)
                .loadControles(response);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.heightPercent(2),
            ),
            user != null
                ? Text(
                    "Salut, ${user!.name}",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: context.t1),
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 200,
                      height: 20,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
            SizedBox(
              height: context.heightPercent(2),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SearchControleScreen()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.withOpacity(0.2)),
                child: const TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Colors.black87,
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Rechercher...",
                      hintStyle: TextStyle(color: Colors.black87),
                      border: InputBorder.none),
                ),
              ),
            ),
            SizedBox(
              height: context.heightPercent(2),
            ),
            SizedBox(
              height: context.heightPercent(5),
              width: context.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: context.widthPercent(3)),
                      padding: EdgeInsets.symmetric(
                        vertical: context.heightPercent(1),
                        horizontal: context.widthPercent(4),
                      ),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          options[index],
                          style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: context.p1),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: context.heightPercent(1),
            ),
            Padding(
              padding: EdgeInsets.only(left: context.widthPercent(1)),
              child: Text(
                "Contrôls",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: context.t3,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            Expanded(
              child: controleProvider.controles.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ), // Afficher un indicateur de chargement si les données ne sont pas encore chargées
                    )
                  : ListView.builder(
                      itemCount: controls.length,
                      itemBuilder: (BuildContext context, int index) {
                        Controle data = controleProvider.controles[index];
                        print("data: $data");
                        return ControleContainerWidget(
                          controle: data,
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
