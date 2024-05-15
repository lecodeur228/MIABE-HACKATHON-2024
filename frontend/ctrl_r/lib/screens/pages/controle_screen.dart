import 'package:ctrl_r/databases/controle_database.dart';
import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/models/controle.dart';
import 'package:ctrl_r/providers/controle_provider.dart';
import 'package:ctrl_r/screens/pages/search_controle_screen.dart';
import 'package:ctrl_r/screens/widgets/controle_container_widget.dart';
import 'package:ctrl_r/services/check_connectivity.dart';
import 'package:ctrl_r/services/controle_service.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class ControleScreen extends StatefulWidget {
  const ControleScreen({super.key});

  @override
  State<ControleScreen> createState() => _ControleScreenState();
}

class _ControleScreenState extends State<ControleScreen> {
  final database = ControleDatabase.instance;
  List<Controle> controls = [];

  @override
  void initState() {
    super.initState();
    // loadControls();
  }

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
