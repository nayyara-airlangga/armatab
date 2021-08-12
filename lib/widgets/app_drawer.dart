import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('ArmaTab'),
              automaticallyImplyLeading: false,
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.shop,
                color: Theme.of(context).textTheme.headline6.color,
              ),
              title: Text(
                'Shop',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.payment,
                color: Theme.of(context).textTheme.headline6.color,
              ),
              title: Text(
                'Orders',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
                // Navigator.of(context).pushReplacement(
                // SpecialRoute(
                // builder: (context) => OrdersScreen(),
                // ),
                // );
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.edit,
                color: Theme.of(context).textTheme.headline6.color,
              ),
              title: Text(
                'Manage Products',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).textTheme.headline6.color,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
            Divider(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
