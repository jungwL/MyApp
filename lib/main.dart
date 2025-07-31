import 'package:flutter/material.dart';
import 'package:studyex04/login.dart';
import 'homepage.dart'; // 메인 홈 화면
import 'joinUser.dart';

void main() {
  runApp(const MyApp());
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
  ThemeMode _themeMode = ThemeMode.light;

  // 다크모드 적용시 호출 되는 메서
  void toggleTheme(bool isDark) {
    // setting page value 값을 매개변수로 받음
    print(isDark);
    setState(() {
      // isDark = true면 다크모드 아니면 light모드 실행
      // _themeMode = isDark ? ThemeMode.dark : ThemeMode.light; > 삼항 연산자 구문
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
    // bool get isDarkMode => _themeMode == ThemeMode.dark; > 표현식 함수로 정의
    return _themeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Start App',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/' : (context) => const HomePage(),
        '/login' : (context) => const LoginPage(),
        '/joinUser' : (context) => const Joinuser(),
      },
    );
  }
}
