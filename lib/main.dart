import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_crud/providers/product_provider.dart';
import 'package:firestore_crud/screens/products.dart';
import 'package:firestore_crud/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestoreServie = FirestoreService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        StreamProvider(create: (context) => firestoreServie.getProducts()),
      ],
      child: MaterialApp(
        title: 'Firestore CRUD',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Products(),
      ),
    );
  }
}
