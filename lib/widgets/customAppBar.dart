import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {

        },
        icon: const Icon(Icons.search_rounded),
      ),
      title: Row(
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
                    color: Colors.brown,
                    fontFamily: 'PlaywriteAUNSW', // 구글 폰트 적용
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              pause: const Duration(seconds: 2),
              repeatForever: true,
              isRepeatingAnimation: true,
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
