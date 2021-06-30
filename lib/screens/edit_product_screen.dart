import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products_pro.dart';
// import '../providers/products_pro.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _edittedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _edittedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _imageUrlController.text = _edittedProduct.imageUrl;
        // print(_edittedProduct.id);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    if (_edittedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_edittedProduct.id, _edittedProduct);
      setState(() {
        _isLoading = true;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_edittedProduct)
          .then((_) {
        setState(() {
          _isLoading = true;
        });
        Navigator.of(context).pop();
      });
    }

    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _edittedProduct.title,
                        autofocus: true,
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        // onFieldSubmitted fired, value entered is given but not not needed here
                        onFieldSubmitted: (_value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          // return null means no validation errror
                          // if you return a string it is considered error message
                          if (value.isEmpty) {
                            print('Empty title');
                            return "Please provide a value";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _edittedProduct = Product(
                            title: value,
                            description: _edittedProduct.description,
                            id: _edittedProduct.id,
                            imageUrl: _edittedProduct.imageUrl,
                            price: _edittedProduct.price,
                            isFavorite: _edittedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _edittedProduct.price.toString(),
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_value) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a price.";
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than 0';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _edittedProduct = Product(
                            title: _edittedProduct.title,
                            description: _edittedProduct.description,
                            id: _edittedProduct.id,
                            imageUrl: _edittedProduct.imageUrl,
                            price: double.parse(value),
                            isFavorite: _edittedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _edittedProduct.description,
                        decoration: InputDecoration(labelText: "Description"),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description.';
                          }
                          if (value.length < 10) {
                            return 'Description should be at least 10 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _edittedProduct = Product(
                              title: _edittedProduct.title,
                              description: value,
                              id: _edittedProduct.id,
                              imageUrl: _edittedProduct.imageUrl,
                              price: _edittedProduct.price,
                              isFavorite: _edittedProduct.isFavorite);
                        },
                        // textInputAction: TextInputAction.next,
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
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a url')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              // initialValue: _edittedProduct.imageUrl,
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an image URL.';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL.';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please enter a valid image URL';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onSaved: (value) {
                                _edittedProduct = Product(
                                    title: _edittedProduct.title,
                                    description: _edittedProduct.description,
                                    id: _edittedProduct.id,
                                    imageUrl: value,
                                    isFavorite: _edittedProduct.isFavorite,
                                    price: _edittedProduct.price);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
