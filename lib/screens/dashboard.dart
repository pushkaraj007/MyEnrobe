import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trier/screens/profile.dart';
import 'package:trier/screens/searchscreen.dart';
import 'Homescreen.dart';
import 'favourites.dart';
import '../login&signin/login_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userName = ''; // Variable to store the user's name
  Future<void> _loadUserInfo() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

        setState(() {
          userName = userDoc['name'] ?? ''; // Replace 'name' with the field in your Firestore collection
        });
      }
    } catch (e) {
      print('Error loading user information: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    _loadUserInfo();

    return WillPopScope(
      onWillPop: () async {
        // Show an alert dialog to confirm exit
        bool exitConfirmed = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App?'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );

        // If the user confirms, exit the app
        if (exitConfirmed == true) {
          // Note: exit(0) is generally discouraged, and you should consider alternatives.
          exit(0);
        }

        // Prevent the screen from being popped
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Add this line to prevent resizing when the keyboard appears
        appBar: AppBar(
          automaticallyImplyLeading: false, // Hide the back button
          title: Text('Welcome $userName'),
          actions: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0,10, 50, 10),
              // child: Text(
              //   // Display user's name as text
              //   userName, // Replace 'UserName' with the variable containing the user's name
              //   style: TextStyle(fontSize: 21.0),
              // ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                await _signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
        body: const ShoppingDashboard(),
      ),
    );
  }
}

class ShoppingDashboard extends StatefulWidget {
  const ShoppingDashboard({super.key});

  @override
  _ShoppingDashboardState createState() => _ShoppingDashboardState();
}

class _ShoppingDashboardState extends State<ShoppingDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const AddProductPage(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle bottom navigation item tap
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.black,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Likes',
            backgroundColor: Colors.black,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.black,

          ),
        ],
      ),
    );
  }
}





