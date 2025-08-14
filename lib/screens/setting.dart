import 'package:flutter/material.dart';
import 'package:studyex04/models/user_session.dart';
import '../main.dart'; // MyApp 상태 접근
import 'cs_page.dart';
import 'package:easy_localization/easy_localization.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isDark = false;
  bool notificationsEnabled = true;

  late Locale currentLocale;
  String language = '한국어';

  final List<String> languagesList = ['한국어', 'English'];

  List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('ko'),
  ];

  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ko':
        return '한국어';
      default:
        return '?';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLocale = context.locale;
    language = getLanguageName(currentLocale);
    isDark = MyApp.of(context)?.isDarkMode ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('setting', style: TextStyle(fontWeight: FontWeight.bold)).tr(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        children: [
          _buildSectionTitle('normal_setting'),
          const SizedBox(height: 12),

          // 다크모드 토글
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              title: Text(
                'dark_mode',
                style: TextStyle(fontWeight: FontWeight.w600),
              ).tr(),
              subtitle: Text('dark_mode_subtitle').tr(),
              value: isDark,
              activeColor: Colors.brown,
              onChanged: (value) {
                setState(() {
                  isDark = value;
                });
                MyApp.of(context)?.toggleTheme(value); //main 다크모드 메서드 호출
              },
              shape: RoundedRectangleBorder(
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              title: Text(
                'notifications',
                style: TextStyle(fontWeight: FontWeight.w600),
              ).tr(),
              subtitle: Text('notifications_subtitle').tr(),
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
          _buildSectionTitle('app_setting'),
          const SizedBox(height: 12),

          // 언어 선택 카드
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                'language_setting',
                style: TextStyle(fontWeight: FontWeight.w600),
              ).tr(),
              subtitle: Text(
                language,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.brown),
              ),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.brown),
              onTap: _showLanguageDialog,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),

          // 앱 버전 카드
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                'app_version',
                style: TextStyle(fontWeight: FontWeight.w600),
              ).tr(),
              subtitle: const Text('1.0.0'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),

          // 고객센터 카드
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                'customer_service',
                style: TextStyle(fontWeight: FontWeight.w600),
              ).tr(),
              trailing: Icon(Icons.phone_forwarded, color: Colors.brown),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CsPage()));
              },
            ),
          ),

          // 개인정보처리방침 카드
          Card(
            margin: const EdgeInsets.only(bottom: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text(
                'privacy_policy',
                style: TextStyle(fontWeight: FontWeight.w600),
              ).tr(),
              trailing: Icon(Icons.open_in_new, color: Colors.brown),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text('privacy_policy').tr(),
                      content: SingleChildScrollView(
                        child: Text(
                          'privacy_policy_example',
                          style: theme.textTheme.bodyMedium,
                        ).tr(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('close').tr(),
                        ),
                      ],
                    );
                  },
                );
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),

          // 로그아웃 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              label: const Text(
                'logout',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ).tr(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              onPressed: () {
                if (UserSession.isLoggedIn) {
                  UserSession.logout();
                } else {
                  Navigator.pushNamed(context, '/login');
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
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color),
      ).tr(),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('language_selection').tr(),
          children: languagesList.map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: language,
              activeColor: Colors.brown,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  language = value;
                  currentLocale = value == 'English' ? const Locale('en') : const Locale('ko');
                });
                context.setLocale(currentLocale);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
