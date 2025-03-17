import 'dart:convert'; // For decoding JSON
import 'dart:io'; // For File class

import 'package:etiop_application/modals/shop_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modals/sub_category.dart';
import '../services/api_services.dart';
import '../utils/location_data.dart';

class AddShop extends StatefulWidget {
  const AddShop({Key? key}) : super(key: key);

  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  XFile? _shopImage;
  List<XFile>? _catalogueImages = []; // Store multiple images
  String? _selectedCategory; // To store the selected category ID
  String? _selectedSubCategory; // To store the selected subcategory ID
  List<dynamic> _categories = []; // To store the list of categories
  List<dynamic> _subCategories = []; // To store the list of subcategories

  // Create text editing controllers for form fields to preserve data
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopNoController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController websiteLinkController = TextEditingController();
  TextEditingController googleMapLinkController = TextEditingController();

  // Add new controllers for government and public fields
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController officeNameController = TextEditingController();
  TextEditingController officerNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController spotNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController spotEmailController = TextEditingController();

  // Add variable to track category type
  String _categoryType = 'private';

  // Add these variables with other state variables
  String? _selectedState;
  String? _selectedDistrict;

  // Add a TextEditingController for the pincode
  TextEditingController pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch categories when the screen loads
    // Initialize other controllers if needed
  }

  @override
  void dispose() {
    // Dispose of the pincode controller
    pincodeController.dispose();
    // Dispose of other controllers
    shopNameController.dispose();
    shopNoController.dispose();
    areaController.dispose();
    cityController.dispose();
    stateController.dispose();
    descriptionController.dispose();
    websiteLinkController.dispose();
    googleMapLinkController.dispose();
    departmentNameController.dispose();
    officeNameController.dispose();
    officerNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    spotNameController.dispose();
    contactNumberController.dispose();
    spotEmailController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('https://etiop.acttconnect.com/api/all-categories'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _categories = data['data'];
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch subcategories based on category selection using ApiService
  Future<void> _fetchSubCategories(int categoryId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(
          'https://etiop.acttconnect.com/api/subcategories-by-cat/$categoryId'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _subCategories =
              data.map((json) => Subcategory.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _shopImage = pickedFile;
    });
  }

  Future<void> _pickCatalogueImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        if (_catalogueImages!.length + pickedFiles.length <= 5) {
          _catalogueImages!.addAll(pickedFiles);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only select up to 5 images')),
          );
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _catalogueImages!.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('id') ?? '';

        // Base request body with common fields
        final Map<String, String> requestBody = {
          'shop_owner_id': userId,
          'owner_id': '1',
          'category_id': _selectedCategory?.toString() ?? '',
          'subcategory_id': _selectedSubCategory ?? '0',
          'country': 'India',
          'zipcode': _formData['pincode'] ?? '',
          'shop_status': 'approved',
          'district': _selectedDistrict ?? '',
          'state': _selectedState ?? '',
          'city': cityController.text,
        };

        // Add fields based on category type
        if (_categoryType == 'government') {
          requestBody.addAll({
            'department_name': departmentNameController.text,
            'office_name': officeNameController.text,
            'officer_name': officerNameController.text,
            'shop_name': departmentNameController.text,
            'area': areaController.text,
            'city': cityController.text,
            'description': descriptionController.text,
            'website_link': websiteLinkController.text,
            'google_map_link': googleMapLinkController.text,
            'mobile_number': mobileNumberController.text,
            'email': emailController.text,
            'services': '', // Add empty services field
          });
        } else if (_categoryType == 'public') {
          requestBody.addAll({
            'shop_name': spotNameController.text,
            'area': areaController.text,
            'description': descriptionController.text,
            'website_link': websiteLinkController.text,
            'google_map_link': googleMapLinkController.text,
            'contact_number': contactNumberController.text,
            'city': cityController.text,
            'email': spotEmailController.text,
            'services': '', // Add empty services field
          });
        } else {
          // Private business
          requestBody.addAll({
            'shop_name': shopNameController.text,
            'shop_no': shopNoController.text,
            'area': areaController.text,
            'city': cityController.text,
            'description': descriptionController.text,
            'website_link': websiteLinkController.text,
            'google_map_link': googleMapLinkController.text,
            'services': '', // Add empty services field
          });
        }

        final result = await _apiService.createShop(
          requestBody,
          _shopImage != null ? File(_shopImage!.path) : null,
          _catalogueImages != null
              ? _catalogueImages!.map((image) => File(image.path)).toList()
              : [],
        );

        if (result.containsKey('success') && result['success'] == true) {
          print('Response: $result');
          if (result.containsKey('data')) {
            print('Shop Data: ${result['data']}');
          }
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']?.toString() ?? "Shop created successfully"),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']?.toString() ?? "Failed to create shop"),
            ),
          );
        }
      } catch (e) {
        print('Exception occurred: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('CREATE BUSINESS',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        
                        // Category Dropdown
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Select Category',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            value: _selectedCategory,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategory = newValue;
                                _selectedSubCategory = null;
                                
                                // Determine category type
                                if (newValue != null) {
                                  final category = _categories.firstWhere(
                                    (cat) => cat['id'].toString() == newValue,
                                    orElse: () => null,
                                  );
                                  if (category != null) {
                                    _categoryType = category['category_name'].toString().toLowerCase();
                                  }
                                }
                              });
                              if (newValue != null) {
                                _fetchSubCategories(int.parse(newValue));
                              }
                            },
                            items: _categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category['id'].toString(),
                                child: Text(category['category_name']),
                              );
                            }).toList(),
                            validator: (value) =>
                                value == null ? 'Please select a category' : null,
                          ),
                        ),

                        // Show the rest of the form only if a category is selected
                        if (_selectedCategory != null) ...[
                          // Subcategory Dropdown
                          if (_subCategories.isNotEmpty)
                            DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Select Subcategory',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              value: _selectedSubCategory != null
                                  ? int.tryParse(_selectedSubCategory!)
                                  : null,
                              onChanged: (int? newValue) {
                                setState(() {
                                  _selectedSubCategory = newValue?.toString();
                                });
                              },
                              items: _subCategories.map<DropdownMenuItem<int>>(
                                  (dynamic subCategory) {
                                final Subcategory sub =
                                    subCategory as Subcategory;
                                return DropdownMenuItem<int>(
                                  value: sub.id,
                                  child: Text(sub.subcategoryName ?? ''),
                                );
                              }).toList(),
                              validator: (value) => value == null
                                  ? 'Please select a subcategory'
                                  : null,
                            ),
                          const SizedBox(height: 16),

                          // Conditional form fields based on category type
                          if (_categoryType == 'government') ...[
                            _buildTextField('Department Name', 'department_name', departmentNameController, 14, const Icon(Icons.business, size: 18)),
                            _buildTextField('Office Name', 'office_name', officeNameController, 14, const Icon(Icons.business_center, size: 18)),
                            _buildTextField('Officer/Employee Name', 'officer_name', officerNameController, 14, const Icon(Icons.person, size: 18)),
                            _buildTextField('Mobile Number', 'mobile_number', mobileNumberController, 14, const Icon(Icons.phone, size: 18), keyboardType: TextInputType.number),
                            _buildTextField('Email ID', 'email', emailController, 14, const Icon(Icons.email, size: 18)),
                            _buildTextField('Description', 'description', descriptionController, 14, const Icon(Icons.description, size: 18)),
                            _buildTextField('Website', 'website_link', websiteLinkController, 14, const Icon(Icons.link, size: 18), isRequired: false),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'State',
                                prefixIcon: const Icon(Icons.location_city, size: 18),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                              ),
                              value: _selectedState,
                              items: IndianLocation.states.map((String state) {
                                return DropdownMenuItem<String>(
                                  value: state,
                                  child: Text(state),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedState = newValue;
                                  _selectedDistrict = null;
                                });
                              },
                              validator: (value) => value == null ? 'Please select a state' : null,
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'District',
                                prefixIcon: const Icon(Icons.location_city, size: 18),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                              ),
                              value: _selectedDistrict,
                              items: _selectedState == null
                                  ? []
                                  : IndianLocation.getDistricts(_selectedState!).map((String district) {
                                      return DropdownMenuItem<String>(
                                        value: district,
                                        child: Text(district),
                                      );
                                    }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDistrict = newValue;
                                });
                              },
                              validator: (value) => value == null ? 'Please select a district' : null,
                            ),
                            const SizedBox(height: 14),
                            //add city field
                            _buildTextField('City', 'city', cityController, 14, const Icon(Icons.location_city, size: 18)),
                            _buildTextField('Pincode', 'pincode', pincodeController, 14, const Icon(Icons.pin_drop, size: 18)),
                            _buildTextField('Office Address', 'area', areaController, 14, const Icon(Icons.location_on, size: 18)),
                            _buildTextField('Google Map Location', 'google_map_link', googleMapLinkController, 14, const Icon(Icons.map, size: 18), isRequired: false),
                          ] else if (_categoryType == 'public') ...[
                            _buildTextField('Spot Name', 'spot_name', spotNameController, 14, const Icon(Icons.place, size: 18)),
                            _buildTextField('Contact Number', 'contact_number', contactNumberController, 14, const Icon(Icons.phone, size: 18), keyboardType: TextInputType.number),
                            _buildTextField('Email ID', 'email', spotEmailController, 14, const Icon(Icons.email, size: 18)),
                            _buildTextField('Description', 'description', descriptionController, 14, const Icon(Icons.description, size: 18)),
                            _buildTextField('Website', 'website_link', websiteLinkController, 14, const Icon(Icons.link, size: 18), isRequired: false),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'State',
                                prefixIcon: const Icon(Icons.location_city, size: 18),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                              ),
                              value: _selectedState,
                              items: IndianLocation.states.map((String state) {
                                return DropdownMenuItem<String>(
                                  value: state,
                                  child: Text(state),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedState = newValue;
                                  _selectedDistrict = null;
                                });
                              },
                              validator: (value) => value == null ? 'Please select a state' : null,
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'District',
                                prefixIcon: const Icon(Icons.location_city, size: 18),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                              ),
                              value: _selectedDistrict,
                              items: _selectedState == null
                                  ? []
                                  : IndianLocation.getDistricts(_selectedState!).map((String district) {
                                      return DropdownMenuItem<String>(
                                        value: district,
                                        child: Text(district),
                                      );
                                    }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDistrict = newValue;
                                });
                              },
                              validator: (value) => value == null ? 'Please select a district' : null,
                            ),
                            const SizedBox(height: 14),
                            //add city field
                            _buildTextField('City', 'city', cityController, 14, const Icon(Icons.location_city, size: 18)),
                            _buildTextField('Pincode', 'pincode', pincodeController, 14, const Icon(Icons.pin_drop, size: 18)),
                            _buildTextField('Spot Address', 'area', areaController, 14, const Icon(Icons.location_on, size: 18)),
                            _buildTextField('Google Map Location', 'google_map_link', googleMapLinkController, 14, const Icon(Icons.map, size: 18), isRequired: false),
                          ] else ...[
                            // Original private business form fields
                            _buildTextField('Shop Name', 'shop_name', shopNameController, 14, const Icon(Icons.storefront, size: 18)),
                            _buildTextField('Shop No', 'shop_no', shopNoController, 14, const Icon(Icons.home, size: 18)),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'State',
                                prefixIcon: const Icon(Icons.location_city, size: 18),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                              ),
                              value: _selectedState,
                              items: IndianLocation.states.map((String state) {
                                return DropdownMenuItem<String>(
                                  value: state,
                                  child: Text(state),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedState = newValue;
                                  _selectedDistrict = null;
                                });
                              },
                              validator: (value) => value == null ? 'Please select a state' : null,
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'District',
                                prefixIcon: const Icon(Icons.location_city, size: 18),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                              ),
                              value: _selectedDistrict,
                              items: _selectedState == null
                                  ? []
                                  : IndianLocation.getDistricts(_selectedState!).map((String district) {
                                      return DropdownMenuItem<String>(
                                        value: district,
                                        child: Text(district),
                                      );
                                    }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDistrict = newValue;
                                });
                              },
                              validator: (value) => value == null ? 'Please select a district' : null,
                            ),
                            const SizedBox(height: 14),
                            //add city field
                            _buildTextField('City', 'city', cityController, 14, const Icon(Icons.location_city, size: 18)),
                            _buildTextField('Pincode', 'pincode', pincodeController, 14, const Icon(Icons.pin_drop, size: 18)),
                            _buildTextField('Address', 'area', areaController, 14, const Icon(Icons.location_city, size: 18)),
                            _buildTextField('Description', 'description', descriptionController, 14, const Icon(Icons.description, size: 18)),
                            _buildTextField('Website Link', 'website_link', websiteLinkController, 14, const Icon(Icons.link, size: 18), isRequired: false),
                            _buildTextField('Google Map Link', 'google_map_link', googleMapLinkController, 14, const Icon(Icons.map, size: 18), isRequired: false),
                          ],

                          const SizedBox(height: 20),
                          
                          // Image picker sections
                          Text(
                            'Main Photo',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          
                          // Existing image picker code
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: _shopImage == null
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.image,
                                          size: 40,
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Pick an Image',
                                        ),
                                      ],
                                    )
                                  : Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            File(_shopImage!.path),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _shopImage = null;
                                              });
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(4),
                                              child: const Icon(
                                                Icons.close,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Catalogue images section
                          Text(
                            'Catalogue Images',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _catalogueImages!.length +
                                  (_catalogueImages!.length < 5 ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _catalogueImages!.length) {
                                  return GestureDetector(
                                    onTap: _catalogueImages!.length < 5
                                        ? _pickCatalogueImages
                                        : null,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      height: 80,
                                      width: 80,
                                      child: Icon(Icons.add, size: 40),
                                    ),
                                  );
                                } else {
                                  return Stack(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Image.file(
                                          File(_catalogueImages![index].path),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () => _removeImage(index),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.cancel,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          // Submit Button
                          Center(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ] else ...[
                          // Show a message when no category is selected
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'Please select a category to view the form',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String label, String key,
      TextEditingController controller, double fontSize, Icon icon, 
      {bool isRequired = true, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: label,
          labelStyle: TextStyle(fontSize: fontSize),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(width: 2.0),
          ),
        ),
        validator: isRequired 
            ? (value) => value?.isEmpty ?? true ? 'This field is required' : null
            : null,
        onSaved: (value) => _formData[key] = value?.trim() ?? '',
      ),
    );
  }
}
