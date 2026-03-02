class Prenotazione{
  final String email;
  final String? nome;
  final String? datapren;
  final String? telefono;

  Prenotazione({
    required this.email,
    this.nome,
    this.datapren,
    this.telefono,
  });

  // Factory che costruisce l'utente da JSON
  factory Prenotazione.fromJson(Map<String, dynamic> json) {

    return Prenotazione(
      email: json['email'] ?? '',
      nome: json['nome'],
      datapren: json['dataPrenotazione'],
      telefono: json['numeroTel'],
    );
  }
}