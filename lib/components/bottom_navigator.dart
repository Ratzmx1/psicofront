// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class BottomNavigator extends StatelessWidget {
  final int id;
  const BottomNavigator(this.id);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.deepPurple,
      fixedColor: Colors.white,
      // ignore: prefer_const_literals_to_create_immutables
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Mis Horas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Tomar Hora',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
      currentIndex: id,
      onTap: (int a) {
        switch (a) {
          case 0:
            Navigator.pushReplacementNamed(context, "hours");
            break;
          case 1:
            Navigator.pushReplacementNamed(context, "take");
            break;
          case 2:
            Navigator.pushReplacementNamed(context, "profile");
            break;
          default:
            break;
        }
      },
    );
  }
}


