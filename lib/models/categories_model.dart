import 'package:isar/isar.dart';

part 'categories_model.g.dart';

@Collection()
class CategoriesModel {
  Id id = Isar.autoIncrement;

  late String categoryName;

  CategoriesModel({
    required this.categoryName,
  });

}