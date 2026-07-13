import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'base_api_service.dart';
import '../di/locator.dart';

final apiServiceProvider = Provider<BaseApiService>((ref) => locator<BaseApiService>());

class NetworkApiService extends BaseApiService {
  @override
  Future getApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw Exception('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw Exception('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Bad Request');
      case 401:
        throw Exception('Unauthorized: Please check your credentials');
      case 404:
        throw Exception('Not Found: Server endpoint not found');
      case 500:
        throw Exception('Server Error: Please try again later');
      default:
        throw Exception(
            'Error occurred while communicating with server: ${response.statusCode}');
    }
  }
}
