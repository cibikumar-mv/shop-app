import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
      'https://shopapp-58850-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json',
    );

    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final Map? extractedData = json.decode(response.body) ;
    if(extractedData == null) {
      _orders = [];
      notifyListeners();
      return;
    }
    extractedData.forEach(
      (oid, odata) {
        loadedOrders.add(
          OrderItem(
            id: oid,
            amount: odata['amount'],
            dateTime: DateTime.parse(odata['dateTime']),
            products: (odata['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ),
                ).toList(),
          ),
        );
      },
    );

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
      'https://shopapp-58850-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json',
    );
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((e) => {
                  'id': e.id,
                  'title': e.title,
                  'quantity': e.quantity,
                  'price': e.price,
                })
            .toList()
      }),
    );
    print(json.decode(response.body)['name']);
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts),
    );
    notifyListeners();
  }
}
