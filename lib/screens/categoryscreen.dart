import 'package:flutter/material.dart';
import 'package:trier/screens/product_info_page.dart';

class ClothesCategoryScreen extends StatelessWidget {
  ClothesCategoryScreen({Key? key}) : super(key: key);

  // Dummy data for clothes categories
  final List<Map<String, dynamic>> clothesCategories = [
    {'name': 'T-Shirts', 'image': 'https://thehouseofrare.com/cdn/shop/products/IMG_0053_5c650849-9d9d-4cc3-8863-6a23778cd9a0.jpg?v=1675170808'},
    {'name': 'Jeans', 'image': 'https://images.pexels.com/photos/603022/pexels-photo-603022.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'},
    {'name': 'Dresses', 'image':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZ8boeFXYr6B-gdEZD8uFyPglicR_EtBeAMA&usqp=CAU'},
    {'name': 'Jackets', 'image': 'https://images.pexels.com/photos/7679656/pexels-photo-7679656.jpeg?cs=srgb&dl=pexels-mart-production-7679656.jpg&fm=jpg'},
    {'name': 'Footwear', 'image': 'https://images.pexels.com/photos/1240892/pexels-photo-1240892.jpeg?cs=srgb&dl=pexels-mstudio-1240892.jpg&fm=jpg'},
    {'name': 'Accessories', 'image': 'https://images.pexels.com/photos/18533675/pexels-photo-18533675.jpeg?cs=srgb&dl=pexels-tien-nguyen-18533675.jpg&fm=jpg'},
    {'name': 'Coats', 'image': 'https://images.pexels.com/photos/6532339/pexels-photo-6532339.jpeg?cs=srgb&dl=pexels-cottonbro-studio-6532339.jpg&fm=jpg'},
    {'name': 'Activewear', 'image': 'https://images.pexels.com/photos/416778/pexels-photo-416778.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'},
    // Add more categories with images
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clothes Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: clothesCategories.length,
          itemBuilder: (context, index) {
            return _buildCategoryTile(context, clothesCategories[index]);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, Map<String, dynamic> category) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to the ProductPage with the selected category
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(productId: 'rR4xZFMD033420vOwM4R'),
            ),
          );

        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              category['image'] as String,
              width: 140.0, // Adjust the width as needed
              height: 130.0, // Adjust the height as needed
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 2.0),
            Text(
              category['name'] as String,
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
