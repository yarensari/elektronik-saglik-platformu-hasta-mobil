import 'package:elektronik_saglik_platformu_kullanici/data/entity/doktorNotlariDegerler.dart';
import 'package:elektronik_saglik_platformu_kullanici/data/entity/mySQLBaglan.dart';
import 'package:elektronik_saglik_platformu_kullanici/renkler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql_client/mysql_client.dart';

class DoktorNotlari extends StatefulWidget {
  const DoktorNotlari({super.key});

  @override
  State<DoktorNotlari> createState() => _DoktorNotlariState();
}

class _DoktorNotlariState extends State<DoktorNotlari> {
  late String host;
  late int port;
  late String userName;
  late String password;
  late String databaseName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MySQLBaglan baglan = MySQLBaglan();
    host = baglan.getHost();
    port = baglan.getPort();
    userName = baglan.getUserName();
    password = baglan.getPassword();
    databaseName = baglan.getDatabaseName();
  }

  Future<List<DoktorNotlariDegerler>> verileriCek() async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: userName,
      password: password,
      databaseName: databaseName, // optional
    );

    await conn.connect();

    print("Connected");

    var mesajBilgisiListe = <DoktorNotlariDegerler>[];
    var dataMesajBilgisi = await conn.execute("SELECT * FROM doktor_notlari ORDER BY date DESC");
    for(final row in dataMesajBilgisi.rows) {
      var gelenDate = DateTime.parse(row.colByName("date").toString());
      var format = DateFormat('dd-MM-yyyy HH:mm');
      var guncellenmisDate = format.format(gelenDate);
      var data = DoktorNotlariDegerler(id: row.colByName("id").toString(), mesaj: row.colByName("mesaj").toString(), tarih: guncellenmisDate);
      mesajBilgisiListe.add(data);
    }
    return mesajBilgisiListe;
  }
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Gönderilen Notlar"), backgroundColor: arkaPlan,),
      body: Container(
        decoration: BoxDecoration(color: arkaPlan),
        child: FutureBuilder<List<DoktorNotlariDegerler>>(
          future: verileriCek(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              var mesajlarListesi = snapshot.data;
              return ListView.builder(
                  itemCount: mesajlarListesi!.length,
                  itemBuilder: (context, indeks){
                    var mesaj = mesajlarListesi[indeks];
                    return Card(
                        color: gelenDoktorNotlariKart,
                            child:
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(mesaj.mesaj, style: TextStyle(color: gelenDoktorNotlariYazi),),
                                  Row(
                                    children: [
                                      Text("Gönderilme Tarihi : " ,style: TextStyle(color: gelenDoktorNotlariKart, fontWeight: FontWeight.bold),),
                                      Text(mesaj.tarih, style: TextStyle(color: gelenDoktorNotlariYazi),),
                                    ],
                                  )
                                ],
                              ),
                            ),
                    );
                  }
              );
            }else {
              return const Center();
            }
          },
        ),
      ),
    );
  }
}