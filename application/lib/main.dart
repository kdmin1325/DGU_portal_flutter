import 'package:application/utils/img_assets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'uni.dart';
import '../service/api_service.dart';
import '../utils/urls.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _apiStatusMessage = '연결 중...'; // 연결 메시지
  String _activeButton = 'general'; // 기본적으로 첫 번째 버튼이 활성화된 상태

  @override
  void initState() {
    super.initState();
    _fetchApiStatus('general'); // 기본적으로 일반 공지 버튼의 API 호출
  }

  // API 상태 확인 메서드
  Future<void> _fetchApiStatus(String buttonColor) async {
    final status = await ApiService.fetchApiStatus(buttonColor); // API 호출
    setState(() {
      _apiStatusMessage = status;
    });
  }

  void _onButtonPressed(String buttonColor) {
    setState(() {
      _activeButton = buttonColor;
      _fetchApiStatus(buttonColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단 바
            PreferredSize(
              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
              child: AppBar(
                backgroundColor: Color(0xFFF89805),
                toolbarHeight: MediaQuery.of(context).size.height * 0.10,
                title: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Image.asset(ImageAssets.dgumain, height: MediaQuery.of(context).size.height * 0.06),
                  ),
                ),
                automaticallyImplyLeading: false,
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double squareIconSizeFactor = 0.4;
                  double circleIconSizeFactor = 0.3;
                  double squareIconSize = constraints.maxWidth * squareIconSizeFactor;
                  double circleIconSize = constraints.maxWidth * circleIconSizeFactor;
                  double spacing = constraints.maxWidth * 0.05;

                  return Padding(
                    padding: EdgeInsets.all(spacing),
                    child: ListView(
                      children: [
                        // 사각형 아이콘들
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing * 0.3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildGridItem(context, ImageAssets.eclass, squareIconSize, MainUrls.ECLASS, true, false),
                            _buildGridItem(context, ImageAssets.noti, squareIconSize, MainUrls.GENERALNOTICE, false, true),
                            _buildGridItem(context, ImageAssets.bus, squareIconSize, MainUrls.BUS, true, false),
                            _buildGridItem(context, ImageAssets.ndrims, squareIconSize, MainUrls.NDRIMS, true, false),
                          ],
                        ),
                        SizedBox(height: spacing * 0.5),
                        // 원형 아이콘들
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCircleItem(context, ImageAssets.mnoti, circleIconSize, MainUrls.MONEYNOTICE, false, false),
                            _buildCircleItem(context, ImageAssets.donoti, circleIconSize, MainUrls.DORMNOTiCE, true, false),
                            _buildCircleItem(context, ImageAssets.uni, circleIconSize, null, false, true),
                          ],
                        ),
                        SizedBox(height: spacing * 0.6),
                        _buildMacStyleAlert(constraints.maxWidth * 0.81, constraints.maxWidth * 0.42),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 알림창 왼쪽에 위치, 공지 불러오는 버튼
  Widget _buildMacStyleAlert(double width, double height) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.04; // 텍스트 크기를 화면 너비의 4%로 설정

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          Container(
            width: 35, // 버튼의 너비 설정
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 버튼 텍스트들
                GestureDetector(
                  onTap: () => _onButtonPressed('general'),
                  child: Text(
                    '일\n반',
                    style: TextStyle(
                      fontSize: fontSize, // 동적으로 텍스트 크기 설정
                      fontWeight: _activeButton == 'general' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _onButtonPressed('school'),
                  child: Text(
                    '학\n사',
                    style: TextStyle(
                      fontSize: fontSize, // 동적으로 텍스트 크기 설정
                      fontWeight: _activeButton == 'school' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _onButtonPressed('employment'),
                  child: Text(
                    '취\n업',
                    style: TextStyle(
                      fontSize: fontSize, // 동적으로 텍스트 크기 설정
                      fontWeight: _activeButton == 'employment' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 알림창과 텍스트 영역 사이의 간격
          SizedBox(width: 2),
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: RichText(
                text: TextSpan(
                  children: _buildClickableTextSpans(_apiStatusMessage),
                  style: TextStyle(fontSize: fontSize * 0.9, color: Colors.black), // 동적으로 텍스트 크기 설정
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 클릭 가능한 텍스트 스팬 리스트를 생성하는 메서드
  List<TextSpan> _buildClickableTextSpans(String apiStatusMessage) {
    List<TextSpan> spans = [];
    List<String> lines = apiStatusMessage.split('\n');

    for (String line in lines) {
      // URL이 포함된 경우를 찾음
      int startIdx = line.indexOf('http');
      if (startIdx != -1) {
        // URL이 시작되는 위치 이후에 공백이나 닫는 괄호로 URL의 끝을 찾음
        int endIdx = line.indexOf(' ', startIdx);
        if (endIdx == -1) {
          endIdx = line.indexOf(')', startIdx);
        }
        if (endIdx == -1) {
          endIdx = line.length;
        }

        String url = line.substring(startIdx, endIdx).trim();
        String text = line.substring(0, startIdx).trim();

        // 출력 에러로 인한 맨 끝에 있는 '(' 제거
        if (text.endsWith('(')) {
          text = text.substring(0, text.length - 1).trim();
        }

        spans.add(
          TextSpan(
            text: text.isNotEmpty ? '$text\n' : '\n',  // 텍스트와 URL을 줄바꿈으로 구분
            style: TextStyle(color: Colors.black),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _openWebView(context, url, false, true);
              },
          ),
        );
      } else {
        // 일반 텍스트인 경우
        spans.add(TextSpan(text: '$line\n'));
      }
    }

    return spans;
  }

  // 사각 아이콘 이미지 위젯 처리
  Widget _buildGridItem(BuildContext context, String assetPath, double iconSize, String? url, bool? showHomeIcon, bool? showHeader) {
    return GestureDetector(
      onTap: () {
        _openWebView(context, url, showHomeIcon, showHeader);
      },
      child: Center(
        child: Image.asset(assetPath, width: iconSize, height: iconSize),
      ),
    );
  }

  // 원형 아이콘 이미지 위젯 처리
  Widget _buildCircleItem(BuildContext context, String assetPath, double iconSize, String? url, bool? showHomeIcon, bool isUniIcon) {
    return GestureDetector(
      onTap: () => isUniIcon
          ? _openUniScreen(context)
          : _openWebView(context, url, showHomeIcon, url == MainUrls.GENERALNOTICE || url == MainUrls.NDRIMS || url == MainUrls.MONEYNOTICE),
      child: Column(
        children: [
          Image.asset(assetPath, width: iconSize, height: iconSize),
          SizedBox(height: iconSize * 0.06),
        ],
      ),
    );
  }

  // 웹뷰 조건
  void _openWebView(BuildContext context, String? url, bool? showHomeIcon, bool? showHeader) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: url ?? '',
          showHomeIcon: showHomeIcon ?? false,
          showHeader: showHeader ?? true,
        ),
      ),
    );
  }

  // 단과대 페이지 넘어가는 함수
  void _openUniScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UniScreen()),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;
  final bool showHomeIcon;
  final bool showHeader;

  WebViewScreen({
    required this.url,
    this.showHomeIcon = false, // 기본값 설정
    this.showHeader = true,    // 기본값 설정
  });

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();

    // 스킴 확인 및 추가
    String processedUrl = widget.url;
    if (!processedUrl.startsWith(RegExp(r'https?://'))) {
      processedUrl = 'http://' + processedUrl;
    }

    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          setState(() {
            _isLoading = true;
          });
        },
        onPageFinished: (String url) {
          setState(() {
            _isLoading = false;
          });
        },
        onWebResourceError: (WebResourceError error) {
          print('Page resource error: ${error.description}');
        },
      ),
    );
    _controller.loadRequest(Uri.parse(processedUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_isLoading) Center(child: CircularProgressIndicator()),
              if (widget.showHomeIcon)
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Image.asset(ImageAssets.home, width: 70, height: 70),
                  ),
                ),
              if (widget.showHeader)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: PreferredSize(
                    preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
                    child: AppBar(
                      backgroundColor: Color(0xFFF89805),
                      toolbarHeight: MediaQuery.of(context).size.height * 0.12,
                      title: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          child: Image.asset(ImageAssets.dgumain, height: MediaQuery.of(context).size.height * 0.06),
                        ),
                      ),
                      automaticallyImplyLeading: false,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
