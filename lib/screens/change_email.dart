import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psicofront/providers/http_provider.dart';
import 'package:psicofront/providers/login_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ChangeEmailScreen extends StatefulWidget {
  ChangeEmailScreen({Key? key}) : super(key: key);

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  String inputEmail = "";
  String inputConfirmEmail = "";

  @override
  Widget build(BuildContext context) {
    final httpProvider = Provider.of<HttpProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Actualizar Correo",
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, bottom: 30),
            child: Text(
              "Actualizar correo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Nuevo correo',
              ),
              onChanged: (value) {
                setState(() {
                  inputEmail = value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Confirme nuevo correo',
              ),
              onChanged: (value) {
                setState(() {
                  inputConfirmEmail = value;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          if (inputEmail == "" || inputConfirmEmail == "") {
            Alert(
              context: context,
              type: AlertType.error,
              title: "Falta informacion",
              buttons: [
                DialogButton(
                  child: const Text(
                    "Cerrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                )
              ],
            ).show();
            return;
          }
          if (inputEmail != inputConfirmEmail) {
            Alert(
              context: context,
              type: AlertType.error,
              title: "Los correos deben ser iguales",
              buttons: [
                DialogButton(
                  child: const Text(
                    "Cerrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                )
              ],
            ).show();
            return;
          }

          final user =
              await httpProvider.updateEmail(inputEmail, loginProvider.token);
          Alert(
            context: context,
            type: AlertType.success,
            title: "Cambiado correctamente",
            buttons: [
              DialogButton(
                child: const Text(
                  "Cerrar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show().whenComplete(
              () => Navigator.pushReplacementNamed(context, "take"));
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
          child: Text(
            "Actualizar",
            style: TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }
}
