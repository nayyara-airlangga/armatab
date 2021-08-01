import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
      'https://flutter-pason-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json',
    );
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderID, orderData) {
      loadedOrders.insert(
        0,
        OrderItem(
          id: orderID,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (cartItem) => CartItem(
                  id: cartItem['id'],
                  name: cartItem['name'],
                  quantity: cartItem['quantity'],
                  price: cartItem['price'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder({
    @required List<CartItem> cartProducts,
    @required double total,
  }) async {
    final url = Uri.parse(
      'https://flutter-pason-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json',
    );
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'name': cartProduct.name,
                    'quantity': cartProduct.quantity,
                    'price': cartProduct.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
