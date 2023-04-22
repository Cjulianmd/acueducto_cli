import 'dart:async';

import 'package:acueducto_cli/home/person.dart';
import 'package:acueducto_cli/home/result.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'animacion.dart';
import 'detalles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<String> imagePaths = [
    '../lib/assets/1.png',
    '../lib/assets/2.png',
    '../lib/assets/3.png',
    '../lib/assets/4.png',
  ];
  PageController _pageController = PageController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 7), (_) {
      if (_pageController.page == imagePaths.length - 1) {
        _stopTimer();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Home()),
        );
      } else {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _stopTimer() async {
    _timer?.cancel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showed_welcome_screen', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (_pageController.page == imagePaths.length - 1) {
            _stopTimer();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Welcomeanimation()),
            );
          } else {
            _pageController.nextPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          }
        },
        child: PageView.builder(
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            return Image.asset(
              imagePaths[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          },
          controller: _pageController,
        ),
      ),
    );
  }
}
