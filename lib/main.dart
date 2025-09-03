import 'package:myapp/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/models/transaction_model.dart';
import 'package:myapp/models/categories_model.dart';

late Isar isar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();

  isar = await Isar.open(
    [TransactionModelSchema, CategoriesModelSchema],
    directory: dir.path,
    inspector: true,
  );
  //isar.writeTxn(() async {
  //  await isar.transactionModels.clear();
  //});
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}