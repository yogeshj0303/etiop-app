import 'package:flutter/material.dart';
import 'package:etiop_application/modals/shop_model.dart';
import 'package:etiop_application/services/api_services.dart'; // Import the ApiServices class
import 'package:image_picker/image_picker.dart'; // Add this import
import 'dart:io';
import 'package:http/http.dart' as http;

class EditShopScreen extends StatefulWidget {
  final Shop shop;

  const EditShopScreen({super.key, required this.shop});

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
  String? websiteLink = '';
  String? googleMapLink = '';
  String? shopImageUrl = '';
  List<String> catalogImageUrls = [];

  @override
  void initState() {
    super.initState();
    _initializeShopData();
  }

  void _initializeShopData() {
    // Basic details
    shopName = widget.shop.shopName ?? '';
    shopNo = widget.shop.shopNo ?? '';
    description = widget.shop.description ?? '';

    // Address details
    area = widget.shop.area ?? '';
    city = widget.shop.city ?? '';
    state = widget.shop.state ?? '';
    district = widget.shop.district ?? '';
    country = widget.shop.country ?? '';
    zipcode = widget.shop.zipcode ?? '';

    // Online presence
    websiteLink = widget.shop.websiteLink ?? '';
    googleMapLink = widget.shop.googleMapLink ?? '';

    // Images
    shopImageUrl = widget.shop.shopImage != null 
        ? 'https://etiop.acttconnect.com/${widget.shop.shopImage}'
        : null;
    
    // Initialize catalog images if they exist
    if (widget.shop.catalogImageUrls != null) {
      catalogImageUrls = widget.shop.catalogImageUrls!.map((url) {
        return url.startsWith('http') ? url : 'https://etiop.acttconnect.com/$url';
      }).toList();
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
    final remainingSlots = 5 - _catalogImages.length;
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
        // Create FormData for multipart request
        Map<String, dynamic> requestData = {
          'shop_owner_id': widget.shop.shopOwnerId.toString(),
          'owner_id': widget.shop.ownerId.toString(),
          'shop_name': shopName,
          'shop_no': shopNo,
          'area': area,
          'city': city,
          'state': state,
          'district': district,
          'country': country,
          'zipcode': zipcode,
          'shop_status': widget.shop.shopStatus,
          'description': description,
          'services': widget.shop.services ?? '',
        };

        if (widget.shop.categoryId != null) {
          requestData['category_id'] = widget.shop.categoryId.toString();
        }
        if (widget.shop.subcategoryId != null) {
          requestData['subcategory_id'] = widget.shop.subcategoryId.toString();
        }

        // Handle optional text fields
        if (websiteLink?.isNotEmpty ?? false) {
          requestData['website_link'] = websiteLink;
        }
        if (googleMapLink?.isNotEmpty ?? false) {
          requestData['google_map_link'] = googleMapLink;
        }

        // Handle shop image
        if (_shopImage != null) {
          requestData['shop_image'] = await http.MultipartFile.fromPath(
            'shop_image',
            _shopImage!.path
          );
        }

        // Handle catalog images
        if (_catalogImages.isNotEmpty) {
          for (int i = 0; i < _catalogImages.length && i < 5; i++) {
            requestData['catlog_$i'] = await http.MultipartFile.fromPath(
              'catlog_$i',
              _catalogImages[i].path
            );
          }
        }

        // Create ApiService instance and call updateShop
        final apiService = ApiService();
        await apiService.updateShop(
          widget.shop.id.toString(),
          requestData,
          _shopImage,
          _catalogImages,
        );
        
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating shop: $e')),
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
              
              // Basic Details Section
              _buildBasicDetailsSection(),

// Online Presence Section
              _buildOnlinePresenceSection(),
              
              // Address Section
              _buildAddressSection(),
              
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

  Widget _buildBasicDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Shop Name', 'shop_name', shopName),
        _buildTextField('Shop No', 'shop_no', shopNo),
        _buildTextField('Description', 'description', description),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Area', 'area', area),
        _buildTextField('City', 'city', city),
        _buildTextField('State', 'state', state),
        _buildTextField('District', 'district', district),
        _buildTextField('Country', 'country', country),
        _buildTextField('Zipcode', 'zipcode', zipcode),
      ],
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shop Image
        const SizedBox(height: 20),
        Text('Shop Image', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        _buildShopImagePicker(),

        // Catalog Images
        const SizedBox(height: 20),
        Text('Catalog Images', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        _buildCatalogImagesPicker(),
      ],
    );
  }

  Widget _buildShopImagePicker() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _shopImage != null
                ? Image.file(_shopImage!, fit: BoxFit.cover)
                : (shopImageUrl?.isNotEmpty ?? false)
                    ? Image.network(
                        shopImageUrl!,
                        fit: BoxFit.cover,
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
                    : const Icon(Icons.store, size: 50),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.black),
              onPressed: _pickShopImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogImagesPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._catalogImages.map((image) => _buildImageTile(image: image, isFile: true)),
            if (_catalogImages.length < 5) _buildAddImageTile(),
          ],
        ),
        if (_catalogImages.length >= 5)
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
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          if (isFile)
            Image.file(image!, fit: BoxFit.cover)
          else
            Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error_outline),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
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
        ],
      ),
    );
  }

  Widget _buildAddImageTile() {
    return GestureDetector(
      onTap: _pickCatalogImages,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.add_photo_alternate, size: 40),
      ),
    );
  }

  Widget _buildOnlinePresenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Website Link', 'website_link', websiteLink),
        _buildTextField('Google Maps Link', 'google_map_link', googleMapLink),
      ],
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

  Widget _buildTextField(String label, String key, String? initialValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(width: 2.0),
          ),
        ),
        validator: (value) {
          if (key == 'website_link' || key == 'google_map_link') {
            return null;
          }
          return value?.isEmpty ?? true ? 'This field is required' : null;
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
            }
          });
        },
      ),
    );
  }
}
