import 'package:application/utils/img_assets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
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
  String _apiStatusMessage = '연결 중...';

  @override
  void initState() {
    super.initState();
    _fetchApiStatus('red'); // 기본적으로 빨간 버튼의 API 호출
  }

  // API 상태 확인 메서드
  Future<void> _fetchApiStatus(String buttonColor) async {
    final status = await ApiService.fetchApiStatus(buttonColor); // API 호출
    setState(() {
      _apiStatusMessage = status;
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
                            _buildGridItem(context, ImageAssets.ndrims, squareIconSize, MainUrls.NDRIMS, false, false),
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
                        SizedBox(height: spacing * 0.5),
                        _buildMacStyleAlert(constraints.maxWidth * 0.7, constraints.maxWidth * 0.45), // 출력창 가로 길이 더 줄임
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

  Widget _buildMacStyleAlert(double width, double height) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 왼쪽에 배치된 버튼들
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildControlButton(Colors.red, () {
                _fetchApiStatus('red');
              }),
              SizedBox(height: 8),
              _buildControlButton(Colors.yellow, () {
                _fetchApiStatus('yellow');
              }),
              SizedBox(height: 8),
              _buildControlButton(Colors.green, () {
                _fetchApiStatus('green');
              }),
            ],
          ),
          SizedBox(width: 16), // 버튼과 텍스트 영역 사이의 간격
          Container(
            width: width, // 더 줄어든 출력창 가로 길이
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Expanded(
              child: Text(
                _apiStatusMessage,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 알림창 컨트롤 버튼
  Widget _buildControlButton(Color color, VoidCallback onPressed) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        Color buttonColor = color;
        return GestureDetector(
          onTap: () {
            setState(() {
              buttonColor = Colors.grey[700]!;  // 클릭 시 색상 변경
              onPressed();
            });
          },
          child: Container(
            width: 30, // 버튼 크기
            height: 30,
            margin: EdgeInsets.only(bottom: 16), // 버튼 사이 간격
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

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

  Widget _buildCircleItem(BuildContext context, String assetPath, double iconSize, String? url, bool? showHomeIcon, bool isUniIcon) {
    return GestureDetector(
      onTap: () => isUniIcon ? _openUniScreen(context) : _openWebView(context, url, showHomeIcon, url == MainUrls.GENERALNOTICE || url == MainUrls.NDRIMS || url == MainUrls.MONEYNOTICE),
      child: Column(
        children: [
          Image.asset(assetPath, width: iconSize, height: iconSize),
          SizedBox(height: iconSize * 0.06),
        ],
      ),
    );
  }

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
    this.showHeader = true, // 기본값 설정
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
    _controller.loadRequest(Uri.parse(widget.url));
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
