import 'package:flutter/material.dart';

class PasswordChangePage extends StatelessWidget {
  PasswordChangePage({super.key});

  final TextEditingController _passwordController = TextEditingController();

  // 비밀번호 유효성검사로직
  bool _isPasswordValid(String password) {
    if (password.length < 8) return false; //password가 8자리이하일 경우 false반환
    final specialCharPattern = RegExp(
      r'[!@#]',
    ); //RegExp : 정규표현식 , r'' : 문자열을 정규표현식으로 인식
    if (!specialCharPattern.hasMatch(password))
      return false; //정규표현식에 포함되지 않는다면 false반환
    return true; //위 두 조건을 만족하는 경우 true반환
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    print(message);
    print(color);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('비밀번호 변경'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
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
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '새 비밀번호',
                labelStyle: TextStyle(
                  color: Colors.brown
                ),
                prefixIcon: const Icon(Icons.lock_outline),
                filled: true,
                fillColor: Colors.white,
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
            ),
            const SizedBox(height: 30),
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

                  if (password.isEmpty) {
                    _showSnackBar(context, '비밀번호를 입력하세요', Colors.red);
                    return;
                  }

                  if (!_isPasswordValid(password)) {
                    _showSnackBar(
                      context,
                      '비밀번호는 8자 이상이며 !, @, # 중 하나를 포함해야 합니다',
                      Colors.orange,
                    );
                    return;
                  }

                  _showSnackBar(context, '비밀번호가 변경되었습니다', Colors.green);
                },
                child: const Text('변경 완료', style: TextStyle(fontSize: 16,color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
