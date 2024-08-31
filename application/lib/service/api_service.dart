import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/urls.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: Duration(milliseconds: 5000),
    receiveTimeout: Duration(milliseconds: 3000),
  ));

  // 버튼 색상에 따라 API 엔드포인트를 결정하는 메서드
  static Future<String> fetchApiStatus(String buttonColor) async {
    String endpoint;

    // 버튼 색상에 따른 API 엔드포인트 설정
    switch (buttonColor) {
      case 'general':
        endpoint = '/information/generalnotice';
        break;
      case 'school':
        endpoint = '/information/acdnotice';
        break;
      case 'employment':
        endpoint = '/information/empprgnoti';
        break;
      default:
        return 'error in button I think';
    }

    try {
      final response = await _dio.get(ApiUrls.SERVERIP + endpoint);

      var jsonResponse = response.data;

      if (jsonResponse is List) {
        StringBuffer output = StringBuffer();

        // 최신 항목부터 6개 가져오기
        var latestItems = jsonResponse.reversed.take(6).toList();

        // 가장 최신 항목부터 차례대로 추가
        for (var item in latestItems) {
          // 각 리스트의 첫 번째 항목이 텍스트라고 가정
          if (item is List && item.isNotEmpty) {
            String text = item[0];

            // 최대 길이 설정
            const int maxLineLength = 28;

            // 문장이 maxLineLength를 넘으면 자르고 '···' 붙이기
            if (text.length > maxLineLength) {
              text = '${text.substring(0, maxLineLength)}···';
            }

            // 각 텍스트를 새로운 줄로 추가
            output.writeln(text);
          }
        }

        return output.toString().trim();  // 최종 문자열 반환
      }

      return '데이터 형식이 올바르지 않습니다.';
    } catch (e) {
      print('Error occurred: $e'); // 에러일 경우 에러 코드 확인
      return '인터넷 연결을 확인해주세요.';
    }
  }
}
