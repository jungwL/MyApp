import 'package:flutter/material.dart';
import 'package:studyex04/models/user_session.dart';
import '../main.dart'; // MyApp 상태 접근
import 'cs_page.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isDark = false;
  bool notificationsEnabled = true;
  String language = '한국어';

  final List<String> languagesList = ['한국어', 'English', '日本語', '中文'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isDark = MyApp.of(context)?.isDarkMode ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        children: [
          _buildSectionTitle('일반 설정'),
          const SizedBox(height: 12),

          // 다크모드 토글
          Card(
            margin: const EdgeInsets.only(bottom: 12), // 카드 아래쪽 12픽셀 마진
            shape: RoundedRectangleBorder(
              //카드 모서리16픽셀 둥글게
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2, //카드 입체감을 주는 그림자 깊이 설정(2는 가벼운 그림자)
            child: SwitchListTile(
              //카드 내부에 스위치가 포함된 리스트 스타일
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24, //가로 24픽셀
                vertical: 4, //세로 4픽셀 타일 안쪽 여백
              ),
              title: Text(
                //타일의 제목 텍스트 다크 모드 굵게 설정
                '다크 모드',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text('화면을 어둡게 합니다'), //타일의 부제목 텍스트
              value: isDark, //스위치 상태를 isDartk 변구 값에 따라 결정(on/off)
              activeColor: Colors.brown, //스위치가 on일 때 표시할 색상 지정
              onChanged: (value) {
                //스위치가 변경되면 isDark 상태를 업데이트 하고 앱테마를 변경하는 메서드 호출
                setState(() {
                  isDark = value;
                });
                MyApp.of(context)?.toggleTheme(value);
              },
              shape: RoundedRectangleBorder(
                //모서리를 둥글게 만들어 카드와 통일된 스타일 적용
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // 알림 토글
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 4,
              ),
              title: Text(
                '알림 받기',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text('새 소식과 업데이트를 받습니다'),
              value: notificationsEnabled,
              activeColor: Colors.brown,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('앱 설정'),
          const SizedBox(height: 12),

          // 언어 선택
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                '언어 설정',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                language,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.brown,
                ),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.brown,
              ),
              onTap: _showLanguageDialog,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // 앱 버전
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                '앱 버전',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text('1.0.0'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          Card(
            margin: const EdgeInsets.only(
              bottom: 12,
            ), // 카드 아래쪽에 12픽셀 여백을 둠 (아래 카드와 간격 확보)
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                16,
              ), // 카드 모서리를 둥글게 16픽셀 반경으로 만듦
            ),
            elevation: 2, // 그림자 깊이 설정, 카드가 떠있는 느낌을 줌
            child: ListTile(
              // 리스트 항목 스타일의 위젯 사용
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
              ), // 좌우 내부 여백 24픽셀 지정
              title: Text(
                // 카드 제목 텍스트
                '고객센터',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, // 폰트 두껍게 지정
                ),
              ),
              trailing: Icon(
                // 오른쪽 끝에 아이콘 추가
                Icons.phone_forwarded, // 전화 아이콘
                color: Colors.brown, // 테마의 주 색상 적용
              ),
              onTap: () {
                // 카드 눌렀을 때 실행되는 함수
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CsPage())
                );
              },
            ),
          ),

          // 개인정보처리방침
          Card(
            margin: const EdgeInsets.only(bottom: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                '개인정보처리방침',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Icon(
                Icons.open_in_new,
                color: Colors.brown,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('개인정보처리방침'),
                      content: SingleChildScrollView(
                        child: Text(
                          '개인정보처리방침 내용 예시.\n\n'
                              '예: 개인정보 수집, 이용 목적, 보관 기간, 제3자 제공 등에 관한 내용 등...\n\n'
                              '제1항 : 서비스 기획부터 종료까지 개인정보보호법 등 국내의 개인정보 보호 법령을 철저히 준수합니다. 또한 OECD의 개인정보 보호 가이드라인 등 국제 기준을 준수하여 서비스를 제공합니다. 제1항 : 서비스 기획부터 종료까지 개인정보보호법 등 국내의 개인정보 보호 법령을 철저히 준수합니다. 또한 OECD의 개인정보 보호 가이드라인 등 국제 기준을 준수하여 서비스를 제공합니다.제1항 : 서비스 기획부터 종료까지 개인정보보호법 등 국내의 개인정보 보호 법령을 철저히 준수합니다. 또한 OECD의 개인정보 보호 가이드라인 등 국제 기준을 준수하여 서비스를 제공합니다.제1항 : 서비스 기획부터 종료까지 개인정보보호법 등 국내의 개인정보 보호 법령을 철저히 준수합니다. 또한 OECD의 개인정보 보호 가이드라인 등 국제 기준을 준수하여 서비스를 제공합니다.제1항 : 서비스 기획부터 종료까지 개인정보보호법 등 국내의 개인정보 보호 법령을 철저히 준수합니다. 또한 OECD의 개인정보 보호 가이드라인 등 국제 기준을 준수하여 서비스를 제공합니다.제1항 : 서비스 기획부터 종료까지 개인정보보호법 등 국내의 개인정보 보호 법령을 철저히 준수합니다. 또한 OECD의 개인정보 보호 가이드라인 등 국제 기준을 준수하여 서비스를 제공합니다.제1항 : 서비스 기획부터 종료까지 개인정보보호법 등 국내의 개인정보 보호 법령을 철저히 준수합니다. 또한 OECD의 개인정보 보호 가이드라인 등 국제 기준을 준수하여 서비스를 제공합니다.제1항 : 서비스 기획부터 종료까지 개인정보보호법 등 국내의 개인정보 보호 법령을 철저히 준수합니다. 또한 OECD의 개인정보 보호 가이드라인 등 국제 기준을 준수하여 서비스를 제공합니다.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('닫기'),
                        ),
                      ],
                    );
                  },
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // 로그아웃 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout_rounded,color: Colors.white,),
              label: const Text(
                '로그아웃',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              onPressed: () {
                //로그아웃구현
                if(UserSession.isLoggedIn){
                  UserSession.logout();
                }else {
                  Navigator.pushNamed(
                    context,
                    '/login',
                  ); // 로그인 화면으로 이동
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown,
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('언어 선택'),
          children: languagesList.map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: language,
              activeColor: Colors.brown,
              onChanged: (value) {
                setState(() {
                  language = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
