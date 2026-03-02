import 'package:campocalcio/profilo_utente.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'entity/user.dart' as App;
import 'homePageUtente.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = const FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _errorMessage;
  final _passwordController = TextEditingController();


  void _goToLogin() async{
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        final String? idToken = await userCredential.user?.getIdToken(); // 👈 Token JWT

        if (idToken != null) {
          await storage.write(key: 'auth_token', value: idToken); // ✅ Memorizzazione del token
        }

        final user = App.User(
          email: userCredential.user?.email ?? "",
          password: "",
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageUtentePage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
          // Altri errori
          setState(() {
            _errorMessage = e.message;
          });

      } catch (e) {
        // Gestisci altri tipi di errori (opzionale)
        setState(() {
          _errorMessage = "Si è verificato un errore: $e";
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Inserisci un'email";
                  }
                  if (!value.contains("@")) {
                    return "Email non valida";
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Campo Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Inserisci una password";
                  }
                  if (value.length < 6) {
                    return "La password deve avere almeno 6 caratteri";
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Messaggio di errore
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),

              SizedBox(height: 16),

              // Bottone Registrazione
              ElevatedButton(
                onPressed: _goToLogin,
                child: Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }

}

