import 'package:flutter/foundation.dart';
// import './products_pro.dart' as pro;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  bool toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
    return isFavorite;

    // print('Fav button clicked');
  }
}
