import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/models/user.dart';
import 'package:ctrl_r/screens/widgets/button_widget.dart';
import 'package:ctrl_r/screens/widgets/input_widget.dart';
import 'package:ctrl_r/services/local_service.dart';
import 'package:ctrl_r/services/profile_service.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  bool isLoad = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDataInInput();
  }

  loadDataInInput() async {
    User? user = await LocalService.getUserData();

    setState(() {
      nameController.text = user!.name;
      emailController.text = user.email;
      contactController.text = user.contact;
    });
  }

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
                      "Se connecter a votre compte",
                      style: TextStyle(
                          color: Colors.black87, fontSize: context.t3),
                    ),
                    SizedBox(
                      height: context.heightPercent(4),
                    ),
                    InputWidget(
                        controller: nameController,
                        placeholder: "Votre nom",
                        error: "Entrez votre nom",
                        isPassword: false),
                    SizedBox(
                      height: context.heightPercent(2),
                    ),
                    InputWidget(
                        controller: emailController,
                        placeholder: "Votre email",
                        error: "Entrez votre email",
                        isPassword: false),
                    SizedBox(
                      height: context.heightPercent(2),
                    ),
                    InputWidget(
                        controller: contactController,
                        placeholder: "Votre contact",
                        error: "Entrez votre contact",
                        isPassword: false),
                    SizedBox(
                      height: context.heightPercent(2),
                    ),
                    isLoad
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
                                  isLoad = true;
                                });
                                ProfileService.editProfil(
                                        name: nameController.text,
                                        email: emailController.text,
                                        contact: contactController.text)
                                    .then((value) {
                                  if (value!["status"] == "succes") {
                                    setState(() {
                                      isLoad = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(value["message"]),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  } else if (value["status"] == "ECHEC") {
                                    setState(() {
                                      isLoad = false;
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
                            child: ButtonWidget(text: "Sauvegarder"),
                          )
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
