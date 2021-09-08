import 'package:flutter/material.dart';

class CategoryModel {
  late final int? id;
  late final String name;
  late final String description;

  static final Color categoryColor = Colors.red.shade300;

  CategoryModel({this.id, required this.name, required this.description});

  CategoryModel.fromMap(Map<String, dynamic> category)
      : this.id = category["id"],
        this.name = category["name"],
        this.description = category["description"];

  Map<String, dynamic> toMap() {
    var mapping = Map<String, dynamic>();

    mapping["id"] = this.id;
    mapping["name"] = this.name;
    mapping["description"] = this.description;

    return mapping;
  }
}
