// ignore_for_file: unused_import
import 'package:messanger_ax/exports.dart';

/// HTTP / API client abstraction used by data sources.
abstract class ApiClient {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});

  Future<dynamic> post(String path, {Object? body});

  Future<dynamic> put(String path, {Object? body});

  Future<dynamic> delete(String path);
}
