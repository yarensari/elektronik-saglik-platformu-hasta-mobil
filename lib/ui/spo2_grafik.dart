import 'package:elektronik_saglik_platformu_kullanici/data/entity/mySQLBaglan.dart';
import 'package:elektronik_saglik_platformu_kullanici/data/entity/olcumDegerleri.dart';
import 'package:elektronik_saglik_platformu_kullanici/renkler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Spo2Grafik extends StatefulWidget {
  const Spo2Grafik({super.key});

  @override
  State<Spo2Grafik> createState() => _Spo2GrafikState();
}

class _Spo2GrafikState extends State<Spo2Grafik> {
  String secim = "BÜTÜN SONUÇLAR";
  var secimler = <String>[];
  var spo2GrafikBilgisi = <OlcumDegerleri>[];
  late String host;
  late int port;
  late String userName;
  late String password;
  late String databaseName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secimler.add("BÜTÜN SONUÇLAR");
    secimler.add("1 HAFTA");
    secimler.add("2 HAFTA");
    secimler.add("3 HAFTA");
    secimler.add("1 AY");
    MySQLBaglan baglan = MySQLBaglan();
    host = baglan.getHost();
    port = baglan.getPort();
    userName = baglan.getUserName();
    password = baglan.getPassword();
    databaseName = baglan.getDatabaseName();
  }

  Future<List<OlcumDegerleri>> verileriCek(String sinirlama) async{
    print("Connecting to mysql server...");

    // create connection
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: userName,
      password: password,
      databaseName: databaseName, // optional
    );

    await conn.connect();

    print("Connected");
    print("verileriCek secim : $secim");

    String butunDegerler = "SELECT * FROM test_spo2 ORDER BY date";
    String hafta1 = "SELECT * FROM test_spo2 WHERE date >= DATE_SUB(NOW(), INTERVAL 1 WEEK) ORDER BY date DESC";
    String hafta2 = "SELECT * FROM test_spo2 WHERE date >= DATE_SUB(NOW(), INTERVAL 2 WEEK) ORDER BY date DESC";
    String hafta3 = "SELECT * FROM test_spo2 WHERE date >= DATE_SUB(NOW(), INTERVAL 3 WEEK) ORDER BY date DESC";
    String ay1 = "SELECT * FROM test_spo2 WHERE date >= DATE_SUB(NOW(), INTERVAL 1 MONTH) ORDER BY date DESC";

    String sorgu = "";
    if(sinirlama == "BÜTÜN SONUÇLAR") {
      sorgu = butunDegerler;
    }else if(sinirlama == "1 HAFTA") {
      sorgu = hafta1;
    }else if(sinirlama == "2 HAFTA") {
      sorgu = hafta2;
    }else if(sinirlama == "3 HAFTA") {
      sorgu = hafta3;
    }else if(sinirlama == "1 AY"){
      sorgu = ay1;
    }

    var dataSpo2Bilgisi = await conn.execute(sorgu);
    spo2GrafikBilgisi.clear();
    for (final row in dataSpo2Bilgisi.rows) {
      var gelenDate = DateTime.parse(row.colByName("date").toString());
      var format = DateFormat('dd-MM-yyyy HH:mm');
      var guncellenmisDate = format.format(gelenDate);
      var data = OlcumDegerleri(
          ates: "ates",
          solunum: "solunum",
          nabiz: row.colByName("pulse").toString(),
          spo2: row.colByName("spo2").toString(),
          sys: "sys",
          dia: "dia",
          gun: guncellenmisDate
      );
      spo2GrafikBilgisi.add(data);
    }

    return spo2GrafikBilgisi;
  }
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
        appBar: AppBar(title: const Text("Grafik Sonuçları"),),
        body: SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(
                  height: ekranYuksekligi/100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: ekranYuksekligi/20,
                      decoration: BoxDecoration(color: butunSonuclarArkaPlan, borderRadius: BorderRadius.circular(8.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        child: DropdownButton(
                            value: secim,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: secimler.map((sec) {
                              return DropdownMenuItem(
                                value: sec,
                                child: Text(sec, style: TextStyle(color: butunSonuclarYazi, fontWeight: FontWeight.bold, fontSize: 12),),
                              );
                            }).toList(),
                            onChanged: (veri) {
                              setState(() {
                                secim = veri!;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                SafeArea(
                  child: FutureBuilder<List<OlcumDegerleri>>(
                    future: verileriCek(secim),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var veriler = snapshot.data;
                        return SfCartesianChart(
                            primaryXAxis: CategoryAxis(
                              labelRotation: 90,),
                            title: const ChartTitle(
                              text: "SPO2 ve NABIZ",
                              textStyle: TextStyle(fontSize: 25),
                            ),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            legend: Legend(isVisible: true),
                            series: <LineSeries<OlcumDegerleri, String>>[
                              LineSeries(
                                name: "Spo2",
                                color: grafikSonuclariRenklerSpo2,
                                dataSource: spo2GrafikBilgisi,
                                xValueMapper: (OlcumDegerleri data, _) => data.gun,
                                yValueMapper: (OlcumDegerleri data, _) => double.parse(data.spo2),
                                dataLabelSettings: const DataLabelSettings(isVisible: true),
                                markerSettings: MarkerSettings(
                                  isVisible: true,
                                  shape: DataMarkerType.circle,
                                  height: 10,
                                  width: 10,
                                  borderColor: grafikSonuclariRenklerSpo2,
                                  borderWidth: 2,
                                  color: grafikSonuclariRenklerSpo2,
                                ),
                              ),
                              LineSeries(
                                name: "Nabız",
                                color: grafikSonuclariNabiz,
                                dataSource: spo2GrafikBilgisi,
                                xValueMapper: (OlcumDegerleri data, _) => data.gun,
                                yValueMapper: (OlcumDegerleri data, _) => double.parse(data.nabiz),
                                dataLabelSettings: const DataLabelSettings(isVisible: true),
                                markerSettings: MarkerSettings(
                                  isVisible: true,
                                  shape: DataMarkerType.circle,
                                  height: 10,
                                  width: 10,
                                  borderColor: grafikSonuclariNabiz,
                                  borderWidth: 2,
                                  color: grafikSonuclariNabiz,
                                ),
                              ),
                            ]
                        );
                      }else {
                        return const Center();
                      }
                    },
                  ),
                ),
              ]),
        )
    );
  }
}