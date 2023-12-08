import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAvatarScreen extends StatefulWidget {
  const CreateAvatarScreen({super.key});

  @override
  _CreateAvatarScreenState createState() => _CreateAvatarScreenState();
}

class _CreateAvatarScreenState extends State<CreateAvatarScreen> {
  late ImagePicker _imagePicker;
  XFile? _selectedImage;
  late firebase_storage.FirebaseStorage _storage;
  late firebase_storage.Reference _storageReference;
  late CameraController _cameraController;
  String _userId = ''; // Replace with the actual user ID

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _initializeFirebaseStorage();
    _initializeCamera();

    // Get the UID of the logged-in user
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _userId = currentUser.uid;
    }
  }
  @override
  void dispose() {
    // Release the resources associated with the camera controller
    _cameraController.dispose();
    super.dispose();
  }
  Future<void> _initializeFirebaseStorage() async {
    await Firebase.initializeApp();
    _storage = firebase_storage.FirebaseStorage.instance;
    _storageReference = _storage.ref().child('Avatar'); // Set the folder name
  }

  Future<void> _initializeCamera() async {
    if (_selectedImage == null) {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      await _cameraController.initialize();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        if (!_cameraController.value.isInitialized) {
          return;
        }
      }

      final XFile? pickedImage = await _imagePicker.pickImage(source: source);

      if (pickedImage != null) {
        setState(() {
          _selectedImage = pickedImage;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImageToFirebase() async {
    try {
      if (_selectedImage == null) {
        print('No image selected');
        return;
      }

      File imageFile = File(_selectedImage!.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.UploadTask task =
      _storageReference.child(fileName).putFile(imageFile);

      await task;

      // Get the download URL
      String imageUrl =
      await _storageReference.child(fileName).getDownloadURL();

      // Update the user's document with the avatar URL
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'avatarUrl': imageUrl});
      }

      print('Image uploaded to Firebase: $imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Avatar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Align Yourself In the camera as  \n shown in the Picture',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              height: 400.0,
              width: 400.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: _selectedImage != null
                  ? Image.file(
                File(_selectedImage!.path),
                height: 400.0,
                width: 400.0,
              )
                  : FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_userId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Map<String, dynamic>? userData =
                    snapshot.data?.data() as Map<String, dynamic>?;

                    // Check if the 'avatarUrl' field exists in the document
                    if (userData != null && userData.containsKey('avatarUrl')) {
                      String imageUrl = userData['avatarUrl'] as String;
                      return Image.network(
                        imageUrl,
                        height: 400.0,
                        width: 400.0,
                      );
                    } else {
                      return Image.asset(
                        'images/pose.png',
                        height: 300.0,
                        width: 300.0,
                        fit: BoxFit.cover,
                      );
                    }
                  }
                },
              ),

            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Take Picture'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Pick from Gallery'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _uploadImageToFirebase,
              child: const Text('Upload to Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}
