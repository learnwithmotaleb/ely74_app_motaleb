import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../utils/variable.dart';

class ApiService {
  // Base URL for your API
  // final String baseUrl = 'http://10.0.60.189:5000';
  // final String baseUrl = 'http://3.138.222.235:5000';
  final String baseUrl = 'https://whxmt66k-5004.inc1.devtunnels.ms';

  // Singleton pattern for API service
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Headers that will be used in all requests
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Add auth token if available
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // Auth token storage
  String? _authToken;

  // Set auth token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Clear auth token (for logout)
  void clearAuthToken() {
    _authToken = null;
  }

  // Check internet connectivity
  Future<bool> checkInternetConnection() async {
    try {
      bool result = await InternetConnection().hasInternetAccess;
      InternetConnection().onStatusChange.listen((InternetStatus status) {
        switch (status) {
          case InternetStatus.connected:
result=true;            break;
          case InternetStatus.disconnected:
            result=false;             break;
        }
      });
      // logger.d(result);
      return true;
    } catch (e) {
      debugPrint('Connection check error: $e');
      return false;
    }
  }
  // Generic HTTP request method
  Future<dynamic> request({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    bool useAuth = true,
  })
  async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      return {
        'success': false,
        'message': 'No internet connection',
      };
    }

    // Build the URL with query parameters if provided
    var uri = Uri.parse('$baseUrl/$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }
// logger.d(uri.toString());
    http.Response response;
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (useAuth && _authToken != null) 'Authorization': 'Bearer $_authToken',
    };
    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
if(body!=null){
  logger.d(body);
}
      // Parse response safely
      var responseData;
      if (response.body.trim().isEmpty) {
        responseData = {};
      } else {
        try {
          responseData = json.decode(response.body);
        } catch (e) {
          logger.e("Failed to parse JSON. Status: ${response.statusCode}, Body: ${response.body}");
          return {
            'success': false,
            'message': 'Server returned an invalid response',
            'statusCode': response.statusCode,
          };
        }
      }

      // Check status code
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        return {
          'success': false,
          'message': responseData['message'] ??
              'Request failed with status: ${response.statusCode}',
          'statusCode': response.statusCode,
          'data': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Request failed: ${e.toString()}',
      };
    }
  }


  Future<dynamic> multipartRequest({
    required String endpoint,
    required String method,
    required Map<String, String> fields,
    required Map<String, dynamic> files, // Use dynamic to support both single files and lists
  })
  async {
    // Check internet connection first
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      return {
        'success': false,
        'message': 'No internet connection',
      };
    }

    var uri = Uri.parse('$baseUrl/$endpoint');
    var request = http.MultipartRequest(method, uri);

    // Add headers (including auth token if available)
    request.headers.addAll({
      'Accept': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    });

    // Add fields (text data)
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add files before logging them
    for (var key in files.keys) {
      var value = files[key];

      if (value is File) {
        var multipartFile = await http.MultipartFile.fromPath(
          key,
          value.path,
          contentType: _getMediaType(value.path),
        );
        request.files.add(multipartFile);
      }
      else if (value is List) {
        for (var file in value) {
          if (file is File) {
            var multipartFile = await http.MultipartFile.fromPath(
              key,
              file.path,
              contentType: _getMediaType(file.path),
            );
            request.files.add(multipartFile);
          }
        }
      }
    }

    logger.d('Sending Multipart Request:');
    logger.d('➡️ URL: $uri');
    logger.d('➡️ Method: $method');
    logger.d('➡️ Headers: ${request.headers}');
    logger.d('➡️ Fields: ${request.fields}');
    logger.d('➡️ Files Count: ${request.files.length}');
    for (var f in request.files) {
      logger.d('  - Field: ${f.field}, Filename: ${f.filename}, Length: ${f.length}, Type: ${f.contentType}');
    }

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      
      var jsonResponse;
      if (responseData.trim().isEmpty) {
        jsonResponse = {};
      } else {
        try {
          jsonResponse = json.decode(responseData);
        } catch (e) {
          logger.e("Failed to parse JSON in multipart request. Status: ${response.statusCode}, Body: $responseData");
          return {
            'success': false,
            'message': 'Server returned an invalid response',
            'statusCode': response.statusCode,
          };
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonResponse;
      } else {
        return {
          'success': false,
          'message': jsonResponse['message'] ?? 'Request failed with status: ${response.statusCode}',
          'statusCode': response.statusCode,
          'data': jsonResponse,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Request failed: ${e.toString()}',
      };
    }
  }

  // Function to determine MediaType based on file extension
  MediaType _getMediaType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'webp':
        return MediaType('image', 'webp');
      case 'doc':
        return MediaType('application', 'msword');
      case 'docx':
        return MediaType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document');
      case 'm4a':
        return MediaType('audio', 'mp4');
      case 'mp3':
        return MediaType('audio', 'mpeg');
      case 'wav':
        return MediaType('audio', 'wav');
      default:
        return MediaType('application', 'octet-stream'); // Default binary data
    }
  }
}
