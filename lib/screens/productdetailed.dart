// ignore_for_file: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trier/screens/addtocart.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product['name'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0, // Remove the app bar shadow
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              constraints: const BoxConstraints.expand(
                height: 300.0, // Adjust the height as needed
              ),
              child: FadeInImage.assetNetwork(
                placeholder: 'images/google.png', // Placeholder image asset
                image: product['imageUrl'] as String,
                fit: BoxFit.contain,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    product['category'] as String,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    product['gender'] as String,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '\$${product['price']}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    product['description'] as String,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      // Implement logic to add the product to the cart
                      // You can use a state management solution or handle it here
                      // For simplicity, let's show a snackbar indicating success
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>AddToCartScreen(product: product),
                          )
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product added to the cart.'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, padding: const EdgeInsets.all(16.0), // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Button border radius
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
