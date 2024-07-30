import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
                toolbarHeight: MediaQuery.of(context).size.height * 0.1,
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
                            _buildGridItem(context, 'assets/en_uni.png', squareIconSize, 'https://infocom.dongguk.ac.kr/', true),
                            _buildGridItem(context, 'assets/book_uni.png', squareIconSize, 'https://coreanwr.dongguk.ac.kr/', true),
                            _buildGridItem(context, 'assets/nu_uni.png', squareIconSize, 'https://nursing.dongguk.ac.kr/', true),
                            _buildGridItem(context, 'assets/bot_uni.png', squareIconSize, 'https://buddhist.dongguk.ac.kr/', true),
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
