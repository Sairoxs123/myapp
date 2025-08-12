import 'package:isar/isar.dart';

part 'categories_model.g.dart';

@Collection()
class CategoriesModel {
  Id id = Isar.autoIncrement;

  late String categoryName;
  late int iconCodePoint;

  CategoriesModel({
    required this.categoryName,
    required this.iconCodePoint
  });

}