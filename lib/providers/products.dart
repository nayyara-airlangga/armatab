import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   name: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageURL:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   name: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageURL:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   name: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageURL:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   name: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageURL:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // bool _showFavoritesOnly = false;

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((product) => product.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findByID({String id}) {
    return _items.firstWhere(
      (product) => product.id == id,
    );
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
      'https://flutter-pason-default-rtdb.asia-southeast1.firebasedatabase.app/products.json',
    );
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((productID, productData) {
        loadedProducts.insert(
          0,
          Product(
            id: productID,
            name: productData['name'],
            description: productData['description'],
            price: productData['price'],
            imageURL: productData['imageURL'],
            isFavorite: productData['isFavorite'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<String> addProduct(Product product) async {
    final url = Uri.parse(
      'https://flutter-pason-default-rtdb.asia-southeast1.firebasedatabase.app/products.json',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'name': product.name,
            'description': product.description,
            'imageURL': product.imageURL,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ),
      );

      print(json.decode(response.body));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        name: product.name,
        description: product.description,
        price: product.price,
        imageURL: product.imageURL,
      );
      _items.insert(0, newProduct);
      notifyListeners();
      return json.decode(response.body)['name'].toString();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct({
    String id,
    Product newProduct,
  }) async {
    final int productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
        'https://flutter-pason-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json',
      );
      try {
        await http.patch(url,
            body: json.encode({
              'name': newProduct.name,
              'description': newProduct.description,
              'imageURL': newProduct.imageURL,
              'price': newProduct.price,
            }));
        _items[productIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
      'https://flutter-pason-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json',
    );
    final int existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    Product existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(
        existingProductIndex,
        existingProduct,
      );
      notifyListeners();
      throw HttpException('Couldn\'t remove product');
    }
    existingProduct = null;
    notifyListeners();
  }
}
