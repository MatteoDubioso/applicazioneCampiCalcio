import 'package:campocalcio/loginPage.dart';
import 'package:campocalcio/registrazione.dart';
import 'package:campocalcio/theme/app_theme.dart';
import 'package:campocalcio/theme/theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final brightness = WidgetsBinding.instance.window.platformBrightness;
  final initialDarkMode = brightness == Brightness.dark;

  final themeManager = ThemeManager();
  await themeManager.initThemes(); // Carica i temi chiaro/scuro
  themeManager.toggleThemeTo(initialDarkMode);

  runApp(
    ChangeNotifierProvider.value(
      value: themeManager,
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return MaterialApp(
      title: 'Campo da Calcio',
      theme: themeManager.lightTheme,     // Tema chiaro fisso
      darkTheme: themeManager.darkTheme, // Tema scuro fisso
      themeMode: themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(title: 'Campo da Calcio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Row(
            children: [
              Icon(Icons.light_mode),
              Switch(
                value: themeManager.isDarkMode,
                onChanged: (value) {
                  themeManager.toggleTheme();
                },
              ),
              Icon(Icons.dark_mode),
            ],
          )
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profilo'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Impostazioni'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/campohome.jpg',
              width: 500,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text("Clicca il bottone qui sotto per registrarti", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
              },
              child: Text("Registrati",style: TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text("Accedi"),
            )
          ],
        ),
      ),
    );
  }
}
