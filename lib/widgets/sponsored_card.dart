import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../modals/banner_model.dart';
import '../services/api_services.dart';

class SponsoredCarousel extends StatefulWidget {
  const SponsoredCarousel({Key? key}) : super(key: key);

  @override
  _SponsoredCarouselState createState() => _SponsoredCarouselState();
}

class _SponsoredCarouselState extends State<SponsoredCarousel> {
  final ApiService _apiService = ApiService();
  late Future<List<BannerModel>> _bannersFuture;

  @override
  void initState() {
    super.initState();
    _bannersFuture = _apiService.fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BannerModel>>(
      future: _bannersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No banners available.',
            ),
          );
        }

        final banners = snapshot.data!;
        return CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = banners[index];
            final imageUrl = "https://etiop.in/${banner.bannerDoc}";
            return GestureDetector(
              onTap: () {
                // Implement action on banner tap if needed
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image, size: 50,),
                    ),
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.95,
            aspectRatio: 16 / 9,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
          ),
        );
      },
    );
  }
}
