// lib/footer.dart
import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      color: Colors.white,
      child: const Text(
        'Footer 영역 Footer 영역 Footer 영역 Footer 영역 Footer 영역 Footer 영역 Footer 영역 Footer 영역 Footer 영역\n © 2025 My App. All rights reserved. \n 개인정보처리방침 ',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
