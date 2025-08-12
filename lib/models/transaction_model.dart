import 'package:isar/isar.dart';

part 'transaction_model.g.dart';

@Collection()
class TransactionModel {

  Id id = Isar.autoIncrement;

  late DateTime timestamp;
  late double amount;
  late String title;
  late String message;

  @Index(type: IndexType.value)
  late String category;

  @Index(type: IndexType.value)
  late String type;

  TransactionModel({
    required this.timestamp,
    required this.amount,
    required this.title,
    required this.message,
    required this.category,
    required this.type
  });

}
