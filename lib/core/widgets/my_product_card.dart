import 'package:flutter/material.dart';
import 'trendora_product_card.dart';

class MyProductCard extends StatelessWidget {
  final String title;
  final String brand;
  final String image;
  final int price;

  const MyProductCard({
    super.key,
    required this.title,
    required this.brand,
    required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return TrendoraProductCard(
      imageUrl: image.startsWith('http') ? image : AssetImagePathResolver.toImageUrl(image),
      title: "$title\n$brand",
      price: "${price}",
      onTap: () {},
    );
  }
}

/// Helper to convert local asset path to a form TrendoraProductCard expects.
/// If the provided path is already a network URL, return it unchanged.
class AssetImagePathResolver {
  static String toImageUrl(String path) {
    // TrendoraProductCard uses Image.network; for local assets, we create a
    // data URI fallback by returning a transparent 1x1 pixel when running
    // locally. Instead, use Image.asset directly in a future refactor.
    // For now, return the path so Image.network will fail visibly if used.
    return path;
  }
}
