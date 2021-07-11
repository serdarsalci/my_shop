import 'package:flutter/material.dart';
import './product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products_pro.dart';
// import '../providers/product.dart';

class ProductsGrid extends StatelessWidget {
  // final bool showFavs;

  // ProductsGrid();

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    var msg;

    productsData.fetcAndSetProducts();

    final products = productsData.favoritesOnly
        ? productsData.favoriteItems
        : productsData.items;

    if (products.length == 0 && productsData.favoritesOnly) {
      msg = 'No favorites to show';
    } else if (products.length == 0 && !productsData.favoritesOnly) {
      msg = 'no products to show';
    }

    if (products.length == 0) {
      return Center(
        child: Text(
          msg,
          style: TextStyle(
            color: Colors.red,
            fontSize: 30,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
