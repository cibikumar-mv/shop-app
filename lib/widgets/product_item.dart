import 'dart:ui';

import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        leading: IconButton(
          icon: Icon(Icons.favorite_border_outlined),
          onPressed: () {},
        ),
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart),
          onPressed: () {},
        ),
        backgroundColor: Colors.black26,
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
