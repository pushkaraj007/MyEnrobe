import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CameraCaptureScreen extends StatefulWidget {
  late final CameraController cameraController;

  CameraCaptureScreen({required this.cameraController, this.cameras}); // Add this line

  List<CameraDescription>? cameras; // Add this line

  @override
  _CameraCaptureScreenState createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  XFile? _capturedImage;
  late firebase_storage.Reference _storageReference;
  bool _isFlashOn = false;
  bool _isRearCameraSelected = true;

  @override
  void initState() {
    super.initState();
    _storageReference = firebase_storage.FirebaseStorage.instance.ref().child('Avatar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Image'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                CameraPreview(widget.cameraController),
                _capturedImage != null
                    ? Image.file(
                  File(_capturedImage!.path),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Container(),
                _buildOverlay(),
              ],
            ),
          ),
          _buildOptionsBar(),
        ],
      ),
    );
  }

  Widget _buildOptionsBar() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // _buildOptionButton(Icons.flash_on, 'Flash', _toggleFlash),
          // _buildOptionButton(
          //   _isRearCameraSelected
          //       ? Icons.camera_front
          //       : Icons.camera_rear,
          //   'Switch Camera',
          //   _switchCamera,
          // ),
          _buildOptionButton(Icons.close, 'Retake', _retakePicture),
          _buildOptionButton(Icons.camera, 'Capture', _captureImage),
          _buildOptionButton(Icons.upload, 'Upload', () {
            if (_capturedImage != null) {
              _uploadImageToFirebase(_capturedImage!.path);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildOptionButton(IconData icon, String label, Function() onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          color: Colors.white,
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildOverlay() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 400.0,
        width: 200.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 0,
              width: double.infinity,
              color: Colors.green,
            ),
            Container(
              height: 0,
              width: double.infinity,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureImage() async {
    try {
      XFile image = await widget.cameraController.takePicture();
      setState(() {
        _capturedImage = image;
      });
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<void> _retakePicture() async {
    setState(() {
      _capturedImage = null;
    });
  }

  Future<void> _uploadImageToFirebase(String imagePath) async {
    try {
      if (imagePath.isEmpty) {
        print('No image selected');
        return;
      }

      File imageFile = File(imagePath);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.UploadTask task =
      _storageReference.child(fileName).putFile(imageFile);

      await task;

      String imageUrl = await _storageReference.child(fileName).getDownloadURL();

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'avatarUrl': imageUrl});
      }

      print('Image uploaded to Firebase: $imageUrl');

      // Show a pop-up
      _showImageUploadedPopup();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _showImageUploadedPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image Uploaded'),
          content: Text('Your image has been successfully uploaded!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
      widget.cameraController.setFlashMode(
          _isFlashOn ? FlashMode.torch : FlashMode.off);
    });
  }

  Future<void> _switchCamera() async {
    if (widget.cameras == null) {
      return; // Ensure that cameras list is not null
    }

    int currentCameraIndex = widget.cameras!.indexOf(widget.cameraController.description);

    if (currentCameraIndex == -1) {
      return; // Camera not found in the list
    }

    int newCameraIndex = (currentCameraIndex + 1) % widget.cameras!.length;
    CameraDescription newCamera = widget.cameras![newCameraIndex];

    await widget.cameraController.dispose();
    await initCamera(newCamera);

    setState(() {
      _isRearCameraSelected = newCamera.lensDirection == CameraLensDirection.back;
    });
  }


  Future<void> initCamera(CameraDescription cameraDescription) async {
    widget.cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    await widget.cameraController.initialize();
    setState(() {});
  }
}
