import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product-detail';

  final String id;

  const ProductDetailScreen({
    Key key,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findByID(
      id: productID,
    );
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'en_US');

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            pinned: true,
            title: Text(
              'Details',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        loadedProduct.name,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 28,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Price:',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 20,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        '${formatCurrency.format(loadedProduct.price)}',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 20,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'Description:',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 20,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    loadedProduct.description,
                    softWrap: true,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
