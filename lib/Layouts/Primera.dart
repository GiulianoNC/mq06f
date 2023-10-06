
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mq06f/Herramientas/global.dart';
import 'package:mq06f/Herramientas/variables_globales.dart';
import 'package:http/http.dart' as http;

String baseUrl = direc;
String ordenTipo = "";
String estado = "";
String ordenN = "";

class Primera extends StatefulWidget {
  @override
  State<Primera> createState() => _PrimeraState();
}

class _PrimeraState extends State<Primera> {
  late String api = "jderest/v3/orchestrator/MQ0601A_ORCH";
  late String api2 = "jderest/v3/orchestrator/MQ0602A_ORCH";

  late Future<List<Map<String, dynamic>>>? _listado;
  List<String> ordenNumeros = [];

  Future<List<Map<String, dynamic>>> obtenerRowset() async {
    var url = Uri.parse(baseUrl + api);
    var _payload = json.encode({
      "username": usuarioGlobal,
      "password": contraGlobal,
      "Solicitante": solicitanteG,
      "Estado_Aprobado": estadoAprobacionG,
      "Estado_1": esta1G,
      "Estado_2": esta2G,
      "Estado_3": esta3G,
      "Estado_4": esta4G,
      "Estado_5": esta5G,
      "Estado_6": esta6G,
    });
    var _headers = {
      "Authorization": autorizacionGlobal,
      'Content-Type': 'application/json',
    };

    var response = await http.post(url, headers: _headers).timeout(Duration(seconds: 60));

    final jsonData = jsonDecode(response.body);
    final rowset = jsonData['MQ0601A_DATAREQ']['rowset'];
    return List<Map<String, dynamic>>.from(rowset);
  }

  Future<List<String>> obtenerOrdenNumeros() async {
    final rowsetData = await obtenerRowset();
    List<String> ordenNumeros = [];
    for (var item in rowsetData) {
      ordenNumeros.add(item['Orden_Numero'].toString());

    }

    return ordenNumeros;
  }


  @override
  void initState() {
    super.initState();
    _listado = obtenerRowset();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[
                  Color.fromRGBO(102, 45, 145, 30),
                  Color.fromRGBO(212, 20, 90, 50),
                ],
              ),
            ),
          ),
          title:
          Container(
            margin: EdgeInsets.fromLTRB(5, 22, 20, 10),
            //padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            // alignment: Alignment.center,
            child: Image.asset("images/nombre.png",
              width: 150,
              height: 50,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(0.0),
              child: IconButton(
                icon: Image.asset('images/icono_flecha.png', height: 320,),
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20.0),
            child: const SizedBox(),
          ),
        ),
        body: FutureBuilder<List<String>>(
          future: obtenerOrdenNumeros(),
          builder: (context, snapshotOrdenes) {
            if (snapshotOrdenes.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshotOrdenes.hasError) {
              return Center(
                child: Text('Error: check configuration or Login ${snapshotOrdenes.error}'),
              );
            } else {
              final ordenNumeros = snapshotOrdenes.data;
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: obtenerRowset(),
                builder: (context, snapshotDatos) {
                  if (snapshotDatos.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshotDatos.hasError) {
                    return Center(
                      child: Text('Error: ${snapshotDatos.error}'),
                    );
                  } else {
                    final rowsetData = snapshotDatos.data;
                    return GridView.count(
                      crossAxisCount: 2, // Número de columnas que deseas mostrar
                      children: List.generate(ordenNumeros?.length ?? 0, (index) {
                        final ordenNumero = ordenNumeros![index];
                        final rowData = rowsetData![index]; // Datos correspondientes a la orden actual
                       return Column(
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0.0),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () async{
                                // Acción a realizar cuando se presione el botón
                                // Puedes agregar tu lógica aquí
                                ordenTipo = rowData['Orden_Tipo'];
                                ordenN = rowData['Orden_Numero'];

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      bool isApproving = false; // Variable para rastrear si se está aprobando

                                      return AlertDialog(
                                        title: Text('Orden  N°$ordenN'),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(212 , 20, 90, 50)),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                            child: Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(212 , 20, 90, 50)),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                            child: Text('Aprobar'),
                                            onPressed: () async {
                                              // Aquí puedes hacer lo que quieras con el texto ingresado
                                              var baseUrl =  direc;
                                              late String api = "/jderest/v3/orchestrator/MQ0602A_ORCH";
                                              var url = Uri.parse(baseUrl + api);

                                              var _payload =  json.encode (
                                                  {
                                                    "username": user,
                                                    "password": pass,
                                                    "Orden_Tipo": ordenTipo,
                                                    "Orden_Numero": ordenN,
                                                    "Estado": estadoAprobacionG
                                                  });

                                              var _headers = {
                                                "Authorization" : autorizacionGlobal,
                                                'Content-Type': 'application/json',
                                              };
                                              var response = await http.post(url, headers: _headers).timeout(Duration(seconds: 60));
                                              respuesta =response.body.toString();

                                              print("este es el status " + response.statusCode.toString());

                                              print ( estadoAprobacionG );
                                              setState(() {
                                                // Aquí puedes recargar los datos o realizar una nueva solicitud HTTP si es necesario
                                                 _listado = obtenerRowset(); // Si necesitas recargar los datos

                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Ink(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color.fromRGBO(212, 20, 90, 50), Color.fromRGBO(102, 45, 145, 50)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  constraints: const BoxConstraints(minWidth: 88.0),
                                  child: Text(ordenNumero, textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(" ${rowData['Orden_Tipo']}" + " | ${rowData['Desc_Equipo']}"+ " | ${rowData['Estado']}", textAlign: TextAlign.center,),
                            // Text(" ${rowData['Desc_Equipo']}"),
                            Text("Fecha Solicitud: ${rowData['Fecha_solicitud']}", textAlign: TextAlign.center,),
                            Text(" ${rowData['Descripcion']}",style: TextStyle(
                        fontSize: 12.0,
                        ), textAlign: TextAlign.center,),
                            Text("Caso: ${rowData['Caso']}"),
                            Divider(),
                          ],
                        );
                      }),
                    );


                  /*   return ListView.builder(
                      itemCount: ordenNumeros?.length ?? 0,
                      itemBuilder: (context, index) {
                        final ordenNumero = ordenNumeros![index];
                        final rowData = rowsetData![index]; // Datos correspondientes a la orden actual
                        return Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0.0),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () async{
                                // Acción a realizar cuando se presione el botón
                                // Puedes agregar tu lógica aquí
                                ordenTipo = rowData['Orden_Tipo'];
                                ordenN = rowData['Orden_Numero'];

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      bool isApproving = false; // Variable para rastrear si se está aprobando

                                      return AlertDialog(
                                        title: Text('Orden  N°$ordenN'),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(212 , 20, 90, 50)),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                            child: Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(212 , 20, 90, 50)),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                            child: Text('Aprobar'),
                                            onPressed: () async {
                                              // Aquí puedes hacer lo que quieras con el texto ingresado
                                              var baseUrl =  direc;
                                              late String api = "/jderest/v3/orchestrator/MQ0602A_ORCH";
                                              var url = Uri.parse(baseUrl + api);

                                              var _payload =  json.encode (
                                                  {
                                                    "username": user,
                                                    "password": pass,
                                                    "Orden_Tipo": ordenTipo,
                                                    "Orden_Numero": ordenN,
                                                    "Estado": estadoAprobacionG
                                                  });

                                              var _headers = {
                                                "Authorization" : autorizacionGlobal,
                                                'Content-Type': 'application/json',
                                              };
                                              var response = await http.post(url, body: _payload, headers: _headers);
                                              respuesta =response.body.toString();

                                              print("este es el status " + response.statusCode.toString());

                                              print ( estadoAprobacionG );
                                              setState(() {
                                                // Aquí puedes recargar los datos o realizar una nueva solicitud HTTP si es necesario
                                                 _listado = obtenerRowset(); // Si necesitas recargar los datos

                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Ink(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color.fromRGBO(212, 20, 90, 50), Color.fromRGBO(102, 45, 145, 50)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  constraints: const BoxConstraints(minWidth: 88.0),
                                  child: Text(ordenNumero, textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(" ${rowData['Orden_Tipo']}" + " | ${rowData['Desc_Equipo']}"),
                           // Text(" ${rowData['Desc_Equipo']}"),
                            Text("Fecha Solicitud: ${rowData['Fecha_solicitud']}"),
                            Text(" ${rowData['Descripcion']}"+ "  | Caso: ${rowData['Caso']}"),
                            //Text("Caso: ${rowData['Caso']}"),
                            Divider(),
                          ],
                        );
                      },
                    );*/
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}

