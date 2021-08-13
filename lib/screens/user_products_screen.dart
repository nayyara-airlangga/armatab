import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import 'edit_product_screen.dart';
import 'screens.dart';

class UserProductsScreen extends StatefulWidget {
  static const String routeName = '/user-products';

  const UserProductsScreen({
    Key key,
  }) : super(key: key);

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(
      filterByUser: true,
    );
  }

  int index = 2;

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      Text(
                        'Fetching your products...',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                      ),
                    ],
                  )
                ],
              )
            : RefreshIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (context, productsData, _) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemBuilder: (_, index) => Column(
                        children: <Widget>[
                          UserProductItem(
                            id: productsData.items[index].id,
                            name: productsData.items[index].name,
                            imageURL: productsData.items[index].imageURL,
                          ),
                          Divider(
                            height: 10,
                            thickness: 1,
                          ),
                        ],
                      ),
                      itemCount: productsData.items.length,
                    ),
                  ),
                ),
              ),
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
