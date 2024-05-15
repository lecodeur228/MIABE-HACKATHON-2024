import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/models/controle.dart';
import 'package:ctrl_r/screens/pages/search_controle_screen.dart';
import 'package:ctrl_r/screens/widgets/controle_container_widget.dart';
import 'package:ctrl_r/services/check_connectivity.dart';
import 'package:ctrl_r/services/controle_service.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class AdminControleScreen extends StatefulWidget {
  const AdminControleScreen({super.key});

  @override
  State<AdminControleScreen> createState() => _AdminControleScreenState();
}

class _AdminControleScreenState extends State<AdminControleScreen> {
  List<Controle> controls = [];
  @override
  void initState() {
    super.initState();
    loadControls();
  }

  Future<void> loadControls() async {
    if (await CheckConnecivity.checkInternet()) {
      dynamic response = await ControleService.getControls();
      setState(() {
        controls = response ?? [];
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPercent(2)),
      child: Column(
        children: [
          SizedBox(
            height: context.heightPercent(2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("liste des contôles",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black,
                      fontSize: context.t2,
                      fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                const SearchControleScreen())));
                  },
                  icon: const HeroIcon(
                    HeroIcons.magnifyingGlass,
                    color: Colors.black,
                  ))
            ],
          ),
          SizedBox(
            height: context.heightPercent(2),
          ),
          Expanded(
            child: controls.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ), // Afficher un indicateur de chargement si les données ne sont pas encore chargées
                  )
                : ListView.builder(
                    itemCount: controls.length,
                    itemBuilder: (BuildContext context, int index) {
                      Controle data = controls[index];
                      return InkWell(
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text(
                                      'Voulez-vous vraiment supprimer cet élément ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            false); // Annuler la suppression
                                      },
                                      child: const Text("Annuler"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ControleService.fakeDelete(data.id)
                                            .then((value) {
                                          Navigator.of(context).pop(false);
                                          if (value["status"] == "SUCCES") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(value["message"]),
                                                duration:
                                                    const Duration(seconds: 2),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(value["message"]),
                                                duration:
                                                    const Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        });
                                      },
                                      child: const Text("Oui"),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: ControleContainerWidget(
                          controle: data,
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
