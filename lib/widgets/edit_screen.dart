import 'package:etiop_application/screens/user_profile.dart';
import 'package:etiop_application/utils/location_data.dart';
import 'package:flutter/material.dart';
import 'package:etiop_application/modals/shop_model.dart';
import 'package:image_picker/image_picker.dart'; // Add this import
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:collection';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/language_provider.dart';

class EditShopScreen extends StatefulWidget {
  final Shop shop;
  final String categoryName;

  const EditShopScreen({super.key, required this.shop, required this.categoryName});

  @override
  _EditShopScreenState createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  File? _shopImage;
  List<File> _catalogImages = [];

  // Variables to hold the input values
  String? shopName = '';
  String? shopNo = '';
  String? area = '';
  String? city = '';
  String? state = '';
  String? district = '';
  String? country = '';
  String? zipcode = '';
  String? description = '';
  String? mobileNo = '';
  String? email = '';
  String? websiteLink = '';
  String? googleMapLink = '';
  String? shopImageUrl = '';
  List<String> catalogImageUrls = [];

  // Add category type variable
  String _categoryType = 'private';

  // Add these variables at the top of the _EditShopScreenState class
  String? _selectedState;
  String? _selectedDistrict;
  List<String> _states = [];
  List<String> _districts = [];

  // Add services variable
  String? services = '';

  // Add departmentName variable
  String? departmentName = '';

  // Add officeName variable
  String? officeName = '';

  // Add officerName variable
  String? officerName = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
    _determineCategoryType();
    _initializeLocationData();
  }

  void _initializeData() {
    // Initialize all data from Shop model
    setState(() {
      shopName = widget.shop.shopName;
      shopNo = widget.shop.shopNo;
      area = widget.shop.area;
      city = widget.shop.city;
      state = widget.shop.state;
      district = widget.shop.district;
      country = widget.shop.country;
      zipcode = widget.shop.zipcode;
      websiteLink = widget.shop.websiteLink;
      googleMapLink = widget.shop.googleMapLink;
      description = widget.shop.description;
      mobileNo = widget.shop.mobileNo;
      email = widget.shop.email;
      departmentName = widget.shop.departmentName;
      officeName = widget.shop.officeName;
      officerName = widget.shop.officerName;
      
      // Initialize shop image
      if (widget.shop.shopImage != null) {
        shopImageUrl = 'https://etiop.in/${widget.shop.shopImage}';
      }

      // Initialize catalog images
      catalogImageUrls = [];
      if (widget.shop.catlog_0 != null) {
        catalogImageUrls.add('https://etiop.in/${widget.shop.catlog_0}');
      }
      if (widget.shop.catlog_1 != null) {
        catalogImageUrls.add('https://etiop.in/${widget.shop.catlog_1}');
      }
      if (widget.shop.catlog_2 != null) {
        catalogImageUrls.add('https://etiop.in/${widget.shop.catlog_2}');
      }
      if (widget.shop.catlog_3 != null) {
        catalogImageUrls.add('https://etiop.in/${widget.shop.catlog_3}');
      }
      if (widget.shop.catlog_4 != null) {
        catalogImageUrls.add('https://etiop.in/${widget.shop.catlog_4}');
      }
    });
  }

  // Modify this method to use widget.categoryName
  void _determineCategoryType() {
    setState(() {
      _categoryType = widget.categoryName.toLowerCase();
    });
  }

  // Add method to initialize location data
  void _initializeLocationData() {
    // This will be updated when the widget builds to use localized data
    _states = [];
    _selectedState = widget.shop.state;
    if (_selectedState != null) {
      _districts = [];
      _selectedDistrict = widget.shop.district;
    }
  }

  Future<void> _pickShopImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _shopImage = File(image.path);
      });
    }
  }

  Future<void> _pickCatalogImages() async {
    final remainingSlots = 5 - (catalogImageUrls.length + _catalogImages.length);
    if (remainingSlots <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 5 catalog images allowed')),
      );
      return;
    }

    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        final newImages = images.take(remainingSlots).map((image) => File(image.path)).toList();
        _catalogImages.addAll(newImages);
      });
    }
  }

  Future<void> _updateShop() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://etiop.in/api/shop-data-update/${widget.shop.id}'),
        );

        // Add common fields
        Map<String, String> fields = {
          'shop_owner_id': widget.shop.shopOwnerId.toString(),
          'owner_id': widget.shop.ownerId.toString(),
          'category_id': widget.shop.categoryId.toString(),
          'subcategory_id': widget.shop.subcategoryId.toString(),
          'shop_name': shopName ?? '',
          'shop_no': shopNo ?? '',
          'area': area ?? '',
          'city': city ?? '',
          'state': _selectedState ?? '',
          'district': _selectedDistrict ?? '',
          'country': country ?? '',
          'zipcode': zipcode ?? '',
          'description': description ?? '',
          'website_link': websiteLink ?? '',
          'google_map_link': googleMapLink ?? '',
          'mobile_no': mobileNo ?? '',
          'email': email ?? '',
          'department_name': departmentName ?? '',
          'office_name': officeName ?? '',
          'officer_name': officerName ?? '',
        };

        // Add fields based on category type
        if (_categoryType == 'government') {
          fields.addAll({
            'govt_name': widget.shop.govtName ?? '',
          });
        } else if (_categoryType == 'public') {
          fields.addAll({
            'shop_name': shopName ?? '',
            'mobile_no': widget.shop.mobileNo ?? '',
            'email': widget.shop.email ?? '',
            'area': area ?? '',
            'description': description ?? '',
            'website_link': websiteLink ?? '',
            'google_map_link': googleMapLink ?? '',
          });
        } else {
          fields.addAll({
            'shop_name': shopName ?? '',
            'shop_no': shopNo ?? '',
            'area': area ?? '',
            'city': city ?? '',
            'state': _selectedState ?? '',
            'district': _selectedDistrict ?? '',
            'country': country ?? '',
            'zipcode': zipcode ?? '',
            'description': description ?? '',
            'website_link': websiteLink ?? '',
            'google_map_link': googleMapLink ?? '',
          });
        }

        request.fields.addAll(fields);

        // Add shop image if selected
        if (_shopImage != null) {
          request.files.add(
            await http.MultipartFile.fromPath('shop_image', _shopImage!.path),
          );
        }

        // Add catalog images
        for (int i = 0; i < _catalogImages.length && i < 5; i++) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'catlog_$i',
              _catalogImages[i].path,
            ),
          );
        }

        var response = await request.send();
        var responseData = await response.stream.bytesToString();
        
        Map<String, dynamic> jsonResponse = {};
        try {
          jsonResponse = json.decode(responseData);
        } catch (e) {
          print('Error parsing response: $e');
        }

        if (response.statusCode == 200) {
          if (mounted) {
            // Create updated shop object with the new values
            final updatedShop = Shop(
              id: widget.shop.id,
              shopOwnerId: widget.shop.shopOwnerId,
              ownerId: widget.shop.ownerId,
              categoryId: widget.shop.categoryId,
              subcategoryId: widget.shop.subcategoryId,
              shopName: shopName,
              shopNo: shopNo,
              area: area,
              city: city,
              state: _selectedState,
              district: _selectedDistrict,
              country: country,
              zipcode: zipcode,
              shopStatus: widget.shop.shopStatus,
              description: description,
              departmentName: departmentName,
              websiteLink: websiteLink,
              googleMapLink: googleMapLink,
              shopImage: _shopImage != null ? _shopImage!.path : widget.shop.shopImage,
              catlog_0: _catalogImages.isNotEmpty ? _catalogImages[0].path : widget.shop.catlog_0,
              catlog_1: _catalogImages.length > 1 ? _catalogImages[1].path : widget.shop.catlog_1,
              catlog_2: _catalogImages.length > 2 ? _catalogImages[2].path : widget.shop.catlog_2,
              catlog_3: _catalogImages.length > 3 ? _catalogImages[3].path : widget.shop.catlog_3,
              catlog_4: _catalogImages.length > 4 ? _catalogImages[4].path : widget.shop.catlog_4,
              shopOwner: widget.shop.shopOwner,
              createdAt: widget.shop.createdAt,
              updatedAt: widget.shop.updatedAt,
              paymentStatus: widget.shop.paymentStatus,
              expiryDate: widget.shop.expiryDate,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Shop updated successfully'),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to the UserProfileScreen in the bottom bar
            Navigator.pop(context);
            Navigator.pop(context);
          }
        } else {
          // Handle different error status codes
          String errorMessage = 'Failed to update shop';
          
          if (response.statusCode == 422) {
            // Handle validation errors
            if (jsonResponse.containsKey('errors')) {
              var errors = jsonResponse['errors'] as Map<String, dynamic>;
              errorMessage = errors.entries
                  .map((e) => '${e.key}: ${(e.value as List).join(', ')}')
                  .join('\n');
            } else if (jsonResponse.containsKey('message')) {
              errorMessage = jsonResponse['message'];
            }
          } else if (response.statusCode == 401) {
            errorMessage = 'Unauthorized. Please login again.';
          } else if (response.statusCode == 403) {
            errorMessage = 'You do not have permission to update this shop.';
          } else if (response.statusCode == 404) {
            errorMessage = 'Shop not found.';
          } else {
            errorMessage = 'Server error occurred. Please try again later.';
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          }
        }
      } catch (e) {
        print('Error updating shop: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Network error: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Edit Shop', 
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 1,
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeader(),
              const SizedBox(height: 20),
              
              // Form fields based on category type
              _buildFormFields(),
              
              // Address Section
              if (_categoryType == 'private') _buildAddressSection(),
              
              // Images Section
              _buildImagesSection(),
              
              const SizedBox(height: 20),
              // Submit Button
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Edit Shop Details',
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFormFields() {
    // Default fields for all categories
    List<Widget> defaultFields = [
      //state and district should be dropdown
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0,top: 0),
        child: DropdownButtonFormField<String>(
          value: _selectedState,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.state,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          items: Provider.of<LanguageProvider>(context, listen: false).localizedStates.map((String state) {
            return DropdownMenuItem<String>(  
              value: state,
              child: Text(state),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedState = newValue;
              // Reset the selected district when state changes
              _selectedDistrict = null;
            });
          },
          validator: (value) => value == null ? AppLocalizations.of(context)!.pleaseSelectState : null,
        ),
      ),
      
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: DropdownButtonFormField<String>(
          value: _selectedDistrict,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.district,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          items: _selectedState == null
              ? []
              : Provider.of<LanguageProvider>(context, listen: false).getLocalizedDistricts(_selectedState!).map((String district) {
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
          validator: (value) => value == null ? AppLocalizations.of(context)!.pleaseSelectDistrict : null,
        ),
      ),
      
      _buildTextField(AppLocalizations.of(context)!.city, 'city', city),
      _buildTextField(AppLocalizations.of(context)!.area, 'area', area),
      _buildTextField(AppLocalizations.of(context)!.zipcode, 'zipcode', zipcode),
    ];

    if (_categoryType == 'government') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(AppLocalizations.of(context)!.departmentName, 'department_name', departmentName),
          _buildTextField(AppLocalizations.of(context)!.officeName, 'office_name', officeName),
          _buildTextField(AppLocalizations.of(context)!.officerName, 'officer_name', officerName),
          _buildTextField(AppLocalizations.of(context)!.mobileNumber, 'mobile_no', mobileNo),
          _buildTextField(AppLocalizations.of(context)!.email, 'email', widget.shop.email),
          _buildTextField(AppLocalizations.of(context)!.description, 'description', description),
          _buildTextField(AppLocalizations.of(context)!.websiteLink, 'website_link', websiteLink, isRequired: false),
          ...defaultFields,
          _buildTextField(AppLocalizations.of(context)!.googleMapLocation, 'google_map_link', googleMapLink, isRequired: false),
        ],
      );
    } else if (_categoryType == 'public') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(AppLocalizations.of(context)!.spotName, 'shop_name', shopName),
          _buildTextField(AppLocalizations.of(context)!.contactNumber, 'mobile_no', mobileNo),
          _buildTextField(AppLocalizations.of(context)!.email, 'email', widget.shop.email),
          _buildTextField(AppLocalizations.of(context)!.description, 'description', description),
          _buildTextField(AppLocalizations.of(context)!.websiteLink, 'website_link', websiteLink, isRequired: false),
          ...defaultFields,
          _buildTextField(AppLocalizations.of(context)!.googleMapLocation, 'google_map_link', googleMapLink, isRequired: false),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(AppLocalizations.of(context)!.shopName, 'shop_name', shopName),
          _buildTextField(AppLocalizations.of(context)!.shopNo, 'shop_no', shopNo),
          _buildTextField(AppLocalizations.of(context)!.description, 'description', description),
          _buildTextField(AppLocalizations.of(context)!.websiteLink, 'website_link', websiteLink, isRequired: false),
          ...defaultFields,
          _buildTextField(AppLocalizations.of(context)!.googleMapLink, 'google_map_link', googleMapLink, isRequired: false),
        ],
      );
    }
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(AppLocalizations.of(context)!.area, 'area', area),
        // _buildTextField(AppLocalizations.of(context)!.city, 'city', city),
        
        // State Dropdown
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: DropdownButtonFormField<String>(
            value: _selectedState,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.state,
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(width: 2.0),
              ),
            ),
            items: Provider.of<LanguageProvider>(context, listen: false).localizedStates.map((String state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(state),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedState = newValue;
                state = newValue;
                // Reset district when state changes
                _selectedDistrict = null;
                district = null;
              });
            },
            validator: (value) => value == null ? AppLocalizations.of(context)!.pleaseSelectState : null,
          ),
        ),

        // District Dropdown
        if (_selectedState != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedDistrict,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.district,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(width: 2.0),
                ),
              ),
              items: Provider.of<LanguageProvider>(context, listen: false).getLocalizedDistricts(_selectedState!).map((String district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDistrict = newValue;
                  district = newValue;
                });
              },
              validator: (value) => value == null ? AppLocalizations.of(context)!.pleaseSelectDistrict : null,
            ),
          ),

        _buildTextField(AppLocalizations.of(context)!.country, 'country', country),
        _buildTextField(AppLocalizations.of(context)!.zipcode, 'zipcode', zipcode),
      ],
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shop Image
        const SizedBox(height: 20),
        Text(AppLocalizations.of(context)!.shopImage, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        _buildShopImagePicker(),

        // Catalog Images
        const SizedBox(height: 20),
        Text(AppLocalizations.of(context)!.catalogueImages, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        _buildCatalogImagesPicker(),
      ],
    );
  }

  Widget _buildShopImagePicker() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Choose Image Source'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_camera, size: 32),
                    onPressed: () async {
                      Navigator.pop(context);
                      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(() {
                          _shopImage = File(image.path);
                        });
                      }
                    },
                    tooltip: 'Camera',
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_library, size: 32),
                    onPressed: () async {
                      Navigator.pop(context);
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _shopImage = File(image.path);
                        });
                      }
                    },
                    tooltip: 'Gallery',
                  ),
                ],
              ),
            );
          },
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 250,
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _shopImage != null
                ? Image.file(
                    _shopImage!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : (shopImageUrl?.isNotEmpty ?? false)
                    ? Image.network(
                        shopImageUrl!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error_outline, size: 50),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.store, size: 50),
                      ),
          ),
        ),
      ),
    );
  }

  Widget _buildCatalogImagesPicker() {
    final totalImages = catalogImageUrls.length + _catalogImages.length;
    final showAddButton = totalImages < 5;
    final itemCount = showAddButton ? totalImages + 1 : totalImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index < catalogImageUrls.length) {
              return _buildImageTile(
                url: catalogImageUrls[index],
                isFile: false,
              );
            } else if (index < totalImages) {
              return _buildImageTile(
                image: _catalogImages[index - catalogImageUrls.length],
                isFile: true,
              );
            } else {
              return _buildAddImageTile();
            }
          },
        ),
        if (totalImages >= 5)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Maximum 5 catalog images allowed',
              style: TextStyle(color: Colors.red[600], fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildImageTile({File? image, String? url, required bool isFile}) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: isFile
              ? Image.file(
                  image!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading file image: $error');
                    return const Center(child: Icon(Icons.error_outline));
                  },
                )
              : Image.network(
                  url!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading network image: $error');
                    return const Center(child: Icon(Icons.error_outline));
                  },
                ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                setState(() {
                  if (isFile) {
                    _catalogImages.remove(image);
                  } else {
                    catalogImageUrls.remove(url);
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageTile() {
    return GestureDetector(
      onTap: _pickCatalogImages,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add_photo_alternate, size: 40),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateShop,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text(
                'Save Changes',
                style: TextStyle(fontSize: 18),
              ),
      ),
    );
  }

  Widget _buildTextField(String label, String key, String? initialValue, {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: key == 'description' || key == 'services',
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(width: 2.0),
          ),
          // helperText: (key == 'website_link' || key == 'google_map_link' || key == 'services') ? '' : null,
        ),
        validator: (value) {
          if (key == 'website_link' || key == 'google_map_link' || key == 'services') {
            return null;
          }
          if (value?.isEmpty ?? true) {
            return 'This field is required';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            switch (key) {
              case 'shop_name':
                shopName = value;
                break;
              case 'shop_no':
                shopNo = value;
                break;
              case 'area':
                area = value;
                break;
              case 'city':
                city = value;
                break;
              case 'state':
                state = value;
                break;
              case 'district':
                district = value;
                break;
              case 'country':
                country = value;
                break;
              case 'zipcode':
                zipcode = value;
                break;
              case 'description':
                description = value;
                break;
              case 'website_link':
                websiteLink = value;
                break;
              case 'google_map_link':
                googleMapLink = value;
                break;
              case 'services':
                services = value;
                break;
              case 'mobile_no':
                mobileNo = value;
                break;
              case 'email':
                email = value;
                break;
              case 'department_name':
                departmentName = value;
                break;
              case 'office_name':
                officeName = value;
                break;
              case 'officer_name':
                officerName = value;
                break;
            }
          });
        },
      ),
    );
  }
}
