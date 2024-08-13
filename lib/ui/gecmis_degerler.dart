import 'package:elektronik_saglik_platformu_kullanici/renkler.dart';
import 'package:elektronik_saglik_platformu_kullanici/ui/ates_grafik.dart';
import 'package:elektronik_saglik_platformu_kullanici/ui/ates_liste.dart';
import 'package:elektronik_saglik_platformu_kullanici/ui/solunum_grafik.dart';
import 'package:elektronik_saglik_platformu_kullanici/ui/solunum_liste.dart';
import 'package:elektronik_saglik_platformu_kullanici/ui/spo2_grafik.dart';
import 'package:elektronik_saglik_platformu_kullanici/ui/spo2_liste.dart';
import 'package:elektronik_saglik_platformu_kullanici/ui/tansiyon_grafik.dart';
import 'package:elektronik_saglik_platformu_kullanici/ui/tansiyon_liste.dart';
import 'package:flutter/material.dart';

class GecmisDegerler extends StatefulWidget {
  const GecmisDegerler({super.key});

  @override
  State<GecmisDegerler> createState() => _GecmisDegerlerState();
}

class _GecmisDegerlerState extends State<GecmisDegerler> {
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
        appBar: AppBar(title: Text("Geçmiş Değerler"),
        backgroundColor: arkaPlan,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: arkaPlan),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/0.5 : ekranGenisligi/0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(color: gecmisDegerlerKutuArkaPlan, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("ATEŞ SONUÇLARI", style: TextStyle(fontSize: 14, color: gecmisDegerlerKutuYazi, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                          ),
                          const Spacer(),
                          SizedBox(width: ekranYuksekligi > ekranGenisligi ? 30 : 45, height: ekranYuksekligi > ekranGenisligi ? 30 : 45,
                              child: Image.asset("resimler/thermometer.png")),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AtesGrafik())).then((value) {
                                        print("Geçmiş değerler dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerGrafikButon,//change text color of button
                                    ),
                                    child: Text("GRAFİK SONUÇLARI", style: TextStyle(fontWeight: FontWeight.bold, color: gecmisDegerlerGrafikYazi),)),
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AtesListe())).then((value){
                                        print("Geçmiş değerlere dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerListeButon,//change text color of button
                                    ),
                                    child: Text("LİSTE SONUÇLARI", style: TextStyle(fontWeight: FontWeight.bold, color: gecmisDegerlerListeYazi),)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/0.5 : ekranGenisligi/0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(color: gecmisDegerlerKutuArkaPlan, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("TANSİYON SONUÇLARI", style: TextStyle(fontSize: 14, color: gecmisDegerlerKutuYazi, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                          ),
                          const Spacer(),
                          SizedBox(width: ekranYuksekligi > ekranGenisligi ? 30 : 45, height: ekranYuksekligi > ekranGenisligi ? 30 : 45,
                              child: Image.asset("resimler/blood-pressure.png")),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TansiyonGrafik())).then((value) {
                                        print("Geçmiş değerler dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerGrafikButon,//change text color of button
                                    ),
                                    child: Text("GRAFİK SONUÇLARI", style: TextStyle(color: gecmisDegerlerGrafikYazi, fontWeight: FontWeight.bold),)),
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TansiyonListe())).then((value){
                                        print("Geçmiş değerlere dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerListeButon,//change text color of button
                                    ),
                                    child: Text("LİSTE SONUÇLARI", style: TextStyle(color: gecmisDegerlerListeYazi, fontWeight: FontWeight.bold),)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ekranYuksekligi > ekranGenisligi ? ekranGenisligi/0.5 : ekranGenisligi/0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(color: gecmisDegerlerKutuArkaPlan, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("SPO2 SONUÇLARI", style: TextStyle(fontSize: 14, color: gecmisDegerlerKutuYazi, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                          ),
                          const Spacer(),
                          SizedBox(width: ekranYuksekligi > ekranGenisligi ? 30 : 45, height: ekranYuksekligi > ekranGenisligi ? 30 : 45,
                              child: Image.asset("resimler/measurement.png")),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Spo2Grafik())).then((value) {
                                        print("Geçmiş değerler dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerGrafikButon,//change text color of button
                                    ),
                                    child: Text("GRAFİK SONUÇLARI", style: TextStyle(color: gecmisDegerlerGrafikYazi, fontWeight: FontWeight.bold),)),
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Spo2Liste())).then((value){
                                        print("Geçmiş değerlere dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerListeButon,//change text color of button
                                    ),
                                    child: Text("LİSTE SONUÇLARI", style: TextStyle(color: gecmisDegerlerListeYazi, fontWeight: FontWeight.bold),)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ekranYuksekligi > ekranGenisligi ? ekranGenisligi : ekranGenisligi/0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(color: gecmisDegerlerKutuArkaPlan, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("SOLUNUM SONUÇLARI", style: TextStyle(fontSize: 14, color: gecmisDegerlerKutuYazi, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                          ),
                          const Spacer(),
                          SizedBox(width: ekranYuksekligi > ekranGenisligi ? 30 : 45, height: ekranYuksekligi > ekranGenisligi ? 30 : 45,
                              child: Image.asset("resimler/respiratory-system.png")),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SolunumGrafik())).then((value) {
                                        print("Geçmiş değerler dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerGrafikButon,//change text color of button
                                    ),
                                    child: Text("GRAFİK SONUÇLARI", style: TextStyle(color: gecmisDegerlerGrafikYazi, fontWeight: FontWeight.bold),)),
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SolunumListe())).then((value){
                                        print("Geçmiş değerlere dönüldü");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      //foregroundColor: yaziRenk1,//change background color of button
                                      backgroundColor: gecmisDegerlerListeButon,//change text color of button
                                    ),
                                    child: Text("LİSTE SONUÇLARI", style: TextStyle(color: gecmisDegerlerListeYazi, fontWeight: FontWeight.bold),)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}