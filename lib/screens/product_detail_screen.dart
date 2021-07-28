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
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    loadedProduct.imageURL,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey[400],
              height: 0,
              thickness: 2,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Text(
                    loadedProduct.name,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 28),
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
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20),
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
                    style:
                        Theme.of(context).primaryTextTheme.headline6.copyWith(
                              color: Colors.black,
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
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20),
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
                style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      color: Colors.black,
                      fontSize: 18,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
