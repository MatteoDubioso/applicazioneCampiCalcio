import 'dart:convert';
import 'package:campocalcio/entity/prenotazioni.dart';
import 'package:campocalcio/profilo_utente.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'entity/user.dart';

class HomePageUtentePage extends StatefulWidget {
  HomePageUtentePage({Key? key}) : super(key: key);

  @override
  _HomePageUtenteState createState() => _HomePageUtenteState();
}

class _HomePageUtenteState extends State<HomePageUtentePage> {
  final storage = FlutterSecureStorage();
  User? user;
  List<Prenotazione> pren = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
          title: Text("Home "),
          actions: [
          ElevatedButton(
          onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfiloUtentePage()));
    },
      child: Text("Account"),
    ),
            SizedBox(width: 10)
    ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40), // Spazio sopra l'immagine
              Image.asset(
                'images/home_enter.png',
                width: 800,
                height: 200,
                fit: BoxFit.cover,
              ),

              ]
        ),
      ),
    );
  }
}
