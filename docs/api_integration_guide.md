# API Integration Guide

This guide outlines the standard pattern for integrating APIs into the Rosewe Online Shopping app.

## 1. Directory Structure

Follow this structure for each feature:
```
lib/features/[feature_name]/
  data/
    models/
      [feature]_model.dart
    repository/
      [feature]_repository.dart
  controller/
    [feature]_controller.dart
  presentation/
    [feature]_screen.dart
```

## 2. Model Creation

Models should extend `BaseModel` and include a `fromJson` factory.
```dart
class MyModel extends BaseModel {
  final String? id;
  // ... fields

  MyModel({this.id, super.success, super.message});

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      id: json['id'],
      success: json['success'],
      message: json['message'],
    );
  }
}
```

## 3. Repository Implementation

Repositories use `ApiService` to fetch data and `ApiService.processResponse` to wrap it in `ApiResponse`.
```dart
class MyRepository {
  Future<ApiResponse<MyModel>> fetchMyData() async {
    final response = await ApiService.get(ApiEndpoints.myEndpoint);
    return ApiService.processResponse<MyModel>(
      response,
      (json) => MyModel.fromJson(json),
    );
  }
}
```

## 4. Controller Management (GetX)

Controllers manage the UI state and error messages.
```dart
class MyController extends GetxController {
  final MyRepository _repository = MyRepository();
  var isLoading = false.obs;
  var data = Rxn<MyModel>();
  var errorMessage = ''.obs;

  Future<void> loadData() async {
    isLoading(true);
    final res = await _repository.fetchMyData();
    if (res.success) data.value = res.data;
    else errorMessage.value = res.message ?? 'Error';
    isLoading(false);
  }
}
```

## 5. UI Integration

Use `Obx` to listen to controller changes and `Get.put()` or `Get.find()` to access the controller.
```dart
final MyController controller = Get.put(MyController());

// In build:
Obx(() {
  if (controller.isLoading.value) return Loader();
  return MyWidget(data: controller.data.value);
})
```
