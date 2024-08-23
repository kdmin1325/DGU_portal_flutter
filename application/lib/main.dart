import 'package:application/utils/img_assets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'uni.dart';
import '../service/api_service.dart';
import '../utils/img_assets.dart';
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
    _checkApiStatus();  // static 메서드를 호출하는 방식으로 변경
  }

  // static 메서드를 사용하여 API 상태를 확인
  void _checkApiStatus() {
    _fetchApiStatus();
  }

  Future<void> _fetchApiStatus() async {
    final status = await ApiService.fetchApiStatus();  // static 메서드 호출
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
                            _buildGridItem(context, ImageAssets.ndrims, squareIconSize, MainUrls.NDRIMS, false, false), // NDRIMS에 맞는 조건 설정
                          ],
                        ),
                        SizedBox(height: spacing * 0.5),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCircleItem(context, ImageAssets.mnoti, circleIconSize, MainUrls.MONEYNOTICE, false, false),
                                _buildCircleItem(context, ImageAssets.donoti, circleIconSize, MainUrls.DORMNOTiCE, true, false),
                                _buildCircleItem(context, ImageAssets.uni, circleIconSize, null, false, true),
                              ],
                            ),
                            SizedBox(height: spacing * 0.5),
                            Container(
                              width: constraints.maxWidth * 0.85,
                              height: constraints.maxWidth * 0.45,
                              decoration: BoxDecoration(
                                color: Color(0xFFE2E2E2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 패딩을 추가
                                child: Column(
                                  children: [
                                    Text(
                                      _apiStatusMessage,
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.left, // 왼쪽 정렬
                                    ),
                                    SizedBox(height: 16), // 아래쪽에 약간의 공간 추가
                                  ],
                                ),
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

  Widget _buildGridItem(BuildContext context, String assetPath, double iconSize, String? url, bool? showHomeIcon, bool? showHeader) {
    return GestureDetector(
      onTap: () {
        if (url == MainUrls.NDRIMS) {
          _openWebView(context, url, true, false); // NDRIMS에 맞는 설정
        } else {
          _openWebView(context, url, showHomeIcon, showHeader);
        }
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
    final bool showHomeIconSafe = showHomeIcon ?? false;
    final bool showHeaderSafe = showHeader ?? true;

    if (url != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewScreen(
            url: url,
            showHomeIcon: showHomeIconSafe,
            showHeader: showHeaderSafe,
          ),
        ),
      );
    } else {
      print('URL is null');
    }
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
    this.showHomeIcon = false,
    this.showHeader = true,
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
              WebViewWidget(
                controller: _controller,
              ),
              if (_isLoading)
                Center(child: CircularProgressIndicator()),
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
