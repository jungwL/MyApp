import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:studyex04/models/UserQna.dart';
import '../../models/user_session.dart';
import '../login/login.dart';
import '../../widgets/customDrawer.dart';
import '../../widgets/customAppBar.dart';
import '../../widgets/customBottomNai.dart';
import '../../core/CsPageList.dart';

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
                color: Theme.of(context).textTheme.bodyMedium?.color,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'customer_center',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ).tr(),
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
            tabs: [
              Tab(text: '1:1_inquiry'.tr()),
              Tab(text: 'customer_compliments'.tr()),
              Tab(text: 'faq'.tr()),
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
  final TextEditingController _emailController = TextEditingController(); //이메일

  final _formKey = GlobalKey<FormState>();

  String selectedConsultType = '문의';
  String selectedContentType = '제품';

  //전화번호 기반 1:1문의 리스트 비동기 호출
  Future<void> fetchInquiryList(String phone) async {
    final url = Uri.parse(dotenv.env['LOGIN_API_URL']!);
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
          Uri.parse(dotenv.env['SUBMIT_INQUIRYLIST_API_URL']!),
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
          ).showSnackBar(const SnackBar(
              content: Text('1:1문의 등록이 완료되었습니다.'),
              backgroundColor: Colors.green,
            )
          );
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
  // 문의 내역 삭제하기
  Future<void> _deleteInquiry(DateTime addtime , String phone) async {
     final url = Uri.parse('http://localhost:8080/api/qna/delete?addtime=${addtime.toIso8601String()}&phone=$phone');
     print('addtime 값 : ${addtime.toIso8601String()}');
     try {
       final response = await http.delete(url);

       if(response.statusCode == 200) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
           content: Text('삭제가 완료되었습니다.'),
           backgroundColor: Colors.green,
           )
         );
         fetchInquiryList(phone);
       } else {
         print('1대1문의 삭제 실패시 : ${response.statusCode}');
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
           content: Text('삭제에 실패했습니다.'),
           backgroundColor: Colors.red,
         ));
       }
     } catch (e) {
       print('오류 발생: \$e');
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('네트워크 오류')));
     }

  }
  //정말로 삭제하시겠습니까 팝업창
// 팝업창 함수
  void _showDeleteConfirmationDialog(BuildContext context, DateTime addtime, String phone) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
              "삭제 확인",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(
              "정말로 삭제하시겠습니까?",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // 취소
              },
              child: Text(
                  "취소",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // 확인
              },
              child: Text(
                  "삭제",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color
                ),
              ),
            ),
          ],
        );
      },
    );//확인 선택시
    if (confirmDelete == true) {
      _deleteInquiry(addtime, phone); // 실제 삭제 실행
    }
  }
  //1대1문의 폼 팝업창
  void _showInquiryForm() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                            color: Theme.of(context).textTheme.bodyMedium?.color, // 포인트 컬러
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

                        // 이름(readOnly)
                        TextFormField(
                          controller: TextEditingController(
                            text : UserSession.currentUser!.userName,
                          ),
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: '이름',
                            labelStyle: const TextStyle(color: Colors.grey),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0
                              )
                            )
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        // 전화번호 (readOnly)
                        TextFormField(
                          controller: TextEditingController(
                            text: UserSession.currentUser!.phoneNumber,
                          ),
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: '전화번호',
                            labelStyle: const TextStyle(color: Colors.grey),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                          ),
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
                              child: Text('취소',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
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
      labelStyle: TextStyle(
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  //1대1문의 하기 버튼 선택시
  void _onInquiryButtonPressed() {
    if (!UserSession.isLoggedIn) { //로그인 안ㄷ되어있을경우
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else { //로그인 되어있을경우 폼창 호출
      _showInquiryForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        const Text(
          '1:1_inquiry',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ).tr(),
        const SizedBox(height: 20),
        const Text(
          '1:1_inquiry_sub',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ).tr(),
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
            '1:1_inquiry_go',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ).tr(),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: UserSession.isLoggedIn
              ? (inquiryList.isEmpty
                    ? Center(child: Text('inquiry_No_List').tr()) // 문의 내역이 없을 경우
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
                              IconButton(
                                onPressed: () { //삭제버튼 클릭시
                                  _showDeleteConfirmationDialog(context,inquiry.addTime,UserSession.currentUser!.phoneNumber);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    )
              : Center(child: Text('inquiry_List_Login').tr()), //비로그인시
        ),
      ],
    );
  }
}
//정말로 삭제하시겠습니까 팝업창

//고객칭찬 탭
class PraiseTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          const Text(
            'customer_compliments',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ).tr(),
          const SizedBox(height: 20),
          const Text(
            'customer_compliments_sub',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ).tr(),
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        Text(
          'faq',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ).tr(),
        SizedBox(height: 20),
        Text(
          'faq_sub',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ).tr(),
        SizedBox(height: 30),
        Divider(thickness: 1),
        Expanded(
          child: ListView.builder(
            itemCount: faqList.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text(
                  faqList[index]['question']!, //질문 정보
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
                      faqList[index]['answer']!, //답변정보
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
