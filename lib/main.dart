import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trier/screens/dashboard.dart';
import 'screens/firstpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyAppStateful());
}

class MyAppStateful extends StatefulWidget {
  const MyAppStateful({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppStateful> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    print(user?.uid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: user != null ? DashboardScreen() : FirstScreen()
      ,
    );
  }
}
