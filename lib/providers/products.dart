import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Models/http_exception.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {required this.description,
      this.isFavourite = false,
      required this.title,
      required this.imageUrl,
      required this.id,
      required this.price});

  Future<void> toggleFavourite() async {
    final oldStatus = isFavourite;

    isFavourite = !isFavourite;
    notifyListeners();
    final url = Uri.parse(
      'https://shopapp-58850-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json',
    );
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavourite': isFavourite,
          },
        ),
      );
      if(response.statusCode >= 400){
        isFavourite = oldStatus;
        notifyListeners();
        throw HttpException("Can't update favourite");
      }
    }

}
