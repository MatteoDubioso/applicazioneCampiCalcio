import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Importa i file necessari
import 'package:campocalcio/main.dart'; // contiene MyApp e MyHomePage
import 'package:campocalcio/theme/app_theme.dart'; // se usi un tema personalizzato

void main() {
  // Test per verificare che l'app venga caricata correttamente
  testWidgets('Homepage visualizza correttamente i widget', (WidgetTester tester) async {
    // Costruisce l'app
    await tester.pumpWidget(
      MaterialApp(// Usa il tuo tema o rimuovilo se non ti serve nel test
        home: const MyHomePage(title: 'Campo da Calcio'),
      ),
    );

    // Verifica che il titolo sia presente
    expect(find.text('Campo da Calcio'), findsOneWidget);

    // Verifica che l'immagine sia visibile
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    // Verifica che il testo guida sia visibile
    expect(find.text('Clicca il bottone qui sotto per registrarti'), findsOneWidget);

    // Verifica che i pulsanti siano presenti
    expect(find.text('Registrati'), findsOneWidget);
    expect(find.text('Accedi'), findsOneWidget);
  });
}