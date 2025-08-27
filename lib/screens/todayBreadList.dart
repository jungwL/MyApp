import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../widgets/customAppBar.dart';
import '../widgets/customBottomNai.dart';
import '../widgets/customDrawer.dart';

class TodayBreadList extends StatefulWidget {
  const TodayBreadList({super.key});

  @override
  State<TodayBreadList> createState() => _TodayBreadListState();
}

class _TodayBreadListState extends State<TodayBreadList> with SingleTickerProviderStateMixin {
  late Future<Map<String, List<Map<String, dynamic>>>> _categorizedBreadFuture;
  late TabController _tabBreadController;

  @override
  void initState() {
    super.initState();
    _tabBreadController = TabController(length: 4, vsync: this);
    _categorizedBreadFuture = _loadAndCategorizeBread();
  }

  Future<Map<String, List<Map<String, dynamic>>>> _loadAndCategorizeBread() async {
    final supabase = Supabase.instance.client;

    // 1. 빵 목록과 평점 목록을 동시에 효율적으로 요청
    final response = await Future.wait([
      supabase.from('todaybreadlist').select(), // Supabase 테이블 이름 확인!
      supabase.from('ratingsbread').select('todaybreadlist_id, rating'),
    ]);

    final allBreadsData = response[0] as List;
    final ratingData = response[1] as List;

    // 2. 평균 평점 계산 (버그 수정된 로직)
    final Map<int, double> ratingSums = {};
    final Map<int, int> ratingCounts = {};

    for (final rating in ratingData) {
      final id = rating['todaybreadlist_id'] as int;
      final value = (rating['rating'] as num).toDouble();
      ratingSums.update(id, (sum) => sum + value, ifAbsent: () => value);
      ratingCounts.update(id, (count) => count + 1, ifAbsent: () => 1);
    }

    final Map<int, double> averageRatings = {};
    for (final id in ratingSums.keys) {
      final sum = ratingSums[id]!;
      final count = ratingCounts[id]!;
      averageRatings[id] = double.parse((sum / count).toStringAsFixed(1)); // 별점 평균값 구하기
    }

    // 3. 빵 데이터에 평점 추가 후 카테고리별로 분류
    final Map<String, List<Map<String, dynamic>>> categorizedBreads = {
      'cake': [], 'baguette': [], 'bread': [], 'sand': [],
    };

    for (final breadItem in allBreadsData) {
      final id = breadItem['id'] as int;
      breadItem['avg_rating'] = averageRatings[id] ?? 0.0;
      final category = breadItem['category'] as String;

      if (categorizedBreads.containsKey(category)) {
        categorizedBreads[category]!.add(breadItem);
      }
    }
    return categorizedBreads;
  }

  @override
  void dispose() {
    _tabBreadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: Customdrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ... (기존 UI 코드) ...
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
                          '오늘의 빵',
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
                const Divider(height: 1),
                TabBar(
                  controller: _tabBreadController,
                  labelColor: Colors.brown,
                  indicatorColor: Colors.brown,
                  tabs:const [
                    Tab(text: '케이크',),
                    Tab(text: '바게트',),
                    Tab(text: '빵',),
                    Tab(text: '샌드위치',),
                  ],
                ),
                const Divider(height: 1,)
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
              future: _categorizedBreadFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('데이터 로딩 실패: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('데이터가 없습니다.'));
                }

                final breadData = snapshot.data!;
                final cakeList = breadData['cake'] ?? [];
                final baguetteList = breadData['baguette'] ?? [];
                final breadList = breadData['bread'] ?? [];
                final sandList = breadData['sand'] ?? [];

                return TabBarView(
                    controller: _tabBreadController,
                    children: [
                      BreadItemList(breadList: cakeList),
                      BreadItemList(breadList: baguetteList),
                      BreadItemList(breadList: breadList),
                      BreadItemList(breadList: sandList),
                    ]
                );
              },
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Custombottomnai(),
    );
  }
}

// --- bread_item_list.dart ---
// 별도 파일로 분리하거나 같은 파일 하단에 두어도 됩니다.

class BreadItemList extends StatefulWidget {
  final List<Map<String, dynamic>> breadList;

  const BreadItemList({super.key, required this.breadList});

  @override
  State<BreadItemList> createState() => _BreadItemListState();
}

class _BreadItemListState extends State<BreadItemList> {
  int? selectedIndex;

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: widget.breadList.length,
        itemBuilder: (context, index) {
          final bread = widget.breadList[index];
          bool isSelected = selectedIndex == index;

          // 데이터 타입 변환
          final String name = bread['name'] ?? '이름 없음';
          final String image = bread['image'] ?? ''; // 기본 이미지 경로 추가 가능
          final String ingredients = bread['ingredients'] ?? '';
          final String formattedIngredients = ingredients.replaceAll(r'\n', '\n');
          final int price = bread['price'] ?? 0;
          final double avgRating = bread['avg_rating'] ?? 0.0;

          print('빵이름 : $name , 이미지URL : $image, 가격 : $price, 평균별점 : $avgRating');
          print('추가설명 : $formattedIngredients');

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () {
                      setState(() {
                      selectedIndex = (selectedIndex == index) ? null : index;
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
                      color: Theme.of(context).cardColor,
                      borderRadius:
                      BorderRadius.circular(isSelected ? 24 : 16),
                      boxShadow: [
                        BoxShadow(
                          color:
                          Theme.of(context).cardColor.withOpacity(0.5),
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
                          // Supabase Storage 이미지 URL을 사용하려면 Image.network 사용
                          child: Image.asset(
                            image,
                            width: isSelected ? 150 : 110,
                            height: isSelected ? 150 : 110,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container( // 에러 발생 시 회색 박스 표시
                                width: isSelected ? 150 : 110,
                                height: isSelected ? 150 : 110,
                                color: Colors.grey[200],
                                child: Icon(Icons.bakery_dining_outlined, color: Colors.grey[400]),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: isSelected ? 18 : 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: isSelected ? 24 : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (isSelected)
                                  Text(
                                    formattedIngredients,
                                    style: const TextStyle(
                                        fontSize: 16, height: 1.4),
                                  ),
                                if (isSelected) const SizedBox(height: 8),
                                Text(
                                  '₩ $price원',
                                  style: TextStyle(
                                    fontSize: isSelected ? 18 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height:8),
                                _buildStarRating(avgRating),
                              ],
                            ),
                          ),
                        ),
                        const Icon(Icons.ads_click_sharp)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}