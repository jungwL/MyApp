import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/user_session.dart';
import '../../homepage.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({super.key});

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  bool _passwordError = false;

  // 비밀번호 유효성검사 로직
  bool _isPasswordValid(String password) {
    if (password.length < 8) return false;
    final specialCharPattern = RegExp(r'[!@#]');
    if (!specialCharPattern.hasMatch(password)) {
      return false;
    }
    return true;
  }

  Future<void> _changePassword() async {
    final String url = 'http://localhost:8080/api/changePw';
    try {
      final response = await http.post(
        Uri.parse(url), //윕 주소 형태로 변환
        headers: {'Content-Type': 'application/json'}, // 보내는 정보 : JSON데이터
        body: json.encode({ // Dart 데이터형식을 Json 형식으로 변환
          'phoneNumber': UserSession.currentUser?.phoneNumber, //로그인 유저 비밀번호 값
          'newPassword': _passwordController.text.trim(), // 입력한 신규 패스워드 값
        }),
      );

      print('비밀번호 변경 HTTP 요청 코드 : ${response.statusCode}');

      if (response.statusCode == 200) { // 요청이 정상일경우
        _showSnackBar('비밀번호가 변경되었습니다', Colors.green);
        UserSession.logout(); //로그아웃
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), //메인으로 이동 
        );
      } else if(response.statusCode == 409){
        _showSnackBar('새로운 비밀번호를 입력해 주세요', Colors.red); // 기등록된 비밀번호와 동일한경우
      } else {
        _showSnackBar('서버오류 발생 : ${response.statusCode}', Colors.red);
      }
    } catch (e) {
      print('네트워크 오류 발생 : $e');
      _showSnackBar('네트워크 오류 발생: $e', Colors.red);
    }
  }

  // 하단 스낵바 제어 메서드
  void _showSnackBar(String message, Color color) { //메시지와 색상을 변수로 받는다
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating, //최하단 띄우기
        margin: const EdgeInsets.all(16), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2), // 팝업 초
      ),
    );
  }

  //초기화
  @override
  void dispose() {
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color borderColor = _passwordError ? Colors.red : Colors.brown;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('비밀번호 변경'),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '새 비밀번호를 입력해주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '비밀번호는 8자 이상이며 !, @, # 중 하나 이상을 포함해야 합니다.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _passwordController,// 사용자가 입력한 텍스트를 제어하고 가져오는 컨트롤러
              obscureText: true,// 입력된 글자를 숨겨주는 기능 (비밀번호 입력 시 필수)
              decoration: InputDecoration(// 텍스트 필드가 비어있을 때 표시되는 레이블 텍스트
                labelText: '새 비밀번호',
                labelStyle: TextStyle(color: borderColor),// labelText의 스타일을 지정
                prefixIcon: Icon(Icons.lock_outline),// 텍스트 필드 왼쪽에 표시되는 아이콘
                filled: true,// 텍스트 필드의 배경을 채울지 여부 (true로 설정하면 fillColor가 적용됨)
                fillColor: Colors.white,// 텍스트 필드 배경의 색상
                enabledBorder: OutlineInputBorder(// 텍스트 필드가 활성화되었지만 포커스되지 않았을 때의 테두리 스타일
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide( // 테두리의 선 스타일을 지정
                        color: borderColor,
                        width: 2.0
                    )
                ),
                focusedBorder: OutlineInputBorder(// 텍스트 필드에 포커스가 맞춰졌을 때의 테두리 스타일
                  borderRadius: BorderRadius.circular(12),// 테두리의 모서리를 둥글게 만듦
                  borderSide: BorderSide(// 테두리의 선 스타일을 지정
                    color: borderColor,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _rePasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호 확인',
                labelStyle: TextStyle(color: borderColor),
                prefixIcon: Icon(Icons.lock_outline),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: borderColor,
                    width: 2.0
                  )
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:  BorderSide(
                    color: borderColor,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final password = _passwordController.text.trim();
                  final repassword = _rePasswordController.text.trim();
                  setState(() {
                    _passwordError = true;
                  });
                  if (password.isEmpty || repassword.isEmpty) {
                    _showSnackBar('비밀번호를 입력하세요', Colors.red);
                    return;
                  }
                  if (!_isPasswordValid(password) || !_isPasswordValid(repassword)) {
                    _showSnackBar(
                      '비밀번호는 8자 이상이며 !, @, # 중 하나를 포함해야 합니다',
                      Colors.orange,
                    );
                    return;
                  }
                  if(password != repassword) {
                    _showSnackBar('동일한 비밀번호를 입력하세요', Colors.red);
                    return;
                  }
                  if(password == repassword) {
                    _changePassword();
                  }
                },
                child: const Text(
                  '변경 완료',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
