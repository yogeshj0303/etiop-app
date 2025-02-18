import 'package:etiop_application/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:etiop_application/modals/shop_model.dart';
import 'package:image_picker/image_picker.dart'; // Add this import
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    _initializeData();
  }

  void _initializeData() {
    // Initialize all data from Shop model
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
    
    // Initialize shop image
    if (widget.shop.shopImage != null) {
      shopImageUrl = 'https://etiop.acttconnect.com/${widget.shop.shopImage}';
    }

    // Initialize catalog images
    catalogImageUrls = [];
    if (widget.shop.catlog_0 != null) {
      catalogImageUrls.add('https://etiop.acttconnect.com/${widget.shop.catlog_0}');
    }
    if (widget.shop.catlog_1 != null) {
      catalogImageUrls.add('https://etiop.acttconnect.com/${widget.shop.catlog_1}');
    }
    if (widget.shop.catlog_2 != null) {
      catalogImageUrls.add('https://etiop.acttconnect.com/${widget.shop.catlog_2}');
    }
    if (widget.shop.catlog_3 != null) {
      catalogImageUrls.add('https://etiop.acttconnect.com/${widget.shop.catlog_3}');
    }
    if (widget.shop.catlog_4 != null) {
      catalogImageUrls.add('https://etiop.acttconnect.com/${widget.shop.catlog_4}');
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
          Uri.parse('https://etiop.acttconnect.com/api/shop-data-update/${widget.shop.id}'),
        );

        // Add text fields
        request.fields.addAll({
          'shop_owner_id': widget.shop.shopOwnerId.toString(),
          'owner_id': widget.shop.ownerId.toString(),
          'category_id': widget.shop.categoryId.toString(),
          'subcategory_id': widget.shop.subcategoryId.toString(),
          'shop_name': shopName ?? '',
          'shop_no': shopNo ?? '',
          'area': area ?? '',
          'city': city ?? '',
          'state': state ?? '',
          'district': district ?? '',
          'country': country ?? '',
          'zipcode': zipcode ?? '',
          'shop_status': widget.shop.shopStatus ?? '',
          'description': description ?? '',
          'services': widget.shop.services ?? '',
          'website_link': websiteLink ?? '',
          'google_map_link': googleMapLink ?? '',
        });

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
              state: state,
              district: district,
              country: country,
              zipcode: zipcode,
              shopStatus: widget.shop.shopStatus,
              description: description,
              services: widget.shop.services,
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
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Shop updated successfully'),
                backgroundColor: Colors.green,
              ),
            );

            // Return the updated shop object and pop the screen
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen()));
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
        _buildTextField('Description', 'description', description?.toString()),
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
          alignLabelWithHint: key == 'description',
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(width: 2.0),
          ),
          helperText: (key == 'website_link' || key == 'google_map_link') ? 'Optional' : null,
        ),
        validator: (value) {
          if (key == 'website_link' || key == 'google_map_link') {
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
            }
          });
        },
      ),
    );
  }
}
