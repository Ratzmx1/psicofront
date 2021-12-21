import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psicofront/providers/http_provider.dart';
import 'package:psicofront/providers/login_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String oldPass = "";
  String newPass = "";
  String newPassConf = "";

  @override
  Widget build(BuildContext context) {
    final httpProvider = Provider.of<HttpProvider>(context);
    final loginprovider = Provider.of<LoginProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cambiar contraseña"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            const Text(
              "Cambiar contraseña",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  oldPass = value;
                });
              },
              obscureText: true,
              decoration: const InputDecoration(hintText: "Contraseña actual"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  newPass = value;
                });
              },
              obscureText: true,
              decoration: const InputDecoration(hintText: "Nueva contraseña"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  newPassConf = value;
                });
              },
              obscureText: true,
              decoration:
                  const InputDecoration(hintText: "Confirme nueva contraseña"),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
          child: Text(
            "Actualizar",
            style: TextStyle(fontSize: 17),
          ),
        ),
        onPressed: () {
          if (newPass != newPassConf) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: const Text("Las contraseñas no coinciden"),
                  actions: [
                    ElevatedButton(
                      child: const Text("Aceptar"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Cambio de contraseña"),
                  content: const Text(
                      "¿Está seguro de que desea cambiar su contraseña?"),
                  actions: [
                    ElevatedButton(
                      child: const Text("Aceptar"),
                      onPressed: () async {
                        final loginData = await loginprovider.loadUser();
                        if (loginData == null) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, "login", (route) => false);
                        }
                        final res = await httpProvider.updatePass(
                            oldPass, newPass, loginData!.token);
                        if (!res!['status']) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: Text(res['message']),
                                actions: [
                                  ElevatedButton(
                                    child: const Text("Aceptar"),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, "profile");
                        }
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Cancelar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
