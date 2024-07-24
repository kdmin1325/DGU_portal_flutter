import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: AppBar(
            backgroundColor: Color(0xFFFFA500),
            toolbarHeight: MediaQuery.of(context).size.height * 0.1,
            title: Center(
              child: Image.asset('assets/dgumain.png', height: MediaQuery.of(context).size.height * 0.05),
            ),
          ),
        ),
        body: LayoutBuilder(
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
                      _buildGridItem(context, 'assets/noti.png', squareIconSize, 'https://web.dongguk.ac.kr/article/generalnotice/list'),
                      _buildGridItem(context, 'assets/bus.png', squareIconSize, 'https://dongguk.unibus.kr/#/'),
                      _buildGridItem(context, 'assets/scnoti.png', squareIconSize, 'https://web.dongguk.ac.kr/article/acdnotice/list'),
                    ],
                  ),
                  SizedBox(height: spacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCircleItem(context, 'assets/mnoti.png', circleIconSize, 'https://web.dongguk.ac.kr/article/servicenotice/list'),
                      _buildCircleItem(context, 'assets/donoti.png', circleIconSize, 'https://dorm.dongguk.ac.kr/'),
                      _buildCircleItem(context, 'assets/uni.png', circleIconSize, null), // 단과대 아이콘은 클릭 기능 없음
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String assetPath, double iconSize, String? url) {
    return GestureDetector(
      onTap: () => _openWebView(context, url),
      child: Center(
        child: Image.asset(assetPath, width: iconSize, height: iconSize),
      ),
    );
  }

  Widget _buildCircleItem(BuildContext context, String assetPath, double iconSize, String? url) {
    return GestureDetector(
      onTap: () => _openWebView(context, url),
      child: Image.asset(assetPath, width: iconSize, height: iconSize),
    );
  }

  void _openWebView(BuildContext context, String? url) {
    if (url != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewScreen(url: url)),
      );
    } else {
      print('URL is null');
    }
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}
