import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> categories = [
    'Electronics',
    'Clothing',
    'Home & Furniture',
    'Books',
    'Beauty',
    'Sports',
    // Add more categories as needed
  ];

  List<String> recentSearches = [
    'Flutter development',
    'Mobile app design',
    'Smartwatch',
    'Summer dresses',
    'Home decor',
    'Fitness equipment',
    // Add more recent searches as needed
  ];

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Search'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    onSearch(searchController.text);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Browse Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(category: categories[index]);
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  return RecentSearchCard(searchTerm: recentSearches[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSearch(String term) {
    // Handle the search logic
    // For simplicity, just add the searched term to recent searches
    if (term.isNotEmpty && !recentSearches.contains(term)) {
      setState(() {
        recentSearches.insert(0, term); // Insert at the beginning of the list
        if (recentSearches.length > 5) {
          recentSearches.removeLast(); // Limit the list to 5 recent searches
        }
      });
    }
  }
}

class CategoryCard extends StatelessWidget {
  final String category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 3,
        child: InkWell(
          onTap: () {
            // Handle category selection
            print('Selected category: $category');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecentSearchCard extends StatelessWidget {
  final String searchTerm;

  const RecentSearchCard({super.key, required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 3,
        child: InkWell(
          onTap: () {
            // Handle recent search selection
            print('Selected search term: $searchTerm');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                searchTerm,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

