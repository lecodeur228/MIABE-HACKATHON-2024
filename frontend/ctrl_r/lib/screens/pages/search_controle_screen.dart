import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/models/controle.dart';
import 'package:ctrl_r/providers/controle_provider.dart';
import 'package:ctrl_r/screens/widgets/controle_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class SearchControleScreen extends StatefulWidget {
  const SearchControleScreen({super.key});

  @override
  State<SearchControleScreen> createState() => _SearchControleScreenState();
}

class _SearchControleScreenState extends State<SearchControleScreen> {
  TextEditingController searchControle = TextEditingController();
  List<Controle>? results;
  bool isFilter = false;
  List<String> options = [
    "Permit de conduire",
    "visite technique",
    "Cart gris",
    "TVM",
    "Assurance"
  ];
  int SelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final controleProvider = Provider.of<ControleProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPercent(2)),
          child: Column(
            children: [
              SizedBox(
                height: context.heightPercent(2),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const HeroIcon(HeroIcons.arrowLeft)),
                  SizedBox(
                    width: context.widthPercent(1),
                  ),
                  Text(
                    "Rechercher un contrôle",
                    style: TextStyle(color: Colors.black, fontSize: context.t2),
                  )
                ],
              ),
              SizedBox(
                height: context.heightPercent(2),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.withOpacity(0.2)),
                child: TextField(
                  controller: searchControle,
                  onChanged: (value) {
                    for (int i = 0; i < value.length; i++) {
                      if (value.length == 2) {
                        // Ajouter un espace après les deux premières lettres
                        searchControle.value = TextEditingValue(
                          text:
                              '${value.substring(0, 2)} ${value.substring(2)}',
                          selection:
                              TextSelection.collapsed(offset: value.length + 1),
                        );
                      }
                    }

                    List<Controle> searchResult =
                        controleProvider.searchControles(searchControle.text);
                    print("${searchResult.length}");
                    setState(() {
                      results = searchResult;
                    });
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.black87,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isFilter = !isFilter;
                            });
                          },
                          icon: HeroIcon(
                            HeroIcons.adjustmentsHorizontal,
                            color: isFilter
                                ? Theme.of(context).primaryColor
                                : Colors.black87,
                          )),
                      contentPadding: const EdgeInsets.all(15),
                      hintText: "Entrez le numero de plaque",
                      hintStyle: const TextStyle(color: Colors.black87),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: context.heightPercent(1),
              ),
              if (isFilter)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: context.heightPercent(5),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: options
                              .length, // Remplacez numberOfElements par le nombre total d'éléments que vous avez
                          itemBuilder: (context, index) {
                            return OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if (SelectedIndex == index) {
                                    // Si l'index actuel correspond à l'index sélectionné, retournez la couleur du thème
                                    return Theme.of(context).primaryColor;
                                  } else {
                                    // Sinon, retournez null (transparent)
                                    return null;
                                  }
                                }),
                              ),
                              onPressed: () {
                                setState(() {
                                  SelectedIndex = index;
                                });
                              },
                              child: Text(
                                options[index],
                                style: TextStyle(
                                    color: SelectedIndex == index
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              SizedBox(
                height: context.heightPercent(1),
              ),
              Expanded(
                child: results == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/nodata.png",
                              height: context.heightPercent(25),
                            ),
                            const Text(
                              "Pas de resultat",
                            )
                          ],
                        ),
                      )
                    : results!.isEmpty
                        ? const Center(
                            child: Text(
                              "Pas de resultat!!!",
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : ListView.builder(
                            itemCount: results!.length,
                            itemBuilder: (BuildContext context, int index) {
                              Controle data = results![index];
                              return ControleContainerWidget(
                                controle: data,
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
