import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Product {
  final String category;
  final String name;
  final String gender;
  final String price;
  final String description;
  final String imageUrl;

  Product({
    required this.category,
    required this.name,
    required this.gender,
    required this.price,
    required this.description,
    required this.imageUrl,
  });
}

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> categories = ['T-shirts', 'Jeans', 'Dresses', 'Jackets','Footwear','Accessories','Coats','Activewear'];
  String selectedCategory = 'T-shirts'; // Set a default category

  File? _image;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String> _uploadImage() async {
    if (_image == null) {
      return '';
    }

    final Reference storageRef = FirebaseStorage.instance.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}');
    final UploadTask uploadTask = storageRef.putFile(_image!);
    await uploadTask.whenComplete(() => null);

    final String imageUrl = await storageRef.getDownloadURL();
    // Now, you can use 'imageUrl' to store in Firestore or anywhere else
    print('Image URL: $imageUrl');
    return imageUrl;
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      // Validate the form

      // Upload image to Firebase Storage and get the image URL
      final String imageUrl = await _uploadImage();

      // Create a Product object
      final Product newProduct = Product(
        category: selectedCategory, // Use the selected category
        name: _nameController.text,
        gender: _genderController.text,
        price: _priceController.text,
        description: _descriptionController.text,
        imageUrl: imageUrl, // Use the actual image URL obtained from _uploadImage
      );

      // Add product data to Firestore with auto-generated product ID
      DocumentReference productRef = await FirebaseFirestore.instance.collection('products').add({
        'category': newProduct.category,
        'name': newProduct.name,
        'gender': newProduct.gender,
        'price': newProduct.price,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        // Add more fields as needed
      });

      // Get the auto-generated product ID
      String productId = productRef.id;

      // Update the document with the product ID
      await productRef.update({'productId': productId});

      // Reset form
      _formKey.currentState!.reset();
      _image = null;

      // Show a success message or navigate to another page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product (Temporary Screen)'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (String? value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a gender';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  // You can add more validation for numeric input, e.g., isNumeric() function
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Pick Image'),
              ),
              if (_image != null)
                Image.file(
                  _image!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addProduct,
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
