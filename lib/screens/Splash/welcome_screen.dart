import 'package:company_chat_app_demo/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 700,
                          child: Image.asset(
                            'assets/images/wel-1.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          "Trò chuyện trực tiếp!",
                          style: GoogleFonts.lobster(
                            color: kColorScheme.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 700,
                          child: Image.asset(
                            'assets/images/wel-2.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          "Kết nối với đồng đội!",
                          style: GoogleFonts.lobster(
                            color: kColorScheme.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 600,
                          child: Image.asset(
                            'assets/images/wel-3.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          "Kết nối với đồng đội!",
                          style: GoogleFonts.lobster(
                            color: kColorScheme.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(350, 50),
                              backgroundColor: kColorScheme.primary,
                              foregroundColor: kColorScheme.onPrimary),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed("/Login");
                          },
                          child: Text(
                            "Bắt đầu ngay",
                            style: GoogleFonts.lobster(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: const WormEffect(
                dotHeight: 16,
                dotWidth: 16,
                type: WormType.normal,
                activeDotColor: Color.fromARGB(255, 207, 46, 46),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
