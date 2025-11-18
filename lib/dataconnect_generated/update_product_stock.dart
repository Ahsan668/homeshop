part of 'generated.dart';

class UpdateProductStockVariablesBuilder {
  String id;
  int stockQuantity;

  final FirebaseDataConnect _dataConnect;
  UpdateProductStockVariablesBuilder(this._dataConnect, {required  this.id,required  this.stockQuantity,});
  Deserializer<UpdateProductStockData> dataDeserializer = (dynamic json)  => UpdateProductStockData.fromJson(jsonDecode(json));
  Serializer<UpdateProductStockVariables> varsSerializer = (UpdateProductStockVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateProductStockData, UpdateProductStockVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateProductStockData, UpdateProductStockVariables> ref() {
    UpdateProductStockVariables vars= UpdateProductStockVariables(id: id,stockQuantity: stockQuantity,);
    return _dataConnect.mutation("UpdateProductStock", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateProductStockProductUpdate {
  final String id;
  UpdateProductStockProductUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProductStockProductUpdate otherTyped = other as UpdateProductStockProductUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateProductStockProductUpdate({
    required this.id,
  });
}

@immutable
class UpdateProductStockData {
  final UpdateProductStockProductUpdate? product_update;
  UpdateProductStockData.fromJson(dynamic json):
  
  product_update = json['product_update'] == null ? null : UpdateProductStockProductUpdate.fromJson(json['product_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProductStockData otherTyped = other as UpdateProductStockData;
    return product_update == otherTyped.product_update;
    
  }
  @override
  int get hashCode => product_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (product_update != null) {
      json['product_update'] = product_update!.toJson();
    }
    return json;
  }

  UpdateProductStockData({
    this.product_update,
  });
}

@immutable
class UpdateProductStockVariables {
  final String id;
  final int stockQuantity;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateProductStockVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  stockQuantity = nativeFromJson<int>(json['stockQuantity']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProductStockVariables otherTyped = other as UpdateProductStockVariables;
    return id == otherTyped.id && 
    stockQuantity == otherTyped.stockQuantity;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, stockQuantity.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['stockQuantity'] = nativeToJson<int>(stockQuantity);
    return json;
  }

  UpdateProductStockVariables({
    required this.id,
    required this.stockQuantity,
  });
}

