import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TodayBreadList extends StatefulWidget {
  const TodayBreadList({super.key});

  @override
  State<TodayBreadList> createState() => _TodayBreadListState();
}

class _TodayBreadListState extends State<TodayBreadList> {
  final List<Map<String, String>> breadList = const [
    {
      'name': '크루아상',
      'image': 'images/croissant.jpg',
      'ingredients': '밀가루, 버터, 설탕, 이스트, 소금\n칼로리: 300kcal\n알레르기: 밀, 우유',
      'price': '₩5000',
    },
    {
      'name': '소금빵',
      'image': 'images/saltbread.jpg',
      'ingredients': '밀가루, 버터, 소금, 설탕, 이스트\n칼로리: 280kcal\n알레르기: 밀, 우유',
      'price': '₩4000',
    },
    {
      'name': '앙버터',
      'image': 'images/anbutter.jpg',
      'ingredients': '팥앙금, 버터, 밀가루, 설탕, 이스트\n칼로리: 350kcal\n알레르기: 밀, 우유',
      'price': '₩5500',
    },
    {
      'name': '바게트',
      'image': 'images/baguette.jpg',
      'ingredients': '밀가루, 소금, 이스트, 물\n칼로리: 270kcal\n알레르기: 밀',
      'price': '₩6000',
    },
    {
      'name': '치아바타',
      'image': 'images/ciabatta.jpg',
      'ingredients': '밀가루, 올리브오일, 소금, 이스트\n칼로리: 320kcal\n알레르기: 밀',
      'price': '₩6500',
    },
  ];

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 빵 🍞'),
        backgroundColor: Colors.orange.shade200,
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: breadList.length,
          itemBuilder: (context, index) {
            final bread = breadList[index];
            bool isSelected = selectedIndex == index;

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedIndex == index) {
                          selectedIndex = null;
                        } else {
                          selectedIndex = index;
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOutCubic,
                      margin: EdgeInsets.symmetric(
                        horizontal: isSelected ? 18 : 24,
                        vertical: isSelected ? 18 : 12,
                      ),
                      padding: EdgeInsets.all(isSelected ? 16 : 12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius:
                        BorderRadius.circular(isSelected ? 24 : 16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.shade100.withOpacity(0.5),
                            blurRadius: isSelected ? 20 : 8,
                            offset: Offset(0, isSelected ? 10 : 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(isSelected ? 24 : 16),
                            child: Image.asset(
                              bread['image']!,
                              width: isSelected ? 150 : 110,
                              height: isSelected ? 150 : 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: isSelected ? 18 : 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bread['name']!,
                                    style: TextStyle(
                                      fontSize: isSelected ? 24 : 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (isSelected)
                                    Text(
                                      bread['ingredients'] ?? '',
                                      style: const TextStyle(fontSize: 16, height: 1.4),
                                    ),
                                  if (isSelected) const SizedBox(height: 8),
                                  Text(
                                    bread['price'] ?? '',
                                    style: TextStyle(
                                      fontSize: isSelected ? 18 : 16,
                                      color: Colors.brown[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
