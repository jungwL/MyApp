import 'package:flutter/material.dart';
import 'password_change_page.dart';
import 'address_change_page.dart';
import '../homepage.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('마이페이지', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '내 정보 관리',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '비밀번호 또는 주소지를 변경할 수 있습니다.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildActionButton(
              icon: Icons.lock_outline,
              label: '비밀번호 변경',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PasswordChangePage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              icon: Icons.location_on_outlined,
              label: '주소지 변경',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddressChangePage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              icon: Icons.apps,
              label: '아이콘 둘러보기',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IconShowcasePage()),
                );
              },
            ),
            const SizedBox(height: 40),

            // 홈으로 돌아가기 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home_outlined),
                label: const Text('홈으로 돌아가기', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                        (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class IconShowcasePage extends StatelessWidget {
  const IconShowcasePage({super.key});

  final List<Map<String, dynamic>> _iconList = const [
    {'icon': Icons.home, 'name': 'home'},
    {'icon': Icons.menu, 'name': 'menu'},
    {'icon': Icons.settings, 'name': 'settings'},
    {'icon': Icons.search, 'name': 'search'},
    {'icon': Icons.account_circle, 'name': 'account_circle'},
    {'icon': Icons.logout, 'name': 'logout'},
    {'icon': Icons.phone, 'name': 'phone'},
    {'icon': Icons.email, 'name': 'email'},
    {'icon': Icons.support_agent, 'name': 'support_agent'},
    {'icon': Icons.chat, 'name': 'chat'},
    {'icon': Icons.message, 'name': 'message'},
    {'icon': Icons.location_on, 'name': 'location_on'},
    {'icon': Icons.map, 'name': 'map'},
    {'icon': Icons.access_time, 'name': 'access_time'},
    {'icon': Icons.calendar_today, 'name': 'calendar_today'},
    {'icon': Icons.wb_sunny, 'name': 'wb_sunny'},
    {'icon': Icons.notifications, 'name': 'notifications'},
    {'icon': Icons.sms, 'name': 'sms'},
    {'icon': Icons.announcement, 'name': 'announcement'},
    {'icon': Icons.forum, 'name': 'forum'},
    {'icon': Icons.favorite, 'name': 'favorite'},
    {'icon': Icons.star, 'name': 'star'},
    {'icon': Icons.thumb_up, 'name': 'thumb_up'},
    {'icon': Icons.bookmark, 'name': 'bookmark'},
    {'icon': Icons.image, 'name': 'image'},
    {'icon': Icons.picture_as_pdf, 'name': 'picture_as_pdf'},
    {'icon': Icons.upload_file, 'name': 'upload_file'},
    {'icon': Icons.video_library, 'name': 'video_library'},
    {'icon': Icons.edit, 'name': 'edit'},
    {'icon': Icons.delete, 'name': 'delete'},
    {'icon': Icons.check_circle, 'name': 'check_circle'},
    {'icon': Icons.error, 'name': 'error'},
    {'icon': Icons.lock, 'name': 'lock'},
    {'icon': Icons.share, 'name': 'share'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('주요 아이콘 리스트')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: _iconList.length,
          itemBuilder: (context, index) {
            final item = _iconList[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item['icon'], size: 40, color: Colors.blueAccent),
                const SizedBox(height: 8),
                Text(item['name'], textAlign: TextAlign.center),
              ],
            );
          },
        ),
      ),
    );
  }
}
