import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      // gridview.builder only renders items on the screen.. for long gridviews it is ideal
      body: ProductsGrid(),
    );
  }
}
