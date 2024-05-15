import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/screens/widgets/button_widget.dart';
import 'package:ctrl_r/screens/widgets/input_widget.dart';
import 'package:ctrl_r/services/alert_service.dart';
import 'package:flutter/material.dart';

class AddAlertScreen extends StatefulWidget {
  const AddAlertScreen({super.key});

  @override
  State<AddAlertScreen> createState() => _AddAlertScreenState();
}

class _AddAlertScreenState extends State<AddAlertScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController plaqueController = TextEditingController();
  TextEditingController motifController = TextEditingController();
  TextEditingController desriptionController = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un alert"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.widthPercent(2)),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.heightPercent(2),
                ),
                Text(
                  'Plaque :',
                  style: TextStyle(fontSize: context.t3),
                ),
                SizedBox(
                  height: context.heightPercent(1),
                ),
                InputWidget(
                    controller: plaqueController,
                    placeholder: "Numero de la plaque",
                    error: "Entrez le numero de la plaque svp",
                    isPassword: false),
                SizedBox(
                  height: context.heightPercent(2),
                ),
                Text(
                  'Motif :',
                  style: TextStyle(fontSize: context.t3),
                ),
                SizedBox(
                  height: context.heightPercent(1),
                ),
                InputWidget(
                  controller: motifController,
                  placeholder: "Entrez le motif de alert",
                  error: "Entrez le motif de alert svp",
                  isPassword: false,
                  line: 2,
                ),
                SizedBox(
                  height: context.heightPercent(2),
                ),
                Text(
                  'Description :',
                  style: TextStyle(fontSize: context.t3),
                ),
                SizedBox(
                  height: context.heightPercent(1),
                ),
                InputWidget(
                  controller: desriptionController,
                  placeholder: "Entrez la description de alert",
                  error: "Entrez la description de alert svp",
                  isPassword: false,
                  line: 4,
                ),
                SizedBox(
                  height: context.heightPercent(2),
                ),
                Center(
                    child: InkWell(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            AlertService.addAlert(
                                    plaque: plaqueController.text,
                                    motif: motifController.text,
                                    descrip: desriptionController.text)
                                .then((value) {
                              if (value["status"] == "SUCCES") {
                                setState(() {
                                  isLoading = false;
                                });
                                plaqueController.clear();
                                motifController.clear();
                                desriptionController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(value["message"]),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              } else if (value["status"] == "ECHEC") {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(value["message"]),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            });
                          }
                        },
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              )
                            : ButtonWidget(text: "Ajouter l'alert")))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
