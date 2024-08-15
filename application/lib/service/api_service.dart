import 'package:http/http.dart' as http;

Future<String> fetchApiStatus() async {
  final url = 'http://a9b8c7d6e5f4g3h2i1j0klmnopqrst.ap-northeast-2.elasticbeanstalk.com';
  try {
    final response = await http.get(Uri.parse(url));
    return response.body;
  } catch (e) {
    return '인터넷 연결이 없습니다';
  }
}
