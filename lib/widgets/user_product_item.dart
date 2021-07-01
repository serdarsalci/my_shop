import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_pro.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    Future<void> _showMyDialog(title) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure you want to delete $title ?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  const Text('This action can not be undone.'),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                  return Theme.of(context).focusColor;
                })),
              ),
              ElevatedButton(
                child: const Text('Delete'),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                    scaffoldMessenger.showSnackBar(SnackBar(
                        content: Text(
                      'Product Deleted.',
                      textAlign: TextAlign.center,
                    )));
                  } catch (error) {
                    scaffoldMessenger.showSnackBar(SnackBar(
                        content: Text(
                      'Deleting failed',
                      textAlign: TextAlign.center,
                    )));
                  }
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Theme.of(context).errorColor),
                ),
              ),
            ],
          );
        },
      );
    }

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                _showMyDialog(title);

                // Provider.of<Products>(context, listen: false).deleteProduct(id);
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
