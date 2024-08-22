import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://a9b8c7d6e5f4g3h2i1j0klmnopqrst.ap-northeast-2.elasticbeanstalk.com/',
    connectTimeout: Duration(milliseconds: 5000),
    receiveTimeout: Duration(milliseconds: 3000),
  ));

  static Future<String> fetchApiStatus() async {
    try {
      final response = await _dio.get('/');
      return response.data.toString();
    } catch (e) {
      return '인터넷 연결이 없습니다.';
    }
  }
}
