import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/screens/widgets/button_widget.dart';
import 'package:ctrl_r/screens/widgets/input_widget.dart';
import 'package:ctrl_r/services/profile_service.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController lastPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: context.heightPercent(2),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: context.heightPercent(5),
          ),
          Center(
              child: SizedBox(
            width: context.widthPercent(90),
            child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "changer de mot de passe",
                      style: TextStyle(
                          color: Colors.black87, fontSize: context.t3),
                    ),
                    SizedBox(
                      height: context.heightPercent(4),
                    ),
                    InputWidget(
                        controller: lastPasswordController,
                        placeholder: "Votre mot de passe actuel",
                        error: "Entrez votre mot de passe actuel",
                        isPassword: false),
                    SizedBox(
                      height: context.heightPercent(2),
                    ),
                    InputWidget(
                        controller: newPasswordController,
                        placeholder: "Votre nouveau mot de passe",
                        error: "Entrez nouveau votre mot de passe",
                        isPassword: false),
                    SizedBox(
                      height: context.heightPercent(2),
                    ),
                    isLoading
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: context.heightPercent(2)),
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                ProfileService.changePassword(
                                        currentPassword:
                                            lastPasswordController.text,
                                        newPassword: newPasswordController.text)
                                    .then((value) {
                                  if (value!["status"] == "SUCCES") {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(value["erreur"]),
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
                            child: ButtonWidget(text: "Changer"),
                          )
                  ],
                )),
          ))
        ],
      )),
    );
  }
}
