import 'package:flutter/material.dart';

class TodayBreadList extends StatelessWidget {
  const TodayBreadList({super.key});

  final List<Map<String, String>> breadList = const [
    {
      'name': '크루아상',
      'image': '/images/croissant.jpg',
      'desc': '겉은 바삭, 속은 부드러운 클래식한 맛'
    },
    {
      'name': '소금빵',
      'image': '/images/saltbread.jpg',
      'desc': '짭짤한 버터향 가득한 소금빵'
    },
    {
      'name': '앙버터',
      'image': '/images/anbutter.jpg',
      'desc': '달콤한 팥과 고소한 버터의 조화'
    },
    {
      'name': '바게트',
      'image': '/images/baguette.jpg',
      'desc': '프랑스 정통 바삭한 바게트'
    },
    {
      'name': '치아바타',
      'image': '/images/ciabatta.jpg',
      'desc': '쫄깃하고 촉촉한 이탈리안 브레드'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 빵 🍞'),
        backgroundColor: Colors.orange.shade200,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: breadList.map((bread) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade100.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Image.asset(
                        bread['image']!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bread['name']!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              bread['desc']!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}