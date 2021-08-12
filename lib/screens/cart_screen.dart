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
            color: Theme.of(context).primaryColor,
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
                      color: Theme.of(context).textTheme.headline6.color,
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
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  OrderButton(cartData: cartData),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartData,
  }) : super(key: key);

  final cart.Cart cartData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Order Now',
              style:
                  TextStyle(color: Theme.of(context).textTheme.headline6.color),
            ),
      onPressed: (widget.cartData.totalPrice <= 0 || _isLoading)
          ? null
          : () async {
              if (widget.cartData.items.length != 0) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: Theme.of(context).primaryColor,
                          title: Text('Finalize order?'),
                          content: Text(
                            'Would you like to finalize this order?',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text('Yes'),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                Navigator.of(context).pop();
                                await Provider.of<Orders>(context,
                                        listen: false)
                                    .addOrder(
                                  cartProducts:
                                      widget.cartData.items.values.toList(),
                                  total: widget.cartData.totalPrice,
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                                widget.cartData.clearCart();
                              },
                            ),
                            TextButton(
                              child: Text('No'),
                              onPressed: () {
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ));
              }
            },
    );
  }
}
