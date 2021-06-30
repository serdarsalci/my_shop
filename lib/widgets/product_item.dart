import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/products_pro.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: true);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,

          // use Consumer if only part of the widget tree needs to change like here only favorite icon needs to change
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(product.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border_outlined),
              onPressed: () {
                bool isFavorite = product.toggleFavoriteStatus();
                Provider.of<Products>(context, listen: false).favUpdated();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(isFavorite
                      ? '${product.title} added to favorites'
                      : '${product.title} removed from favorites'),
                  duration: Duration(seconds: 2),
                ));
              },
              color: Theme.of(context).accentColor,
            ),
            child: Text(
                'Some widget that does not change!, this widget can be used in above builder method'),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              // reaches the nearest scaffold
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Added item to cart'),
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
