import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trier/screens/AvatarScreen.dart';

class AvatarHomeScreen extends StatefulWidget {
  @override
  _AvatarHomeScreenState createState() => _AvatarHomeScreenState();
}

class _AvatarHomeScreenState extends State<AvatarHomeScreen> {
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avatar Home'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(_user?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic>? userData = snapshot.data?.data() as Map<String, dynamic>?;

            if (userData == null) {
              return Center(child: Text('User data is null.'));
            }

            List<String> avatarUrls = [];
            if (userData.containsKey('avatarUrls')) {
              avatarUrls = List<String>.from(userData['avatarUrls']);
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AvatarContainer(imageUrl: avatarUrls.length > 0 ? avatarUrls[0] : ''),
                      AvatarContainer(imageUrl: avatarUrls.length > 1 ? avatarUrls[1] : ''),
                      AvatarContainer(imageUrl: avatarUrls.length > 2 ? avatarUrls[2] : ''),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to My Profile screen
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfileScreen()));
                        },
                        child: Text('My Profile'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to Add Profile screen
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAvatarScreen()));
                        },
                        child: Text('Add Profile'),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Demo screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DemoScreen()));
                    },
                    child: Text('Demo'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

// ... (remaining code stays the same)


class AvatarContainer extends StatelessWidget {
  final String imageUrl;

  AvatarContainer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: imageUrl.isNotEmpty
          ? Image.network(imageUrl, height: 100.0, width: 100.0, fit: BoxFit.cover)
          : Placeholder(), // You can customize the placeholder widget
    );
  }
}

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Center(
        child: Text('My Profile Screen'),
      ),
    );
  }
}

class AddProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Profile'),
      ),
      body: Center(
        child: Text('Add Profile Screen'),
      ),
    );
  }
}

class DemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: Center(
        child: Text('Demo Screen'),
      ),
    );
  }
}
