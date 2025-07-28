import 'package:flutter/material.dart';

class AddressChangePage extends StatefulWidget {
  const AddressChangePage({super.key});

  @override
  State<AddressChangePage> createState() => _AddressChangePageState();
}

class _AddressChangePageState extends State<AddressChangePage> {
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  // 👉 카카오 API 제거하고 직접 주소 입력하게 변경
  void _inputAddressManually() async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) {
        String temp = '';
        return AlertDialog(
          title: const Text('주소 입력'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: '주소를 입력하세요'),
            onChanged: (val) => temp = val,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(temp),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        _addressController.text = result.trim();
      });
    }
  }

  // 👉 실제 서버 연동 없이 UI 테스트용 처리
  Future<void> _changeAddress() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      _showSnackBar('주소를 입력해주세요');
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // 로딩 시뮬레이션

    setState(() => _isLoading = false);

    _showDialog('주소 변경 완료', '주소지가 성공적으로 변경되었습니다.');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('확인'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('주소지 변경'),
        elevation: 0.5,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '주소지를 변경하세요',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // 주소 입력 카드
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _addressController,
                readOnly: true,
                onTap: _inputAddressManually,
                decoration: InputDecoration(
                  labelText: '주소 입력',
                  hintText: '주소를 직접 입력하려면 클릭하세요',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 변경 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('변경 완료'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _changeAddress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
