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
    // 안드로이드 엔드포인트
    switch (buttonColor) {
      case 'general':
        endpoint = 'and/information/generalnotice';
        break;
      case 'school':
        endpoint = 'and/information/acdnotice';
        break;
      case 'employment':
        endpoint = 'and/information/empprgnoti';
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
          try {
            String text = jsonResponse[key].toString();

            // 디버깅용 로그 추가
            print("Processing Key: $key, Value: $text");

            // URL 생성 - 프로토콜 포함
            String url = jsonResponse['link'] + key;
            if (!url.startsWith('http')) {
              url = 'http://' + url; // http 프로토콜 추가
            }

            // 각 텍스트를 새로운 줄로 추가하고, URL 연결
            output.writeln('$text ($url)');
          } catch (e) {
            print("Error processing key $key: $e");
          }
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
