import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_manager/models/category/category_models.dart';

const category_db_name = 'category-database';

abstract class CategoryDbfuctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryId);
}

class CategoryDb implements CategoryDbfuctions {
  CategoryDb._internal();
  static CategoryDb instance = CategoryDb._internal();

  factory CategoryDb() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryListListener =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListListener =
      ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDb = await Hive.openBox<CategoryModel>(category_db_name);
    await _categoryDb.put(value.id, value);
    refreshUi();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDb = await Hive.openBox<CategoryModel>(category_db_name);
    return _categoryDb.values.toList();
  }

  Future<void> refreshUi() async {
    final _allCategories = await getCategories();
    incomeCategoryListListener.value.clear();
    expenseCategoryListListener.value.clear();
    await Future.forEach(_allCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryListListener.value.add(category);
      } else {
        expenseCategoryListListener.value.add(category);
      }
    });
    incomeCategoryListListener.notifyListeners();
    expenseCategoryListListener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    final _categoryDb = await Hive.openBox<CategoryModel>(category_db_name);
    await _categoryDb.delete(categoryId);
    refreshUi();
  }
}
