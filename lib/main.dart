import 'package:flutter/material.dart';
import 'package:studyex04/screens/login/login.dart';
import 'package:easy_localization/easy_localization.dart'; //다국어지원 라이브러리
import 'homepage.dart'; // 메인 홈 화면
import 'screens/join/termspage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ko')],//지원하는 언어 리스트
      path: '/translations', // json 파일 위치
      fallbackLocale: const Locale('ko'), //기본언어
      child: const MyApp(), // 실제 앱 위젯
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // marterial.dart 안에 enum타입 클래스 테마모드를 밝은 테마로 초기화 앱 구동시 라이트 모드로 동작하도록 설정
  ThemeMode _themeMode = ThemeMode.light; //테마모드 초기값(light모드)

  // 다크모드 적용시 호출 되는 메서드
  void toggleTheme(bool isDark) {
    // setting page value 값을 매개변수로 받음
    print('다크 모드 여부 값 : $isDark');
    setState(() {
      // isDark = true면 다크모드 아니면 light모드 실행
      if (isDark) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  bool get isDarkMode {
    // 현재 테마가 다크모드인지 확인 할 수 있는 읽기 전용 속성
    // _themeMode와 같이 ThemeMode.dark 이면 true 리턴
    return _themeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //디버그 띠 제거
      title: 'Seoul Baguette', //앱 타이틀
      //테마모드 색상 속성값 적용
      theme: ThemeData.light(useMaterial3: true,).copyWith(
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white70,
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.brown
        ),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[800],
        textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white
        ),
      ),
      themeMode: _themeMode,
      //페이지라우팅 초기 기본 값 설정
      initialRoute: '/',
      routes: {
        '/' : (context) => const HomePage(), //홈페이지로 이동
        '/login' : (context) => const LoginPage(), //로그인 페이지로 이동
        '/termspage' : (context) => const TermsPage(), //회원가입 전 약관동의 페이지 이동
      },
      //언어 선택 속성
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
