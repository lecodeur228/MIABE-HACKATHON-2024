import 'package:ctrl_r/databases/controle_database.dart';
import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/models/controle.dart';
import 'package:ctrl_r/providers/controle_provider.dart';
import 'package:ctrl_r/screens/pages/scan_screen.dart';
import 'package:ctrl_r/screens/widgets/button_widget.dart';
import 'package:ctrl_r/screens/widgets/input_widget.dart';
import 'package:ctrl_r/services/check_connectivity.dart';
import 'package:ctrl_r/services/controle_service.dart';
import 'package:ctrl_r/services/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class AddControleScreen extends StatefulWidget {
  const AddControleScreen({super.key});

  @override
  State<AddControleScreen> createState() => _AddControleScreenState();
}

class _AddControleScreenState extends State<AddControleScreen> {
  final database = ControleDatabase.instance;
  final formKey = GlobalKey<FormState>();
  TextEditingController plaqueController = TextEditingController();
  TextEditingController conducteurController = TextEditingController();
  int? permitOption;
  int? cartGrisoption;
  int? assuranceOption;
  int? visiteTechniqueOption;
  int? tvmOption;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPercent(2)),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: context.heightPercent(2),
              ),
              Text(
                "Ajouter un contrôle",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.black,
                    fontSize: context.t1,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: context.heightPercent(4),
              ),
              CustomInputWidget(
                  controller: plaqueController,
                  placeholder: "Entrez la plaque",
                  error: "Le numero de plaque est obligatoire",
                  isPassword: false),
              SizedBox(
                height: context.heightPercent(2),
              ),
              InputWidget(
                  controller: conducteurController,
                  placeholder: "Entrez le nom du conducteur",
                  error: "Le nom du conducteur est obligatoire",
                  isPassword: false),
              SizedBox(
                height: context.heightPercent(2),
              ),
              SizedBox(
                height: context.heightPercent(2),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: context.widthPercent(6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "motifs :",
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Colors.black,
                                fontSize: context.t2,
                              ),
                    ),
                    const Spacer(),
                    const HeroIcon(
                      HeroIcons.xMark,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: context.widthPercent(15),
                    ),
                    const HeroIcon(
                      HeroIcons.check,
                      color: Colors.green,
                    )
                  ],
                ),
              ),
              OptionSelectControlWidget(
                text: "Permis de conduire",
                option: permitOption,
                onChanged: (value) {
                  setState(() {
                    permitOption = value;
                  });
                },
              ),
              OptionSelectControlWidget(
                text: "Carts gris",
                option: cartGrisoption,
                onChanged: (value) {
                  setState(() {
                    cartGrisoption = value;
                  });
                },
              ),
              OptionSelectControlWidget(
                text: "Assurance",
                option: assuranceOption,
                onChanged: (value) {
                  setState(() {
                    assuranceOption = value;
                  });
                },
              ),
              OptionSelectControlWidget(
                text: "Visite technique",
                option: visiteTechniqueOption,
                onChanged: (value) {
                  setState(() {
                    visiteTechniqueOption = value;
                  });
                },
              ),
              OptionSelectControlWidget(
                text: "TVM",
                option: tvmOption,
                onChanged: (value) {
                  setState(() {
                    tvmOption = value;
                  });
                },
              ),
              SizedBox(
                height: context.heightPercent(4),
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        if (formKey.currentState!.validate() &&
                            permitOption != null &&
                            cartGrisoption != null &&
                            assuranceOption != null &&
                            visiteTechniqueOption != null &&
                            tvmOption != null) {
                          setState(() {
                            isLoading = true;
                          });
                          Position position =
                              await LocationService.determinePosition();
                          print(
                              "lat: ${position.latitude}, long: ${position.longitude}");
                          Map<String, dynamic> data = {
                            "plaque": plaqueController.text.trim(),
                            "nom_conducteur": conducteurController.text,
                            "permit_conduire": permitOption,
                            "date_validite_carte_grise": cartGrisoption,
                            "carte_visite_technique": visiteTechniqueOption,
                            "date_expiration": null,
                            "assurance": assuranceOption,
                            "tvm": tvmOption,
                            "latitude": position.latitude.toString(),
                            "longitude": position.longitude.toString(),
                          };
                          Controle controle = Controle.fromJson(data);
                          if (await CheckConnecivity.checkInternet()) {
                            ControleService.addControls(data).then((value) => {
                                  if (value["status"] == "SUCCES")
                                    {
                                      setState(() {
                                        isLoading = false;
                                      }),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(value["message"]),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      )
                                    }
                                  else if (value["status"] == "ECHEC")
                                    {
                                      setState(() {
                                        isLoading = false;
                                      }),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(value["message"]),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      )
                                    }
                                });
                            dynamic response =
                                await ControleService.getControls();
                            Provider.of<ControleProvider>(context,
                                    listen: false)
                                .loadControles(response);
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            database
                                .createControleInLocal(controle)
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.amberAccent,
                                  content: Text(
                                      "Le contrôle a été ajouter en local.Connectez vous à internet pour la synchronisations."),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            });
                            dynamic response = await database.getAllControles();
                            Provider.of<ControleProvider>(context,
                                    listen: false)
                                .loadControles(response);
                          }
                        }
                      },
                      child: ButtonWidget(text: "Ajouter"))
            ],
          ),
        ),
      ),
    );
  }
}

class OptionSelectControlWidget extends StatefulWidget {
  final String text;
  final int? option;
  final ValueChanged<int?> onChanged;

  const OptionSelectControlWidget({
    super.key,
    required this.text,
    required this.option,
    required this.onChanged,
  });

  @override
  State<OptionSelectControlWidget> createState() =>
      _OptionSelectControlWidgetState();
}

class _OptionSelectControlWidgetState extends State<OptionSelectControlWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPercent(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.text,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.black,
                  fontSize: context.t3,
                ),
          ),
          const Spacer(),
          Radio(
            activeColor: Theme.of(context).primaryColor,
            value: 0,
            groupValue: widget.option,
            onChanged: (value) {
              widget.onChanged(value);
            },
          ),
          SizedBox(
            width: context.widthPercent(7),
          ),
          Radio(
            activeColor: Theme.of(context).primaryColor,
            value: 1,
            groupValue: widget.option,
            onChanged: (value) {
              widget.onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomInputWidget extends StatefulWidget {
  TextEditingController controller;
  String placeholder, error;
  bool isPassword;
  CustomInputWidget(
      {super.key,
      required this.controller,
      required this.placeholder,
      required this.error,
      required this.isPassword});

  @override
  State<CustomInputWidget> createState() => _CustomInputWidgetState();
}

class _CustomInputWidgetState extends State<CustomInputWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword,
      maxLength: 7,
      onChanged: (text) {
        for (int i = 0; i < text.length; i++) {
          if (text.length == 2) {
            // Ajouter un espace après les deux premières lettres
            widget.controller.value = TextEditingValue(
              text: '${text.substring(0, 2)} ${text.substring(2)}',
              selection: TextSelection.collapsed(offset: text.length + 1),
            );
          }
        }
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TextScan(
                      plaqueController: widget.controller,
                    ),
                  ));
            },
            icon: const Icon(Icons.camera)),
        contentPadding: EdgeInsets.symmetric(
            vertical: context.heightPercent(2),
            horizontal: context.widthPercent(3)),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: widget.placeholder,
        labelStyle: TextStyle(color: Colors.black87, fontSize: context.t3),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return widget.error;
        }
        return null;
      },
    );
  }
}
