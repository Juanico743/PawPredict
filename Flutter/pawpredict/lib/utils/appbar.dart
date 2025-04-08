import 'package:flutter/material.dart';
import 'package:pawpredict/services/global.dart';

class Appbar extends StatelessWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Image(
            image: AssetImage('assets/images/background/wave-w.png'),
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
        ),

        Positioned(
          top: 0,
          right: 10,
          child: Opacity(
            opacity: 0.7,
            child: Image(
              image: AssetImage('assets/images/background/paw.png'),
              width: 80,
              height: 80,
              fit: BoxFit.fill,
            ),
          ),
        ),


        Positioned(
          bottom: 10,
          left: 20,
          child: Text(
            currentPageTitle!,
            style: TextStyle(
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),

        Positioned(
          top: 0,
          left: 0,
          child: Builder(
            builder: (BuildContext context) {
              return TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Image(
                  image: AssetImage('assets/images/icons/back.png'),
                  width: 30,
                  height: 30,
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
        ),
      ]
    );
  }
}
