import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' as cart;

class CartItem extends StatelessWidget {
  const CartItem({
    Key key,
    @required this.productID,
    @required this.itemID,
    @required this.name,
    @required this.price,
    @required this.quantity,
  }) : super(key: key);

  final double price;
  final String productID;
  final String itemID;
  final int quantity;
  final String name;

  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'en_US');
    final cartData = Provider.of<cart.Cart>(context, listen: false);
    final cartItem = Provider.of<cart.CartItem>(context, listen: false);
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<cart.Cart>(context, listen: false).removeItem(productID);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Remove ${cartItem.name}?'),
            content: Text(
              'Would you like to remove this item from the cart?',
              style: TextStyle(
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        );
      },
      key: ValueKey(itemID),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: const EdgeInsets.only(right: 15),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Theme.of(context).primaryTextTheme.headline6.color,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: ListTile(
          tileColor: Theme.of(context).primaryColor,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
            radius: 25,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: FittedBox(
                child: Text(
                  '${formatCurrency.format(price)}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
              color: Theme.of(context).textTheme.headline6.color,
            ),
          ),
          subtitle: Text(
            'Total: ${formatCurrency.format(price * quantity)}',
            style: TextStyle(
              color:
                  Theme.of(context).textTheme.headline6.color.withOpacity(0.6),
            ),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    cartData.removeSingleItem(
                      cartItem.id,
                    );
                  },
                  child: Icon(
                    Icons.remove,
                    color: Theme.of(context)
                        .textTheme
                        .headline6
                        .color
                        .withOpacity(0.6),
                  ),
                ),
                Container(
                  width: 25,
                  child: FittedBox(
                    child: Text(
                      '${quantity}x',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    cartData.addItem(
                      productID: cartItem.id,
                      name: cartItem.name,
                      price: cartItem.price,
                    );
                  },
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context)
                        .textTheme
                        .headline6
                        .color
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
