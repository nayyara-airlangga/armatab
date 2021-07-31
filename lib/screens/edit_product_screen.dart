import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    Key key,
  }) : super(key: key);

  static const String routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageURLController = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    name: '',
    description: '',
    price: 0,
    imageURL: '',
  );
  bool _isInit = true;
  bool _isLoading = false;
  bool _isAdded;
  bool _isEdited;
  Map<String, String> _initValues = {
    'name': '',
    'description': '',
    'price': '',
    'imageURL': '',
  };

  @override
  void dispose() {
    _imageURLController.dispose();
    _imageURLFocusNode.removeListener(_updateImageURL);
    _imageURLFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productID = ModalRoute.of(context).settings.arguments as String;
      if (productID != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findByID(id: productID);
        _initValues = {
          'name': _editedProduct.name,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageURL': '',
        };
        _imageURLController.text = _editedProduct.imageURL;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      if ((!_imageURLController.text.startsWith('http') &&
              !_imageURLController.text.startsWith('https')) ||
          (!_imageURLController.text.contains('.png') &&
              !_imageURLController.text.contains('.jpg') &&
              !_imageURLController.text.contains('jpeg'))) return;
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    // setState(() {
    // _isLoading = true;
    // });

    final productsData = Provider.of<Products>(context, listen: false);
    if (_editedProduct.id != null) {
      Future<bool> confirmEdit = showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Update this product?',
          ),
          content: Text('Would you like to update this item in your products?'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                Navigator.of(context).pop(true);
                print(_editedProduct.name);
                print(_editedProduct.price);
                print(_editedProduct.description);
                print(_editedProduct.imageURL);
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop(false);
              },
            ),
          ],
        ),
      );

      confirmEdit.then((value) async {
        setState(() {
          _isEdited = value;
        });
        print(_isEdited);
        if (_isEdited)
          try {
            await productsData.updateProduct(
              id: _editedProduct.id,
              newProduct: _editedProduct,
            );
            if (_isLoading)
              setState(() {
                _isLoading = false;
                print(_isLoading);
              });
            if (_isEdited && !_isLoading) {
              print(_editedProduct.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Edited ${_editedProduct.name}',
                  ),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          } catch (error) {
            final bool isOkay = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('An error occured'),
                content: Text('Something went wrong'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Okay'),
                  ),
                ],
              ),
            );
            if (_isLoading)
              setState(() {
                _isLoading = isOkay;
                print(_isLoading);
                Navigator.of(context).pop();
              });
          }
      });
    } else {
      Future<bool> confirmAdd = showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Add ${_editedProduct.name}?',
          ),
          content: Text('Would you like to add this item to your products?'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                Navigator.of(context).pop(true);

                // Navigator.of(context).pop(true);
                print(_editedProduct.name);
                print(_editedProduct.price);
                print(_editedProduct.description);
                print(_editedProduct.imageURL);
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          ],
        ),
      );

      confirmAdd.then((value) async {
        setState(() {
          _isAdded = value;
        });
        print(_isAdded);
        if (_isAdded)
          try {
            final productID = await productsData.addProduct(_editedProduct);
            if (_isLoading)
              setState(() {
                _isLoading = false;
                print(_isLoading);
              });
            if (_isAdded && !_isLoading) {
              print(productID);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added ${_editedProduct.name} to your products',
                  ),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          } catch (error) {
            final bool isOkay = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('An error occured'),
                content: Text('Something went wrong'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Okay'),
                  ),
                ],
              ),
            );
            if (_isLoading)
              setState(() {
                _isLoading = isOkay;
                print(_isLoading);
                Navigator.of(context).pop();
              });
          }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: _isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text('Updating your products...'),
                  ],
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['name'],
                        decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Ex: Baseball Bat, Shoes, Jacket'),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _editedProduct = Product(
                            name: value,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageURL: _editedProduct.imageURL,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter your product name';
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                          labelText: 'Price (USD)',
                          hintText: 'Ex: 99.99',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _editedProduct = Product(
                            name: _editedProduct.name,
                            price: double.parse(value),
                            description: _editedProduct.description,
                            imageURL: _editedProduct.imageURL,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter a price';
                          else if (double.tryParse(value) == null)
                            return 'Please enter a valid number';
                          else if (double.parse(value) <= 0)
                            return 'Your price can\'t be 0 or lower';
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText:
                              'Ex: A hand crafted knife, durable and can cut through flesh effortlessly',
                        ),
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          _editedProduct = Product(
                            name: _editedProduct.name,
                            price: _editedProduct.price,
                            description: value,
                            imageURL: _editedProduct.imageURL,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter a description';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageURLController.text.isEmpty
                                ? Center(
                                    child: Text(
                                    'Enter an image URL',
                                    textAlign: TextAlign.center,
                                  ))
                                : FittedBox(
                                    child: Image.network(
                                      _imageURLController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageURLController,
                            onFieldSubmitted: (_) {
                              setState(() {});
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                name: _editedProduct.name,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageURL: value,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please enter an image URL';
                              else if (!value.startsWith('http') &&
                                  !value.startsWith('https'))
                                return 'Please enter a valid URL';
                              else if (!value.contains('.png') &&
                                  !value.contains('.jpg') &&
                                  !value.contains('jpeg'))
                                return 'Please enter a valid image URL';
                              return null;
                            },
                            focusNode: _imageURLFocusNode,
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus)
                                currentFocus.unfocus();
                              _saveForm();
                            },
                            child: Text(_editedProduct.id == null
                                ? 'Add Your Product'
                                : 'Update your product'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
