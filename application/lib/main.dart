import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PreferredSize(
              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
              child: AppBar(
                backgroundColor: Color(0xFFF89805),
                toolbarHeight: MediaQuery.of(context).size.height * 0.1,
                title: Center(
                  child: Image.asset('assets/dgumain.png', height: MediaQuery.of(context).size.height * 0.06),
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
                  double spacing = constraints.maxWidth * 0.04;

                  return Padding(
                    padding: EdgeInsets.all(spacing),
                    child: ListView(
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildGridItem(context, 'assets/eclass.png', squareIconSize, 'https://eclass.dongguk.ac.kr/home/mainHome/Form/main'),
                            _buildGridItem(context, 'assets/noti.png', squareIconSize, 'https://web.dongguk.ac.kr/article/generalnotice/list', true),
                            _buildGridItem(context, 'assets/bus.png', squareIconSize, 'https://dongguk.unibus.kr/#/'),
                            _buildGridItem(context, 'assets/scnoti.png', squareIconSize, 'https://web.dongguk.ac.kr/article/acdnotice/list', true),
                          ],
                        ),
                        SizedBox(height: spacing),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCircleItem(context, 'assets/mnoti.png', circleIconSize, 'https://web.dongguk.ac.kr/article/servicenotice/list', true),
                                _buildCircleItem(context, 'assets/donoti.png', circleIconSize, 'https://dorm.dongguk.ac.kr/'),
                                _buildCircleItem(context, 'assets/uni.png', circleIconSize, null), // 단과대 아이콘은 클릭 기능 없음
                              ],
                            ),
                            SizedBox(height: spacing),
                            // 회색 사각형 추가 부분
                            Container(
                              width: constraints.maxWidth * 0.85,
                              height: constraints.maxWidth * 0.6,
                              decoration: BoxDecoration(
                                color: Color(0xFFA0A0A0), // 색상을 원하는 컬러 코드로 변경
                                borderRadius: BorderRadius.circular(15), // 모서리 둥글게 설정
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildGridItem(BuildContext context, String assetPath, double iconSize, String? url, [bool showHeader = false]) {
    return GestureDetector(
      onTap: () => _openWebView(context, url, showHeader),
      child: Center(
        child: Image.asset(assetPath, width: iconSize, height: iconSize),
      ),
    );
  }

  Widget _buildCircleItem(BuildContext context, String assetPath, double iconSize, String? url, [bool showHeader = false]) {
    return GestureDetector(
      onTap: () => _openWebView(context, url, showHeader),
      child: Column(
        children: [
          Image.asset(assetPath, width: iconSize, height: iconSize),
          SizedBox(height: iconSize * 0.1), // 원형 아이콘과 사각형 간의 간격
        ],
      ),
    );
  }

  void _openWebView(BuildContext context, String? url, bool showHeader) {
    if (url != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewScreen(url: url, showHeader: showHeader)),
      );
    } else {
      print('URL is null');
    }
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;
  final bool showHeader;

  WebViewScreen({required this.url, required this.showHeader});

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
          child: Column(
            children: [
              if (widget.showHeader)
                PreferredSize(
                  preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
                  child: AppBar(
                    backgroundColor: Color(0xFFF89805),
                    toolbarHeight: MediaQuery.of(context).size.height * 0.1,
                    title: Center(
                      child: Image.asset('assets/dgumain.png', height: MediaQuery.of(context).size.height * 0.1),
                    ),
                    automaticallyImplyLeading: false,
                  ),
                ),
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(
                      controller: _controller,
                    ),
                    if (_isLoading) Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
