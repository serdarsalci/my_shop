import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_pro.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;

  // ProductDetailScreen(this.title);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    // by setting the listen to false, we are not listening thus rebuilding this widget when products state change. it makes sense because this is one product detail screen.
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
