# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### ListProductsByCategory
#### Required Arguments
```dart
String category = ...;
ExampleConnector.instance.listProductsByCategory(
  category: category,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListProductsByCategoryData, ListProductsByCategoryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listProductsByCategory(
  category: category,
);
ListProductsByCategoryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String category = ...;

final ref = ExampleConnector.instance.listProductsByCategory(
  category: category,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetProductDetails
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getProductDetails(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetProductDetailsData, GetProductDetailsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getProductDetails(
  id: id,
);
GetProductDetailsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getProductDetails(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### AddNewProduct
#### Required Arguments
```dart
String description = ...;
String imageUrl = ...;
String name = ...;
double price = ...;
ExampleConnector.instance.addNewProduct(
  description: description,
  imageUrl: imageUrl,
  name: name,
  price: price,
).execute();
```

#### Optional Arguments
We return a builder for each query. For AddNewProduct, we created `AddNewProductBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class AddNewProductVariablesBuilder {
  ...
 
  AddNewProductVariablesBuilder category(String? t) {
   _category.value = t;
   return this;
  }
  AddNewProductVariablesBuilder stockQuantity(int? t) {
   _stockQuantity.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.addNewProduct(
  description: description,
  imageUrl: imageUrl,
  name: name,
  price: price,
)
.category(category)
.stockQuantity(stockQuantity)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<AddNewProductData, AddNewProductVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.addNewProduct(
  description: description,
  imageUrl: imageUrl,
  name: name,
  price: price,
);
AddNewProductData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String description = ...;
String imageUrl = ...;
String name = ...;
double price = ...;

final ref = ExampleConnector.instance.addNewProduct(
  description: description,
  imageUrl: imageUrl,
  name: name,
  price: price,
).ref();
ref.execute();
```


### UpdateProductStock
#### Required Arguments
```dart
String id = ...;
int stockQuantity = ...;
ExampleConnector.instance.updateProductStock(
  id: id,
  stockQuantity: stockQuantity,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateProductStockData, UpdateProductStockVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateProductStock(
  id: id,
  stockQuantity: stockQuantity,
);
UpdateProductStockData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
int stockQuantity = ...;

final ref = ExampleConnector.instance.updateProductStock(
  id: id,
  stockQuantity: stockQuantity,
).ref();
ref.execute();
```

