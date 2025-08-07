import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../widgets/customAppBar.dart';
import '../widgets/customBottomNai.dart';
import '../widgets/customDrawer.dart';
import '../core/todayBreadList.dart';

class TodayBreadList extends StatefulWidget {
  const TodayBreadList({super.key});

  @override
  State<TodayBreadList> createState() => _TodayBreadListState();
}

class _TodayBreadListState extends State<TodayBreadList> with SingleTickerProviderStateMixin{

  late TabController _tabBreadController;

  @override
  void initState() {
    super.initState();
    _tabBreadController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabBreadController.dispose();
    super.dispose();
  }

  int? selectedIndex;

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
                Row(
                  children: [
                    BackButton(
                      color: Colors.brown,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '오늘의 빵',
                          style: TextStyle(
                            color: Colors.brown,
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
                  height: 1,
                ),
                TabBar(
                  controller: _tabBreadController,
                  labelColor: Colors.brown,
                  indicatorColor: Colors.brown,
                  tabs:const [
                    Tab(text: '케익',),
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
              child: TabBarView(
                  controller: _tabBreadController,
                  children: const [
                    TodayCake(),
                    TodayBaguette(),
                    TodayBread(),
                    TodaySand(),
                  ]
              ),
          ),
        ],
      ),
      bottomNavigationBar: Custombottomnai(),
    );
  }
}
// bread_item_list.dart
class BreadItemList extends StatefulWidget {
  final List<Map<String, String>> breadList;

  const BreadItemList({super.key, required this.breadList});

  @override
  State<BreadItemList> createState() => _BreadItemListState();
}

class _BreadItemListState extends State<BreadItemList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: widget.breadList.length,
          itemBuilder: (context, index) {
            final bread = widget.breadList[index];
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
                              padding: EdgeInsets.symmetric(
                                  vertical: isSelected ? 18 : 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bread['name']!,
                                    style: TextStyle(
                                        fontSize: isSelected ? 24 : 20,
                                        fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (isSelected)
                                    Text(
                                      bread['ingredients'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 16, height: 1.4),
                                    ),
                                  if (isSelected) const SizedBox(height: 8),
                                  Text(
                                    bread['price'] ?? '',
                                    style: TextStyle(
                                      fontSize: isSelected ? 18 : 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Icon(Icons.ads_click_sharp)
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
