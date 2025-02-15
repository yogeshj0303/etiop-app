import 'package:etiop_application/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:etiop_application/services/api_services.dart';
import '../modals/sub_category.dart';
import '../widgets/sub_category_related_shops.dart';

class SubcategoryScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const SubcategoryScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  _SubcategoryScreenState createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  late Future<List<Subcategory>> _subcategoriesFuture;

  @override
  void initState() {
    super.initState();
    _subcategoriesFuture =
        ApiService().fetchSubcategoriesByCategoryId(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MainScreen();
            }));
          },
        ),
        title: Text(widget.categoryName,
            style: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold)),
        elevation: 1,
      ),
      body: FutureBuilder<List<Subcategory>>(
        future: _subcategoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load subcategories'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No subcategories available'));
          } else {
            final subcategories = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Set the number of columns in the grid
                childAspectRatio: 1, // Aspect ratio for each item
                crossAxisSpacing: 8.0, // Horizontal space between items
                mainAxisSpacing: 8.0, // Vertical space between items
              ),
              itemCount: subcategories.length,
              itemBuilder: (context, index) {
                final subcategory = subcategories[index];
                return GestureDetector(
                  onTap: () {
                    // Handle subcategory tap (for example, navigate to a details page)
                    print(
                        'Tapped on subcategory: ${subcategory.subcategoryName}');
                    //navigate to SubCategoryRelatedShops

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategoryRelatedShops(
                          subCategoryId: subcategory.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Rounded corners for the card
                    ),
                    elevation: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image with border radius
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10.0)),
                          // Rounded corners for image
                          child: subcategory.subcategoryImage.isNotEmpty
                              ? Image.network(
                                  "https://etiop.acttconnect.com/${subcategory.subcategoryImage}",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 120, // Fixed height for the image
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error, size: 50),
                                )
                              : const Icon(Icons.category, size: 50),
                        ),
                        // Subcategory name with border radius for bottom part
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            subcategory.subcategoryName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
