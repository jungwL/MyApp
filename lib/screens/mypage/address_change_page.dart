import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:studyex04/models/User.dart';
import 'package:studyex04/models/user_session.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AddressChangePage extends StatefulWidget {
  const AddressChangePage({super.key});

  @override
  State<AddressChangePage> createState() => _AddressChangePageState();
}

class _AddressChangePageState extends State<AddressChangePage> {
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  String address = UserSession.currentUser!.userAddress;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }
  //주소목록
  Future<void> _fetchAddresses() async {
    final String url = 'http://localhost:8080/api/getAddress?phoneNumber=${UserSession.currentUser!.phoneNumber}';
    print('주소지 가져오기 호출 $url');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final user = User.fromJson(json.decode(response.body));
        setState(() {
          address = user.userAddress;
        });
        print('가져온 주소 : $address');
      } else {
        throw Exception('Failed to fetch addresses');
      }
    } catch (e) {
      print('오류 발생: \ $e');
    }
  }

  //API 비동기 호출
  Future<void> _changeAddress() async {
    final String url = dotenv.env['CHANGE_ADDRESS_API_URL']!;
    print('주소 변경 API 호출 : $url');
    print('변경 주소값 : ${_addressController.text}');
    print('전화번호 : ${UserSession.currentUser!.phoneNumber}');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'phoneNumber': UserSession.currentUser!.phoneNumber,
          'userAddress': _addressController.text,
        },)
      );
      if (response.statusCode == 200) {
        _showSnackBar('주소가 변경되었습니다.');
        final newAddress = _addressController.text;

        setState(() {
          Navigator.pop(context, newAddress);
        });


      }else{
        _showSnackBar('주소 변경에 실패하였습니다.');
      }
    } catch (e) {
      print('오류 발생: \ $e');
    }
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
              '현재 주소',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('${address}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            SizedBox(height: 20,),
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
              child: TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: '주소 입력',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '주소를 입력해주세요.';
                  }else {
                    return null;
                  }
                }
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
                icon: const Icon(Icons.check_circle_outline,color: Colors.white,),
                label: const Text('변경 완료',
                  style: TextStyle(
                    color: Colors.white
                  ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: (){
                  _changeAddress(); //비동기함수 호출
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
