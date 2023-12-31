import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trier/screens/avatars/AvatarScreen.dart';
import 'dart:io';

import 'Avatarprofilescreen.dart';
class AvatarHomeScreen extends StatefulWidget {
  const AvatarHomeScreen({super.key});

  @override
  _AvatarHomeScreenState createState() => _AvatarHomeScreenState();
}

class _AvatarHomeScreenState extends State<AvatarHomeScreen> {
  late User? _user;
  String _userId = '';
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _userId = currentUser.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Home'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 100.0), // Adjust the top padding as needed
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(_userId).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Map<String, dynamic>? userData = snapshot.data?.data() as Map<String, dynamic>?;
                    if (userData != null && userData.containsKey('avatarUrl')) {
                      String imageUrl = userData['avatarUrl'] as String;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                    decoration: const BoxDecoration(
                                      border: Border(top: BorderSide(), bottom: BorderSide(),),
                                    ),
                                    child: Column(
                                      children: [
                                        AvatarContainer(imageUrl: imageUrl),
                                        const Text('Product Example'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                    decoration: const BoxDecoration(
                                      border: Border(top: BorderSide(), bottom: BorderSide()),
                                    ),
                                    child: Column(
                                      children: [
                                        AvatarContainer(imageUrl: imageUrl),
                                        const Text('Actual Avatar'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                    decoration: const BoxDecoration(
                                      border: Border(top: BorderSide(), bottom: BorderSide()),
                                    ),
                                    child: Column(
                                      children: [
                                        AvatarContainer(imageUrl: imageUrl),
                                        const Text('Try on Pic'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (_selectedImage != null && File(_selectedImage!.path).existsSync()) {
                      // Display the selected image
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                    decoration: const BoxDecoration(
                                      border: Border(top: BorderSide(), bottom: BorderSide()),
                                    ),
                                    child: Column(
                                      children: [
                                        AvatarContainer(imageUrl: _selectedImage!.path),
                                        const Text('Avatar 1'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                    decoration: const BoxDecoration(
                                      border: Border(top: BorderSide(), bottom: BorderSide()),
                                    ),
                                    child: Column(
                                      children: [
                                        AvatarContainer(imageUrl: _selectedImage!.path),
                                        const Text('Avatar 2'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                    decoration: const BoxDecoration(
                                      border: Border(top: BorderSide(), bottom: BorderSide()),
                                    ),
                                    child: Column(
                                      children: [
                                        AvatarContainer(imageUrl: _selectedImage!.path),
                                        const Text('Avatar 3'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }

                    return Container(); // Return an empty container if no image is displayed.
                  }
                },
              ),
              const SizedBox(height: 60.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to My Profile screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfileScreen()));
                    },
                    child: const Text('My Profile'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Add Profile screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAvatarScreen()));
                    },
                    child: const Text('Add Profile'),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Demo screen
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DemoScreen()));
                },
                child: const Text('Demo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class AvatarContainer extends StatelessWidget {
  final String imageUrl;

  AvatarContainer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      width: 120.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: imageUrl.isNotEmpty
          ? Image.network(imageUrl, height: 100.0, width: 100.0, fit: BoxFit.cover)
          :  const Placeholder(), // You can customize the placeholder widget
    );
  }
}

// class MyProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Profile'),
//       ),
//       body: Center(
//         child: Text('My Profile Screen'),
//       ),
//     );
//   }
// }

class AddProfileScreen extends StatelessWidget {
  const AddProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Profile'),
      ),
      body: const Center(
        child: Text('Add Profile Screen'),
      ),
    );
  }
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
      ),
      body: const Center(
        child: Text('Demo Screen'),
      ),
    );
  }
}
