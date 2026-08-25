// ignore_for_file: unused_import
import 'package:messanger_ax/exports.dart';

class ServerException implements Exception {
  const ServerException([this.message = 'Server exception']);

  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache exception']);

  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'Network exception']);

  final String message;
}
