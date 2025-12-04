import 'package:dio/dio.dart';

class HTTPService {
  HTTPService();

  final _dio = Dio();

  Future<Response?> get(String path) async {
    try {
      final res = await _dio.get(path);
      return res;
    } catch (e) {
      print("HTTP Error: $e");
      return null;
    }
  }
}
