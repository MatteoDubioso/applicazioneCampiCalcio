class User {
  final String email;
  final String password;
  final String? name;
  final String? surname;
  final DateTime? birthDate;
  final String? indirizzo;

  User({
    required this.email,
    required this.password,
    this.name,
    this.surname,
    this.birthDate,
    this.indirizzo,
  });

  // Metodo per visualizzare la data in formato leggibile
  String get formattedBirthDate {
    if (birthDate == null) return "Non selezionata";
    return "${birthDate!.day.toString().padLeft(2, '0')}/${birthDate!.month.toString().padLeft(2, '0')}/${birthDate!.year}";
  }

  // Factory che costruisce l'utente da JSON
  factory User.fromJson(Map<String, dynamic> json) {
    final birth = json['birthDate'];
    final birthDate = birth != null && birth['seconds'] != null
        ? DateTime.fromMillisecondsSinceEpoch(birth['seconds'] * 1000)
        : null;

    return User(
      email: json['email'] ?? '',
      password: '', // se non viene fornita dal server
      name: json['nome'],
      surname: json['cognome'],
      indirizzo: json['indirizzo'],
      birthDate: birthDate,
    );
  }

  // Metodo per copiare e modificare un oggetto
  User copyWith({
    String? email,
    String? password,
    String? name,
    String? surname,
    DateTime? birthDate,
    String? indirizzo,
  }) {
    return User(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      birthDate: birthDate ?? this.birthDate,
      indirizzo: indirizzo ?? this.indirizzo,
    );
  }
}
