import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/models/controle.dart';
import 'package:ctrl_r/screens/pages/controle_position_screen.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

// ignore: must_be_immutable
class ControleContainerWidget extends StatefulWidget {
  Controle controle;
  ControleContainerWidget({super.key, required this.controle});

  @override
  State<ControleContainerWidget> createState() =>
      _ControleContainerWidgetState();
}

class _ControleContainerWidgetState extends State<ControleContainerWidget> {
  @override
  Widget build(BuildContext context) {
    bool allVerificationsTrue = widget.controle.permitConduire == 1 &&
        widget.controle.carteVisiteTechnique == 1 &&
        widget.controle.dateValiditeCarteGrise == 1 &&
        widget.controle.assurance == 1 &&
        widget.controle.tvm == 1;

    return Container(
        // height: context.heightPercent(32),
        width: context.width,
        padding: EdgeInsets.all(context.heightPercent(2)),
        margin: EdgeInsets.symmetric(vertical: context.heightPercent(1)),
        decoration: BoxDecoration(
            color: allVerificationsTrue
                ? const Color(0xffDAF2C9)
                : const Color.fromARGB(255, 241, 205, 205),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Matricule de agent : ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: context.t4,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.controle.matricule,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: context.t4,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: context.heightPercent(1),
              ),
              Row(
                children: [
                  Text(
                    "Numero de plaque : ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: context.t4,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.controle.plaque,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: context.t4,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: context.heightPercent(1),
              ),
              Row(
                children: [
                  Text(
                    "Conducteur : ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: context.t4,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.controle.nomConducteur,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: context.t4,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: context.heightPercent(1),
              ),
              Text(
                "Verifications :",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: context.p1),
              ),
              SizedBox(
                height: context.heightPercent(2),
              ),
              Row(
                children: [
                  OptionContainer(
                      text: "Permit de conduire",
                      isOk: widget.controle.permitConduire),
                  SizedBox(
                    width: context.widthPercent(4),
                  ),
                  OptionContainer(
                      text: "Visite technique",
                      isOk: widget.controle.carteVisiteTechnique),
                ],
              ),
              SizedBox(
                height: context.heightPercent(1),
              ),
              Row(
                children: [
                  OptionContainer(
                      text: "Cart gris",
                      isOk: widget.controle.dateValiditeCarteGrise),
                  SizedBox(
                    width: context.widthPercent(4),
                  ),
                  OptionContainer(text: "TVM", isOk: widget.controle.tvm),
                  SizedBox(
                    width: context.widthPercent(4),
                  ),
                  OptionContainer(
                      text: "Assurance", isOk: widget.controle.assurance),
                ],
              ),
              SizedBox(
                height: context.heightPercent(1),
              ),
              Row(
                children: [
                  Text(
                    "date de verification :",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: context.p1),
                  ),
                  SizedBox(
                    width: context.widthPercent(2),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.controle.createdAt.timeZoneName,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: context.p1),
                      ),
                    ],
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => ControlePositionScreen(
                                    controle: widget.controle,
                                    color: allVerificationsTrue
                ? const Color(0xffDAF2C9)
                : const Color.fromARGB(255, 241, 205, 205)
                                  ))));
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Voir la position",
                          style: TextStyle(color: Colors.black87),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        HeroIcon(HeroIcons.arrowRight, color: Colors.black87)
                      ],
                    )),
              )
            ]));
  }
}

// ignore: must_be_immutable
class OptionContainer extends StatelessWidget {
  String text;
  int isOk;
  OptionContainer({super.key, required this.text, required this.isOk});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.heightPercent(1)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          isOk == 1
              ? const HeroIcon(
                  HeroIcons.check,
                  color: Colors.green,
                )
              : const HeroIcon(
                  HeroIcons.xMark,
                  color: Colors.red,
                )
        ],
      ),
    );
  }
}
