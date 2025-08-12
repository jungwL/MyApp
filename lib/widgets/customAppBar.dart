import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _controller.forward();
      } else {
        _controller.reverse();
        _searchController.clear();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      centerTitle: true,
      leading: IconButton(
        onPressed: _toggleSearch,
        icon: Icon(_isSearching ? Icons.close : Icons.search_rounded),
      ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isSearching
            ? SlideTransition(
          position: _slideAnimation,
          child: TextField(
            key: const ValueKey('searchField'),
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: '검색어를 입력하세요...',
              border: InputBorder.none,
              suffixIcon: _searchController.text.isNotEmpty ?
                   IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                      icon: Icon(Icons.clear,color: Colors.grey,)
                  )
              : null,
            ),
            onChanged: (query) {
              print('검색어: $query');
            },
          ),
        )
            : Row(
          key: const ValueKey('logoTitle'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/Logo1.png', width: 120, height: 120),
            const SizedBox(width: 2),
            Expanded(
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'SEOUL BAGUETTE',
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light //
                          ? Colors.brown // 라이트 모드
                          : Colors.white, // 다크 모드
                      fontFamily: 'PlaywriteAUNSW',
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                pause: const Duration(seconds: 2),
                repeatForever: true,
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
