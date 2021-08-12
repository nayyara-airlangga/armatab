import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  const OrderItem({
    Key key,
    @required this.order,
  }) : super(key: key);

  final ord.OrderItem order;

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.simpleCurrency(locale: "en_US");
    return AnimatedContainer(
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 300),
      height: _isExpanded
          ? min(
              widget.order.products.length == 0
                  ? 0
                  : widget.order.products.length * 20.0 + 120,
              205,
            )
          : 92,
      child: Card(
        color: Theme.of(context).primaryColor,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              tileColor: Theme.of(context).primaryColor,
              title: Text(
                '${formatCurrency.format(widget.order.amount)}',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              ),
              subtitle: Text(
                DateFormat('EEEEE, dd MMMM yyyy HH:mm')
                    .format(widget.order.dateTime),
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .headline6
                      .color
                      .withOpacity(0.6),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).textTheme.headline6.color,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              color: Theme.of(context).primaryColor,
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 300),
              height: _isExpanded
                  ? min(
                      widget.order.products.length == 0
                          ? 0
                          : widget.order.products.length * 20.0 + 20,
                      170,
                    )
                  : 0,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final products = widget.order.products;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          products[index].name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .textTheme
                                .headline6
                                .color
                                .withOpacity(0.6),
                          ),
                        ),
                        Text(
                          '${products[index].quantity}x     ${formatCurrency.format(products[index].price)}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: widget.order.products.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
