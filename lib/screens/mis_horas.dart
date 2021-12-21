import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psicofront/components/bottom_navigator.dart';
import 'package:psicofront/models/hora_detalle.dart';
import 'package:psicofront/models/mi_historial.dart';
import 'package:psicofront/providers/http_provider.dart';
import 'package:intl/intl.dart';
import 'package:psicofront/providers/login_provider.dart';

class MisHorasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HttpProvider>(context);
    final loginData = Provider.of<LoginProvider>(context);
    
  
      
    
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Mis Horas",
          ),
          backgroundColor: Colors.deepPurple,
        ),
        bottomNavigationBar: const BottomNavigator(0),
        body: FutureBuilder(
          future: provider.getHistorial(),
          builder: (BuildContext context, AsyncSnapshot<MiHistorial?> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!.horas;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final date = data[index].fecha;
                    return ListTile(
                      title: Text(DateFormat("d/M/yy").format(date)),
                      subtitle: Text(DateFormat("h:m").format(date)),
                      trailing: data[index].pagado
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.cancel,
                              color: Colors.red.shade700,
                            ),
                      onTap: () {
                        final id = data[index].id;
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 500,
                                child: FutureBuilder(
                                  future:
                                      provider.getDetail(id),
                                  builder: _futureBuilder,
                                ),
                              );
                            });
                      },
                    );
                  },
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }

  Widget _futureBuilder(
      BuildContext context, AsyncSnapshot<HoraDetalle?> snapshot) {
    final provider = Provider.of<HttpProvider>(context);
    final loginData = Provider.of<LoginProvider>(context);

    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = snapshot.data!.hora;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          const SizedBox(height: 30),
          Center(
            child: Text(
              DateFormat("d/M/yy").format(data.fecha),
              style: TextStyle(fontSize: 40.0),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              DateFormat("h:m").format(data.fecha),
              style: TextStyle(fontSize: 30.0),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (data.descripcion != "") ...[
            Card(
              elevation: 7,
              child: SizedBox(
                child: Center(
                  child: Text(data.descripcion),
                ),
                width: 450,
                height: 150,
              ),
            ),
            SizedBox(
              height: 55,
            ),
          ] else ...[
            SizedBox(
              height: 150,
            )
          ],
          if (data.fecha.compareTo(DateTime.now()) >= 0) ...[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: const Padding(
                child: Text(
                  "Cancelar",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () async {
                await provider.cancelHour(data.id);
                Navigator.pushReplacementNamed(context, "hours");
              },
            ),
            const SizedBox(
              height: 15,
            ),
          ],
          ElevatedButton(
            child: const Padding(
              child: Text(
                "Cerrar",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
