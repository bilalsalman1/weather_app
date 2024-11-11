import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/screen/weather_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => WeatherHomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.asset('assets/weather.png'),
          const SizedBox(
            height: 50,
          ),
          Text(
            'Weather',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50),
          ),
          Text(
            'ForeCasts',
            style: GoogleFonts.poppins(
                color: const Color(0xffDDB130),
                fontWeight: FontWeight.bold,
                fontSize: 50),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    ));
  }
}
