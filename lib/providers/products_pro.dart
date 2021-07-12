import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'dart:convert';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<Product> _favoriteProducts = [];
  var _showFavoritesOnly = false;

  String authToken;
  String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoitesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  bool get favoritesOnly {
    return _showFavoritesOnly;
  }

  List<Product> get favoriteItems {
    return _favoriteProducts;
  }

  // void notifyProductsListeners() {
  //   notifyListeners();
  // }

  Future<void> fetcAndSetProducts([bool filterByUser = false]) async {
    // print('User Id from Products.fetchAndSetProducts');
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    try {
      var url = Uri.parse(
          'https://proshop-2e18c-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');

      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // print(extractedData.toString());
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://proshop-2e18c-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');

      final favoritesResponse = await http.get(url);
      final favoritesData = json.decode(favoritesResponse.body);
      // print('this is favorites Data from products provider');
      // print(favoritesData.toString());

      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              isFavorite: favoritesData == null
                  ? false
                  : favoritesData[prodId] ?? false,
              price: prodData['price']),
        );
      });
      // print('showFavorites only is $_showFavoritesOnly');

      _favoriteProducts = loadedProducts
          .where((element) => element.isFavorite == true)
          .toList();

      _items = loadedProducts;
      // _items = _showFavoritesOnly
      //     ? loadedProducts.where((prod) => prod.isFavorite == true).toList()
      //     : loadedProducts;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://proshop-2e18c-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));

      final newProduct = Product(
        title: product.title,
        description: product.description,
        id: json.decode(response.body)['name'],
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      // print('error caught  at products_pro $error ');
      throw error;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id, orElse: () {
      return null;
      // throw ErrorDescription('No prod with this id found');
    });
  }

  void showFavorites() {
    _showFavoritesOnly = true;
    // print('showFavorites Called');
    notifyListeners();
    // fetcAndSetProducts();
  }

  void showAll() {
    // print('showAll Called');
    _showFavoritesOnly = false;
    notifyListeners();
    // fetcAndSetProducts();
  }

  void favUpdated() {
    // fetcAndSetProducts();
    // print('favUpdated Called');
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://proshop-2e18c-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.title,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://proshop-2e18c-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
