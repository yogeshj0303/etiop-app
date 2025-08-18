import 'package:flutter/material.dart';
import '../modals/shop_model.dart';
import 'translated_text.dart';

class TranslatedShopCard extends StatelessWidget {
  final Shop shop;
  final VoidCallback? onTap;

  const TranslatedShopCard({
    super.key,
    required this.shop,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shop name - translated
              TranslatedText(
                text: shop.shopName ?? 'Shop Name',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Shop description - translated
              if (shop.description != null && shop.description!.isNotEmpty)
                TranslatedText(
                  text: shop.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              
              // Shop category - translated
              if (shop.categoryName != null && shop.categoryName!.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.category, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: TranslatedText(
                        text: shop.categoryName!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              
              // Shop address - translated (combine area, city, state)
              if (shop.area != null || shop.city != null || shop.state != null)
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: TranslatedText(
                        text: [
                          if (shop.area != null && shop.area!.isNotEmpty) shop.area,
                          if (shop.city != null && shop.city!.isNotEmpty) shop.city,
                          if (shop.state != null && shop.state!.isNotEmpty) shop.state,
                        ].join(', '),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TranslatedShopList extends StatelessWidget {
  final List<Shop> shops;
  final Function(Shop)? onShopTap;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const TranslatedShopList({
    super.key,
    required this.shops,
    this.onShopTap,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      itemCount: shops.length,
      itemBuilder: (context, index) {
        final shop = shops[index];
        return TranslatedShopCard(
          shop: shop,
          onTap: onShopTap != null ? () => onShopTap!(shop) : null,
        );
      },
    );
  }
}
