import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../homepage.dart';
import '../../models/user_session.dart';

// Pin 등록 단계 정의
enum PinStage {
  firstEntry,
  secondEntry,
}

// ---------------- 2단계 Pin 번호 등록 페이지 ----------------
class RegisterPinPage extends StatefulWidget {
  const RegisterPinPage({super.key});

  @override
  _RegisterPinPageState createState() => _RegisterPinPageState();
}

class _RegisterPinPageState extends State<RegisterPinPage> {
  String _inputPassword = ""; //입력받을 비밀번호
  List<String> _digits = []; //키트데
  PinStage _pinStage = PinStage.firstEntry;
  String _firstPin = "";  //첫번째 핀번호
  String _instructionText = '등록하실 번호 4자리를 입력해주세요'; //디폴트 메세지
  Color? _instructionTextColor; //디폴트 메세지 색상

  @override
  void initState() {
    super.initState();
    _shuffleDigits();
    _instructionText = '등록하실 번호 4자리를 입력해주세요';
    _instructionTextColor = null;
  }
@override
  void didChangeDependencies() { //테마 색상을 가져와 초기화하는 가장 안전한 방법
    super.didChangeDependencies();
    _instructionTextColor = Theme.of(context).textTheme.bodyMedium?.color;
  }
  //키패드 번호 순서 랜덤 생성
  void _shuffleDigits() {
    _digits = List.generate(10, (index) => index.toString());
    _digits.shuffle(Random());
    print("---------------- _digits: $_digits");
  }
//  동일 숫자 4자리 유효성 검사 메서드
  bool _validateIdenticalNumbers(String pin) {
    if (pin.length != 4) {
      return false; // 4자리가 아니면 검사하지 않음
    }
    // 첫 번째 문자와 나머지 문자들이 모두 같은지 확인
    final firstChar = pin[0];
    return pin.split('').every((char) => char == firstChar); //pin.split(''): "8888"이라는 문자열을 ["8", "8", "8", "8"]
  }
  void _addDigit(String digit) {
    if (_inputPassword.length < 4) {
      _inputPassword += digit;
    }
    setState(() {});
    if (_inputPassword.length == 4) {
      if (_pinStage == PinStage.firstEntry) {
        _handleFirstEntry();
      } else {
        _handleSecondEntry();
      }
    }
  }
  //핀번호 삭제 버튼 메서드
  void _deleteDigit() {
    if (_inputPassword.isNotEmpty) {
      _inputPassword = _inputPassword.substring(0, _inputPassword.length - 1);
    }
    setState(() {});
  }

  // 1단계 입력 처리
  void _handleFirstEntry() {
    //동일한 숫자 4자리 검증
    if (_validateIdenticalNumbers(_inputPassword)) {
      _showSnackBar('동일한 숫자 4자리는 Pin 번호로 사용할 수 없습니다.', Colors.red);
      // 입력값을 초기화하고 UI를 업데이트
      setState(() {
        _inputPassword = ""; //번호 초기화
        _instructionText = '동일한 숫자 4자리는 Pin 번호로 사용할 수 없습니다.';
        _instructionTextColor = Colors.red;
      });
      return; // 검사에 실패했으므로 다음 단계로 진행하지 않음
    }
    _firstPin = _inputPassword;
    _inputPassword = ""; // 입력 초기화
    _shuffleDigits(); // 키패드 다시 섞기
    setState(() {
      _pinStage = PinStage.secondEntry;
      _instructionText = '확인을 위해 한번더 입력해주세요.';
      _instructionTextColor = Colors.blue;
    });
    _showSnackBar('확인을 위해 한 번 더 입력해주세요.', Colors.blue);
  }

  // 2단계 입력 처리 및 서버 전송
  void _handleSecondEntry() {
    if (_inputPassword == _firstPin) {
      _savePinNo();
    } else {
      _resetPinInput();
      setState(() {
        _instructionText = '입력하신 두 Pin 번호가 일치하지 않습니다. 재입력 하세요';
        _instructionTextColor = Colors.red;
      });
      _showSnackBar('입력하신 두 Pin 번호가 일치하지 않습니다. 재입력 하세요', Colors.red);
    }
  }

  // 핀 번호 저장(등록) 로직
  Future<void> _savePinNo() async {
    final url = dotenv.env['REGISTER_PIN_API_URL']!;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': UserSession.currentUser?.phoneNumber,
          'pinNo': int.parse(_inputPassword),
        }),
      );

      print('서버 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        _showSnackBar('Pin 번호가 성공적으로 등록되었습니다.', Colors.green);
        Navigator.pop(context);
      } else {
        _resetPinInput();
        _showSnackBar('Pin 번호 등록에 실패했습니다. 다시 시도해 주세요.', Colors.red);
      }
    } catch (e) {
      _resetPinInput();
      _showSnackBar('네트워크 오류가 발생했습니다: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
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
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  // Pin번호 초기화 로직
  void _resetPinInput() {
    _inputPassword = "";
    _shuffleDigits();
    setState(() {
      _pinStage = PinStage.firstEntry; // 첫 번째 단계로 리셋
      _firstPin = "";
      _instructionText = '등록하실 숫자 4자리를 입력해주세요.';
      _instructionTextColor = Theme.of(context).textTheme.bodyMedium?.color;
    });
  }

  Widget _buildPinDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: index < _inputPassword.length ? Theme.of(context).textTheme.bodyLarge?.color : Colors.transparent,
        border: Border.all(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.transparent),
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

  String get _appBarTitle {
    return _pinStage == PinStage.firstEntry ? 'Pin 번호 등록' : 'Pin 번호 재확인';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_appBarTitle),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20,),
          Text(
            _instructionText,
            style: TextStyle(
                color: _instructionTextColor
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