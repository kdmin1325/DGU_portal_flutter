import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/urls.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiUrls.SERVERIP + '/information/generalnotice',
    connectTimeout: Duration(milliseconds: 5000),
    receiveTimeout: Duration(milliseconds: 3000),
  ));

  static Future<String> fetchApiStatus() async {
    try {
      final response = await _dio.get('');

      var jsonResponse = response.data;

      if (jsonResponse is List) {
        StringBuffer output = StringBuffer();

        for (var item in jsonResponse) {
          // 각 리스트의 첫 번째 항목이 텍스트라고 가정
          if (item is List && item.isNotEmpty) {
            String text = item[0];

            // 한 줄의 최대 길이 설정 (예: 33자로 제한)
            const int maxLineLength = 33;

            // 문장이 maxLineLength를 넘으면 자르고 '···' 붙이기
            if (text.length > maxLineLength) {
              output.writeln('${text.substring(0, maxLineLength)}···');
            } else {
              output.writeln(text);
            }
          }
        }

        return output.toString().trim();  // 최종 문자열 반환
      }

      return '데이터 형식이 올바르지 않습니다.';
    } catch (e) {
      print('Error occurred: $e'); // 에러일 경우 에러 코드 확인
      return '인터넷 연결이 없습니다.';
    }
  }
}
