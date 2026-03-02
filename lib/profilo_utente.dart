import 'dart:convert';
import 'package:campocalcio/entity/prenotazioni.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'entity/user.dart';

class ProfiloUtentePage extends StatefulWidget {
  ProfiloUtentePage({Key? key}) : super(key: key);

  @override
  _ProfiloUtentePageState createState() => _ProfiloUtentePageState();
}

class _ProfiloUtentePageState extends State<ProfiloUtentePage> {
  final storage = FlutterSecureStorage();
  User? user;
  List<Prenotazione> pren = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> getprenotazioni() async {
    final url = Uri.parse('http://192.168.2.28:8080/api/get-prenotazioni');
    String? token = await storage.read(key: 'auth_token');

    if (token == null) {
      print('Nessun token trovato. Utente non autenticato.');
      return;
    }

    final headers = {'Authorization': '$token'};

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          pren = data.map((item) => Prenotazione.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        print('Errore prenotazioni: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore di rete prenotazioni: $e');
    }
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://192.168.2.28:8080/api/get-utente');
    String? token = await storage.read(key: 'auth_token');

    if (token == null) {
      print('Nessun token trovato. Utente non autenticato.');
      return;
    }

    final headers = {'Authorization': '$token'};

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          user = User.fromJson(data);
        });
        await getprenotazioni();
      } else {
        print('Errore utente: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore di rete utente: $e');
    }
  }

  Widget buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        "$label: $value",
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Profilo Utente")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Profilo Utente"),
            expandedHeight: 150,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(

                child: Icon(Icons.person, size: 100, color: Colors.white),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildUserInfo("📧 Email", user!.email),
                  buildUserInfo("🔒 Password", "••••••"),
                  buildUserInfo("👤 Nome", user!.name ?? "Non inserito"),
                  buildUserInfo("👥 Cognome", user!.surname ?? "Non inserito"),
                  buildUserInfo("🎂 Data di nascita", user!.birthDate.toString()),
                  SizedBox(height: 30),

                  Center(
                    child: Text(
                      "Elenco prenotazioni effettuate:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  if (pren.isEmpty)
                    Text("Nessuna prenotazione trovata."),

                  ...pren.map((p) => Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildUserInfo("📆 Data", p.datapren ?? "Non disponibile"),
                          buildUserInfo("👤 Nome", p.nome ?? "Non disponibile"),
                          buildUserInfo("📧 Email", p.email),
                          buildUserInfo("📞 Telefono", p.telefono ?? "Non disponibile"),
                        ],
                      ),
                    ),
                  )),

                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Torna indietro"),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}