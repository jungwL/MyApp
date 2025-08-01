import 'package:flutter/material.dart';
import 'joinuser.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool agreeAll = false;
  bool agreeService = false;
  bool agreePrivacy = false;
  bool agreeAd = false;

  void _toggleAll(bool? value) {
    setState(() {
      agreeAll = value ?? false;
      agreeService = agreeAll;
      agreePrivacy = agreeAll;
      agreeAd = agreeAll;
    });
  }

  void _checkNext() {
    if (agreeService && agreePrivacy) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Joinuser()),
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
      appBar: AppBar(title: const Text('약관 동의')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('[필수] 서비스 이용약관 동의'),
              value: agreeService,
              onChanged: (value) {
                setState(() {
                  agreeService = value ?? false;
                  agreeAll = agreeService && agreePrivacy;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('[필수] 개인정보 수집 및 이용 동의'),
              value: agreePrivacy,
              onChanged: (value) {
                setState(() {
                  agreePrivacy = value ?? false;
                  agreeAll = agreeService && agreePrivacy;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('[선택] 광고성 메시지 수신 동의'),
              value: agreeAd,
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
