import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:homeshop/data/models/category_model.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class ProductModel extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final List<String> images;

  @HiveField(5)
  final CategoryModel category;

  @HiveField(6)
  final DateTime? creationAt;

  @HiveField(7)
  final DateTime? updatedAt;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
    this.creationAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductModel copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    List<String>? images,
    CategoryModel? category,
    DateTime? creationAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      images: images ?? this.images,
      category: category ?? this.category,
      creationAt: creationAt ?? this.creationAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        description,
        images,
        category,
        creationAt,
        updatedAt,
      ];
}
