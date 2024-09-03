import 'package:application/utils/img_assets.dart';
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
                                _buildGridItem(context, ImgAssets.Engineer, squareIconSize, UniUrls.ENGINEER),
                                _buildGridItem(context, ImgAssets.book, squareIconSize, UniUrls.BOOK),
                                _buildGridItem(context, ImgAssets.nurse, squareIconSize, UniUrls.NURSING),
                                _buildGridItem(context, ImgAssets.buddhist, squareIconSize, UniUrls.BUDDHIST),
                              ],
                            ),
                            SizedBox(height: spacing * 0.3),
                            _buildWideItem(context, ImgAssets.computer, wideIconHeight, UniUrls.COMPUTER),
                            SizedBox(height: spacing * 0.6),
                            GridView.count(
                              crossAxisCount: 4,
                              crossAxisSpacing: spacing,
                              mainAxisSpacing: spacing * 1.3,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                _buildGridItem(context, ImgAssets.hotelcook, squareIconSize / 2, UniUrls.COOK),
                                _buildGridItem(context, ImgAssets.hotel, squareIconSize / 2, UniUrls.HOTEL),
                                _buildGridItem(context, ImgAssets.police, squareIconSize / 2, UniUrls.POLICE),
                                _buildGridItem(context, ImgAssets.air, squareIconSize / 2, UniUrls.AIR),
                                _buildGridItem(context, ImgAssets.eco, squareIconSize / 2, UniUrls.ECO),
                                _buildGridItem(context, ImgAssets.openmajor, squareIconSize / 2, UniUrls.OPENMAJOR),
                                _buildGridItem(context, ImgAssets.orient, squareIconSize / 2, UniUrls.ORIENT),
                                _buildGridItem(context, ImgAssets.medical, squareIconSize / 2, UniUrls.MEDICAL),
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
                right: 27,
                bottom: 100,
                child: GestureDetector(
                  onTap: () {
                    // Handle list button tap
                  },
                  child: Image.asset(ImgAssets.listbutton, width: 55, height: 55), // 리스트 버튼
                ),
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Image.asset(ImageAssets.home, width: 70, height: 70), // 홈버튼
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
