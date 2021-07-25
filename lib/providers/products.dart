import 'package:flutter/material.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
   required this.description,
    this.isFavourite = false,
   required this.title,
   required this.imageUrl,
   required this.id,
   required this.price
  });

  void toggleFavourite(){
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
