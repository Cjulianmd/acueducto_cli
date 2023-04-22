import 'dart:async';

import 'package:acueducto_cli/home/home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Welcomeanimation extends StatefulWidget {
  @override
  _Welcomeanimation createState() => _Welcomeanimation();
}

class _Welcomeanimation extends State<Welcomeanimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    Future.delayed(Duration(seconds: 5))
        .then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Home()),
            ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 125, 184),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
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
              SizedBox(height: 20),
              Flexible(
                child: Text(
                  'Asociación de Usuarios Acueducto',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Flexible(
                child: Text(
                  'Veredal La Unión - Bello',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






//../lib/assets/83863-dripping-water-faucet.json