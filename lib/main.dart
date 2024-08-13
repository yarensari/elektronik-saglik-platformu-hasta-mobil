import 'package:elektronik_saglik_platformu_kullanici/data/entity/doktorNotlariDegerler.dart';
import 'package:elektronik_saglik_platformu_kullanici/ui/anasayfa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:mysql_client/mysql_client.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elektronik Sağlık Platformu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Anasayfa()
    );
  }
}
