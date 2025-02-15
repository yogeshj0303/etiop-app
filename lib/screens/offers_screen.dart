import 'package:flutter/material.dart';

import '../constants/image_path.dart';
import '../widgets/sponsored_card.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          'Offers & Discounts',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Catalog Section
            _buildSectionHeader('Brand Catalog'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: AppImages.premiumBusinesses.length,
                itemBuilder: (context, index) {
                  return _buildBrandCard(
                      imagePath: AppImages.premiumBusinesses[index]);
                },
              ),
            ),

            // Sponsored Section
            _buildSponsoredSection(),

            // Best Products in Discount
            _buildSectionHeader('Best Products in Discount'),
            _buildHorizontalList([
              _buildOfferCard(
                  imagePath: AppImages.sponsoredImages[0],
                  title: '50% OFF on Electronics'),
              _buildOfferCard(
                  imagePath: AppImages.sponsoredImages[1],
                  title: 'Buy 1 Get 1 Free'),
              _buildOfferCard(
                  imagePath: AppImages.sponsoredImages[2],
                  title: 'Flat 30% OFF on Fashion'),
            ]),

            // Hot Deals Section
            _buildSectionHeader('Hot Deals'),
            _buildHorizontalList([
              _buildOfferCard(
                  imagePath: AppImages.sponsoredImages[3], title: 'Mega Sale'),
              _buildOfferCard(
                  imagePath: AppImages.sponsoredImages[4],
                  title: 'Travel Discounts'),
              _buildOfferCard(
                  imagePath: AppImages.sponsoredImages[5],
                  title: 'Home Essentials'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showViewAll = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, ),
          ),
          if (showViewAll)
            const Text(
              'View All',
            ),
        ],
      ),
    );
  }

  Widget _buildBrandCard({required String imagePath}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }

  Widget _buildSponsoredSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Sponsored',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
),
            ),
          ),
          SponsoredCarousel(),
        ],
      ),
    );
  }

  Widget _buildOfferCard({required String imagePath, required String title}) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
                 fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalList(List<Widget> items) {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items,
      ),
    );
  }
}
