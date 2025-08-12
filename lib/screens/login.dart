import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/User.dart';
import '../models/user_session.dart';
import 'mypage.dart';
import '../homepage.dart';
import 'termspage.dart';

class LoginPage extends StatefulWidget {
  final String? redirectTo;
  const LoginPage({super.key, this.redirectTo});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeIn;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  //로그인 API 호출
  Future<void> _login() async {
    final String url = 'http://localhost:8080/api/login';
    try {
      final response = await http.post( // post방식 응답 요청
        Uri.parse(url), //서버와 연동
        headers: {'Content-Type': 'application/json'},
        body: json.encode({ //json 인코딩 진행
          'userId': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );
      print('http 응답코드 : ${response.statusCode}');
      //응답코드가 200일경우
      if (response.statusCode == 200) {
        final user = User.fromJson(json.decode(response.body)); //회원DB를 통해 받은 데이터 값 저장
        UserSession.login(user); // 로그인 상태 유지 처리
        print(user.userName);
        final targetPage = widget.redirectTo == 'mypage'
            ? const MyPage() //마이페이지 선택 후 로그인했을 경우 마이페이지로 이동
            : const HomePage(); //아닐경우 홈페이지로 이동

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => targetPage),
        );
      } else {
        _showErrorSnackBar('이메일 또는 비밀번호가 틀렸습니다');
      }
    } catch (e) {
      _showErrorSnackBar('서버 오류: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('본인 인증',),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        iconTheme: const IconThemeData(),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '이메일과 비밀번호를 입력해 로그인하세요.',
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    cursorColor: Colors.brown,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white // 다크모드일 때 연한 흰색
                          : Colors.black,  // 라이트모드일 때 완전 흰색,
                    ),
                    decoration: InputDecoration(
                      hintText: 'example@example.com',
                      hintStyle: TextStyle(
                        color: Colors.brown.withOpacity(0.4),
                        fontStyle: FontStyle.italic
                      ),
                      labelText: '이메일',
                      labelStyle: TextStyle(
                        color: Colors.brown
                      ),
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white10 // 다크모드일 때 연한 흰색
                          : Colors.white,  // 라이트모드일 때 완전 흰색,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.brown,
                          width: 2.0,
                        )
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력해주세요';
                      } else if (!_isValidEmail(value)) {
                        return '올바른 이메일 형식을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      labelStyle: TextStyle(
                        color: Colors.brown,
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white10 // 다크모드일 때 연한 흰색
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.brown,
                          width: 2.0
                        )
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      child: const Text(
                        '로그인',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/termspage');
                      },
                      label: Text(
                        '회원가입하러 가기',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                          fontSize: 16,
                        ),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_right, color: Colors.brown,),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
