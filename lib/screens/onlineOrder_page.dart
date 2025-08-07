import 'package:flutter/material.dart';
import '../widgets/customDrawer.dart';
import '../widgets/customAppBar.dart';

class OnlineorderPage extends StatefulWidget {
  const OnlineorderPage({super.key});

  @override
  State<OnlineorderPage> createState() => _OnlineorderPageState();
}

class _OnlineorderPageState extends State<OnlineorderPage> {
  @override
  Widget build(BuildContext context) {
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
                      color: Colors.brown,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                        child: Center(
                          child: Text(
                            '온라인 주문',
                            style: TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        )
                    ),
                    const SizedBox(width: 48,)
                  ],
                ),
                const SizedBox(height: 8,),
                Divider(
                  color: Colors.brown.shade200,
                  thickness: 1.5,
                    indent: 24,
                    endIndent: 24,
                ),
                const SizedBox(height: 48,),
                Image.asset('images/Logo1.png'),
                const SizedBox(height: 8,),
                Center(
                    child: Text(
                        '오픈 준비중입니다..',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                    )
                )
                ,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
