import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import '/providers/cart.dart';
import '/providers/orders.dart';
import '/providers/products_provider.dart';
import '/screens/cart_screen.dart';
import '/screens/orders_screen.dart';
import '/screens/product_detail_screen.dart';
import '/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Latso',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProducts.routeName: (ctx) => UserProducts(),
        },
      ),
    );
  }
}
