import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'uni.dart';

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
                toolbarHeight: MediaQuery.of(context).size.height * 0.10,
                title: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Image.asset('assets/dgumain.png', height: MediaQuery.of(context).size.height * 0.06),
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
                            _buildGridItem(context, 'assets/eclass.png', squareIconSize, 'https://eclass.dongguk.ac.kr/home/mainHome/Form/main', true, false),
                            _buildGridItem(context, 'assets/noti.png', squareIconSize, 'https://web.dongguk.ac.kr/article/generalnotice/list', false, true),
                            _buildGridItem(context, 'assets/bus.png', squareIconSize, 'https://dongguk.unibus.kr/#/', true, false),
                            _buildGridItem(context, 'assets/scnoti.png', squareIconSize, 'https://web.dongguk.ac.kr/article/acdnotice/list', false, true),
                          ],
                        ),
                        SizedBox(height: spacing),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCircleItem(context, 'assets/mnoti.png', circleIconSize, 'https://web.dongguk.ac.kr/article/servicenotice/list', false, false),
                                _buildCircleItem(context, 'assets/donoti.png', circleIconSize, 'https://dorm.dongguk.ac.kr/', true, false),
                                _buildCircleItem(context, 'assets/uni.png', circleIconSize, null, false, true), // 단과대 아이콘은 새로운 화면으로 이동
                              ],
                            ),
                            SizedBox(height: spacing),
                            Container(
                              width: constraints.maxWidth * 0.85,
                              height: constraints.maxWidth * 0.6,
                              decoration: BoxDecoration(
                                color: Color(0xFFE2E2E2),
                                borderRadius: BorderRadius.circular(15),
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

  Widget _buildGridItem(BuildContext context, String assetPath, double iconSize, String? url, bool showHomeIcon, bool showHeader) {
    return GestureDetector(
      onTap: () => _openWebView(context, url, showHomeIcon, showHeader),
      child: Center(
        child: Image.asset(assetPath, width: iconSize, height: iconSize),
      ),
    );
  }

  Widget _buildCircleItem(BuildContext context, String assetPath, double iconSize, String? url, bool showHomeIcon, bool isUniIcon) {
    return GestureDetector(
      onTap: () => isUniIcon ? _openUniScreen(context) : _openWebView(context, url, showHomeIcon, url == 'https://web.dongguk.ac.kr/article/generalnotice/list' || url == 'https://web.dongguk.ac.kr/article/acdnotice/list' || url == 'https://web.dongguk.ac.kr/article/servicenotice/list' || url == 'https://dorm.dongguk.ac.kr/'),
      child: Column(
        children: [
          Image.asset(assetPath, width: iconSize, height: iconSize),
          SizedBox(height: iconSize * 0.1),
        ],
      ),
    );
  }

  void _openWebView(BuildContext context, String? url, bool showHomeIcon, bool showHeader) {
    if (url != null) {
      if (url == 'https://dorm.dongguk.ac.kr/') {
        showHeader = false;
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewScreen(url: url, showHomeIcon: showHomeIcon, showHeader: showHeader)),
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

  WebViewScreen({required this.url, required this.showHomeIcon, required this.showHeader});

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
              if (widget.showHomeIcon && (widget.url == 'https://eclass.dongguk.ac.kr/home/mainHome/Form/main' || widget.url == 'https://dongguk.unibus.kr/#/' || widget.url == 'https://dorm.dongguk.ac.kr/'))
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Image.asset('assets/home.png', width: 70, height: 70),
                  ),
                ),
              if (widget.showHeader && widget.url != 'https://dorm.dongguk.ac.kr/')
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
                          child: Image.asset('assets/dgumain.png', height: MediaQuery.of(context).size.height * 0.06),
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
