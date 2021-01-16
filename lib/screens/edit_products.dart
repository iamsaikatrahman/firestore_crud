import 'package:firestore_crud/model/product.dart';
import 'package:firestore_crud/providers/product_provider.dart';
import 'package:firestore_crud/screens/products.dart';
import 'package:firestore_crud/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  final Product product;
  EditProduct([this.product]);
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.product == null) {
      nameController.text = "";
      priceController.text = "";
      Future.delayed(Duration.zero, () {
        final productProvider =
            Provider.of<ProductProvider>(context, listen: false);
        productProvider.loadValues(Product());
      });
    } else {
      //controller update
      nameController.text = widget.product.name;
      priceController.text = widget.product.price.toString();
      //state update
      Future.delayed(Duration.zero, () {
        final productProvider =
            Provider.of<ProductProvider>(context, listen: false);
        productProvider.loadValues(widget.product);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text('Edit Product'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView(children: <Widget>[
          TextFormField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'Product Name'),
              onChanged: (value) {
                productProvider.changeName(value);
              }),
          TextFormField(
              controller: priceController,
              decoration: InputDecoration(hintText: 'Product Price'),
              onChanged: (value) {
                productProvider.changePrice(value);
              }),
          SizedBox(height: 20),
          RaisedButton(
            child: Text('Save'),
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                productProvider.saveProduct();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (c) => Products()));
              } else {
                showDialog(
                    context: context,
                    builder: (c) {
                      return ErrorAlertDialog(
                        message: "Please write product name and price.",
                      );
                    });
              }

              // nameController.text.isNotEmpty && priceController.text.isNotEmpty
              //     ? productProvider.saveProduct(context)
              //     : showDialog(
              //         context: context,
              //         builder: (c) {
              //           return ErrorAlertDialog(
              //             message: "Please write product name and price.",
              //           );
              //         });
            },
          ),
          (widget.product != null)
              ? RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text('Delete'),
                  onPressed: () {
                    productProvider.removeProduct(widget.product.productId);
                    Navigator.of(context).pop();
                  },
                )
              : Container(),
        ]),
      ),
    );
  }

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    scaffoldkey.currentState.showSnackBar(snackbar);
  }
}
