import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import 'cart_screen.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({
    Key key,
  }) : super(key: key);

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoritesOnly = false;
  // bool _isInit = true;
  // bool _isLoading = false;

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
                child: Text('Favorites only'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
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
                    Text('Fetching products...'),
                  ],
                ),
              ],
            );
          } else {
            return RefreshIndicator(
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
    );
  }
}
