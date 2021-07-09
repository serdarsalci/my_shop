import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './screens/cart_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';

import './providers/products_pro.dart';
// import './providers/product.dart' as prod;
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  // await dotenv().load();

  runApp(MyApp());

  // print(dotenv.env['API_KEY']);

  // print(DotEnv().env['API_KEY']);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext ctx) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Products(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Orders(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange[50],
                fontFamily: 'Lato',
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(),
                )),
            home: ProductOverviewScreen(),
            // home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen()
            },
          ),
        ));
  }
}
