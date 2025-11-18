library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'add_new_product.dart';

part 'list_products_by_category.dart';

part 'update_product_stock.dart';

part 'get_product_details.dart';







class ExampleConnector {
  
  
  AddNewProductVariablesBuilder addNewProduct ({required String description, required String imageUrl, required String name, required double price, }) {
    return AddNewProductVariablesBuilder(dataConnect, description: description,imageUrl: imageUrl,name: name,price: price,);
  }
  
  
  ListProductsByCategoryVariablesBuilder listProductsByCategory ({required String category, }) {
    return ListProductsByCategoryVariablesBuilder(dataConnect, category: category,);
  }
  
  
  UpdateProductStockVariablesBuilder updateProductStock ({required String id, required int stockQuantity, }) {
    return UpdateProductStockVariablesBuilder(dataConnect, id: id,stockQuantity: stockQuantity,);
  }
  
  
  GetProductDetailsVariablesBuilder getProductDetails ({required String id, }) {
    return GetProductDetailsVariablesBuilder(dataConnect, id: id,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'homeshop',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
