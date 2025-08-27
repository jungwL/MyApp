import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'screens/login/login.dart';
import 'models/user_session.dart';
import 'dart:async';
import 'screens/todayBreadList.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'widgets/footer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screens/MyPoint.dart';
import 'widgets/customAppBar.dart';
import 'widgets/customBottomNai.dart';
import 'widgets/customDrawer.dart';
import 'core/ImageSlideList.dart';
import 'screens/storeInfo/companyInfoPage.dart';
import 'core/todayBreadListImg.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _weatherDescription = '로딩 중...';
  String _temperature = '';
  String _feellike = '';
  String _humidity = '';
  String city = 'Seoul';
  String today = DateFormat('yyyy년 MM월 dd일').format(DateTime.now());

  final PageController _pageController = PageController(viewportFraction: 0.9);
  final PageController _slideController = PageController();
  int _currentBannerIndex = 0;
  late Timer _bannerTimer;

  int _currentCategoryIndex = 0;
  int _currentBreadItemIndex = 0;
  late Timer _breadItemTimer;

  late PageController _breadCategoryController;
  late PageController _breadItemController;
  // 1. 오늘의 빵 카테고리명
  final List<String> breadCategoryTitles = ['케이크', '바게트', '빵', '샌드위치'];

// 2. 빵 데이터 직접 변수로 선언 (필요하면 파일에서 불러도 됨)
  final List<List<Map<String, String>>> allBreadLists = [
    cakeList,
    baguetteList,
    breadList,
    sandList,
  ];

  // 1. 변수 추가: 현재 슬라이드 인덱스와 타이머
  int _currentSlideIndex = 0;
  late Timer _slideTimer;



  @override
  void initState() {
    super.initState();
    _startSlideAutoPlay();
    _startAutoSlide();
    _breadCategoryController = PageController();
    _breadItemController = PageController();

    _startBreadItemAutoSlide();
    _fetchWeather();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_showCookieConsentBottomSheet();
    });
  }

  // 3. dispose에서 타이머 정리
  @override
  void dispose() {
    _pageController.dispose();
    _slideTimer?.cancel();
    _slideController.dispose();
    _bannerTimer?.cancel();
    _breadItemTimer?.cancel();
    super.dispose();
  }

  //최상단 이미지 영역 자동 슬라이드 함수
  void _startSlideAutoPlay() {
    _slideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_slideController.hasClients) {
        _currentSlideIndex = (_currentSlideIndex + 1) % imagePaths.length;
        _slideController.animateToPage(
          _currentSlideIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  //배너 영역 자동 슬라이드
  void _startAutoSlide() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        int nextPage = (_currentBannerIndex + 1) % bannerImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  //오늘의 빵 자동 슬라이드
  void _startBreadItemAutoSlide() {
    _breadItemTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_breadItemController.hasClients) {
        final currentBreadList = allBreadLists[_currentCategoryIndex];
        int nextPage = (_currentBreadItemIndex + 1) % currentBreadList.length;
        _breadItemController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentBreadItemIndex = nextPage;
        });
      }
    });
  }



  // openweather에서 제공하는 API로 날씨 정보 가져오는 메서드
  Future<void> _fetchWeather() async {
    // 비동기 작업을 수행하고 아무 값도 반환하지 않는다. async키워드 ==> await 사용가능하게
    var apiKey = dotenv.env['OPENWEATHERMAP_KEY']; //발급받은 API키를 지정 (암호화 필수)
    //var apiKey = '';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=kr'; //날씨 api요청 URL

    try {
      final response = await http.get(Uri.parse(url)); //위 URL로 GET요청을 보냄
      //디버깅용 로그 출력 > 배포전에는 무시됨
      if (kDebugMode) {
        debugPrint('응답 코드: ${response.statusCode}'); // 응답 코드 출력
      }

      if (response.statusCode == 200) {
        //HTTP 응답코드가 200일 경우
        final data = json.decode(response.body); //JSON 형식의 응답본문을 Map 형태로 디코딩한다.
        setState(() {
          //상태를 화면에 반영
          _weatherDescription =
              data['weather'][0]['description']; // weather 키값 을 이용해 날씨 설명 온도를 가져와 상태 변수에 저장 ,날씨 정보는 리스트 형태
          _temperature =
              '${data['main']['temp'].toInt()}°C'; //main키 값을 이용해 temp 값을 가져온다, toInt() 소수점 이하를 버리고 정수형태
          _feellike = '${data['main']['feels_like']}°C'; //체감온도
          _humidity = '${data['main']['humidity']}%'; //습도 정보
        });
        print(_feellike);
        print(_humidity);
      } else {
        setState(() {
          _weatherDescription = '날씨 정보를 불러올 수 없습니다';
          _temperature = '';
        });
      }
    } catch (e) {
      setState(() {
        _weatherDescription = '네트워크 오류';
        _temperature = '';
      });
    }
  }

  /*void _showCookieConsentBottomSheet() {
    showModalBottomSheet(
      //flutter기본함수 중 하단 모달 팝업함수
      context: context,
      //현재 위젯트리에서 팝업을 띄울 위치를 지정
      isDismissible: false,
      //사용자가 화면 팝업창 외 터치해도 팝업이 닫히지 않도록 설정
      enableDrag: false,
      //드래그 방지 , 사용자가 아래로 그래그 해서 팝업을 닫히지 않도록 설정
      shape: const RoundedRectangleBorder(
        //팝업상단 모서리 둥글게 : 상단만 20픽셀로 둥글게 설정
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        //팝업안에 들어갈 내용을 정의하는 영역
        return Padding(
          padding: const EdgeInsets.all(24), // 전체 내부 여백 24픽셀 적용
          child: Column(
            //세로의 위젯을 배치하는 위젯
            mainAxisSize: MainAxisSize.min, //팝업 높이를 자식 위젯 높이게 맞게 최소로 설정
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              const Text(
                // 제목 텍스트 : 아래의 css적용된 굵은 텍스트가 맨위에 표시
                '쿠키 수집 동의',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12), //간격추가 : 제목과 안내문 사이에 12픽셀 띄움
              const Text(
                //설명텍스트 : 쿠키 수집 목적을 사용자에게 설명한다.
                '당사는 서비스 품질 향상을 위해 쿠키를 수집합니다. 이에 동의하시겠습니까?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20), //간격추가 : 버튼과 설명텍스트 사이 20픽셀 띄움
              Row(
                // 가로로 두 개의 버튼 배치
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        print('쿠키 수집 비동의');
                      },
                      child: const Text(
                        '비동의',
                        style: TextStyle(color: Colors.brown),
                      ),
                    ),
                  ),
                  SizedBox(width: 12), // 버튼 간 간격
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        print('쿠키 수집 동의');
                      },
                      child: const Text(
                        '동의',
                        style: TextStyle(color: Colors.brown),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }*/

  Widget _buildHomePage() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _pageViewBanner(),
            _todayScheduleCard(),
            _todayBreadSlide(),
            _companyinfo(),
            _notificationCard(),
            _statsCard(),
            _weatherCard(),
            _outSideLinkCard(),
            //footer추가
            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }

  //상단 슬라이드위젯
  Widget _mainSlide() {
    return SizedBox(
      height: MediaQuery.of(context).size.height, // 전체 화면 높이
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _slideController,
            physics: const PageScrollPhysics(), //이미지 수동으로 넘길수 있게
            itemCount: imagePaths.length,
            onPageChanged: (index) {
              setState(() {
                _currentSlideIndex = index;
              });
            },
            itemBuilder: (context, index) {
              if (Theme.of(context).brightness == Brightness.light) {
                return Image.asset(
                  imagePaths[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              } else if (Theme.of(context).brightness == Brightness.dark) {
                return Image.asset(
                  imagePathsDark[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              }
              // 혹시 대비책으로 빈 위젯 리턴
              return SizedBox.shrink();
            },
          ),
          // 인디케이터 위치 조절
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _slideController,
                count: imagePaths.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  type: WormType.thin,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //배너 영역 위젯
  Widget _pageViewBanner() => Column(
    children: [
      AspectRatio(
        aspectRatio: 16 / 7, // 가로:세로 비율
        child: PageView.builder(
          controller: _pageController,
          physics: const PageScrollPhysics(),
          itemCount: bannerImages.length,
          onPageChanged: (index) {
            setState(() {
              _currentBannerIndex = index;
            });
          },
          itemBuilder: (context, index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(bannerImages[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 8),
      SmoothPageIndicator(
        controller: _pageController,
        count: bannerImages.length,
        effect: WormEffect(
          dotHeight: 8,
          dotWidth: 8,
          type: WormType.thin,
          // WormStyle.thin 스타일 적용
          activeDotColor: Colors.brown,
          dotColor: Colors.grey.shade400,
        ),
      ),
    ],
  );

  //오늘의 빵보러가기 위젯카드
  Widget _todayScheduleCard() => Card(
    color: Theme.of(context).cardColor,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: const Icon(
        FontAwesomeIcons.breadSlice,
        color: Color(0xFFD2691E),
      ),
      title: const Text('오늘의 빵 전체 보러가기'),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TodayBreadList()),
          );
        },
      ),
    ),
  );

  //케이크 이미지 슬라이드
  Widget _todayBreadSlide() {
    return SizedBox(
      height: 160, //슬라이드 사이즈
      child: PageView.builder(
        controller: _breadCategoryController,
        itemCount: allBreadLists.length,
        onPageChanged: (categoryIndex) {
          setState(() {
            _currentCategoryIndex = categoryIndex;
            _currentBreadItemIndex = 0;
          });
          _breadItemController.jumpToPage(0); // 내부 슬라이드 페이지 초기화
        },
        itemBuilder: (context, categoryIndex) {
          final breadList = allBreadLists[categoryIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _breadItemController,
                  itemCount: breadList.length,
                  onPageChanged: (breadIndex) {
                    setState(() {
                      _currentBreadItemIndex = breadIndex;
                    });
                  },
                  itemBuilder: (context, breadIndex) {
                    final bread = breadList[breadIndex];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              bread['image']!,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.5),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bread['name'] ?? '',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 6)
                                        ]),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    bread['price'] ?? '',
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: SmoothPageIndicator(
                  controller: _breadItemController,
                  count: breadList.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.brown,
                    dotColor: Colors.brown.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  //매장정보 위젯카드
  Widget _companyinfo() => Card(
    color: Theme.of(context).cardColor,
    margin: const EdgeInsets.symmetric(vertical: 8), //위 아래 마진 8
    child: ListTile(
      leading: const Icon(
        Icons.store,
        color: Colors.blueGrey,
      ),
      title: const Text('매장 정보 보러가기'),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> CompanyMapPage()));
        },
      ),
    ),
  );
  //공지사항 위젯 카드
  Widget _notificationCard() => Card(
    color: Theme.of(context).cardColor,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: const Icon(Icons.notifications_active, color: Colors.deepOrange),
      title: const Text('새로운 알림이 있습니다'),
      subtitle: const Text('공지사항 또는 메시지를 확인해보세요'),
      onTap: () {
        //추후 공지사항 페이지 입력...
      },
    ),
  );

  //포인트 오늘날짜 위젯카드
  Widget _statsCard() => Card(
    color: Theme.of(context).cardColor,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Icon(Icons.star, color: Colors.yellow, size: 32),
              const SizedBox(height: 4),
              Text(
                UserSession.isLoggedIn
                    ? '포인트\n${UserSession.currentUser?.userPoint ?? 0} P'
                    : '로그인 하세요',
                textAlign: TextAlign.center,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (UserSession.isLoggedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyPointPage()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }
                  });
                },
                icon: FaIcon(
                  FontAwesomeIcons.barcode,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.calendar_today, color: Colors.teal, size: 32),
              const SizedBox(height: 4),
              Text('오늘 날짜\n$today', textAlign: TextAlign.center),
            ],
          ),
        ],
      ),
    ),
  );

  //오늘 날씨 위젯카드
  Widget _weatherCard() => Card(
    color: Theme.of(context).cardColor,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: const Icon(Icons.wb_sunny, color: Colors.orangeAccent, size: 40),
      title: Text('서울시 현재 날씨'),
      subtitle: Text(
        '$_weatherDescription, 온도 : $_temperature 습도 : $_humidity',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: _fetchWeather,
      ),
    ),
  );
  //신규 위젯카드
  Widget _outSideLinkCard() => Card(
    color: Theme.of(context).cardColor,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        TextButton(
            onPressed: () {
              launchUrl(Uri.parse('https://www.paris.co.kr/'));
            }, 
            child: Text('타 사이트 바로가기')
        ),
      ],
    )
  );

  // UI 위젯
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(),
      endDrawer: Customdrawer(),
      body: CustomScrollView(
          slivers: [
          SliverToBoxAdapter(child: _mainSlide()),
          SliverToBoxAdapter(child: _buildHomePage()),
          SliverToBoxAdapter(child: Footer(),)
        ],
      ),
      bottomNavigationBar: Custombottomnai(),
    );
  }
}
