import 'package:ctrl_r/helpers/screen.dart';
import 'package:ctrl_r/helpers/text.dart';
import 'package:ctrl_r/models/user.dart';
import 'package:ctrl_r/providers/role_provider.dart';
import 'package:ctrl_r/screens/pages/admin/admin_home_screen.dart';
import 'package:ctrl_r/screens/pages/home_screen.dart';
import 'package:ctrl_r/screens/widgets/button_widget.dart';
import 'package:ctrl_r/screens/widgets/input_widget.dart';
import 'package:ctrl_r/services/auth_service.dart';
import 'package:ctrl_r/services/local_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController matriculeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context);
    String role = roleProvider.role;
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
                        controller: matriculeController,
                        placeholder: "Votre matricule",
                        error: "Entrez votre matricule",
                        isPassword: false),
                    SizedBox(
                      height: context.heightPercent(2),
                    ),
                    InputWidget(
                        controller: passwordController,
                        placeholder: "Votre mot de passe",
                        error: "Entrez votre mot de passe",
                        isPassword: true),
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
                                AuthService.login(
                                        matricule:
                                            matriculeController.text.trim(),
                                        password: passwordController.text)
                                    .then((value) {
                                  if (value!["status"] == "SUCCES") {
                                    User user = User.fromJson(
                                        value["profile"],
                                        value["access_token"],
                                        value["matricule"],
                                        value["role"]);
                                    setState(() {
                                      isLoad = false;
                                    });
                                    if (value["role"] == role) {
                                      if (value["role"] == "OFFICIER") {
                                        LocalService.saveUserData(user);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const HomeScreen())));
                                      } else if (value["role"] == "ADMIN") {
                                        LocalService.saveUserData(user);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const AdminHomeScreen())));
                                      }
                                    } else {
                                      _showReservedDialog(context, role);
                                    }
                                  } else if (value["status"] == "ECHEC") {
                                    setState(() {
                                      isLoad = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(value["erreur"]),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                });
                                matriculeController.clear();
                                passwordController.clear();
                              }
                            },
                            child: ButtonWidget(text: "Connexion"),
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

  _showReservedDialog(BuildContext context, String role) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Accès réservé"),
          content: Text("Cette partie est réservée aux $role."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
