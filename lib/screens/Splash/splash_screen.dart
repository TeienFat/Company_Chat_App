import 'dart:async';

import 'package:company_chat_app_demo/screens/chat_home.dart';
import 'package:company_chat_app_demo/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController_BG;
  late AnimationController _animationController_W;
  late Animation<double> animation_BG;
  late Animation<double> animation_W;

  checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {
      // not first time
      return Timer(_duration, goToNextScreen(false));
    } else {
      // first time
      prefs.setBool('first_time', false);
      return new Timer(_duration, goToNextScreen(true));
    }
  }

  goToNextScreen(bool firstTime) {
    if (firstTime) {
      Navigator.of(context).pushReplacementNamed("/Welcome");
    } else {
      Navigator.of(context).pushReplacementNamed("/Login");
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController_BG = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController_W = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0,
      upperBound: 1,
    );

    animation_BG = CurvedAnimation(
      parent: _animationController_BG,
      curve: Curves.bounceOut,
    );

    animation_W = CurvedAnimation(
      parent: _animationController_W,
      curve: Curves.easeInOutExpo,
    );

    animation_BG.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController_W.forward();
      }
    });

    animation_W.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkFirstTime();
      }
    });
    _animationController_BG.forward();
  }

  @override
  void dispose() {
    _animationController_BG.dispose();
    _animationController_W.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController_BG,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("assets/images/bg-logo.png"),
              Positioned(
                top: 35,
                child: AnimatedBuilder(
                  animation: _animationController_W,
                  child: Image.asset("assets/images/w.png", width: 250),
                  builder: (context, child) => ScaleTransition(
                    scale: animation_W,
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
        builder: (context, child) => SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.3),
            end: const Offset(0, 0),
          ).animate(animation_BG),
          child: child,
        ),
      ),
    );
  }
}
