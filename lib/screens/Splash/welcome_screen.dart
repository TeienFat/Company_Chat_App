import 'package:company_chat_app_demo/main.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final List<String> imgList = [
  'assets/images/hinh1.png',
  'assets/images/hinh2.png',
  'assets/images/hinh3.png',
];

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
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Wido Chat',
            style: TextStyle(fontSize: 19),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: controller,
                  children: [
                    Container(
                      child: Image.asset('assets/images/hinh1.png'),
                    ),
                    Container(
                      child: Image.asset('assets/images/hinh2.png'),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/hinh3.png',
                            height: 700,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Bắt đầu'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SmoothPageIndicator(
                controller: controller,
                count: imgList.length,
                effect: const WormEffect(
                  dotHeight: 14,
                  dotWidth: 14,
                  type: WormType.thinUnderground,
                  activeDotColor: Colors.red,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
