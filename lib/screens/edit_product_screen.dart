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

  void _saveForm() {
    final bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
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
                Navigator.of(context).pop(true);
                print(_editedProduct.name);
                print(_editedProduct.price);
                print(_editedProduct.description);
                print(_editedProduct.imageURL);
                productsData.updateProduct(
                  id: _editedProduct.id,
                  newProduct: _editedProduct,
                );
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        ),
      );
      bool isEdited;
      confirmEdit.then((value) {
        setState(() {
          isEdited = value;
        });
        print(isEdited);
        if (isEdited) Navigator.pop(context);
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
                Navigator.of(context).pop(true);
                print(_editedProduct.name);
                print(_editedProduct.price);
                print(_editedProduct.description);
                print(_editedProduct.imageURL);

                productsData.addProduct(_editedProduct);
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        ),
      );
      bool isAdded;
      confirmAdd.then((value) {
        setState(() {
          isAdded = value;
        });
        print(isAdded);
        if (isAdded) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
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
                    if (value.isEmpty) return 'Please enter your product name';
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
                    if (value.isEmpty) return 'Please enter a description';
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
                        FocusScopeNode currentFocus = FocusScope.of(context);
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
