part of 'generated.dart';

class AddNewProductVariablesBuilder {
  Optional<String> _category = Optional.optional(nativeFromJson, nativeToJson);
  String description;
  String imageUrl;
  String name;
  double price;
  Optional<int> _stockQuantity = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  AddNewProductVariablesBuilder category(String? t) {
   _category.value = t;
   return this;
  }
  AddNewProductVariablesBuilder stockQuantity(int? t) {
   _stockQuantity.value = t;
   return this;
  }

  AddNewProductVariablesBuilder(this._dataConnect, {required  this.description,required  this.imageUrl,required  this.name,required  this.price,});
  Deserializer<AddNewProductData> dataDeserializer = (dynamic json)  => AddNewProductData.fromJson(jsonDecode(json));
  Serializer<AddNewProductVariables> varsSerializer = (AddNewProductVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddNewProductData, AddNewProductVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddNewProductData, AddNewProductVariables> ref() {
    AddNewProductVariables vars= AddNewProductVariables(category: _category,description: description,imageUrl: imageUrl,name: name,price: price,stockQuantity: _stockQuantity,);
    return _dataConnect.mutation("AddNewProduct", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddNewProductProductInsert {
  final String id;
  AddNewProductProductInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddNewProductProductInsert otherTyped = other as AddNewProductProductInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddNewProductProductInsert({
    required this.id,
  });
}

@immutable
class AddNewProductData {
  final AddNewProductProductInsert product_insert;
  AddNewProductData.fromJson(dynamic json):
  
  product_insert = AddNewProductProductInsert.fromJson(json['product_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddNewProductData otherTyped = other as AddNewProductData;
    return product_insert == otherTyped.product_insert;
    
  }
  @override
  int get hashCode => product_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['product_insert'] = product_insert.toJson();
    return json;
  }

  AddNewProductData({
    required this.product_insert,
  });
}

@immutable
class AddNewProductVariables {
  late final Optional<String>category;
  final String description;
  final String imageUrl;
  final String name;
  final double price;
  late final Optional<int>stockQuantity;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddNewProductVariables.fromJson(Map<String, dynamic> json):
  
  description = nativeFromJson<String>(json['description']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  name = nativeFromJson<String>(json['name']),
  price = nativeFromJson<double>(json['price']) {
  
  
    category = Optional.optional(nativeFromJson, nativeToJson);
    category.value = json['category'] == null ? null : nativeFromJson<String>(json['category']);
  
  
  
  
  
  
    stockQuantity = Optional.optional(nativeFromJson, nativeToJson);
    stockQuantity.value = json['stockQuantity'] == null ? null : nativeFromJson<int>(json['stockQuantity']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddNewProductVariables otherTyped = other as AddNewProductVariables;
    return category == otherTyped.category && 
    description == otherTyped.description && 
    imageUrl == otherTyped.imageUrl && 
    name == otherTyped.name && 
    price == otherTyped.price && 
    stockQuantity == otherTyped.stockQuantity;
    
  }
  @override
  int get hashCode => Object.hashAll([category.hashCode, description.hashCode, imageUrl.hashCode, name.hashCode, price.hashCode, stockQuantity.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(category.state == OptionalState.set) {
      json['category'] = category.toJson();
    }
    json['description'] = nativeToJson<String>(description);
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    json['name'] = nativeToJson<String>(name);
    json['price'] = nativeToJson<double>(price);
    if(stockQuantity.state == OptionalState.set) {
      json['stockQuantity'] = stockQuantity.toJson();
    }
    return json;
  }

  AddNewProductVariables({
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.stockQuantity,
  });
}

