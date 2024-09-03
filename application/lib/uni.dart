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
                                _buildGridItem(context, ImgAssets.Engineer, squareIconSize, UniUrls.ENGINEER, true),
                                _buildGridItem(context, ImgAssets.book, squareIconSize, UniUrls.BOOK, true),
                                _buildGridItem(context, ImgAssets.nurse, squareIconSize, UniUrls.NURSING, true),
                                _buildGridItem(context, ImgAssets.buddhist, squareIconSize, UniUrls.BUDDHIST, true),
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
                                _buildGridItem(context, ImgAssets.hotelcook, squareIconSize / 2, UniUrls.COOK, false),
                                _buildGridItem(context, ImgAssets.hotel, squareIconSize / 2, UniUrls.HOTEL, false),
                                _buildGridItem(context, ImgAssets.police, squareIconSize / 2, UniUrls.POLICE, false),
                                _buildGridItem(context, ImgAssets.air, squareIconSize / 2, UniUrls.AIR, false),
                                _buildGridItem(context, ImgAssets.eco, squareIconSize / 2, UniUrls.ECO, false),
                                _buildGridItem(context, ImgAssets.openmajor, squareIconSize / 2, UniUrls.OPENMAJOR, false),
                                _buildGridItem(context, ImgAssets.orient, squareIconSize / 2, UniUrls.ORIENT, false),
                                _buildGridItem(context, ImgAssets.medical, squareIconSize / 2, UniUrls.MEDICAL, false),
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

  Widget _buildGridItem(BuildContext context, String assetPath, double iconSize, String? url, bool showListButton) {
    return GestureDetector(
      onTap: () {
        _openWebView(context, url, showListButton);
      },
      child: Center(
        child: Image.asset(assetPath, width: iconSize, height: iconSize),
      ),
    );
  }

  Widget _buildWideItem(BuildContext context, String assetPath, double iconHeight, String? url) {
    return GestureDetector(
      onTap: () => _openWebView(context, url, false),
      child: Center(
        child: Image.asset(assetPath, height: iconHeight),
      ),
    );
  }

  void _openWebView(BuildContext context, String? url, bool showListButton) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: url ?? '',
          showListButton: showListButton,
        ),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;
  final bool showListButton;

  WebViewScreen({required this.url, required this.showListButton});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> with SingleTickerProviderStateMixin {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _isListVisible = false;

  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  ScrollController? _scrollController;

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

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation =
    Tween<double>(begin: 0, end: 375).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  void _toggleListVisibility() {
    if (_isListVisible) {
      _animationController.reverse();
    } else {
      _scrollController = ScrollController(); // 새로운 ScrollController 생성
      _animationController.forward();
    }
    setState(() {
      _isListVisible = !_isListVisible;
    });
  }

  // 리스트 닫는 동작 수행
  Future<bool> _onWillPop() async {
    if (_isListVisible) {
      _toggleListVisibility(); // 리스트가 열려 있을 때는 리스트를 닫음
      return false;
    } else {
      return true; // 리스트가 닫혀 있을 때는 원래의 뒤로 가기 동작 수행
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // 뒤로 가기 버튼 핸들링
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(
                controller: _controller,
              ),
              if (_isLoading)
                Center(child: CircularProgressIndicator()),
              if (widget.showListButton) // showListButton이 true일 때만 리스트 버튼 및 리스트 표시
                Positioned(
                  right: 27,
                  bottom: 100 + 55, // listbutton의 높이 추가
                  child: _isListVisible
                      ? Container(
                    width: 200,
                    height: _heightAnimation.value,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ListView.builder(
                        controller: _scrollController, // 스크롤 컨트롤러 지정
                        padding: EdgeInsets.all(0), // 패딩 제거
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(_getListTileTitle(index)),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // 패딩 설정
                              ),
                              if (index < 8)
                                Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                  height: 1,
                                ), // 구분선 양옆에 공백 없이 설정
                            ],
                          );
                        },
                      ),
                    ),
                  )
                      : SizedBox.shrink(), // 리스트가 숨겨진 상태에서는 아무것도 표시하지 않음
                ),
              if (widget.showListButton)
                Positioned(
                  right: 27,
                  bottom: 100,
                  child: GestureDetector(
                    onTap: _toggleListVisibility, // 리스트 토글 기능 추가
                    child: Image.asset(ImgAssets.listbutton, width: 55, height: 55),
                  ),
                ),
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
            ],
          ),
        ),
      ),
    );
  }

  String _getListTileTitle(int index) {
    // ListTile에 표시될 텍스트를 반환하는 메서드
    List<String> titles = [
      '디자인미술학과',
      '바이오제약공학과',
      '전자정보통신공학전공',
      '에너지·전기공학전공',
      '자동차소재부품공학과',
      '인공지능전공',
      '소방방재전공',
      '조경전공',
      '정원디자인전공',
    ];
    return titles[index];
  }
}
