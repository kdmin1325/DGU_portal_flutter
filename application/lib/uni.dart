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
                backgroundColor: Color(0xFFF89805), // 헤더
                toolbarHeight: MediaQuery.of(context).size.height * 0.10,
                title: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Image.asset(ImageAssets.dgumain, height: MediaQuery.of(context).size.height * 0.06), // 로고
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

                  // 단과대 화면 아이콘
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
                                _buildGridItem(context, ImgAssets.Engineer, squareIconSize, UniUrls.ENGINEER, "공과대학", false, constraints),
                                _buildGridItem(context, ImgAssets.book, squareIconSize, UniUrls.BOOK, "인문대학", false, constraints),
                                _buildGridItem(context, ImgAssets.nurse, squareIconSize, UniUrls.NURSING, "간호대학", false, constraints),
                                _buildGridItem(context, ImgAssets.buddhist, squareIconSize, UniUrls.BUDDHIST, "불교대학", false, constraints),
                              ],
                            ),
                            SizedBox(height: spacing * 0.3),
                            _buildWideItem(context, ImgAssets.computer, wideIconHeight, UniUrls.COMPUTER, true, constraints),
                            SizedBox(height: spacing * 0.6),
                            GridView.count(
                              crossAxisCount: 4,
                              crossAxisSpacing: spacing,
                              mainAxisSpacing: spacing * 1.3,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                _buildGridItem(context, ImgAssets.hotelcook, squareIconSize / 2, UniUrls.COOK, "", true, constraints), // 호텔조리
                                _buildGridItem(context, ImgAssets.hotel, squareIconSize / 2, UniUrls.HOTEL, "", true, constraints), // 호텔경영
                                _buildGridItem(context, ImgAssets.police, squareIconSize / 2, UniUrls.POLICE, "", true, constraints), // 행정경찰
                                _buildGridItem(context, ImgAssets.air, squareIconSize / 2, UniUrls.AIR, "", true, constraints), // 항공서비스
                                _buildGridItem(context, ImgAssets.eco, squareIconSize / 2, UniUrls.ECO, "", true, constraints), // 융경
                                _buildGridItem(context, ImgAssets.openmajor, squareIconSize / 2, UniUrls.OPENMAJOR, "", true, constraints), // 자전
                                _buildGridItem(context, ImgAssets.orient, squareIconSize / 2, UniUrls.ORIENT, "", true, constraints), // 한의학
                                _buildGridItem(context, ImgAssets.medical, squareIconSize / 2, UniUrls.MEDICAL, "", true, constraints), // 의예과
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

  Widget _buildGridItem(BuildContext context, String assetPath, double iconSize, String? url, String listTitle, bool showHomeButton, BoxConstraints constraints) {
    double adjustedIconSize = constraints.maxWidth * 0.4;
    return GestureDetector(
      onTap: () {
        _openWebView(context, url, listTitle, showHomeButton);
      },
      child: Center(
        child: Image.asset(assetPath, width: adjustedIconSize, height: adjustedIconSize),
      ),
    );
  }

  Widget _buildWideItem(BuildContext context, String assetPath, double iconHeight, String? url, bool showHomeButton, BoxConstraints constraints) {
    double adjustedIconHeight = constraints.maxWidth * 0.2;
    return GestureDetector(
      onTap: () => _openWebView(context, url, "", showHomeButton),
      child: Center(
        child: Image.asset(assetPath, height: adjustedIconHeight),
      ),
    );
  }

  // 웹뷰 함수
  void _openWebView(BuildContext context, String? url, String listTitle, bool showHomeButton) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: url ?? '',
          listTitle: listTitle,
          showHomeButton: showHomeButton,
        ),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;
  final String listTitle;
  final bool showHomeButton;

  WebViewScreen({required this.url, required this.listTitle, required this.showHomeButton});

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
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
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
      )
      ..loadRequest(Uri.parse(widget.url));

    double listHeight = _calculateListHeight(widget.listTitle);

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation =
    Tween<double>(begin: 0, end: listHeight).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  double _calculateListHeight(String listTitle) {
    switch (listTitle) {
      case '간호대학':
        return 230; // 간호대학 리스트 높이
      case '불교대학':
        return 230; // 불교대학 리스트 높이
      default:
        return 375; // 기본 리스트 높이
    }
  }

  void _toggleListVisibility() {
    if (_isListVisible) {
      _animationController.reverse();
    } else {
      _scrollController = ScrollController();
      _animationController.forward();
    }
    setState(() {
      _isListVisible = !_isListVisible;
    });
  }

  Future<bool> _onWillPop() async {
    if (_isListVisible) {
      _toggleListVisibility();
      return false;
    } else if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    } else {
      return true;
    }
  }

  void _onListItemTap(BuildContext context, String title) {
    if (title == '홈화면') {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      String? url;
      switch (widget.listTitle) {
        case '공과대학':
          url = _getEngineeringUrl(title);
          break;
        case '인문대학':
          url = _getHumanitiesUrl(title);
          break;
        case '간호대학':
          url = _getNurseUrl(title);
          break;
        case '불교대학':
          url = _getBuddhistUrl(title);
          break;
      }
      if (url != null) {
        _controller.loadRequest(Uri.parse(url));
      }
    }
  }

  String? _getEngineeringUrl(String title) {
    switch (title) {
      case '젼자정보통신공학과':
        return Engineering.infocom;
      case '에너지·전기공학전공':
        return Engineering.energy;
      case '스마트안전공학부':
        return Engineering.safety;
      case '조경·정원디자인학과':
        return Engineering.land;
      case '바이오제약공학과':
        return Engineering.biopharm;
      case '자동차부품공학과':
        return Engineering.smartfuturecar;
      case '고고미술사학과':
        return Engineering.arthistory;
      case '디자인미술학과':
        return Engineering.art;
      case '기계시스템공학전공':
        return Engineering.mecha;
      case '빅데이터응용통계학전공':
        return Engineering.infostat;
      default:
        return null;
    }
  }

  String? _getHumanitiesUrl(String title) {
    switch (title) {
      case '국어국문학과':
        return Humanities.coreanwr;
      case '아동청소년교육학과':
        return Humanities.budchild;
      case '유아교육과':
        return Humanities.babyhood;
      case '가정교육과':
        return Humanities.homeedu;
      case '사회복지학과':
        return Humanities.welfare;
      case '영어영문학전공':
        return Humanities.engl;
      case '국사학과':
        return Humanities.khistory;
      case '수학교육과':
        return Humanities.mathedu;
      case '중어중문학전공':
        return Humanities.china;
      case '일어일문학전공':
        return Humanities.japanese;
      default:
        return null;
    }
  }

  String? _getNurseUrl(String title) {
    switch (title) {
      case '간호학과':
        return Nurse.nursing;
      case '보건의료정보학과':
        return Nurse.healthinfo;
      case '뷰티메디컬학과':
        return Nurse.beautymedi;
      case '스포츠건강과학부':
        return Nurse.sports;
      default:
        return null;
    }
  }

  String? _getBuddhistUrl(String title) {
    switch (title) {
      case '불교학전공':
        return Buddhist.buddhist;
      case '불교문화컨텐츠전공':
        return Buddhist.bcc;
      case '명상심리상담학과':
        return Buddhist.mpc;
      case '한국음악과':
        return Buddhist.kormusic;
      default:
        return null;
    }
  }

  List<String> _getListItems() {
    switch (widget.listTitle) {
      case '공과대학':
        return [
          '홈화면',
          '젼자정보통신공학과',
          '에너지·전기공학전공',
          '스마트안전공학부',
          '조경·정원디자인학과',
          '바이오제약공학과',
          '자동차부품공학과',
          '고고미술사학과',
          '디자인미술학과',
          '기계시스템공학전공',
          '빅데이터응용통계학전공',
        ];
      case '인문대학':
        return [
          '홈화면',
          '국어국문학과',
          '아동청소년교육학과',
          '유아교육과',
          '가정교육과',
          '사회복지학과',
          '영어영문학전공',
          '국사학과',
          '수학교육과',
          '중어중문학전공',
          '일어일문학전공',
        ];
      case '간호대학':
        return [
          '홈화면',
          '간호학과',
          '보건의료정보학과',
          '뷰티메디컬학과',
          '스포츠건강과학부'
        ];
      case '불교대학':
        return [
          '홈화면',
          '불교학전공',
          '불교문화컨텐츠전공',
          '명상심리상담학과',
          '한국음악과'
        ];
      default:
        return [];
    }
  }

  // 웹뷰 리스트
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_isLoading) Center(child: CircularProgressIndicator()),
              if (widget.listTitle.isNotEmpty)
                Positioned(
                  right: 20,
                  bottom: 75,
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
                        controller: _scrollController,
                        padding: EdgeInsets.all(0),
                        itemCount: _getListItems().length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(_getListItems()[index]),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                                onTap: () => _onListItemTap(context, _getListItems()[index]),
                              ),
                              if (index < _getListItems().length - 1)
                                Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                  height: 1,
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                      : SizedBox.shrink(),
                ),
              if (widget.listTitle.isNotEmpty)
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: GestureDetector(
                    onTap: _toggleListVisibility,
                    child: Image.asset(ImgAssets.listbutton, width: 55, height: 55),
                  ),
                ),
              if (widget.showHomeButton && widget.listTitle.isEmpty)
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Image.asset('assets/home.png', width: 55, height: 55),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
