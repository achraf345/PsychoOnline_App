import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:awa/screens/HomeScreen/home_screen.dart';
// ignore: unused_import
import 'package:awa/screens/AcceptClientScreen/acceptclientscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "AIzaSyBO6j6OXuiaEGNyLEa2_VFL2pNyxLVvRiM",
    authDomain: "psychologistonlineawa.firebaseapp.com",
    projectId: "psychologistonlineawa",
    storageBucket: "psychologistonlineawa.appspot.com",
    messagingSenderId: "548853502071",
    appId: "1:548853502071:android:17473b44f16c651e47f672",
  ),
);
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PsychOnline',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Homescreen(),
    );
  }
}
