import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ebuy/app/constants/constant.dart';

import '../../services/storage_service.dart';
import '../models/req/address_req.model.dart';

class ApiProvider {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: kBaseUrl,
      contentType: 'application/json',
      responseType: ResponseType.json,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );

  ApiProvider() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Do sth before request is sent
          // e.g. add authorization token

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode == 401) {
            //
          }
          //do sth with response data
          //this is where you can handle responses globally
          print('GLOBAL RESPONSE: ${response.statusCode} - ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          //do sth with response error
          print('GLOBAL ERROR: ${e.response?.statusCode} - ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      return _dio.post(
        '/login',
        data: {'email': email, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> register({
    required String email,
    required String password,
    required String name,
    File? image,
  }) async {
    final _formData = FormData.fromMap({
      'email': email,
      'password': password,
      'c_password': password,
      'name': name,
      'image': image != null ? await MultipartFile.fromFile(image.path) : null,
    });
    try {
      return _dio.post(
        '/register',
        data: _formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // logout
  Future<Response> logout() async {
    try {
      return _dio.post(
        '/logout',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> me() async {
    try {
      return _dio.get(
        '/user',
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAddress() async {
    try {
      return _dio.get(
        '/address',
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addAddress(AddressReq address) async {
    try {
      return _dio.post(
        '/address',
        data: address.toJson(),
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getProducts() async {
    try {
      return _dio.get(
        '/products',
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addToCart({required int proId, required int qty}) async {
    try {
      return _dio.post(
        '/carts',
        data: {"product_id": proId, "quantity": qty},
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCarts() async {
    try {
      return _dio.get(
        '/carts',
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getOrders() async {
    try {
      return _dio.get(
        '/orders',
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> searchProduct({
    String? searchKeyword,
    String? minPrice,
    String? maxPrice,
  }) async {
    try {
      return _dio.get(
        '/products/search',
        queryParameters: {
          "search": searchKeyword,
          "min_price": minPrice,
          "max_price": maxPrice,
        },
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }


  Future<Response> deleteCartItem({required int itemId}) async {
    try {
      return _dio.delete(
        '/carts/items/$itemId',
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateCartItem({required int itemId, required int quantity}) async {
    try {
      return _dio.put(
        '/carts/items/$itemId',
        data: {'quantity': quantity},
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await StorageService.read(key: 'token')}',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
