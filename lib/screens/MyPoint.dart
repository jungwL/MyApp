import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
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
  late final Animation<int> _pointAnimation;

  //로그인 user 데이터
  final userName = UserSession.currentUser?.userName ?? 'UNKNOWN';
  final userId = UserSession.currentUser?.userId ?? 'UNKNOWN';
  final userPoint = UserSession.currentUser?.userPoint ?? 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pointAnimation = IntTween(begin: 0, end: userPoint).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barcodeData = '$userId:$userPoint'; // 바코드안 넣을 데이터

    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: Customdrawer(),
      body: Column(
        children: [
          Padding(
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
        ],
      ),
      bottomNavigationBar: Custombottomnai(),
    );
  }
}
