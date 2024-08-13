import 'package:elektronik_saglik_platformu_kullanici/data/entity/hastaBilgileri.dart';
import 'package:elektronik_saglik_platformu_kullanici/data/entity/mySQLBaglan.dart';
import 'package:elektronik_saglik_platformu_kullanici/data/entity/olcumDegerleri.dart';
import 'package:elektronik_saglik_platformu_kullanici/main.dart';
import 'package:elektronik_saglik_platformu_kullanici/renkler.dart';
import 'package:elektronik_saglik_platformu_kullanici/ui/cihaz_ayarlari.dart';
import 'package:elektronik_saglik_platformu_kullanici/ui/doktor_notlari.dart';
import 'package:elektronik_saglik_platformu_kullanici/ui/gecmis_degerler.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mysql_client/mysql_client.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  var gelenHastaBilgileri = Hastabilgileri(isim: "isim", soyisim: "soyisim", yas: "yas", boy: "boy", kilo: "kilo", bmi: "bmi");
  var tfDegerAtes = TextEditingController();
  var tfDegerSpo2 = TextEditingController();
  var tfDegerNabiz = TextEditingController();
  var tfDegerDia = TextEditingController();
  var tfDegerSys = TextEditingController();
  var tfDegerSolunum = TextEditingController();
  var gelenDegerler = OlcumDegerleri(ates: "", solunum: "", nabiz: "", spo2: "", sys: "", dia: "", gun: "");
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
    verileriCek();
  }


  Future<void> verileriCek() async {
    final conn = await MySQLConnection.createConnection(
        host: host,
        port: port,
        userName: userName,
        password: password,
        databaseName: databaseName
    );

    await conn.connect();

    var dataHastaBilgileri = await conn.execute("SELECT * FROM hasta_bilgileri WHERE id=1");

    setState(() {
      for(final row in dataHastaBilgileri.rows) {
        gelenHastaBilgileri.isim = row.colByName("ad").toString();
        gelenHastaBilgileri.soyisim = row.colByName("soyad").toString();
        gelenHastaBilgileri.yas = row.colByName("yas").toString();
        gelenHastaBilgileri.kilo = row.colByName("kilo").toString();
        gelenHastaBilgileri.boy = row.colByName("boy").toString();
        gelenHastaBilgileri.bmi = row.colByName("bmi").toString();
      }
    });

    await conn.close();
  }
  
  Future<void> veriyiKaydet() async {
    final conn = await MySQLConnection.createConnection(
        host: host,
        port: port,
        userName: userName,
        password: password,
        databaseName: databaseName
    );

    await conn.connect();


    if(gelenDegerler.ates != "") {
      print("ateş : ${gelenDegerler.ates}");
      await conn.execute("INSERT INTO test_ates (fever, date) VALUES (:gelenAtes, :gelenDate)",
    {
      "gelenAtes" : gelenDegerler.ates,
      "gelenDate" : DateTime.now(),
    },);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ateş değeri kaydedilmiştir."),
          duration: Duration(seconds: 3),
        ),
      );
      gelenDegerler.ates = "";
      print("ateş : ${gelenDegerler.ates}");
    }else if(gelenDegerler.spo2 != "" && gelenDegerler.nabiz != "") {
      print("sys : ${gelenDegerler.spo2}");
      print("sys : ${gelenDegerler.nabiz}");
      await conn.execute("INSERT INTO test_spo2 (spo2, pulse, date) VALUES (:gelenSpo2, :gelenNabiz, :gelenDate)",
        {
          "gelenSpo2" : gelenDegerler.spo2,
          "gelenNabiz" : gelenDegerler.nabiz,
          "gelenDate" : DateTime.now(),
        },);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Spo2 ve Nabız değeri kaydedilmiştir."),
          duration: Duration(seconds: 3),
        ),
      );
      gelenDegerler.spo2 = "";
      gelenDegerler.nabiz = "";
      print("sys : ${gelenDegerler.spo2}");
      print("sys : ${gelenDegerler.nabiz}");
    }else if(gelenDegerler.solunum != "") {
      print("solunum : ${gelenDegerler.solunum}");
      await conn.execute("INSERT INTO test_res (res, date) VALUES (:gelenSolunum, :gelenDate)",
        {
          "gelenSolunum" : gelenDegerler.solunum,
          "gelenDate" : DateTime.now(),
        },);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Solunum değeri kaydedilmiştir."),
          duration: Duration(seconds: 3),
        ),
      );
      gelenDegerler.solunum = "";
      print("solunum : ${gelenDegerler.solunum}");
    }else if(gelenDegerler.sys != "" && gelenDegerler.dia != "") {
      print("sys : ${gelenDegerler.sys}");
      await conn.execute("INSERT INTO test_tansiyon (sys, dia, date) VALUES (:gelenSys, :gelenDia, :gelenDate)",
        {
          "gelenSys" : gelenDegerler.sys,
          "gelenDia" : gelenDegerler.dia,
          "gelenDate" : DateTime.now(),
        },);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sys ve Dia değeri kaydedilmiştir."),
          duration: Duration(seconds: 3),
        ),
      );
      gelenDegerler.sys = "";
      gelenDegerler.dia = "";
      print("sys : ${gelenDegerler.sys}");
      print("dia : ${gelenDegerler.dia}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Boş değer girilemez. Lütfen değer girip tekrar deneyiniz."),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> mailYolla() async {
    final conn = await MySQLConnection.createConnection(
        host: host,
        port: port,
        userName: userName,
        password: "sifre",
        databaseName: databaseName
    );

    await conn.connect();

    print("Connected");
    var gonderilecekMailAdresi;
    var dataMail = await conn.execute("SELECT mail FROM hasta_bilgileri WHERE id=1");
    for(final row in dataMail.rows){
      gonderilecekMailAdresi = row.colByName("mail");
    }
    String username = 'derscalisiyorum2018@gmail.com';
    String password = 'wxdv srhi ohnj zvdh';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Elektronik Sağlık Platformu')
      ..recipients.add(gonderilecekMailAdresi)
      ..subject = 'ACİL DURUM '
      ..text = 'ACİL DURUM MESAJI : Hastanın durumu kritik. Lütfen iletişime geçiniz.';

    try {
      await send(message, smtpServer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Acil durum mailiniz başarıyla gönderildi."),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print("hata");
    }
  }


    @override
    Widget build(BuildContext context) {
      var ekranBilgisi = MediaQuery.of(context);
      final double ekranYuksekligi = ekranBilgisi.size.height;
      final double ekranGenisligi = ekranBilgisi.size.width;
      print(ekranYuksekligi);
      print(ekranGenisligi);
      print(gelenHastaBilgileri.isim);
      return Scaffold(
        appBar: AppBar(title: const Text("Elektronik Sağlık Platformu"),
          backgroundColor: arkaPlan,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: arkaPlan),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: ekranGenisligi / 100, right: ekranGenisligi / 100, bottom: ekranYuksekligi / 60),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: hastaBilgileriGenelArkaPlan,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 75, height: 75, child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset("resimler/user.png"),
                          )),
                          Padding(
                              padding: EdgeInsets.only(right: ekranGenisligi / 18),
                              child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: ekranYuksekligi / 75),
                                    child: Text("HASTA BİLGİLERİ", style: TextStyle(color: hastaBilgileriYaziRenk, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                  Text("İSİM: ${gelenHastaBilgileri.isim}", style: TextStyle(color: hastaBilgileriYaziRenk, fontSize: 10, fontWeight: FontWeight.bold),),
                                  Text("SOYİSİM: ${gelenHastaBilgileri.soyisim}", style: TextStyle(color: hastaBilgileriYaziRenk, fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              )
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: hastaBilgileriAyrintiArkaPlan,
                                        borderRadius: BorderRadius.circular(8)),
                                    height: ekranYuksekligi < 500 ? ekranGenisligi / 45 : ekranYuksekligi / 45,
                                    width: ekranGenisligi > 360 ? ekranYuksekligi / 3 : ekranGenisligi / 6,
                                    child: Text("YAŞ: ${gelenHastaBilgileri.yas}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: hastaBilgileriAyrintiYaziRenk),
                                      textAlign: TextAlign.center,),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(color: hastaBilgileriAyrintiArkaPlan,
                                        borderRadius: BorderRadius.circular(8)),
                                    height: ekranYuksekligi < 500 ? ekranGenisligi / 45 : ekranYuksekligi / 45,
                                    width: ekranGenisligi > 360 ? ekranYuksekligi / 3 : ekranGenisligi / 6,
                                    child: Text("BOY: ${gelenHastaBilgileri.boy}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: hastaBilgileriAyrintiYaziRenk),
                                        textAlign: TextAlign.center),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(color: hastaBilgileriAyrintiArkaPlan,
                                        borderRadius: BorderRadius.circular(8)),
                                    height: ekranYuksekligi < 500 ? ekranGenisligi / 45 : ekranYuksekligi / 45,
                                    width: ekranGenisligi > 360 ? ekranYuksekligi / 3 : ekranGenisligi / 6,
                                    child: Text("KİLO: ${gelenHastaBilgileri.kilo}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: hastaBilgileriAyrintiYaziRenk), textAlign: TextAlign.center,),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Container(
                                  child: Container(
                                      decoration: BoxDecoration(color: hastaBilgileriAyrintiArkaPlan,
                                          borderRadius: BorderRadius.circular(8)),
                                      width: ekranGenisligi > 360 ? ekranYuksekligi : ekranGenisligi / 2,
                                      height: ekranYuksekligi < 500 ? ekranGenisligi / 45 : ekranYuksekligi / 45,
                                      child: Text("VÜCUT KİTLE İNDEKSİ: ${gelenHastaBilgileri.bmi}",
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: hastaBilgileriAyrintiYaziRenk),
                                        textAlign: TextAlign.center,)),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => GecmisDegerler())).then((value) {
                                  print("Anasayfaya dönüldü");
                                });
                              },
                              child: Card(
                                color: gecmisDegerlerKartArkaPlan,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(width: ekranGenisligi/2.5, height: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/6 : ekranYuksekligi/7,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("GEÇMİŞ DEĞERLER", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: gecmisDegerlerYazi),),
                                        SizedBox(width: 25, height: 25,
                                            child: Image.asset("resimler/bar-chart.png"))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Cihazayarlari())).then((value) {
                                  print("Anasayfaya dönüldü");
                                  setState(() {
                                    verileriCek();
                                  });
                                });
                              },
                              child: Card(
                                color: cihazAyarlariKartArkaPlan,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(width: ekranGenisligi/2.5, height: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/6 : ekranYuksekligi/7,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("CİHAZ AYARLARI", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: cihazAyarlariYazi),),
                                        SizedBox(width: 25, height: 25, child: Image.asset("resimler/settings.png"))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => DoktorNotlari())).then((value) {
                                  print("Anasayfaya dönüldü");
                                });
                              },
                              child: Card(
                                color: doktorNotlariKartArkaPlan,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(width: ekranGenisligi/2.5, height: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/6 : ekranYuksekligi/7,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("DOKTOR NOTLARI", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: doktorNotlariYazi),),
                                        SizedBox(width: 25, height: 25,
                                            child: Image.asset("resimler/writing.png"))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                mailYolla();
                              },
                              child: Card(
                                color: acilDurumKartArkaPlan,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(width: ekranGenisligi/2.5, height: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/6 : ekranYuksekligi/7,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("ACİL DURUM", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: acilDurumYazi),),
                                        SizedBox(width: 25, height: 25,
                                            child: Image.asset("resimler/attention.png"))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/1.5 : ekranGenisligi, height: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/10 : ekranYuksekligi/8,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(color: atesDegeriKartArkaPlan,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: atesDegeriGirButonArkaPlan,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("ATEŞ"),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      TextField(
                                                        controller: tfDegerAtes,
                                                        decoration: InputDecoration(hintText: "Ateş"),
                                                        keyboardType: TextInputType.number,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        print("İptal seçildi");
                                                        Navigator.pop(context);
                                                        },
                                                      child: Text("İptal")),
                                                  TextButton(
                                                      onPressed: () {
                                                        print("Kaydet seçildi.");
                                                        setState(() {
                                                          gelenDegerler.ates = tfDegerAtes.text;
                                                          tfDegerAtes.text = "";
                                                          veriyiKaydet();
                                                        });
                                                      },
                                                      child: Text("Kaydet"))
                                                ],
                                              );
                                              },
                                          );
                                          },
                                        child: SizedBox(width: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/2.6 : ekranYuksekligi/2,
                                            child: Text("ATEŞ DEĞERİNİ GİR", style: TextStyle(color: atesDegeriGirYazi, fontWeight: FontWeight.bold),))),
                                  ),
                                  const Spacer(),
                                  SizedBox(width: 50, height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.asset("resimler/thermometer.png"),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/1.5 : ekranGenisligi, height: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/10 : ekranYuksekligi/8,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(color: tansiyonDegeriKartArkaPlan,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: tansiyonDegeriGirButonArkaPlan,),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("TANSİYON"),
                                                content:
                                                SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 100,
                                                        child: Column(
                                                          children: [
                                                            TextField(
                                                              controller: tfDegerDia,
                                                              decoration: InputDecoration(hintText: "Dia"),
                                                              keyboardType: TextInputType.number,
                                                            ),
                                                            TextField(
                                                              controller: tfDegerSys,
                                                              decoration: InputDecoration(hintText: "Sys"),
                                                              keyboardType: TextInputType.number,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        print("İptal seçildi");
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("İptal")),
                                                  TextButton(
                                                      onPressed: () {
                                                        print("Kaydet seçildi.");
                                                        setState(() {
                                                          gelenDegerler.dia = tfDegerDia.text;
                                                          gelenDegerler.sys = tfDegerSys.text;
                                                          tfDegerSys.text = "";
                                                          tfDegerDia.text = "";
                                                          veriyiKaydet();
                                                        });
                                                      },
                                                      child: Text("Kaydet"))
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: SizedBox(width: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/2.6 : ekranYuksekligi/2,
                                            child: Text("TANSİYON DEĞERİNİ GİR", style: TextStyle(color: tansiyonDegeriGirYazi, fontWeight: FontWeight.bold),))),
                                  ),
                                  const Spacer(),
                                  SizedBox(width: 50, height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.asset("resimler/blood-pressure.png"),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/1.5 : ekranGenisligi, height: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/10 : ekranYuksekligi/8,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(color: spo2DegeriKartArkaPlan,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: spo2DegeriGirButonArkaPlan,),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("SPO2"),
                                                content:
                                                SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 100,
                                                        child: Column(
                                                          children: [
                                                            TextField(
                                                              controller: tfDegerSpo2,
                                                              decoration: InputDecoration(
                                                                  hintText: "Spo2"),
                                                              keyboardType: TextInputType.number,
                                                            ),
                                                            TextField(
                                                              controller: tfDegerNabiz,
                                                              decoration: InputDecoration(
                                                                  hintText: "Nabız"),
                                                              keyboardType: TextInputType.number,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        print("İptal seçildi");
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("İptal")),
                                                  TextButton(
                                                      onPressed: () {
                                                        print("Kaydet seçildi.");
                                                        setState(() {
                                                          gelenDegerler.spo2 = tfDegerSpo2.text;
                                                          gelenDegerler.nabiz = tfDegerNabiz.text;
                                                          tfDegerNabiz.text = "";
                                                          tfDegerSpo2.text = "";
                                                          veriyiKaydet();
                                                        });
                                                      },
                                                      child: Text("Kaydet"))
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: SizedBox( width: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/2.6 : ekranYuksekligi/2,
                                            child: Text("SPO2 DEĞERİNİ GİR", style: TextStyle(color: spo2DegeriGirYazi, fontWeight: FontWeight.bold),))),
                                  ),
                                  const Spacer(),
                                  SizedBox(width: 50, height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.asset("resimler/measurement.png"),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/1.5 : ekranGenisligi, height: ekranYuksekligi > ekranGenisligi ? ekranYuksekligi/10 : ekranYuksekligi/8,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(color: solunumDegeriKartArkaPlan,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: solunumDegeriGirButonArkaPlan,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("SOLUNUM"),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                  children: [
                                                    TextField(
                                                      controller: tfDegerSolunum,
                                                      decoration: InputDecoration(hintText: "Solunum"),
                                                      keyboardType: TextInputType.number,
                                                    ),]
                                                    ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                          print("İptal seçildi");
                                                          Navigator.pop(context);
                                                          },
                                                          child: Text("İptal")),
                                                      TextButton(
                                                          onPressed: () {
                                                          print("Kaydet seçildi.");
                                                          setState(() {
                                                            gelenDegerler.solunum = tfDegerSolunum.text;
                                                            tfDegerSolunum.text = "";
                                                            veriyiKaydet();
                                                          });
                                                          },
                                                          child: Text("Kaydet"))
                                                    ],
                                              );
                                              },
                                          );
                                          },
                                        child: SizedBox(width: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/2.6 : ekranYuksekligi/2,
                                            child: Text("SOLUNUM DEĞERİNİ GİR", style: TextStyle(color: solunumDegeriGirYazi, fontWeight: FontWeight.bold),))),
                                  ),
                                  const Spacer(),
                                  SizedBox(width: 50, height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.asset("resimler/respiratory-system.png"),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }