import 'package:flutter/material.dart';
import 'package:studyex04/user_session.dart';

class MyPointPage extends StatelessWidget {
  const MyPointPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 예시 포인트
    final int myPoints = 3500;

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 포인트'),
        centerTitle: true,
        backgroundColor: Colors.orange.shade200,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.amber.shade50,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  size: 60,
                  color: Colors.amber,
                ),
                const SizedBox(height: 20),
                const Text(
                  '보유 포인트',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  '포인트\n${UserSession.currentUser?.userPoint ?? 0} P',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
