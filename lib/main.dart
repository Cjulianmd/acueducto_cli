import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/firebase_options.dart';
import 'home/animacion.dart';
import 'home/home.dart';
import 'home/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // aquí se inicializa Firebase
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool showedWelcomeScreen = prefs.getBool('showed_welcome_screen') ?? false;

  runApp(MyApp(showedWelcomeScreen));
}

class MyApp extends StatelessWidget {
  final bool showedWelcomeScreen;

  MyApp(this.showedWelcomeScreen);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      debugShowCheckedModeBanner: false,
      home: showedWelcomeScreen ? Welcomeanimation() : WelcomeScreen(),
    );
  }
}
//Color.fromARGB(255, 7, 125, 184),)