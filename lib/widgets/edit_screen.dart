import 'package:flutter/material.dart';
import 'package:etiop_application/modals/shop_model.dart';
import 'package:etiop_application/services/api_services.dart'; // Import the ApiServices class

class EditShopScreen extends StatefulWidget {
  final Shop shop;

  const EditShopScreen({super.key, required this.shop});

  @override
  _EditShopScreenState createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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

  @override
  void initState() {
    super.initState();
    // Initialize the text fields with the current shop data
    shopName = widget.shop.shopName;
    shopNo = widget.shop.shopNo;
    area = widget.shop.area;
    city = widget.shop.city;
    state = widget.shop.state;
    district = widget.shop.district ?? '';
    country = widget.shop.country;
    zipcode = widget.shop.zipcode;
    description = widget.shop.description;
  }

  Future<void> _updateShop() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Collect form data
      Map<String, dynamic> shopData = {
        'shop_name': shopName,
        'shop_no': shopNo,
        'area': area,
        'city': city,
        'state': state,
        'district': district,
        'country': country,
        'zipcode': zipcode,
        'description': description,
      };

      // Call the API service to update the shop
      await ApiService.editShop(context, widget.shop.id, shopData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shop', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Edit Shop Details',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Form Fields
                _buildTextField('Shop Name', 'shop_name', shopName),
                _buildTextField('Shop No', 'shop_no', shopNo),
                _buildTextField('Area', 'area', area),
                _buildTextField('City', 'city', city),
                _buildTextField('State', 'state', state),
                _buildTextField('District', 'district', district),
                _buildTextField('Country', 'country', country),
                _buildTextField('Zipcode', 'zipcode', zipcode),
                _buildTextField('Description', 'description', description),
                const SizedBox(height: 10),

                const SizedBox(height: 10),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateShop,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                    )
                        : const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 18, ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
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
            borderSide: const BorderSide( width: 2.0),
          ),
        ),
        validator: (value) => value?.isEmpty ?? true ? 'This field is required' : null,
        onChanged: (value) {
          setState(() {
            if (key == 'shop_name') shopName = value;
            else if (key == 'shop_no') shopNo = value;
            else if (key == 'area') area = value;
            else if (key == 'city') city = value;
            else if (key == 'state') state = value;
            else if (key == 'district') district = value;
            else if (key == 'country') country = value;
            else if (key == 'zipcode') zipcode = value;
            else if (key == 'description') description = value;
          });
        },
      ),
    );
  }
}
