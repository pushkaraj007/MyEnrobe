import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:trier/screens/categoryscreen.dart';

import 'AvatarScreen.dart';
import 'avatarhome.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> bannerImages = [
    'images/shoppics.png',
    'images/banner2.jpg',
    // Add more banner images as needed
  ];

  List<String> dealsImages = [
    'images/bgbg.png',
    'images/deals2.png',
    'images/bggg.jpg',
    // 'images/deal3.jpg',
    // Add more deal images as needed
  ];

  List<String> pose = [
    'images/avatar.png',
    // 'images/bggg.jpg',
    // 'images/deal3.jpg',
    // Add more deal images as needed
  ];

  late String searchQuery;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchQuery = '';
  }

  List<String> getFilteredProducts(List<String> products, String query) {
    return products
        .where((product) => product.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            CarouselSlider.builder(
              itemCount: bannerImages.length,
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                aspectRatio: 2.0,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ClothesCategoryScreen()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                        image: AssetImage(bannerImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 17, 10, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Deals for you',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to another page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DealsPage()),
                      );
                    },
                    child: const Row(
                      children: [
                        Text(
                          'See all',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.blue,
                          ),
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 1, 16, 2),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SubCategoryButton(subCategory: 'Men'),
                    SizedBox(width: 24.0),
                    SubCategoryButton(subCategory: 'Women'),
                    SizedBox(width: 24.0),
                    SubCategoryButton(subCategory: 'Girls'),
                    SizedBox(width: 24.0),
                    SubCategoryButton(subCategory: 'Boys'),
                    SizedBox(width: 24.0),
                    SubCategoryButton(subCategory: 'Pictures'),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 150.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dealsImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        // Handle tap on the deal item
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClothesCategoryScreen(),
                          ),
                        );
                      },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        dealsImages[index],
                        width: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 17, 10, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Design your Avatar',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to another page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  AvatarHomeScreen()),
                      );
                    },
                    child: const Row(
                      children: [
                        Text(
                          'See all',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.blue,
                          ),
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(10, 0, 16, 2),
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Row(
            //       children: [
            //         SubCategoryButton(subCategory: 'Men'),
            //         SizedBox(width: 24.0),
            //         SubCategoryButton(subCategory: 'Women'),
            //         SizedBox(width: 24.0),
            //       ],
            //     ),
            //   ),
            // ),
            Container(
              height: 150.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pose.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        // Handle tap on the deal item
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvatarHomeScreen(),
                          ),
                        );
                      },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        pose[index],
                        width: 400.0,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class SubCategoryButton extends StatelessWidget {
  final String subCategory;

  const SubCategoryButton({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle subcategory tap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ClothesCategoryScreen()),
        );      },
      child: Text(subCategory),
    );
  }
}

class DealsPage extends StatelessWidget {
  const DealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Deals'),
      ),
      body: const Center(
        child: Text('All Deals Page'),
      ),
    );
  }
}