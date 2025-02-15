class AppImages {
  // Sponsored Images
  static const List<String> sponsoredImages = [
    'assets/images/sponsored1.jpg',
    'assets/images/sponsored2.jpg',
    'assets/images/sponsored3.jpg',
    'assets/images/sponsored4.jpg',
    'assets/images/sponsored5.jpg',
    'assets/images/sponsored6.jpg',
  ];

  static const List<String> sponsoredDescriptions = [
    'Delicious food to make your day special!',
    'Try our spicy chaat for a tangy experience.',
    'Our famous dahi puri will leave you wanting more!',
    'Enjoy the crispy aloo tikki with every bite.',
    'Authentic street food that tastes like home.',
    'Chase the taste with our signature snacks!',
  ];

  // Premium Business Images
  static const List<String> premiumBusinesses = [
    'assets/images/business1.jpg',
    'assets/images/business2.jpg',
    'assets/images/business3.jpg',
    'assets/images/business4.jpg',
    'assets/images/business5.jpg',
    'assets/images/business6.jpg',
    'assets/images/business7.jpg',
    'assets/images/business8.jpg',
    'assets/images/business9.jpg',
    'assets/images/business10.jpg',
  ];

  // Circular Tab Images (Add images for circular tabs here)
  static const List<String> circularTabImages = [
    'assets/images/nearby.jpg',
    'assets/images/gwalior.jpg',
    'assets/images/gurugram.jpg',
    'assets/images/agra.jpg',
    'assets/images/bengaluru.jpg',
    'assets/images/prayagraj.jpg',
    'assets/images/delhi.jpg',
    'assets/images/ghaziabad.jpg',
    'assets/images/noida.jpg',
    'assets/images/jhansi.jpg',
    'assets/images/bhopal.jpg',
    'assets/images/all_cities.jpg',
  ];

  // Other Categories
  static const List<String> electronics = [
    'assets/images/electronics1.jpg',
    'assets/images/electronics2.jpg',
    'assets/images/electronics3.jpg',
  ];

  static const List<String> mobiles = [
    'assets/images/phone1.jpg',
    'assets/images/phone2.jpg',
    'assets/images/phone3.jpg',
  ];

  static const List<String> medical = [
    'assets/images/medical1.jpg',
    'assets/images/medical2.jpg',
    'assets/images/medical3.jpg',
  ];

  // Utility method for accessing images dynamically by category
  static String getImageByCategory(String category, int index) {
    switch (category) {
      case 'sponsored':
        return sponsoredImages[index % sponsoredImages.length];
      case 'premiumBusinesses':
        return premiumBusinesses[index % premiumBusinesses.length];
      case 'electronics':
        return electronics[index % electronics.length];
      case 'mobiles':
        return mobiles[index % mobiles.length];
      case 'medical':
        return medical[index % medical.length];
      case 'circularTab':
        return circularTabImages[
            index % circularTabImages.length]; // For circular tab images
      default:
        throw ArgumentError('Invalid category: $category');
    }
  }
}
