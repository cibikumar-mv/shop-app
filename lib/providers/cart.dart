import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({required this.id,
    required this.price,
    required this.quantity,
    required this.title});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItems(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (existing) =>
            CartItem(
                id: existing.id,
                price: existing.price,
                quantity: existing.quantity + 1,
                title: existing.title),
      );
    } else {
      _items.putIfAbsent(
        productId,
            () =>
            CartItem(
                id: DateTime.now().toString(),
                price: price,
                quantity: 1,
                title: title),
      );
    }
    notifyListeners();
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void deleteItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void deleteSingleItem(String productId) {
    if (!_items.containsKey(productId))
      return;
    if (_items[productId]!.quantity > 1){
      _items.update(productId, (exvalue) =>
          CartItem(id: exvalue.id,
              price: exvalue.price,
              quantity: exvalue.quantity - 1,
              title: exvalue.title),);
    }
    else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

