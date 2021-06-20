import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// because only Orders needed from this provider we can use show to prevent name clash
import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/my-orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
