import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/urls.dart';

class UniScreen extends StatelessWidget {
  const UniScreen({Key? key}) : super(key: key);

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
                  double squareIconSize = constraints.maxWidth * squareIconSizeFactor;
                  double spacing = constraints.maxWidth * 0.05;
                  double wideIconHeight = squareIconSize * 0.5;

                  return Padding(
                    padding: EdgeInsets.all(spacing),
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: spacing,
                              mainAxisSpacing: spacing * 0.3,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                _buildGridItem(context, 'assets/en_uni.png', squareIconSize, Urls.ENGINEER),
                                _buildGridItem(context, 'assets/book_uni.png', squareIconSize, Urls.BOOK),
                                _buildGridItem(context, 'assets/nu_uni.png', squareIconSize, Urls.NURSING),
                                _buildGridItem(context, 'assets/bot_uni.png', squareIconSize, Urls.BUDDHIST),
                              ],
                            ),
                            SizedBox(height: spacing * 0.3),
                            _buildWideItem(context, 'assets/computer.png', wideIconHeight, Urls.COMPUTER),
                            SizedBox(height: spacing * 0.6),
                            GridView.count(
                              crossAxisCount: 4,
                              crossAxisSpacing: spacing,
                              mainAxisSpacing: spacing * 1.3,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                _buildGridItem(context, 'assets/hotel_cook.png', squareIconSize / 2, Urls.COOK),
                                _buildGridItem(context, 'assets/hotel_hotel.png', squareIconSize / 2, Urls.HOTEL),
                                _buildGridItem(context, 'assets/pol.png', squareIconSize / 2, Urls.POLICE),
                                _buildGridItem(context, 'assets/air.png', squareIconSize / 2, Urls.AIR),
                                _buildGridItem(context, 'assets/eco.png', squareIconSize / 2, Urls.ECO),
                                _buildGridItem(context, 'assets/frame.png', squareIconSize / 2, Urls.OPENMAJOR),
                                _buildGridItem(context, 'assets/k_medi.png', squareIconSize / 2, Urls.ORIENT),
                                _buildGridItem(context, 'assets/medi.png', squareIconSize / 2, Urls.MEDICAL),
                              ],
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

  Widget _buildGridItem(BuildContext context, String assetPath, double iconSize, String? url) {
    return GestureDetector(
      onTap: () => _openWebView(context, url),
      child: Center(
        child: Image.asset(assetPath, width: iconSize, height: iconSize),
      ),
    );
  }

  Widget _buildWideItem(BuildContext context, String assetPath, double iconHeight, String? url) {
    return GestureDetector(
      onTap: () => _openWebView(context, url),
      child: Center(
        child: Image.asset(assetPath, height: iconHeight),
      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
