import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(
      filterByUser: true,
    );
  }

  const UserProductsScreen({
    Key key,
  }) : super(key: key);

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
    );
  }
}
