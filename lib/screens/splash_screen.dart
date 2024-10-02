import 'package:flutter/material.dart';
import 'package:flutter_listing_app/constants/dimensions.dart';
import 'package:flutter_listing_app/screens/homepage.dart';
import 'package:gap/gap.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Homepage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo/logo 2.png",
              height: 100 * Dimensions.heightF(context),
              width: 150 * Dimensions.widthP(context),
              fit: BoxFit.cover,
            ),
            Gap(40),
            Text(
              "Girman Technologies",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
    );
  }
}
