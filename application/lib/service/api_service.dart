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

    // 버튼 타입에 따른 API 엔드포인트 설정
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
        return 'error in endpoint';
    }

    try {
      final response = await _dio.get(ApiUrls.SERVERIP + endpoint);

      var jsonResponse = response.data;

      if (jsonResponse is Map<String, dynamic>) {
        StringBuffer output = StringBuffer();

        // 키가 숫자인 항목들 리스트에 추가
        List<String> numericKeys = [];

        jsonResponse.forEach((key, value) {
          if (_isNumeric(key)) {
            numericKeys.add(key);
          }
        });

        // 키를 내림차순으로 정렬
        numericKeys.sort((a, b) => b.compareTo(a));

        // 내림차순으로 정렬된 키에 맞는 값들을 출력
        for (String key in numericKeys) {
          String text = jsonResponse[key].toString();

          // 최대 길이 설정
          const int maxLineLength = 28;

          // 문장이 maxLineLength를 넘으면 자르고 '···' 붙이기
          if (text.length > maxLineLength) {
            text = '${text.substring(0, maxLineLength)}···';
          }

          // 각 텍스트를 새로운 줄로 추가
          output.writeln(text);
        }

        return output.toString().trim(); // 최종 문자열 반환
      }

      return '데이터 형식이 올바르지 않습니다.';
    } catch (e) {
      print('Error occurred: $e'); // 에러일 경우 에러 코드 확인
      return '인터넷 연결을 확인해주세요.';
    }
  }

  // 키가 숫자인지 확인
  static bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
}
