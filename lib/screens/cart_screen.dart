import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/cart.dart' as cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    Key key,
  }) : super(key: key);

  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<cart.Cart>(context);
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'en_US');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 7, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '${formatCurrency.format(cartData.totalPrice)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    child: Text(
                      'Order Now',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      if (cartData.items.length != 0) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Finalize order?'),
                                  content: Text(
                                      'Would you like to finalize this order?'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text('Yes'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Provider.of<Orders>(context,
                                                listen: false)
                                            .addOrder(
                                          cartProducts:
                                              cartData.items.values.toList(),
                                          total: cartData.totalPrice,
                                        );
                                        cartData.clearCart();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => ChangeNotifierProvider.value(
                value: cartData.items.values.toList()[index],
                child: CartItem(
                  itemID: cartData.items.values.toList()[index].id,
                  name: cartData.items.values.toList()[index].name,
                  price: cartData.items.values.toList()[index].price,
                  quantity: cartData.items.values.toList()[index].quantity,
                  productID: cartData.items.keys.toList()[index],
                ),
              ),
              itemCount: cartData.items.length,
            ),
          ),
        ],
      ),
    );
  }
}
