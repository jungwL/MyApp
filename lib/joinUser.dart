import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studyex04/User.dart';
import 'package:studyex04/user_session.dart';
import 'homepage.dart';

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

  //회원가입 API호출
  Future<void> _joinUser() async {
    final String url = 'http://localhost:8080/api/joinUser';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userName': _nameController.text,
          'userId': _emailController.text,
          'password': _passwordController.text,
          'phoneNumber': _phoneController.text,
        }),
      );

      print('http 응답코드 : ${response.statusCode}');

      if (response.statusCode == 200) {
        final user = User.fromJson(json.decode(response.body));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (response.statusCode == 409) {
        // 예: 이미 가입된 사용자일 경우
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미 존재하는 회원입니다.')),
        );
        print('이미 존재하는 회원입니다.');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${response.statusCode}')),
        );
        print('회원가입 실패: ${response.statusCode}');
      }
    } catch (e,stack) {
      print('❗ 서버 예외 발생: $e');
      print('📍 스택 트레이스: $stack');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버 오류: ${e.toString()}')),
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

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\d{10,11}$'); // 10~11자리 숫자만 허용 (전화번호 형식)
    return phoneRegex.hasMatch(phone);
  }

  //본인인증 타이머 호출
  void _startTimer() {
    _remainingSeconds = 1 * 60; // 5분
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('회원가입이 완료됬습니다. 로그인을 완료하세요'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue,
        ),
      );
      // 회원가입 API 호출 등 처리 가능
      _joinUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('회원가입', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
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
                    style: TextStyle(color: Colors.black),
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
                      fillColor: Colors.white,
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
                      fillColor: Colors.white,
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
                      fillColor: Colors.white,
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
                      fillColor: Colors.white,
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
                                fillColor: Colors.white,
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
