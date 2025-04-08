import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/findings');
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                margin: EdgeInsets.only(bottom: 20),
                child: Lottie.asset(
                  "assets/animations/loading-design.json",
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                height: 200,
                width: 400,
                margin: EdgeInsets.only(bottom: 20),
                child: Lottie.asset(
                  "assets/animations/loading-dots.json",
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                'Loading, please wait...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
