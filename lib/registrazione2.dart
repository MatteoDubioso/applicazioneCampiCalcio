import 'package:campocalcio/profilo_utente.dart';
import 'package:flutter/material.dart';

import 'entity/user.dart';

class CompleteProfilePage extends StatefulWidget {

  final User user;

  const CompleteProfilePage({
    Key? key,
    required this.user
  }) : super(key: key);

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _indirizzoController;
  DateTime? _selectedDate; // Campo per memorizzare la data selezionata

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _indirizzoController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _indirizzoController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updatedUser = widget.user.copyWith(
      name: _nameController.text.isNotEmpty ? _nameController.text : null,
      surname: _surnameController.text.isNotEmpty ? _surnameController.text : null,
      indirizzo: _indirizzoController.text.isNotEmpty ? _indirizzoController.text: null,
      birthDate: _selectedDate,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfiloUtentePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completa il Profilo"),
        backgroundColor:Colors.red,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email (sola lettura)
              TextFormField(
                initialValue: widget.user.email,
                enabled: false,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 16),

              // Nome
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Inserisci il tuo nome";
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Cognome
              TextFormField(
                controller: _surnameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(labelText: "Cognome"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Inserisci il tuo cognome";
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // data
              Text("Seleziona la tua data di nascita", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              // Bottone per aprire il selettore della data
              ElevatedButton.icon(
                onPressed: () => _selectDate(context),
                icon: Icon(Icons.calendar_today),
                label: Text(_selectedDate == null ? "Seleziona Data" : "${_selectedDate!.toLocal()}".split(' ')[0]),
              ),
              SizedBox(height: 16),

              // Cognome
              TextFormField(
                controller: _indirizzoController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(labelText: "Indirizzo"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Inserisci il tuo cognome";
                  }
                  return null;
                },
              ),

              SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveProfile,
                child: Text("Salva e continua"),
              )
            ],
          ),
        ),
      ),
    );
  }
}