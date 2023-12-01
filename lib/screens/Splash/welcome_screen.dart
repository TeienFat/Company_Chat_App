import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imgList = [
  'Image.asset("assets/images/hinh1.png")',
  'Image.asset("assets/images/hinh2.png")',
  'Image.asset("assets/images/hinh3.png")',
];

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
              Padding(
                padding: EdgeInsets.all(20),
              ),
              CarouselSlider(
                  items: imgList
                      .map(
                        (item) => Container(
                          child: Image.asset(
                            item,
                            width: 20,
                          ),
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      height: 400)),
              SizedBox(
                height: 250,
              ),
              ElevatedButton(onPressed: () {}, child: Text('Bắt Đầu'))
            ],
          ),
        ));
  }
}
