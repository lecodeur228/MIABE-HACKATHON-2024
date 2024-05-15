import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/models/alert.dart';
import 'package:ctrl_r/screens/pages/alert_screen.dart';
import 'package:ctrl_r/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class AlertContainerWidget extends StatefulWidget {
  final bool isDelected;
  final Alert alert;
  const AlertContainerWidget(
      {super.key, required this.alert, this.isDelected = false});

  @override
  State<AlertContainerWidget> createState() => _AlertContainerWidgetState();
}

class _AlertContainerWidgetState extends State<AlertContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
          horizontal: context.widthPercent(1),
          vertical: context.heightPercent(1)),
      padding: EdgeInsets.symmetric(
          horizontal: context.heightPercent(1),
          vertical: context.heightPercent(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(
              Icons.warning_amber_outlined,
              color: Colors.red,
              size: context.heightPercent(5),
            ),
          ),
          SizedBox(
            height: context.heightPercent(1),
          ),
          Row(
            children: [
              Text(
                "Plaque : ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: context.t4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.alert.plaque,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: context.t4,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.heightPercent(1),
          ),
          Row(
            children: [
              Text(
                "Motif : ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: context.t4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.alert.motif,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: context.t4,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.heightPercent(1),
          ),
          Text(
            "Description : ",
            style: TextStyle(
              color: Colors.black,
              fontSize: context.t4,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              widget.alert.description,
              style: TextStyle(
                color: Colors.black87,
                fontSize: context.p1,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Row(
            children: [
              widget.isDelected
                  ? IconButton(
                      onPressed: () {
                       showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title:
                                    const Text('Confirmation de suppression'),
                                content: const Text(
                                    'Voulez-vous vraiment supprimer cette alerte ?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      // Annuler la suppression
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      AlertService.deleteAlert(widget.alert.id)
                                          .then((value) {
                                        Navigator.of(context).pop(true);
                                        if (value["status"] == "SUCCES") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(value["message"]),
                                            duration:
                                                const Duration(seconds: 2),
                                          ));
                                        } else if (value["status"] == "ECHEC") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(value["erreur"]),
                                            duration:
                                                const Duration(seconds: 2),
                                          ));
                                        }
                                      });
                                    },
                                    child: const Text('Supprimer'),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: const HeroIcon(
                        HeroIcons.trash,
                        color: Colors.red,
                      ),
                    )
                  : const SizedBox(),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(widget.alert.createdAt),
              ),
            ],
          )
        ],
      ),
    );
  }
}
