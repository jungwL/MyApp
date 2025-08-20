import 'package:flutter/material.dart';
import 'joinUser.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool agreeAll = false; // 전체동의
  bool agreeService = false; //서비스 약관동의(필수)
  bool agreePrivacy = false; //개인정보 수집 및 이용동의(필수)
  bool agreeAd = false; // 광고성 메시지 수신동의(선택)

  void _toggleAll(bool? value) {
    setState(() {
      agreeAll = value ?? false; //value == null 이면 false값
      agreeService = agreeAll;
      agreePrivacy = agreeAll;
      agreeAd = agreeAll;
    });
  }

  //필수 항목 두개가 체크 되어야지만 다음 페이지 이동
  void _checkNext() {
    if (agreeService && agreePrivacy) { 
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Joinuser()), // 회원가입 페이지로 이동
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필수 항목에 동의해주세요')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('약관 동의'),
      centerTitle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('[필수] 서비스 이용약관 동의'),
              value: agreeService,
              activeColor: Colors.brown,
              onChanged: (value) {
                setState(() {
                  agreeService = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('[필수] 개인정보 수집 및 이용 동의'),
              value: agreePrivacy,
              activeColor: Colors.brown,
              onChanged: (value) {
                setState(() {
                  agreePrivacy = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('[선택] 광고성 메시지 수신 동의'),
              value: agreeAd,
              activeColor: Colors.brown,
              onChanged: (value) {
                setState(() {
                  agreeAd = value ?? false; // 선택 동의 상태 업데이트
                });
              },
            ),
            const Divider(),
            CheckboxListTile(
              title: const Text('[전체 동의]'),
              value: agreeAll,
              onChanged: _toggleAll,
              activeColor: Colors.brown,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (agreeService && agreePrivacy) ? _checkNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('다음', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
