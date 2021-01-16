import 'package:firestore_crud/model/product.dart';
import 'package:firestore_crud/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  String _name;
  double _price;
  String _productId;
  var uuid = Uuid();

//Getters
  String get name => _name;
  double get price => _price;

//Setters
  changeName(String value) {
    _name = value;
    notifyListeners();
  }

  changePrice(String value) {
    _price = double.parse(value);
    notifyListeners();
  }

  loadValues(Product product) {
    _name = product.name;
    _price = product.price;
    _productId = product.productId;
  }

  saveProduct() {
    if (_productId == null) {
      var newProduct = Product(name: name, price: price, productId: uuid.v4());
      firestoreService.saveProduct(newProduct);
    } else {
//update
      var updateProduct =
          Product(name: name, price: price, productId: _productId);
      firestoreService.saveProduct(updateProduct);
    }
  }

  removeProduct(String productId) {
    firestoreService.removeProduct(productId);
  }
}
