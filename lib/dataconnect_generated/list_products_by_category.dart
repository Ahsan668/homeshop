part of 'generated.dart';

class ListProductsByCategoryVariablesBuilder {
  String category;

  final FirebaseDataConnect _dataConnect;
  ListProductsByCategoryVariablesBuilder(this._dataConnect, {required  this.category,});
  Deserializer<ListProductsByCategoryData> dataDeserializer = (dynamic json)  => ListProductsByCategoryData.fromJson(jsonDecode(json));
  Serializer<ListProductsByCategoryVariables> varsSerializer = (ListProductsByCategoryVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListProductsByCategoryData, ListProductsByCategoryVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListProductsByCategoryData, ListProductsByCategoryVariables> ref() {
    ListProductsByCategoryVariables vars= ListProductsByCategoryVariables(category: category,);
    return _dataConnect.query("ListProductsByCategory", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListProductsByCategoryProducts {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int? stockQuantity;
  ListProductsByCategoryProducts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = nativeFromJson<String>(json['description']),
  price = nativeFromJson<double>(json['price']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  stockQuantity = json['stockQuantity'] == null ? null : nativeFromJson<int>(json['stockQuantity']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListProductsByCategoryProducts otherTyped = other as ListProductsByCategoryProducts;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    price == otherTyped.price && 
    imageUrl == otherTyped.imageUrl && 
    stockQuantity == otherTyped.stockQuantity;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, price.hashCode, imageUrl.hashCode, stockQuantity.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['description'] = nativeToJson<String>(description);
    json['price'] = nativeToJson<double>(price);
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    if (stockQuantity != null) {
      json['stockQuantity'] = nativeToJson<int?>(stockQuantity);
    }
    return json;
  }

  ListProductsByCategoryProducts({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.stockQuantity,
  });
}

@immutable
class ListProductsByCategoryData {
  final List<ListProductsByCategoryProducts> products;
  ListProductsByCategoryData.fromJson(dynamic json):
  
  products = (json['products'] as List<dynamic>)
        .map((e) => ListProductsByCategoryProducts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListProductsByCategoryData otherTyped = other as ListProductsByCategoryData;
    return products == otherTyped.products;
    
  }
  @override
  int get hashCode => products.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['products'] = products.map((e) => e.toJson()).toList();
    return json;
  }

  ListProductsByCategoryData({
    required this.products,
  });
}

@immutable
class ListProductsByCategoryVariables {
  final String category;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListProductsByCategoryVariables.fromJson(Map<String, dynamic> json):
  
  category = nativeFromJson<String>(json['category']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListProductsByCategoryVariables otherTyped = other as ListProductsByCategoryVariables;
    return category == otherTyped.category;
    
  }
  @override
  int get hashCode => category.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['category'] = nativeToJson<String>(category);
    return json;
  }

  ListProductsByCategoryVariables({
    required this.category,
  });
}

