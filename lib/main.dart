import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/models/category/category_models.dart';
import 'package:money_manager/screen/add_transaction/screen_add_transaction.dart';
import 'package:money_manager/screen/home/srceen_home.dart';

import 'models/transactions/transaction_model.dart';

Future<void> main() async {
  // final obj1 = CategoryDb();
  // final obj2 = CategoryDb();
  // print('object comparing');
  // print(obj1 == obj2);

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScreenHome(),
      routes: {
        ScreenAddTransaction.routeName: (ctx) => const ScreenAddTransaction(),
      },
    );
  }
}
