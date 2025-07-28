import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'login.dart';
import 'mypage.dart';
import 'setting.dart';
import 'user_session.dart';
import 'dart:async';
import 'todayBreadList.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'footer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'MyPoint.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _weatherDescription = '로딩 중...';
  String _temperature = '';
  String _feellike = '';
  String _humidity = '';
  String city = 'Seoul';
  String today = DateFormat('yyyy년 MM월 dd일').format(DateTime.now());

  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentBannerIndex = 0;
  late Timer _bannerTimer;

  final List<String> _bannerImages = [
  /*  'assets/image/banner1.jpg',
    'assets/image/banner2.jpg',
    'assets/image/banner3.jpg',
  */];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    _fetchWeather();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCookieConsentBottomSheet();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bannerTimer.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients) {
        int nextPage = (_currentBannerIndex + 1) % _bannerImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // openweather에서 제공하는 API로 날씨 정보 가져오는 메서드
  Future<void> _fetchWeather() async {
    // 비동기 작업을 수행하고 아무 값도 반환하지 않는다. async키워드 ==> await 사용가능하게
    var apiKey = dotenv.env['OPENWEATHERMAP_KEY']; //발급받은 API키를 지정 (암호화 필수)
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=kr'; //날씨 api요청 URL

    try {
      final response = await http.get(Uri.parse(url)); //위 URL로 GET요청을 보냄
      //디버깅용 로그 출력 > 배포전에는 무시됨
      if (kDebugMode) {
        debugPrint(url);
        debugPrint('응답 코드: ${response.statusCode}'); // 응답 코드 출력
        debugPrint('응답 바디: ${response.body}'); // 응답 바디 출력
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

  void _showCookieConsentBottomSheet() {
    showModalBottomSheet(
      //flutter기본함수 중 하단 모달 팝업함수
      context: context, //현재 위젯트리에서 팝업을 띄울 위치를 지정
      isDismissible: false, //사용자가 화면 팝업창 외 터치해도 팝업이 닫히지 않도록 설정
      enableDrag: false, //드래그 방지 , 사용자가 아래로 그래그 해서 팝업을 닫히지 않도록 설정
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
                //가로로 두개의 버튼 배치를 위해 ROW사용
                children: [
                  Expanded(
                    //남은 공간을 균등하게 분할해서 버튼 2개를 같은 넓이로 만듬
                    child: OutlinedButton(
                      // 테두리만 있는 비동의 버튼
                      onPressed: () {
                        //눌렀을때 팝업 닫고 콘솔에 비동의 로그 출력
                        Navigator.pop(context);
                        print('쿠키 수집 비동의');
                      },
                      child: const Text('비동의'),
                    ),
                  ),
                  const SizedBox(width: 12), //두 버튼 사이 간격 12픽셀
                  Expanded(
                    child: ElevatedButton(
                      //강조된 버튼
                      onPressed: () {
                        //눌렀을때 팝업 닫고 콘솔에 동의 로그 출력
                        Navigator.pop(context);
                        print('쿠키 수집 동의');
                      },
                      child: const Text('동의'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return const Setting();
      default:
        return const SizedBox();
    }
  }

  Widget _buildHomePage() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    '/images/Logo1.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _todayScheduleCard(),
            _notificationCard(),
            _statsCard(),
            _weatherCard(),
            _pageViewBanner(),

            //footer추가
            const SizedBox(height: 24),
            const AppFooter(), // footer.dart에 정의된 위젯
          ],
        ),
      ),
    );
  }

  Widget _todayScheduleCard() => Card(
    color: Colors.orange.shade50,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: const Icon(FontAwesomeIcons.breadSlice, color: Color(0xFFD2691E)),
      title: const Text('오늘의 빵 보러가기'),
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

  Widget _notificationCard() => Card(
    color: Colors.orange.shade50,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: const Icon(Icons.notifications_active, color: Colors.deepOrange),
      title: const Text('새로운 알림이 있습니다'),
      subtitle: const Text('공지사항 또는 메시지를 확인해보세요'),
      onTap: () {},
    ),
  );

  Widget _statsCard() => Card(
    color: Colors.orange.shade50,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Icon(Icons.star, color: Colors.yellow ,size: 32),
              const SizedBox(height: 4),
              Text(
                UserSession.isLoggedIn
                    ? '포인트\n${UserSession.currentUser?.userPoint ?? 0} P'
                    : '로그인 하세요',
                textAlign: TextAlign.center,
              )

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

  Widget _weatherCard() => Card(
    color: Colors.orange.shade50,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: const Icon(Icons.wb_sunny, color: Colors.orangeAccent, size: 40),
      title: Text('서울시 현재 날씨'),
      subtitle: Text(
        '$_weatherDescription, $_temperature 체감온도 : $_feellike 습도 : $_humidity',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: _fetchWeather,
      ),
    ),
  );

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blueAccent,
            child: Icon(icon, size: 28, color: Colors.blueAccent),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _pageViewBanner() => Column(
    children: [
      SizedBox(
        height: 160,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _bannerImages.length,
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
                image: AssetImage(_bannerImages[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_bannerImages.length, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentBannerIndex == index
                  ? Colors.blueAccent
                  : Colors.grey[400],
            ),
          );
        }),
      ),
    ],
  );

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  //마이페이지 이동 화면전환 navigator 호출 메서드
  void _goToMyPage(BuildContext context) {
    Navigator.pop(context);
    if (UserSession.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MyPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(redirectTo: 'mypage'),
        ),
      );
    }
  }

  void _logout(BuildContext context) {
    UserSession.logout();
    setState(() => _selectedIndex = 0);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserSession.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('메인'),
        centerTitle: true,
        backgroundColor: Colors.orange.shade200,
        elevation: 4, // 그림자
        leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_rounded)
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserSession.isLoggedIn
                ? UserAccountsDrawerHeader(
              accountName: Text(UserSession.currentUser?.userName ?? '사용자'),
              accountEmail: Text(UserSession.currentUser?.userId ?? '이메일'),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
              ),
              decoration: const BoxDecoration(color: Colors.brown),
            )
                : DrawerHeader(
              decoration: const BoxDecoration(color: Colors.brown),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '로그인이 필요합니다',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context , '/login'
                      ); // 로그인 화면으로 이동
                    },
                    child: const Text('로그인하러 가기'),
                  ),
                ],
              ),
            ),
            if (UserSession.isLoggedIn) ...[
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('마이페이지'),
                onTap: () => _goToMyPage(context),
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('마이 포인트'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyPointPage()));

                },
              ),
            ],
            ListTile(
              leading: const Icon(FontAwesomeIcons.breadSlice),
              title: const Text('오늘의 빵'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TodayBreadList()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text('공지사항'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('설정'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
          ],
        ),
      ),


      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange.shade200,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 13,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
