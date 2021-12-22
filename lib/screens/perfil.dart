import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psicofront/components/bottom_navigator.dart';
import 'package:psicofront/models/login_data.dart';
import 'package:psicofront/providers/login_provider.dart';
import "package:intl/intl.dart";

class PerfilScreen extends StatefulWidget {
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    const textStyle = const TextStyle(fontSize: 19);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Perfil",
        ),
        backgroundColor: Colors.deepPurple,
      ),
      bottomNavigationBar: const BottomNavigator(2),
      body: FutureBuilder(
          future: loginProvider.loadUser(),
          builder: (context, AsyncSnapshot<LoginData?> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      snapshot.data?.usuario != null
                          ? snapshot.data!.usuario.rut
                          : "Loading",
                      style: textStyle,
                    ),
                    Text(
                      snapshot.data?.usuario != null
                          ? snapshot.data!.usuario.nombre
                          : "Loading",
                      style: textStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      snapshot.data?.usuario != null
                          ? snapshot.data!.usuario.correo
                          : "Loading",
                      style: textStyle,
                    ),
                    Text(
                      snapshot.data?.usuario != null
                          ? DateFormat("d/M/yy")
                              .format(snapshot.data!.usuario.nacimiento)
                          : "Loading",
                      style: textStyle,
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "changeEmail");
                  },
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Text(
                      "Actualizar correo",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "changePass");
                  },
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Text(
                      "Actualizar password",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await loginProvider.logout();
                    Navigator.popUntil(context, ModalRoute.withName("login"));
                    Navigator.pushNamed(context, "login");
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
                    child: Text(
                      "Cerrar sesion",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            );
          }),
    );
  }
}

Color getRandomColor(int index) {
  final start = Random(DateTime.now().microsecondsSinceEpoch).nextInt(4);

  final colors = [
    Colors.lightBlue.shade300,
    Colors.green.shade200,
    Colors.blue.shade200,
    Colors.deepPurple.shade200,
    Colors.teal.shade200
  ];
  return colors[(index + start) % 5];
}