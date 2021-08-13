import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import 'cart_screen.dart';
import 'screens.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({
    Key key,
  }) : super(key: key);

  static const String routeName = '/';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoritesOnly = false;
  // bool _isInit = true;
  // bool _isLoading = false;

  int index = 0;

  Future _productsFuture;

  Future _obtainProductsFuture() {
    return Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  void initState() {
    _productsFuture = _obtainProductsFuture();
    // Future.delayed(Duration.zero).then((_) async {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   Provider.of<Products>(context, listen: false)
    //       .fetchAndSetProducts()
    //       .then((_) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    // });
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Products>(context, listen: false).fetchAndSetProducts().then(
  //       (_) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       },
  //     );
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return
        // ChangeNotifierProvider.value(
        //   value: Provider.of<Products>(context),
        //   child:
        Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cartData, child) => cartData.itemCount == 0
                ? child
                : Badge(
                    child: child,
                    value: cartData.itemCount.toString(),
                  ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
            color: Theme.of(context).scaffoldBackgroundColor,
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Favorites only',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text(
                  'Show all',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(
                      'Fetching products...',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return RefreshIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              onRefresh: _obtainProductsFuture,
              child: Consumer<Products>(
                builder: (context, productsData, _) => productsData
                        .items.isEmpty
                    ? ListView(
                        children: <Widget>[
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4),
                          Center(
                              child: Text(
                            'Try refreshing if nothing appears',
                            textAlign: TextAlign.center,
                          )),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.45),
                        ],
                      )
                    : ProductsGrid(
                        showFavoritesOnly: _showFavoritesOnly,
                      ),
              ),
            );
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
