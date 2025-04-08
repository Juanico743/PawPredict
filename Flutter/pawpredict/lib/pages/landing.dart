


import 'package:flutter/material.dart';
import 'package:pawpredict/services/global.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image(
              image: AssetImage('assets/images/background/wave.png'),
              width: 250,
              height: 250,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image(
              image: AssetImage('assets/images/background/dogb.png'),
              width: 320,
              height: 320,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  height: 300.0,
                  width: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage('assets/images/PawPredict-logo.png'),
                      fit: BoxFit.contain,),
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        width: double.infinity,
                        child: Text(
                          'Proactive Pet Care \nStarts Here.',
                          style: TextStyle(
                            color: Color(0xFF091F5C),
                            fontFamily:'Podkova',
                            fontWeight: FontWeight.w700,
                            fontSize: 30.0,
                            height: 1
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        width: double.infinity,
                        child: Text(
                          'Catch potential health issues \nbefore they become serious.',
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontFamily:'Lexend',
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                            height: 1
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 3,
                        color: Color(0xFF1DCFC1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Start Now!!',
                        style: TextStyle(
                          color: Color(0xFF1DCFC1),
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  width: double.infinity,
                  color: Color(0xFF9EFFF8),
                  child: Center (
                    child: Text(
                      '© 2025 NJCGA | SCAS - BSCS',
                      style: TextStyle(
                          color: Color(0XFF1E1E1E),
                          fontFamily: 'lexend'
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

