import 'package:flutter/material.dart';
import 'package:studyex04/user_session.dart';

class MyPointPage extends StatefulWidget {
  const MyPointPage({super.key});

  @override
  State<MyPointPage> createState() => _MyPointPageState();
}

class _MyPointPageState extends State<MyPointPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<int> _pointAnimation;

  @override
  void initState() {
    super.initState();
    int targetPoints = UserSession.currentUser?.userPoint ?? 0;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _pointAnimation = IntTween(begin: 0, end: targetPoints).animate(
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 포인트'),
        centerTitle: true,
        backgroundColor: Colors.orange.shade200,
        foregroundColor: Colors.white,
      ),
      body: Center(
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
                padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
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
                    const SizedBox(height: 24),
                    const Text(
                      '보유 포인트',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.orangeAccent,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedBuilder(
                      animation: _pointAnimation,
                      builder: (context, child) {
                        return Text(
                          '${_pointAnimation.value} P',
                          style: const TextStyle(
                            fontSize: 44,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
