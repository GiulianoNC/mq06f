import 'dart:convert';
// To parse this JSON data, do
//
//     final mq0601 = mq0601FromJson(jsonString);


//List <Mq0601> mq0601FromJson(String str)=> List <Mq0601>.from(json.decode(str).map((x) => Mq0601.fromJson(x)));
List<Mq0601> mq0601FromJson(String str) => (json.decode(str) as List<dynamic>).map((e) => Mq0601.fromJson(e)).toList();

String mq0601ToJson(List<Mq0601> data) => json.encode(data.map((e) => e.toJson()).toList());
//String mq0601ToJson(List<Mq0601> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mq0601 {
  Mq0601ADatareq? mq0601ADatareq;
  String? jdeStatus;
  String? jdeStartTimestamp;
  String? jdeEndTimestamp;
  double? jdeServerExecutionSeconds;

  Mq0601({
      this.mq0601ADatareq,
      this.jdeStatus,
     this.jdeStartTimestamp,
       this.jdeEndTimestamp,
       this.jdeServerExecutionSeconds,
  });

  factory Mq0601.fromJson(Map<String, dynamic> json) => Mq0601(
    mq0601ADatareq: json["MQ0601A_DATAREQ"] == null ? null : Mq0601ADatareq.fromJson(json["MQ0601A_DATAREQ"]),
    jdeStatus: json["jde__status"],
    jdeStartTimestamp: json["jde__startTimestamp"],
    jdeEndTimestamp: json["jde__endTimestamp"],
    jdeServerExecutionSeconds: json["jde__serverExecutionSeconds"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "MQ0601A_DATAREQ": mq0601ADatareq?.toJson(),
    "jde__status": jdeStatus,
    "jde__startTimestamp": jdeStartTimestamp,
    "jde__endTimestamp": jdeEndTimestamp,
    "jde__serverExecutionSeconds": jdeServerExecutionSeconds,
  };
}
List <Mq0601ADatareq>  mQ0601FromJson(String str) => List <Mq0601ADatareq>.from(json.decode(str).map((x) => Mq0601ADatareq.fromJson(x)));

String mQ0601ToJson(List<Mq0601ADatareq> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mq0601ADatareq {
  String? tableId;
  List<Rowset>? rowset;
  int? records;
  bool? moreRecords;

  Mq0601ADatareq({
    this.tableId,
    this.rowset,
    this.records,
    this.moreRecords,
  });

  factory Mq0601ADatareq.fromJson(Map<String, dynamic> json) => Mq0601ADatareq(
    tableId: json["tableId"],
    rowset: json["rowset"] == null ? [] : List<Rowset>.from(json["rowset"]!.map((x) => Rowset.fromJson(x))),
    records: json["records"],
    moreRecords: json["moreRecords"],
  );

  Map<String, dynamic> toJson() => {
    "tableId": tableId,
    "rowset": rowset == null ? [] : List<dynamic>.from(rowset!.map((x) => x.toJson())),
    "records": records,
    "moreRecords": moreRecords,
  };
}

class Rowset {
  late var descEquipo;
  late var ordenNumero;
  late var descripcion;
  late var estado;
  late var ordenTipo;
  late var fechaSolicitud;
  late var caso;
  late var idEquipo;

  Rowset( descEquipo,ordenNumero,descripcion, estado, ordenTipo,  fechaSolicitud,  caso, idEquipo,){
    this.descEquipo= descEquipo;
    this.ordenNumero= ordenNumero;
    this.descripcion = descripcion;
    this.estado = estado;
    this.ordenTipo=  ordenTipo;
    this.fechaSolicitud = fechaSolicitud;
    this.caso = caso;
    this.idEquipo = idEquipo;
  }

   Rowset.fromJson(Map<String, dynamic> json) {
  descEquipo = json["Desc_Equipo"];
  ordenNumero = json["Orden_Numero"];
  descripcion = json["Descripcion"];
  estado = json["estado"];
  ordenTipo = json["Orden_Tipo"];
  fechaSolicitud = json["Fecha_solicitud"];
  caso = json["Caso"];
  idEquipo = json["ID_Equipo"];
}


  Map<String, dynamic> toJson() => {
    "Desc_Equipo": descEquipo,
    "Orden_Numero": ordenNumero,
    "Descripcion": descripcion,
    "Estado": estado,
    "Orden_Tipo": ordenTipo,
    "Fecha_solicitud": fechaSolicitud,
    "Caso": caso,
    "ID_Equipo": idEquipo,
  };
}
