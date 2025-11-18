part of 'generated.dart';

class GetProductDetailsVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetProductDetailsVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetProductDetailsData> dataDeserializer = (dynamic json)  => GetProductDetailsData.fromJson(jsonDecode(json));
  Serializer<GetProductDetailsVariables> varsSerializer = (GetProductDetailsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetProductDetailsData, GetProductDetailsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetProductDetailsData, GetProductDetailsVariables> ref() {
    GetProductDetailsVariables vars= GetProductDetailsVariables(id: id,);
    return _dataConnect.query("GetProductDetails", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetProductDetailsProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int? stockQuantity;
  final String? category;
  GetProductDetailsProduct.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = nativeFromJson<String>(json['description']),
  price = nativeFromJson<double>(json['price']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  stockQuantity = json['stockQuantity'] == null ? null : nativeFromJson<int>(json['stockQuantity']),
  category = json['category'] == null ? null : nativeFromJson<String>(json['category']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductDetailsProduct otherTyped = other as GetProductDetailsProduct;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    price == otherTyped.price && 
    imageUrl == otherTyped.imageUrl && 
    stockQuantity == otherTyped.stockQuantity && 
    category == otherTyped.category;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, price.hashCode, imageUrl.hashCode, stockQuantity.hashCode, category.hashCode]);
  

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
    if (category != null) {
      json['category'] = nativeToJson<String?>(category);
    }
    return json;
  }

  GetProductDetailsProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.stockQuantity,
    this.category,
  });
}

@immutable
class GetProductDetailsData {
  final GetProductDetailsProduct? product;
  GetProductDetailsData.fromJson(dynamic json):
  
  product = json['product'] == null ? null : GetProductDetailsProduct.fromJson(json['product']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductDetailsData otherTyped = other as GetProductDetailsData;
    return product == otherTyped.product;
    
  }
  @override
  int get hashCode => product.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (product != null) {
      json['product'] = product!.toJson();
    }
    return json;
  }

  GetProductDetailsData({
    this.product,
  });
}

@immutable
class GetProductDetailsVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetProductDetailsVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductDetailsVariables otherTyped = other as GetProductDetailsVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetProductDetailsVariables({
    required this.id,
  });
}

