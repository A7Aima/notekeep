import 'package:notekeep/const/routes/routes.dart';
import 'package:notekeep/ui/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  runApp(NoteKeep());
}

class NoteKeep extends StatelessWidget {
  NoteKeep({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Keep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      onGenerateRoute: (settings) => Routes.animateRoutes(settings),
    );
  }
}
