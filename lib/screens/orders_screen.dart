import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
import 'screens.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    Key key,
  }) : super(key: key);

  static const String routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  int index = 1;

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(
                      'Fetching your orders...',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('Something went wrong'),
              );
            } else {
              return Consumer<Orders>(
                builder: (context, orderData, child) => ListView.builder(
                  itemBuilder: (context, index) => OrderItem(
                    order: orderData.orders[index],
                  ),
                  itemCount: orderData.orders.length,
                ),
              );
            }
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor:
            Theme.of(context).textTheme.headline6.color.withOpacity(0.6),
        selectedItemColor: Theme.of(context).textTheme.headline6.color,
        onTap: (value) {
          setState(() {
            index = value;
          });
          if (index == 0)
            Navigator.of(context).pushReplacementNamed(screens[0]);
          if (index == 1)
            Navigator.of(context).pushReplacementNamed(screens[1]);
          if (index == 2)
            Navigator.of(context).pushReplacementNamed(screens[2]);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Products',
          ),
        ],
      ),
    );
  }
}
