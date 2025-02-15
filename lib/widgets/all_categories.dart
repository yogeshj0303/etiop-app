import 'package:flutter/material.dart';

import '../screens/sub_category_screen.dart';
import '../services/api_services.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  List<dynamic> _categories = [];
  String? _errorMessage;

  Future<void> _fetchCategories() async {
    try {
      final categories = await ApiService().fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching categories: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: _buildCategoryGrid()),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Categories',
        style: TextStyle(color: Colors.black),
      ),
      clipBehavior: Clip.none,
      elevation: 1,
    );
  }

  Widget _buildCategoryGrid() {
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
        crossAxisSpacing: 10.0, // Horizontal space between grid items
        mainAxisSpacing: 10.0, // Vertical space between grid items
        childAspectRatio: 2, // Aspect ratio of each grid item
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return _buildCategoryItem(category);
      },
    );
  }

  Widget _buildCategoryItem(dynamic category) {
    return GestureDetector(
      onTap: () => _onCategoryTapped(category),
      child: Card(
        clipBehavior: Clip.antiAlias, // Clip the card to apply border radius
        elevation: 1, // Adds shadow effect for better visibility
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
        child: Center(
          child: Text(
            category['category_name'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _onCategoryTapped(dynamic category) {
    final categoryId = category['id'];
    final categoryName = category['category_name'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubcategoryScreen(
          categoryId: categoryId,
          categoryName: categoryName,
        ),
      ),
    );
  }
}
