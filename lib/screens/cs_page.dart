import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studyex04/models/UserQna.dart';
import '../models/user_session.dart';
import 'login.dart';
import '../widgets/customDrawer.dart';
import '../widgets/customAppBar.dart';
import '../widgets/customBottomNai.dart';
import '../models/user_session.dart';

class CsPage extends StatefulWidget {
  const CsPage({super.key});

  @override
  State<CsPage> createState() => _CsPageState();
}

class _CsPageState extends State<CsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: Customdrawer(),
      body: Column(
        children: [
          const SizedBox(height: 20),
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
                    '고객센터',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          TabBar(
            controller: _tabController,
            labelColor: Colors.brown,
            indicatorColor: Colors.brown,
            tabs: const [
              Tab(text: '1:1 문의'),
              Tab(text: '고객칭찬'),
              Tab(text: '자주하는 질문'),
            ],
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [InquiryTab(), PraiseTab(), FAQTab()],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Custombottomnai(),
    );
  }
}

//1대1문의 탭
class InquiryTab extends StatefulWidget {
  @override
  State<InquiryTab> createState() => _InquiryTabState();
}

class _InquiryTabState extends State<InquiryTab> {
  List<UserQna> inquiryList = [];

  @override
  void initState() {
    super.initState();

    final phone = UserSession.currentUser?.phoneNumber ?? '';
    if (phone.isNotEmpty) {
      fetchInquiryList(phone);
    }
  }

  //입력값을 받을 변수 선언
  final TextEditingController _titleController = TextEditingController(); //제목
  final TextEditingController _contentController = TextEditingController(); //내용
  final TextEditingController _nameController = TextEditingController(); //이름
  final TextEditingController _phoneController = TextEditingController(); //폰번호
  final TextEditingController _emailController = TextEditingController(); //이메일

  final _formKey = GlobalKey<FormState>();

  String selectedConsultType = '문의';
  String selectedContentType = '제품';

  //전화번호 기반 1:1문의 리스트 비동기 호출
  Future<void> fetchInquiryList(String phone) async {
    final url = Uri.parse('http://localhost:8080/api/qna/list?phone=$phone');
    try {
      final response = await http.get(url);

      print('1대1문의 리스트 응답코드 ${response.statusCode}');
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<UserQna> loadedList = jsonList
            .map((item) => UserQna.fromJson(item as Map<String, dynamic>))
            .toList();
        setState(() {
          inquiryList = loadedList;
        });
        print('첫 번째 문의 날짜: ${inquiryList[0].addTime}');
      }else {
        print('문의 내역이 없습니다.');
      }
    } catch (e) {
      print('문의 목록 불러오기 실패: $e');
    }
  }

  // 1대1 문의 등록 비동기 함수
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse("http://localhost:8080/api/qna"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'consultType': selectedConsultType,
            'contentType': selectedContentType,
            'title': _titleController.text.trim(),
            'content': _contentController.text.trim(),
            'name': _nameController.text.trim(),
            'phone': UserSession.currentUser!.phoneNumber,
            'email': _emailController.text.trim(),
            'addTime': DateTime.now().toIso8601String(),//현재입력된 시간을 String 값으로 형변환해서 넘김

          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("등록 완료")));
          // 초기화
          _titleController.clear();
          _contentController.clear();
          _nameController.clear();
          _emailController.clear();
          setState(() {
            selectedConsultType = '문의';
            selectedContentType = '제품';
          });

          // 문의 목록 갱신
          final phone = UserSession.currentUser?.phoneNumber ?? '';
          await fetchInquiryList(phone);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("오류: ${response.statusCode}")));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("통신 실패: $e")));
      }
    }
  }

  void _showInquiryForm() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1:1 문의 작성',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[700], // 포인트 컬러
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 상담유형
                        DropdownButtonFormField<String>(
                          value: selectedConsultType,
                          items: ['칭찬', '불만', '문의', '제안', '정보']
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setStateDialog(() {
                                selectedConsultType = value;
                              });
                            }
                          },
                          decoration: _inputDecoration('상담유형'),
                        ),
                        const SizedBox(height: 16),

                        // 내용유형
                        DropdownButtonFormField<String>(
                          value: selectedContentType,
                          items: ['제품', '모바일쿠폰', '인적서비스', '정보서비스', '이벤트', '기타']
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setStateDialog(() {
                                selectedContentType = value;
                              });
                            }
                          },
                          decoration: _inputDecoration('내용유형'),
                        ),
                        const SizedBox(height: 16),

                        // 제목
                        TextFormField(
                          controller: _titleController,
                          decoration: _inputDecoration('제목'),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? '제목을 입력해주세요.'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // 문의내용
                        TextFormField(
                          controller: _contentController,
                          decoration: _inputDecoration('문의 내용'),
                          maxLines: 4,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? '문의 내용을 입력해주세요.'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // 이름
                        TextFormField(
                          controller: _nameController,
                          decoration: _inputDecoration('이름'),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? '이름을 입력해주세요.'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // 전화번호 (readOnly)
                        TextFormField(
                          controller: TextEditingController(
                            text: _formatPhoneNumber(
                              UserSession.currentUser!.phoneNumber,
                            ),
                          ),
                          readOnly: true,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration('전화번호'),
                        ),
                        const SizedBox(height: 16),

                        // 이메일
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration('이메일'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '이메일을 입력해주세요.';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value.trim())) {
                              return '유효한 이메일을 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // 버튼
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                side: BorderSide(color: Colors.brown[300]!),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('취소'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown[400],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await _submit();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text(
                                '등록',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 공통 Input 스타일 함
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.brown[400]!),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // 전화번호 포맷 함수
  String _formatPhoneNumber(String phone) {
    String digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
    }
    return phone;
  }

  void _onInquiryButtonPressed() {
    if (!UserSession.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      _showInquiryForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        const Text(
          '1:1 문의',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          '신속히 답변 드리겠습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        const Divider(thickness: 1),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _onInquiryButtonPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            '1:1 문의 하기',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: UserSession.isLoggedIn
              ? (inquiryList.isEmpty
                    ? const Center(child: Text('문의 내역이 없습니다.')) // 문의 내역이 없을 경우
                    : ListView.builder(
                        // 로그인 상태일 경우 && inquiryList에 값이 들어있을 경우 해당 고객의 문의 내역 정보를 가져온다.
                        itemCount: inquiryList.length,
                        itemBuilder: (context, index) {
                          final inquiry = inquiryList[index];
                          return ExpansionTile(
                            leading: Icon(
                              Icons.question_answer,
                              color: Colors.orange.shade200,
                            ),
                            title: Text(
                              '[${inquiry.addTime.year}-${inquiry.addTime.month.toString().padLeft(2, '0')}-${inquiry.addTime.day.toString().padLeft(2, '0')}] 제목 : ${inquiry.title}',
                            ),
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '문의 내용 : ${inquiry.content}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    )
              : const Center(child: Text('문의 내역을 보시려면 로그인 해주세요.')), //비로그인시
        ),
      ],
    );
  }
}

//고객칭찬 탭
class PraiseTab extends StatelessWidget {
  final List<Map<String, String>> praiseStores = const [
    {
      'store': '광화문점',
      'location': '서울특별시 종로구 세종대로 23',
      'praise': '직원분들이 매우 친절하고 빵도 항상 신선합니다!',
    },
    {
      'store': '강남점',
      'location': '서울특별시 강남구 강남대로 456',
      'praise': '빠르고 정확한 서비스에 감동했습니다.',
    },
    {
      'store': '홍대점',
      'location': '서울특별시 마포구 홍익로 123',
      'praise': '매장 분위기가 너무 좋고 빵 종류도 다양했어요.',
    },
    {
      'store': '성수점',
      'location': '서울특별시 성동구 성수동 123',
      'praise': '직원분이 매우 친철합니다..',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          const Text(
            '고객칭찬',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            '서울바게트 칭찬점포를 소개합니다.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          const Divider(thickness: 1),

          // 고객칭찬 리스트 추가
          Expanded(
            child: ListView.builder(
              itemCount: praiseStores.length,
              itemBuilder: (context, index) {
                final store = praiseStores[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store['store']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                store['location']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          store['praise']!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 자주하는 질문 탭 (FAQ 아코디언 리스트 추가)
class FAQTab extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      'question': '한 제품 구매 시 여러 개의 교환권을 한번에 사용할 수 있나요?',
      'answer': '모바일금액권은 액면가액과 동일하거나 그 이상만 결제할 수 있습니다. 교환권은 최대 6개까지 사용 가능합니다.',
    },
    {
      'question': '사업설명회를 참석하려면 어떻게 해야 하나요?',
      'answer': '담당자와 상담을 통해 자세히 안내받으실 수 있습니다.',
    },
    {
      'question': '할인 받을 수 있는 카드는 무엇이 있나요?',
      'answer': '담당자와 상담을 통해 자세히 안내받으실 수 있습니다.',
    },
    {
      'question': '매장 정보는 어떻게 알수 있나요?',
      'answer': '담당자와 상담을 통해 자세히 안내받으실 수 있습니다.',
    },
    {'question': '비닐 봉투는 유상 제공인가요?', 'answer': '담당자와 상담을 통해 자세히 안내받으실 수 있습니다.'},
    {'question': '멤버십 적립은 어떻게 하나요?', 'answer': '담당자와 상담을 통해 자세히 안내받으실 수 있습니다.'},
    {
      'question': '마진율 및 수익구조는 어떻게 되나요?',
      'answer': '담당자와 상담을 통해 자세히 안내받으실 수 있습니다.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        Text(
          '자주하는 질문',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          '아래 질문 내용을 확인 해주세요.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(height: 30),
        Divider(thickness: 1),
        Expanded(
          child: ListView.builder(
            itemCount: faqList.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text(
                  faqList[index]['question']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.brown[100],
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      faqList[index]['answer']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
