import 'package:flutter/material.dart';
import '../homepage.dart';
import '../screens/storeInfo/companyInfoPage.dart';
import 'package:studyex04/screens/MyPoint.dart';
import '../models/user_session.dart';
import '../screens/login/login.dart';
import '../screens/setting/setting.dart';
import '../screens/onlineOrder_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Custombottomnai extends StatefulWidget {
  const Custombottomnai({super.key});

  @override
  State<Custombottomnai> createState() => _CustombottomnaiState();
}

class _CustombottomnaiState extends State<Custombottomnai> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });

        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CompanyMapPage()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OnlineorderPage(),
              ), // 온라인 주문 페이지로 변경 가능
            );
            break;
          case 3:
            if(UserSession.isLoggedIn){ //로그인되어있을경우
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MyPointPage()
                ), // 온라인 주문 페이지로 변경 가능
              );
              break;
            }else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => LoginPage()
                ),
              );
            }
          case 4:
           // if(UserSession.isLoggedIn){
              Navigator.push(
               context,
                MaterialPageRoute(builder: (_) => const Setting()),
             );
          /*  }else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            }*/
            break;
        }
      },
      selectedItemColor: Colors.brown,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 14,
      unselectedFontSize: 13,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: '매장정보'),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: '온라인 주문',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
              FontAwesomeIcons.barcode),
          label: '멤버십',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: '설정',
        ),
      ],
    );
  }
}

