import 'package:flutter/material.dart';
import '../models/user_session.dart';
import '../screens/setting/setting.dart';
import '../screens/mypage/mypage.dart';
import '../screens/storeInfo/companyInfoPage.dart';
import '../screens/cs/cs_page.dart';
import '../screens/MyPoint.dart';
import '../screens/todayBreadList.dart';
import '../screens/login/login.dart';
import '../screens/onlineOrder_page.dart';
import '../screens/onlineOrder_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Customdrawer extends StatefulWidget {
  const Customdrawer({super.key});

  @override
  State<Customdrawer> createState() => _CustomdrawerState();
}

class _CustomdrawerState extends State<Customdrawer> {

  //마이페이지 이동 화면전환 navigator 호출 메서드
  void _goToMyPage(BuildContext context) {
    Navigator.pop(context);
    if (UserSession.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MyPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(redirectTo: 'mypage'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserSession.isLoggedIn
              ? Stack( // UserAccountsDrawerHeader 고정값이라 Positioned 버튼 추가시 Stack위젯으로 감싸야함
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  UserSession.currentUser?.userName ?? '사용자',
                ),
                accountEmail: Text(
                  UserSession.currentUser?.userId ?? '이메일',
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: ClipOval(child: Icon(Icons.person_2_outlined,),
                ),),
                decoration: const BoxDecoration(color: Colors.brown),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () {
                    UserSession.logout();
                    Navigator.pushNamed(
                      context,
                      '/',
                    );
                  },
                  icon: Icon(Icons.logout, color: Colors.white),
                ),
              ),
            ],
          )
              : DrawerHeader(
            decoration: const BoxDecoration(color: Colors.brown),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '로그인 하세요',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    '로그인하러 가기',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/termspage');
                  },
                  child: Text(
                    '회원가입하러 가기',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (UserSession.isLoggedIn) ...[
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('마이페이지'),
              onTap: () => _goToMyPage(context),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('마이 포인트'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPointPage()),
                );
              },
            ),
          ],
          ListTile(
            leading: const Icon(FontAwesomeIcons.breadSlice),
            title: const Text('오늘의 빵'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodayBreadList()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: const Text('공지사항'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('설정'),
            onTap: () {
              if(UserSession.isLoggedIn){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Setting()),
                );
              }else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('매장정보'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompanyMapPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.handshake),
            title: const Text('창업안내'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text('고객센터'),
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => CsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('온라인 주문'),
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=>OnlineorderPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_offer),
            title: const Text('프로모션'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
