import 'package:elektronik_saglik_platformu_kullanici/data/entity/mySQLBaglan.dart';
import 'package:elektronik_saglik_platformu_kullanici/data/entity/olcumDegerleri.dart';
import 'package:elektronik_saglik_platformu_kullanici/renkler.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:intl/intl.dart';

class SolunumListe extends StatefulWidget {
  const SolunumListe({super.key});

  @override
  State<SolunumListe> createState() => _SolunumListeState();
}

class _SolunumListeState extends State<SolunumListe> {
  String secim = "BÜTÜN SONUÇLAR";
  var secimler = <String>[];
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

    var atesBilgisiListe = <OlcumDegerleri>[];
    String butunDegerler = "SELECT * FROM test_res ORDER BY date";
    String hafta1 = "SELECT * FROM test_res WHERE date >= DATE_SUB(NOW(), INTERVAL 1 WEEK)";
    String hafta2 = "SELECT * FROM test_res WHERE date >= DATE_SUB(NOW(), INTERVAL 2 WEEK)";
    String hafta3 = "SELECT * FROM test_res WHERE date >= DATE_SUB(NOW(), INTERVAL 3 WEEK)";
    String ay1 = "SELECT * FROM test_res WHERE date >= DATE_SUB(NOW(), INTERVAL 1 MONTH)";

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

    var dataAtesBilgisi = await conn.execute(sorgu);
    for (final row in dataAtesBilgisi.rows) {
      var gelenDate = DateTime.parse(row.colByName("date").toString());
      var format = DateFormat('dd-MM-yyyy HH:mm');
      var guncellenmisDate = format.format(gelenDate);
      var data = OlcumDegerleri(
          ates: "ates",
          solunum: row.colByName("res").toString(),
          nabiz: "nabiz",
          spo2: "spo2",
          sys: "sys",
          dia: "dia",
          gun: guncellenmisDate);
      print(data.ates);
      print(data.gun);
      atesBilgisiListe.add(data);
    }

    return atesBilgisiListe;
  }
  @override
  Widget build(BuildContext context) {
    print("build secim : $secim");
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
        appBar: AppBar(title: Text("Solunum Liste Sonuçları"), backgroundColor: arkaPlan,),
        body: Column(
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
            Expanded(
              child: FutureBuilder<List<OlcumDegerleri>>(
                future: verileriCek(secim),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var verilerListesi = snapshot.data;
                    return ListView.builder(
                        itemCount: verilerListesi!.length,
                        itemBuilder: (context, indeks){
                          var deger = verilerListesi[indeks];
                          return Card(
                              color: listeArkaPlan,
                              child: SizedBox(
                                  height: ekranYuksekligi/8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("ÖLÇÜLEN DEĞER   : ${deger.solunum}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: listeYazi),),
                                        Text("ÖLÇÜLDÜĞÜ TARİH : ${deger.gun}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: listeYazi),)
                                      ],
                                    ),
                                  )
                              )
                          );
                        }
                    );
                  }else{
                    return const Center();
                  }
                },
              ),
            ),
          ],
        )
    );
  }
}
