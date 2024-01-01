// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ProductPage extends StatelessWidget {
//   final Map<String, dynamic> category;
//
//   const ProductPage({Key? key, required this.category}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Products in ${category['name']}'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('products')
//             .where('category', isEqualTo: category['name'])
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//
//           if (snapshot.data?.docs.isEmpty ?? true) {
//             return Center(
//               child: Text('No products available in this category. Category: ${category['name']}'),
//             );
//           }
//
//           return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16.0,
//               mainAxisSpacing: 16.0,
//             ),
//             itemCount: snapshot.data?.docs.length,
//             itemBuilder: (context, index) {
//               return _buildProductTile(context, snapshot.data!.docs[index]);
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildProductTile(BuildContext context, QueryDocumentSnapshot<Object?> productDoc) {
//     Map<String, dynamic> product = productDoc.data() as Map<String, dynamic>;
//     print('Product Data: $product');
//
//     return Card(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Image.network(
//             product['imageUrl'] as String, // Replace with your image URL field
//             height: 120.0,
//             width: double.infinity,
//             fit: BoxFit.cover,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product['name'] as String,
//                   style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4.0),
//                 Text(
//                   'Price: \$${product['price']}',
//                   style: const TextStyle(fontSize: 14.0),
//                 ),
//                 const SizedBox(height: 8.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Implement logic to add the product to the cart
//                     // You can use a state management solution or handle it here
//                     // For simplicity, let's show a snackbar indicating success
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Product added to the cart.'),
//                       ),
//                     );
//                   },
//                   child: const Text('Add to Cart'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trier/screens/productdetailed.dart';

class ProductListScreen extends StatelessWidget {
  // const ProductListScreen({super.key});
  final Map<String, dynamic> category;

  const ProductListScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').where('category', isEqualTo: category['name']).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.data?.docs.isEmpty ?? true) {
            return const Center(
              child: Text('No products available.'),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              return _buildProductTile(context, snapshot.data!.docs[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductTile(BuildContext context, QueryDocumentSnapshot<Object?> productDoc) {
    Map<String, dynamic> product = productDoc.data() as Map<String, dynamic>;

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product['imageUrl'] as String,
              height: 100.0,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] as String,
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Price: \$${product['price']}',
                    style: const TextStyle(fontSize: 14.0),
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
