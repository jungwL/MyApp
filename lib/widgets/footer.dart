import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3A3E47),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Info + Logo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Info",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    FooterLink(
                      "브랜드 소개"
                    ),
                    FooterLink("회사 소개"),
                    FooterLink("창업안내"),
                    FooterLink("B2B 주문 및 문의"),
                    FooterLink("안전보건경영방침"),
                    FooterLink("거래희망사전등록"),
                    FooterLink("윤리신고센터"),
                    FooterLink("채용"),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(width: 20),
              // Contact Us + Follow Us
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Contact Us",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    FooterLink(
                        "고객센터"
                    ),
                    const FooterText("010-1234-5678"),
                    const FooterText("평일 09:00 - 17:00"),
                    const FooterText("(점심 12:00 - 13:00)"),
                    const FooterText("고객칭찬"),
                    const SizedBox(height: 20),
                    const Text(
                      "Follow Us",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(FontAwesomeIcons.facebookF, color: Colors.white),
                        SizedBox(width: 15),
                        Icon(FontAwesomeIcons.instagram, color: Colors.white),
                        SizedBox(width: 15),
                        Icon(FontAwesomeIcons.youtube, color: Colors.white),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          ImageFooter(), // 이미지 추가 위치
          const SizedBox(height: 10),
          const Text(
            "All Rights Reserved © SEOUL BAGUETTE, Seoul CROISSANT",
            style: TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          const Text(
            "서울특별시 종로구 세종대로 175 (광화문)",
            style: TextStyle(color: Colors.white54, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// 이미지 영역 분리
class ImageFooter extends StatelessWidget {
  const ImageFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/Logo1.png',
      width: 200,
      height: 100,
    );
  }
}

class FooterLink extends StatelessWidget {
  final String text;
  const FooterLink(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 14),
    );
  }
}

class FooterText extends StatelessWidget {
  final String text;
  const FooterText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 14),
    );
  }
}
