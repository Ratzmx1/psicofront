import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psicofront/providers/http_provider.dart';
import 'package:psicofront/providers/login_provider.dart';
import 'package:psicofront/screens/change_email.dart';
import 'package:psicofront/screens/change_password.dart';
import 'package:psicofront/screens/login_page.dart';

import 'package:psicofront/screens/mis_horas.dart';
import 'package:psicofront/screens/perfil.dart';
import 'package:psicofront/screens/tomar_hora.dart';

void main() {
  runApp(const ProviderHttp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "login",
      debugShowCheckedModeBanner: false,
      locale: const Locale("es"),
      routes: {
        "login": (_) => LoginScreen(),
        "hours": (_) => MisHorasScreen(),
        "take": (_) => TomarHoraScreen(),
        "profile": (_) => PerfilScreen(),
        "changeEmail": (_) => ChangeEmailScreen(),
        "changePass": (_) => ChangePasswordScreen(),
      },
    );
  }
}

class ProviderHttp extends StatelessWidget {
  const ProviderHttp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HttpProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: MyApp(),
    );
  }
}
