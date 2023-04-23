import 'dart:async';

import 'package:acueducto_cli/home/home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Welcomeanimation extends StatefulWidget {
  @override
  _WelcomeanimationState createState() => _WelcomeanimationState();
}

class _WelcomeanimationState extends State<Welcomeanimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    Future.delayed(Duration(seconds: 15)).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Home()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          double titleFontSize = screenWidth * 0.09;
          double subTitleFontSize = screenWidth * 0.05;
          double imageHeight = screenHeight * 0.3;
          double textPadding = screenWidth * 0.05;
          return Container(
            padding: EdgeInsets.all(textPadding),
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'Bienvenido',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.1),
                        Flexible(
                          child: Container(
                            height: imageHeight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Lottie.asset(
                              './lib/assets/wc.json',
                              controller: _controller,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.08),
                        Text(
                          'Asociación de Usuarios Acueducto',
                          style: TextStyle(
                            fontSize: subTitleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Veredal La Unión - Bello',
                          style: TextStyle(
                            fontSize: subTitleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
