import 'package:flutter/material.dart';
import 'package:studyex04/homepage.dart';
import '../login/login.dart';
import '../MyPoint.dart';

class Joinsuccess extends StatefulWidget {
  Joinsuccess({super.key , required this.userName});
  String userName;

  @override
  State<Joinsuccess> createState() => _JoinsuccessState();
}

class _JoinsuccessState extends State<Joinsuccess> {
  @override
  Widget build(BuildContext context) {
    // 현재 테마의 색상 가져오기
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 완료'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 완료 아이콘
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(height: 20),

            // 제목
            Text(
              '환영합니다, ${widget.userName}님!', // 사용자 이름에 따라 동적으로 변경 가능
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // 부제 텍스트
            Text(
              '회원가입이 성공적으로 완료되었습니다.',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color
              ),
              textAlign: TextAlign.center,
            ),            Text(
              '멤버십을 통한 적립이 가능합니다.',
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // ✨ 버튼 디자인 개선
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    icon: Icon(Icons.login ,color: Colors.white),
                    label: Text('로그인 하러가기', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    icon: const Icon(Icons.home, color: Colors.black),
                    label: const Text('홈으로', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}