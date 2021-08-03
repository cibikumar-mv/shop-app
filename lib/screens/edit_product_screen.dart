import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  void initState() {
    // TODO: implement initState
    _imageFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
       var productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        productId = productId as String;
        _editedProduct = Provider.of<Products>(context).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  var _isInit = true;
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');

  void dispose() {
    _imageFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formkey.currentState!.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProducts(_editedProduct.id!, _editedProduct);
    }
    else{
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formkey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) return 'Please provide a value.';
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    title: newValue!,
                    price: _editedProduct.price,
                    id: _editedProduct.id,
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a price';
                  if (double.tryParse(value) == null)
                    return 'Please enter a valid number';
                  if (double.parse(value) < 1) return 'Enter price above zero';
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(newValue!),
                    id: _editedProduct.id,
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                // textInputAction: TextInputAction.next,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descFocusNode,
                validator: (value) {
                  if (value!.isEmpty) return 'Please provide a description.';
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    id: _editedProduct.id,
                    imageUrl: _editedProduct.imageUrl,
                    description: newValue!,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: Container(
                      child: _imageUrlController.text.isEmpty
                          ? Text(
                              "Enter URL",
                              textAlign: TextAlign.center,
                            )
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      // initialValue: _initValues['imageUrl'],
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageFocusNode,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Please provide a image URL.';
                        if (!value.startsWith('http') &&
                            !value.startsWith('https'))
                          return 'Enter a valid URL';
                        if (!value.endsWith(".png") &&
                            !value.endsWith(".jpg") &&
                            !value.endsWith(".jpeg"))
                          return 'Enter a valid image URL';
                        return null;
                      },
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          id: _editedProduct.id,
                          imageUrl: newValue!,
                          description: _editedProduct.description,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
