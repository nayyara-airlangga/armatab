import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String name;
  final String imageURL;

  const UserProductItem({
    Key key,
    @required this.name,
    @required this.id,
    @required this.imageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          color: Theme.of(context).textTheme.headline6.color,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(imageURL),
      ),
      trailing: Container(
        width: 96,
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context)
                    .textTheme
                    .headline6
                    .color
                    .withOpacity(0.5),
              ),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Text('Remove $name?'),
                    content: Text(
                      'Would you like to remove this item from your products?',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text('Yes'),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          try {
                            await Provider.of<Products>(context, listen: false)
                                .deleteProduct(id)
                                .then(
                                  (_) => scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Removed $name from your products',
                                      ),
                                      duration: Duration(seconds: 3),
                                    ),
                                  ),
                                );
                          } catch (error) {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Couldn\'t remove $name',
                                ),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                      ),
                      TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
