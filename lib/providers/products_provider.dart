import 'package:flutter/material.dart';
import 'package:shop_app/Models/http_exception.dart';
import 'products.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 30.00,
  //     imageUrl:
  //     'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //     'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //     'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //     'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future <void> fetchProduct() async {
    var url = Uri.parse(
      'https://shopapp-58850-default-rtdb.asia-southeast1.firebasedatabase.app/products.json',
    );
    final response = await http.get(url);
    final Map? extractedData = json.decode(response.body);
    if(extractedData == null)
        return;
    final List<Product> loadedProducts = [];
    extractedData.forEach((prodId, prodData) {
      loadedProducts.add(Product(description: prodData['description'],
          title: prodData['title'],
          imageUrl: prodData['imageUrl'],
          id: prodId,
          isFavourite: prodData['isFavourite'],
          price: prodData['price']));
    });
    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.parse(
      'https://shopapp-58850-default-rtdb.asia-southeast1.firebasedatabase.app/products.json',
    );
    final response = await http.post(
      url,
      body: json.encode(
        {
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavourite': product.isFavourite
        },
      ),
    );
    final newproduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isFavourite: false,
      id: json.decode(response.body)['name'],
    );
    _items.add(newproduct);
    notifyListeners();
  }

  List<Product> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Future<void> updateProducts(String id, Product newProduct) async {
    final url = Uri.parse(
      'https://shopapp-58850-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json',
    );
    await http.patch(
      url,
      body: json.encode(
        {
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        },
      ),
    );
    final prodIndex = _items.lastIndexWhere((element) => element.id == id);
    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  Future <void> deleteProducts(String id) async {
    final url = Uri.parse(
      'https://shopapp-58850-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json',
    );
    var productIndex = _items.indexWhere((element) => element.id == id);
    Product? exProduct = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, exProduct);
      notifyListeners();
      throw HttpException("Can't delete product.");
    }
    exProduct = null;
  }
}
