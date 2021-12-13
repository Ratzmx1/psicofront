import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:psicofront/models/login_data.dart';
import 'package:psicofront/providers/http_provider.dart';
import 'package:psicofront/providers/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String formRut = "";
  String formPass = "";

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
        body: Center(
      child: FutureBuilder(
        builder: _loginWidget,
        future: loginProvider.loadUser(),
        initialData: false,
      ),
    ));
  }

  Widget _loginWidget(BuildContext context, AsyncSnapshot<bool> snapshot) {
    if (!snapshot.hasData) {
      const Center(child: CircularProgressIndicator());
    }
    if (snapshot.data == null) {
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, "take");
      });
    } else if (snapshot.data!) {
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, "take");
      });
    }

    final httpProvider = Provider.of<HttpProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    return SizedBox(
      width: 350,
      height: 500,
      child: Card(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const Text(
                    "Iniciar sesion",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onChanged: (data) {
                      setState(() {
                        formRut = data;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Ingrese su rut',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onChanged: (data) {
                      setState(() {
                        formPass = data;
                      });
                    },
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Ingrese su password',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () async {
                      LoginData? data =
                          await httpProvider.loginUser(formRut, formPass);
                      if (data != null) {
                        await loginProvider.saveData(data);
                        Navigator.pushNamed(context, "take");
                      } else {
                        print("Wrong credentials");
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Iniciar sesion"),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
