import 'package:campocalcio/registrazione2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'entity/user.dart' as App;
import 'loginPage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _errorMessage;

  void _goToCompleteProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Utente registrato con successo
        final user = App.User(
          email: userCredential.user?.email ?? "",
          password: "",
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompleteProfilePage(user: user),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          setState(() {
            _errorMessage = "Email già registrata. Effettua il login.";
          });
        }

      } catch (e) {
        // Gestisci altri tipi di errori (opzionale)
        setState(() {
          _errorMessage = "Si è verificato un errore: $e";
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrati"),
        backgroundColor: Colors.red,
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
              if (_errorMessage != null && _errorMessage!.contains("Email già registrata"))
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text("Vai al login"),
                ),
              // Bottone Registrazione
              ElevatedButton(
                onPressed: _goToCompleteProfile,
                child: Text("Registrati"),
              )
            ],
          ),
        ),
      ),
    );
  }
}