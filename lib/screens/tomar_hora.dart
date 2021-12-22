// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psicofront/components/bottom_navigator.dart';
import 'package:psicofront/models/horas_disponibles.dart';
import 'package:psicofront/providers/http_provider.dart';
import 'package:psicofront/providers/login_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class TomarHoraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final httpProvider = Provider.of<HttpProvider>(context);
    final loginData = Provider.of<LoginProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Tomar hora",
          ),
          backgroundColor: Colors.deepPurple,
        ),
        bottomNavigationBar: const BottomNavigator(1),
        body: FutureBuilder(
          builder: _calendarBuilder,
          future: httpProvider.getHorasDisponibles(),
        ));
  }

  // ignore: non_constant_identifier_names
  Widget _calendarBuilder(
      BuildContext context, AsyncSnapshot<HorasDisponibles?> snapshot) {
    if (!snapshot.hasData) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return SfCalendar(
      view: CalendarView.month,
      timeZone: 'Pacific SA Standard Time',
      dataSource: MeetingDataSource(_getDataSource(snapshot.data!)),
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
          showAgenda: true),
      appointmentBuilder: (context, appointment) {
        final event2 = appointment.appointments.cast<Meeting>();
        final event = event2.first;
        final hourText = DateFormat('kk:mm').format(event.from) +
            " - " +
            DateFormat('kk:mm').format(event.to);
        return ListTile(
          tileColor: event.background,
          title: Text(event.eventName),
          leading: Text(hourText),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return _ModalContent(
                      hourText: hourText, date: event.from, id: event.id);
                });
          },
        );
      },
    );
  }

  List<Meeting> _getDataSource(HorasDisponibles data) {
    final List<Meeting> meetings = <Meeting>[];
    int index = 0;
    data.horas.forEach((element) {
      final DateTime today = element.fecha;
      final DateTime startTime = element.fecha;
      final DateTime endTime = startTime.add(const Duration(hours: 1));
      meetings.add(Meeting(element.id, 'Disponible', startTime, endTime,
          getRandomColor(), false));
      index++;
    });

    return meetings;
  }
}

class _ModalContent extends StatelessWidget {
  const _ModalContent(
      {Key? key, required this.hourText, required this.date, required this.id})
      : super(key: key);

  final String hourText;
  final String id;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(height: 500, child: _data(context));
  }

  Column _data(BuildContext context) {
    final httpProvider = Provider.of<HttpProvider>(context);
    final loginData = Provider.of<LoginProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        SizedBox(
          height: 50,
        ),
        Text(
          DateFormat("d/M/y").format(date),
          style: TextStyle(fontSize: 40.0),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          hourText,
          style: TextStyle(fontSize: 30.0),
        ),
        Expanded(child: SizedBox()),
        ElevatedButton(
            onPressed: () async {
              await httpProvider.scheduleHour(id);
              Navigator.pushNamed(context, "hours");
            },
            child: Text("Solicitar hora")),
        SizedBox(
          height: 70,
        )
      ],
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.id, this.eventName, this.from, this.to, this.background,
      this.isAllDay);

  String id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

Color getRandomColor() {
  final start = Random(DateTime.now().microsecondsSinceEpoch).nextInt(5);
  final index = Random(DateTime.now().microsecondsSinceEpoch).nextInt(7);
  final colors = [
    Colors.lightBlue.shade300,
    Colors.green.shade200,
    Colors.blue.shade200,
    Colors.deepPurple.shade200,
    Colors.teal.shade200
  ];
  return colors[(index * start) % 5];
}
