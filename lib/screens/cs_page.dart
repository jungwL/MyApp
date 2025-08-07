import 'package:flutter/material.dart';
import '../models/user_session.dart';
import 'login.dart';
import '../widgets/customDrawer.dart';
import '../widgets/customAppBar.dart';
import '../widgets/customBottomNai.dart';

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
              const SizedBox(width: 48,)
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
  List<String> inquiryList = [

  ]; // 예시 데이터. 실제로는 API로 가져오면 됨.

  void _showInquiryForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String inquiryText = '';
        String title = '';
        String name = '';
        String phone = '';
        String email = '';
        String selectedConsultType = '문의';
        String selectedContentType = '제품';

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '1:1 문의 작성',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // 상담유형
                DropdownButtonFormField<String>(
                  value: selectedConsultType,
                  items: ['칭찬', '불만', '문의', '제안', '정보'].map((String type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedConsultType = value;
                    }
                  },
                  decoration: const InputDecoration(labelText: '상담유형'),
                ),

                // 내용유형
                DropdownButtonFormField<String>(
                  value: selectedContentType,
                  items: [
                    '제품',
                    '모바일쿠폰',
                    '인적서비스',
                    '정보서비스',
                    '이벤트',
                    '기타'
                  ].map((String type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedContentType = value;
                    }
                  },
                  decoration: const InputDecoration(labelText: '내용유형'),
                ),

                // 제목
                TextFormField(
                  onChanged: (value) => title = value,
                  decoration: const InputDecoration(labelText: '제목'),
                ),

                // 내용
                TextFormField(
                  onChanged: (value) => inquiryText = value,
                  decoration: const InputDecoration(labelText: '문의 내용'),
                  maxLines: 4,
                ),

                // 이름
                TextFormField(
                  onChanged: (value) => name = value,
                  decoration: const InputDecoration(labelText: '이름'),
                ),

                // 전화번호
                TextFormField(
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => phone = value,
                  decoration: const InputDecoration(labelText: '전화번호'),
                ),

                // 이메일
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => email = value,
                  decoration: const InputDecoration(labelText: '이메일'),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (inquiryText.isNotEmpty) {
                          setState(() {
                            inquiryList.insert(
                              0,
                              '${DateTime.now().toString().substring(0, 10)} : [$title] $inquiryText',
                            );
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('등록'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }


  void _onInquiryButtonPressed() {
    if (!UserSession.isLoggedIn) {
      // 로그인 안 되어 있으면 로그인 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      // 로그인 되어 있으면 바로 문의 폼 띄움
      _showInquiryForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        Text(
          '1:1 문의',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          '신속히 답변 드리겠습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(height: 30),
        Divider(thickness: 1),
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
        UserSession.isLoggedIn
            ? Expanded(
                child: inquiryList.isEmpty
                    ? const Center(child: Text('문의 내역이 없습니다.'))
                    : ListView.builder(
                        itemCount: inquiryList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.blue,
                            ),
                            title: Text(inquiryList[index]),
                          );
                        },
                      ),
              )
            : const Expanded(
                child: Center(child: Text('문의 내역을 보시려면 로그인 해주세요.')),
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
            '서울바게트 칭찬점포를 소개합니다. 고객 여러분의 칭찬과 격려에 감사 드립니다!',
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
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            const Icon(Icons.location_on, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                store['location']!,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
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
      'answer':
      '모바일금액권은 액면가액과 동일하거나 그 이상만 결제할 수 있습니다. 교환권은 최대 6개까지 사용 가능합니다.',
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
    {
      'question': '비닐 봉투는 유상 제공인가요?',
      'answer': '담당자와 상담을 통해 자세히 안내받으실 수 있습니다.',
    },
    {
      'question': '멤버십 적립은 어떻게 하나요?',
      'answer': '담당자와 상담을 통해 자세히 안내받으실 수 있습니다.',
    },
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
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

