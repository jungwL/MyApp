import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studyex04/models/User.dart';
import 'package:studyex04/models/user_session.dart';
import '../homepage.dart';

class Joinuser extends StatefulWidget {
  const Joinuser({super.key});

  @override
  State<Joinuser> createState() => _JoinUserState();
}

class _JoinUserState extends State<Joinuser> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //회원가입 입력정보
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();

  //커서 포커스
  final FocusNode _authCodeFocus = FocusNode();


  late AnimationController _animationController;
  late Animation<double> _fadeIn;

  bool _isVerified = false;
  String? _authError;

  Timer? _timer;
  int _remainingSeconds = 0;

  //비밀번호 우휴성검사 로직
  bool _isPasswordValid(String password) {
    if (password.length < 8) return false; //password가 8자리이하일 경우 false반환
    final specialCharPattern = RegExp(
      r'[!@#]',
    ); //RegExp : 정규표현식 , r'' : 문자열을 정규표현식으로 인식
    if (!specialCharPattern.hasMatch(password))
      return false; //정규표현식에 포함되지 않는다면 false반환
    return true; //위 두 조건을 만족하는 경우 true반환
  }

// 회원가입 API를 호출하는 비동기 함수
  Future<void> _joinUser() async {
    // 요청을 보낼 백엔드 API 주소 (Spring Boot 서버)
    final String url = 'http://localhost:8080/api/joinUser';
    //final String url = 'http://192.168.30.133:8080/api/joinUser';

    try {
      // HTTP POST 요청을 보냄 (사용자 입력 값을 JSON으로 변환해서 전송)
      final response = await http.post(
        Uri.parse(url), // 문자열 URL을 Uri 객체로 변환
        headers: {'Content-Type': 'application/json'}, // 요청 헤더에 JSON 형식
        body: json.encode({
          'userName': _nameController.text,        // 사용자 이름
          'userId': _emailController.text,         // 사용자 이메일(ID)
          'password': _passwordController.text,    // 사용자 비밀번호
          'phoneNumber': _phoneController.text,    // 사용자 전화번호
        }),
      );
      print('회원가입 HTTP 요청 코드 :  ${response.statusCode}');
      // 서버가 200 OK 응답을 보낸 경우 → 회원가입 성공
      if (response.statusCode == 200) {
        // 응답받은 JSON 데이터를 User 객체로 변환
        final user = User.fromJson(json.decode(response.body));

        // 상단에 파란색 알림 표시 (회원가입 성공 메시지)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('회원가입이 완료됬습니다. 로그인을 완료하세요'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.blue,
          ),
        );

        // 홈 페이지로 이동하면서 현재 화면 제거 (뒤로 못 돌아가게)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );

        // 서버 응답이 409 Conflict인 경우 → 이미 가입된 ID
      } else if (response.statusCode == 409) {
        // 경고 메시지 출력
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미 존재하는 회원입니다.')),
        );
        print('이미 존재하는 회원입니다.');

        // 그 외의 다른 실패 응답
      } else {
        // 에러 상태 코드와 함께 스낵바 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${response.statusCode}')),
        );
        print('회원가입 실패: ${response.statusCode}');
      }

      // 예외가 발생한 경우 (예: 서버 연결 실패, JSON 오류 등)
    } catch (e, stack) {
      print('서버 예외 발생: $e');           // 예외 메시지 출력
      print('스택 트레이스: $stack');        // 어디서 예외가 났는지 추적
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버 오류: ${e.toString()}')),  // 사용자에게 오류 메시지 표시
      );
    }
  }


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
    _timer?.cancel();
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _authCodeController.dispose();
    _authCodeFocus.dispose();
    super.dispose();
  }

  //이메일 형식 유효성 검사
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  //연락처 형식 유효성 검사
  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\d{10,11}$'); // 10~11자리 숫자만 허용 (전화번호 형식)
    return phoneRegex.hasMatch(phone);
  }

  //본인인증 타이머 호출
  void _startTimer() {
    _remainingSeconds = 1 * 60; // 1분
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        setState(() {
          if (!_isVerified) {
            _authError = '인증시간이 만료되었습니다.';
          }
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String get _timerText {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (!_isVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('본인인증을 완료해주세요')),
        );
        return;
      }
      // 회원가입 API 호출 등 처리 가능
      _joinUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('회원가입'),
        centerTitle: true,
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
                    '회원가입을 위해 정보를 입력하세요.',
                  ),
                  const SizedBox(height: 32),

                  // 이름 입력
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '이름',
                      labelStyle: const TextStyle(color: Colors.brown),
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white10 // 다크모드일 때 연한 흰색
                          : Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.brown, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '이름을 입력해주세요';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // 이메일 입력
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: '아이디 (이메일)',
                      labelStyle: const TextStyle(color: Colors.brown),
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white10 // 다크모드일 때 연한 흰색
                          : Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.brown, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '이메일을 입력해주세요';
                      } else if (!_isValidEmail(value.trim())) {
                        return '올바른 이메일 형식을 입력해주세요';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // 비밀번호 입력
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      labelStyle: const TextStyle(color: Colors.brown),
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white10 // 다크모드일 때 연한 흰색
                          : Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.brown, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '비밀번호를 입력해주세요';
                      } else if (!_isPasswordValid(value.trim()) ) {
                        return '비밀번호는 8자 이상이고 !, @, # 특수문자를 포함해야 합니다';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // 연락처 입력
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: '연락처',
                      labelStyle: const TextStyle(color: Colors.brown),
                      prefixIcon: const Icon(Icons.phone_outlined),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white10 // 다크모드일 때 연한 흰색
                          : Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.brown, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '연락처를 입력해주세요';
                      } else if (!_isValidPhone(value.trim())) {
                        return '올바른 연락처 형식을 입력해주세요 (숫자 10~11자리)';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // 인증번호 입력 + 본인인증 버튼 Row
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _authCodeController,
                              focusNode: _authCodeFocus,
                              keyboardType: TextInputType.number,
                              enabled: !_isVerified,
                              decoration: InputDecoration(
                                labelText: '인증번호 입력',
                                labelStyle: const TextStyle(color: Colors.brown),
                                prefixIcon: const Icon(Icons.vpn_key_outlined),
                                filled: true,
                                fillColor: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white10 // 다크모드일 때 연한 흰색
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.brown, width: 2),
                                ),
                                suffix: (_remainingSeconds > 0 && !_isVerified)
                                    ? Text(
                                  _timerText,
                                  style: const TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    : null,
                              ),
                              validator: (value) {
                                if (!_isVerified && (value == null || value.trim().isEmpty)) {
                                  return '인증번호를 입력해주세요';
                                }
                                return null;
                              },
                            ),
                            if (_authError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4, left: 12),
                                child: Text(
                                  _authError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _isVerified
                              ? null
                              : () {
                            final code = _authCodeController.text.trim();

                            // 인증요청 상태일 때는 타이머 시작
                            if (_remainingSeconds == 0) {
                              setState(() {
                                _authError = null;
                                _authCodeController.clear(); // 이전 값 초기화
                              });
                              _startTimer();
                              FocusScope.of(context).requestFocus(_authCodeFocus); //커서이동 추가
                            }
                            // 타이머 도중이면 인증번호 확인
                            else {
                              if (code.isEmpty) {
                                setState(() {
                                  _authError = '인증번호를 입력해주세요';
                                });
                                return;
                              }

                              if (code == '1234') {
                                setState(() {
                                  _isVerified = true;
                                  _authError = null;
                                  _timer?.cancel();
                                });
                              } else {
                                setState(() {
                                  _authError = '인증번호가 틀렸습니다.';
                                });
                              }
                            }
                          },
                          child: Text(
                            _isVerified ? '인증완료' : '인증하기',
                            style: const TextStyle(fontSize: 14, color: Colors.white70),
                           ),
                          ),
                        ),
                    ],
                  ),

                  if (_isVerified)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        '인증 완료',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

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
                      onPressed: _submit,
                      child: const Text(
                        '회원가입',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
