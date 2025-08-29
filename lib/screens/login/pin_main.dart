import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:studyex04/homepage.dart';
import 'package:studyex04/models/user_session.dart';
import '../../models/User.dart';

class RandomPin extends StatefulWidget {
  const RandomPin({super.key});

  @override
  _RandomPinState createState() => _RandomPinState();
}

class _RandomPinState extends State<RandomPin> {
  String _inputPassword = "";
  List<String> _digits = [];
  String _instructionText = '로그인 또는 회원가입 후 마이페이지에서 등록이 가능합니다.';
  Color? _instructionTextColor;

  // initState에서 키패드 섞기
  @override
  void initState() {
    super.initState();
    _shuffleDigits();
    _instructionText = '로그인 또는 회원가입 후 마이페이지에서 등록이 가능합니다.';
    _instructionTextColor = null;
  }

  @override
  void didChangeDependencies() { //빌드함수가 실행되기전 먼저 실행
    super.didChangeDependencies();
    _instructionTextColor= Theme.of(context).textTheme.bodyMedium?.color;
  }

  // 0~9까지 문자리스트를 만들고 shuffle하는 함수
  void _shuffleDigits() {
    _digits = List.generate(10, (index) => index.toString());
    _digits.shuffle(Random());
    print("---------------- _digits: $_digits");
  }

  // 숫자키패드를 클릭하면
  void _addDigit(String digit) {
    if (_inputPassword.length < 4) {
      _inputPassword += digit;
    }
    setState(() {}); // UI 업데이트

    // 4자리 입력이 완료되면 서버에 핀번호 검증 요청
    if (_inputPassword.length == 4) {
      _checkPinNo();
    }
  }

  
  void _deleteDigit() {
    if (_inputPassword.isNotEmpty) {
      _inputPassword = _inputPassword.substring(0, _inputPassword.length - 1);
    }
    setState(() {

    });
  }

  // login_pinNo 호출 메서드
  Future<void> _checkPinNo() async {
    final url = dotenv.env['LOGIN_PINNO_API_URL']!; // 서버 API 주소
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'pinNo': int.parse(_inputPassword), // 정수형으로 변환하여 전송
        }),
      );
      print('Pin번호 서버 응답 상태 코드: ${response.statusCode}');
      if (response.statusCode == 200) {
        // 로그인 성공 시 사용자 정보를 UserSession에 저장
        final user = User.fromJson(json.decode(response.body)); //회원DB를 통해 받은 데이터 값 저장
        UserSession.login(user); // 로그인 상태 유지 처리
        print(user.userName);
        _showSnackBar('로그인에 성공했습니다.', Colors.green);
        // Pin 페이지로 이동 (Navigator.pushReplacement로 뒤로가기 방지)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  HomePage()),
        );
      } else if (response.statusCode == 401) {
        // 로그인 실패 (비밀번호 불일치)
        _resetPinInput();
        _instructionText='Pin 번호가 틀렸습니다.';
        _instructionTextColor=Colors.red;
        _showSnackBar('Pin 번호가 틀렸습니다.', Colors.red);
      } else {
        // 기타 서버 오류
        _resetPinInput();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("서버 오류가 발생했습니다: ${response.statusCode}")),
        );
      }
    } catch (e) {
      // 네트워크 오류
      _resetPinInput();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("네트워크 오류가 발생했습니다: $e")),
      );
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

  // 핀 입력 초기화 및 키패드 섞기
  void _resetPinInput() {
    _inputPassword = "";
    _shuffleDigits();
    setState(() {});
  }

  // 나머지 위젯들은 기존 코드와 동일
  Widget _buildPinDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: index < _inputPassword.length ? Colors.black : Colors.transparent,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildButton({required String str}) {
    return GestureDetector(
      onTap: str == "del" ? _deleteDigit : () => _addDigit(str),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(8),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: str == "del"
            ? const Icon(Icons.backspace)
            : Text(str, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Pin 번호 로그인'),
      centerTitle: true,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
                _instructionText,
              style: TextStyle(
                color: _instructionTextColor
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int index = 0; index < 4; index++) _buildPinDot(index),
            ],
          ),
          const SizedBox(height: 50),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            children: [
              for (var i = 0; i < 10; i++) _buildButton(str: _digits[i]),
              _buildButton(str: "del"),
            ],
          ),
        ],
      ),
    );
  }
}