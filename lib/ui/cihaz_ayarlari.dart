import 'package:elektronik_saglik_platformu_kullanici/data/entity/mySQLBaglan.dart';
import 'package:elektronik_saglik_platformu_kullanici/renkler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mysql_client/mysql_client.dart';

class Cihazayarlari extends StatefulWidget {
  const Cihazayarlari({super.key});

  @override
  State<Cihazayarlari> createState() => _CihazayarlariState();
}

class _CihazayarlariState extends State<Cihazayarlari> {
  var tfHastaAdi = TextEditingController();
  var tfHastaSoyadi = TextEditingController();
  var tfHastaYasi = TextEditingController();
  var tfHastaBoyu = TextEditingController();
  var tfHastaKilosu = TextEditingController();
  var tfHastaMail = TextEditingController();
  late var hastaBmi;
  var hastaMail = TextEditingController();
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


  Future<void> hastaBilgileriKaydet() async{
    final conn = await MySQLConnection.createConnection(
        host: host,
        port: port,
        userName: userName,
        password: password,
        databaseName: databaseName
    );

    await conn.connect();
    double kilo = double.parse(tfHastaKilosu.text);
    double boy = double.parse(tfHastaBoyu.text);
    double bmi = kilo / (boy*boy);
    bmi.toString();
    if(tfHastaBoyu.text != "" && tfHastaKilosu.text != "" && tfHastaMail.text != "" && tfHastaYasi.text != "" && tfHastaSoyadi.text != "" && tfHastaAdi.text != "") {
      await conn.execute("UPDATE hasta_bilgileri SET ad = :gelenIsim, soyad = :gelenSoyisim, yas = :gelenYas, boy = :gelenBoy, kilo = :gelenKilo, bmi = :hesaplananBmi, mail = :gelenMail WHERE id=1",
        {
          "gelenIsim" : tfHastaAdi.text.toUpperCase(),
          "gelenSoyisim" : tfHastaSoyadi.text.toUpperCase(),
          "gelenYas" : tfHastaYasi.text,
          "gelenKilo" : tfHastaKilosu.text,
          "gelenBoy" : tfHastaBoyu.text,
          "hesaplananBmi" : bmi.toString(),
          "gelenMail" : tfHastaMail.text,

        },);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Bilgiler kaydedildi."),
            duration: Duration(seconds: 3),
          ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Boş değer girilemez. Lütfen değer girip tekrar deneyiniz."),
            duration: Duration(seconds: 3),
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      appBar: AppBar(title: Text("HASTA BİLGİLERİ")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: ekranYuksekligi > ekranGenisligi
                                  ? ekranYuksekligi / 14
                                  : ekranGenisligi / 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: solKisimKartArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: Text("HASTA İSİM :", style: TextStyle(color: solKisimYaziRenk, fontWeight: FontWeight.bold),),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: ekranYuksekligi > ekranGenisligi
                                  ? ekranYuksekligi / 14
                                  : ekranGenisligi / 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: sagKisimKartArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: TextField(
                                controller: tfHastaAdi,
                                decoration: InputDecoration(
                                  hintText: "İSİM",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: ekranYuksekligi > ekranGenisligi
                                  ? ekranYuksekligi / 14
                                  : ekranGenisligi / 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: solKisimKartArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: Text("HASTA SOYİSİM :", style: TextStyle(color: solKisimYaziRenk, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: ekranYuksekligi > ekranGenisligi
                                  ? ekranYuksekligi / 14
                                  : ekranGenisligi / 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: sagKisimKartArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: TextField(
                                controller: tfHastaSoyadi,
                                decoration: InputDecoration(
                                  hintText: "SOYİSİM",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Diğer TextFieldler için de benzer şekilde devam edin...
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: ekranYuksekligi > ekranGenisligi
                                  ? ekranYuksekligi / 14
                                  : ekranGenisligi / 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: solKisimKartArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: Text("HASTA BOY :", style: TextStyle(color: solKisimYaziRenk, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: ekranYuksekligi > ekranGenisligi
                                  ? ekranYuksekligi / 14
                                  : ekranGenisligi / 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: sagKisimKartArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: TextField(
                                controller: tfHastaBoyu,
                                decoration: InputDecoration(
                                  hintText: "BOY",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: ekranYuksekligi > ekranGenisligi
                                  ? ekranYuksekligi / 14
                                  : ekranGenisligi / 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: solKisimKartArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: Text("HASTA KİLO :", style: TextStyle(color: solKisimYaziRenk, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: ekranYuksekligi > ekranGenisligi
                                  ? ekranYuksekligi / 14
                                  : ekranGenisligi / 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: sagKisimKartArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: TextField(
                                controller: tfHastaKilosu,
                                decoration: InputDecoration(
                                  hintText: "KİLO",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: ekranYuksekligi > ekranGenisligi
                                  ? ekranYuksekligi / 14
                                  : ekranGenisligi / 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: solKisimKartArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: Text("HASTA YAŞ :", style: TextStyle(color: solKisimYaziRenk, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: ekranYuksekligi > ekranGenisligi
                                  ? ekranYuksekligi / 14
                                  : ekranGenisligi / 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: sagKisimKartArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: TextField(
                                controller: tfHastaYasi,
                                decoration: InputDecoration(
                                  hintText: "YAŞ",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: ekranYuksekligi > ekranGenisligi
                                  ? ekranYuksekligi / 14
                                  : ekranGenisligi / 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: solKisimKartArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: Text("HASTA MAIL :", style: TextStyle(color: solKisimYaziRenk, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: ekranYuksekligi > ekranGenisligi
                                  ? ekranYuksekligi / 14
                                  : ekranGenisligi / 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: sagKisimKartArkaPlan, borderRadius: BorderRadius.circular(8)),
                              child: TextField(
                                controller: tfHastaMail,
                                decoration: InputDecoration(
                                  hintText: "MAIL",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: kaydetArkaPlanRenk,),
                              onPressed: () {
                                print("Kaydet");
                                hastaBilgileriKaydet();
                              },
                              child: Text("KAYDET", style: TextStyle(color: kaydetYazi),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
