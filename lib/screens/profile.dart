import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User _user;
  Map<String, dynamic>? _userData;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _shirtsizeController = TextEditingController();
  final TextEditingController _pantsizeController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      final userData =
      await _firestore.collection('users').doc(_user.uid).get();

      if (userData.exists) {
        setState(() {
          _userData = userData.data() as Map<String, dynamic>;
          _nameController.text = _userData?['name'] ?? '';
          _contactNoController.text = _userData?['contactNo'] ?? '';
          _addressController.text = _userData?['address'] ?? '';
          _emailController.text = _userData?['email'] ?? '';
          _heightController.text = _userData?['height'] ?? '';
          _weightController.text = _userData?['weight'] ?? '';
          _shirtsizeController.text = _userData?['shirtsize'] ?? '';
          _pantsizeController.text = _userData?['pantsize'] ?? '';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void updateProfile() async {
    try {
      await _firestore.collection('users').doc(_user.uid).update({
        'name': _nameController.text,
        'contactNo': _contactNoController.text,
        'address': _addressController.text,
        'email': _emailController.text,
        'weight': _weightController.text,
        'height': _heightController.text,
        'shirtsize': _shirtsizeController.text,
        'pantsize': _pantsizeController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully.'),
        ),
      );

      toggleEditing(); // Disable editing after profile update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile.'),
        ),
      );
    }
  }

  void changeProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Upload the image to Firebase Storage and get the download URL
      Reference ref =
      FirebaseStorage.instance.ref().child('images/${_user.uid}');
      UploadTask uploadTask = ref.putFile(File(pickedImage.path));
      TaskSnapshot downloadUrl = await uploadTask;
      String imageUrl = await downloadUrl.ref.getDownloadURL();

      // Update the Firestore document with the new image URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .update({
        'imageUrl': imageUrl,
      });

      // Update the state to reflect the new image
      setState(() {
        _userData?['imageUrl'] = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: changeProfilePicture, // Handle onTap event
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: _userData?['imageUrl'] != null
                        ? NetworkImage(_userData?['imageUrl'])
                        : const AssetImage('images/placeholder.png') as ImageProvider<Object>, // Replace with a placeholder image
                  ),
                ),
                const SizedBox(height: 20.0),
                buildProfileInfoRow(Icons.email, 'Email', _userData?['email'] ?? 'N/A', _isEditing, _emailController),
                const SizedBox(height: 24.0),
                buildProfileInfoRow(Icons.person, 'Name', _userData?['name'] ?? 'N/A', _isEditing, _nameController),
                const SizedBox(height: 24.0),
                buildProfileInfoRow(Icons.phone, 'Contact No', _userData?['contactNo'] ?? 'N/A', _isEditing, _contactNoController),
                const SizedBox(height: 24.0),
                buildProfileInfoRow(Icons.location_on, 'Address', _userData?['address'] ?? 'N/A', _isEditing, _addressController),
                const SizedBox(height: 24.0),
                buildProfileInfoRow(Icons.height, 'Height', _userData?['height'] ?? 'N/A', _isEditing, _heightController),
                const SizedBox(height: 24.0),
                buildProfileInfoRow(Icons.fitness_center, 'Weight', _userData?['weight'] ?? 'N/A', _isEditing, _weightController),
                const SizedBox(height: 24.0),
                buildProfileInfoRow(Icons.accessibility, 'Shirt Size', _userData?['shirtsize'] ?? 'N/A', _isEditing, _shirtsizeController),
                const SizedBox(height: 24.0),
                buildProfileInfoRow(Icons.accessibility, 'Pant Size', _userData?['pantsize'] ?? 'N/A', _isEditing, _pantsizeController),
                const SizedBox(height: 50.0),
                if (!_isEditing)
                  ElevatedButton(
                    onPressed: toggleEditing,
                    child: const Text('Edit Information', style: TextStyle(fontSize: 16)),
                  ),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: updateProfile,
                    child: const Text('Update Profile'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileInfoRow(IconData icon, String label, String value, bool isEditing, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                isEditing
                    ? buildEditableTextField(controller, label)
                    : buildReadOnlyText(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditableTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 18.0),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget buildReadOnlyText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18.0),
    );
  }
}
