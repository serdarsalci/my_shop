import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import './products_pro.dart' as pro;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  // final String userId;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  void _saveFavValue(favStatus) {
    isFavorite = favStatus;
    notifyListeners();
  }

  Future<bool> toggleFavoriteStatus(String authToken, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://proshop-2e18c-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken');

    try {
      final response = await http.put(url, body: json.encode(isFavorite));

      if (response.statusCode >= 400) {
        _saveFavValue(oldStatus);
        return false;
      }
    } catch (error) {
      _saveFavValue(oldStatus);
      return false;
    } finally {
      notifyListeners();
    }
    return true;

    // print('Fav button clicked');
  }
}
