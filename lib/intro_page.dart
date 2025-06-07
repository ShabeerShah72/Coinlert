import 'dart:async';
import 'package:coinlert/home_page.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageSrate();
}

class _IntroPageSrate extends State<IntroPage> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Image.asset('lib/assets/logo/Coinlert.png',
          width:170,
          height: 170,
            ),
          ),
        )
    );
  }
}
