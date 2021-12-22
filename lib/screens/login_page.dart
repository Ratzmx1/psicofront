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
      ),
    ));
  }

  Widget _loginWidget(
      BuildContext context, AsyncSnapshot<LoginData?> snapshot) {
    if (!snapshot.hasData) {
      const Center(child: CircularProgressIndicator());
    }

    if (snapshot.data?.token != null) {
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
                        if (data.usuario.tipo == "CLIENTE") {
                          await loginProvider.saveData(data);
                          Navigator.pushReplacementNamed(context, "take");
                        } else {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Usuario no autorizado'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: const Text('Ok'),
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, "login");
                                      },
                                    ),
                                  ],
                                );
                              });

                          Navigator.pushReplacementNamed(context, "login");
                        }
                      } else {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'Usuario o contraseña incorrectos'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, "login");
                                    },
                                  ),
                                ],
                              );
                            });
                        Navigator.pushReplacementNamed(context, "login");
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
