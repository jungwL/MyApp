import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:http/http.dart' as http;
import '../models/user_session.dart';
import '../widgets/customAppBar.dart';
import '../widgets/customBottomNai.dart';
import '../widgets/customDrawer.dart';


//멤버십 페이지
class MyPointPage extends StatefulWidget {
  const MyPointPage({super.key});

  @override
  State<MyPointPage> createState() => _MyPointPageState();
}

class _MyPointPageState extends State<MyPointPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  // [수정] late final 대신 late를 사용하여 나중에 값을 재할당할 수 있도록 변경
  late Animation<int> _pointAnimation;
  late Animation<Offset> _slideAnimation;

  final userName = UserSession.currentUser?.userName ?? 'UNKNOWN';
  final userId = UserSession.currentUser?.userId ?? 'UNKNOWN';
  var userPoint = UserSession.currentUser?.userPoint ?? 0;

  // initState 로직 변경
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    // [수정] 초기 애니메이션은 기본값으로 설정해둡니다.
    _pointAnimation = IntTween(begin: 0, end: userPoint).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    // initState에서 데이터 로딩 및 첫 애니메이션을 시작합니다.
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3), // Y축으로 -30% 위에서 시작
      end: Offset.zero,             // 제자리로 돌아옴
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _getUserpoint();
  }

  // [수정] _getUserpoint 함수가 애니메이션을 재시작하도록 변경
  Future<void> _getUserpoint() async {
    final String url = 'http://localhost:8080/api/userPoint?phoneNumber=${UserSession.currentUser!.phoneNumber}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final newPoint = int.parse(response.body);
        print("서버로부터 받은 포인트: $newPoint");

        // setState를 호출하여 UI의 포인트 값을 즉시 업데이트
        setState(() {
          userPoint = newPoint;
          // ✨ 애니메이션을 새로운 포인트 값으로 다시 설정합니다.
          _pointAnimation = IntTween(begin: 0, end: userPoint).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          );
        });

        // ✨ 애니메이션 컨트롤러를 처음부터 다시 시작합니다.
        _controller.forward(from: 0.0);

      } else {
        print('서버 오류 발생 : ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barcodeData = '$userId:$userPoint';

    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: Customdrawer(),
      // [수정] RefreshIndicator가 스크롤 가능한 위젯을 감싸도록 구조 변경
      body: RefreshIndicator(
        onRefresh: _getUserpoint, // [수정] onRefresh에는 비동기 함수를 직접 연결합니다.
        color: Colors.orange,
        child: SingleChildScrollView( // 스크롤이 가능하도록 전체를 감쌉니다.
          physics: const AlwaysScrollableScrollPhysics(), // 내용이 짧아도 항상 스크롤 되도록 설정
          child: Column(
            children: [
              Padding(
                // ... (상단 UI 부분은 기존과 동일)
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        BackButton(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '나의 멤버십',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                fontFamily: 'PlaywriteAUNSW',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // 오른쪽 공간 맞춤용 빈 박스
                      ],
                    ),

                    const SizedBox(height: 8),
                    Divider(
                      color: Colors.brown.shade200,
                      thickness: 1.5,
                      indent: 24,
                      endIndent: 24,
                    ),
                  ],
                ),
              ),
              Center(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _controller,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.85, end: 1).animate(
                        CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
                      ),
                      child: Card(
                        elevation: 8,
                        margin: const EdgeInsets.all(24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white,
                        shadowColor: Colors.orange.shade300.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ... (카드 내부 UI는 기존과 동일)
                              Icon(
                                Icons.card_membership,
                                size: 60,
                                color: Colors.orange.shade400,
                                shadows: [
                                  Shadow(
                                    color: Colors.orange.shade200,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                '나의 멤버십',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              const SizedBox(height: 12),
                              AnimatedBuilder(
                                animation: _pointAnimation,
                                builder: (context, child) {
                                  return Text(
                                    // userPoint 대신 _pointAnimation.value를 사용해야 애니메이션이 보입니다.
                                    '${_pointAnimation.value} P',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange,
                                      shadows: [
                                        Shadow(
                                          color: Colors.orangeAccent,
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              Text(
                                '회원: $userName',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              BarcodeWidget(
                                barcode: Barcode.code128(),
                                data: barcodeData, // 바코드 안에들어갈 실제 데이터
                                width: 250,
                                height: 80,
                                drawText: false,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                '카운터에서 바코드를 보여주세요',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}