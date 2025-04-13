import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawpredict/services/global.dart';


class Navbar extends StatelessWidget {
  const Navbar({super.key});


  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: double.infinity,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                },
                child: Container(
                  color: Colors.transparent,
                ),
              );
            },
          ),
          Container(
            height: 520,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(70.0),
                bottomLeft: Radius.circular(10.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          return TextButton(
                            onPressed: (){
                              Scaffold.of(context).closeDrawer();
                            },
                            child: Image(
                              image: AssetImage('assets/images/icons/close.png'),
                              width: 15,
                              height: 15,
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 110,
                  width: 250,
                  child: Center(
                    child: Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage('assets/images/PawPredict-logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                Container(height: 30.0),

                lineCut(),
                navButtons(
                  title: 'Home',
                  titleColor: Color(0xFF1DCFC1),
                  underlineColor: Color(0xFF1DCFC1),
                  underlineWidth: 70,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/home');
                  }
                ),
                lineCut(),
                navButtons(
                  title: 'About',
                  titleColor: Color(0xFF091F5C),
                  underlineColor: Colors.transparent,
                  underlineWidth: 70,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/about');
                  }
                ),
                lineCut(),
                navButtons(
                  title: 'Help Center',
                  titleColor: Color(0xFF091F5C),
                  underlineColor: Colors.transparent,
                  underlineWidth: 130,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/help');
                  }
                ),
                lineCut(),
                navButtons(
                  title: 'Map',
                  titleColor: Color(0xFF091F5C),
                  underlineColor: Colors.transparent,
                  underlineWidth: 100,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/all-vet-map' );
                  }
                ),
                lineCut(),
                navButtons(
                  title: 'Exit',
                  titleColor: Color(0xFF091F5C),
                  underlineColor: Colors.transparent,
                  underlineWidth: 50,
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return Center(
                          child: Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                                  margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(100.0),
                                      topLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(15.0),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          'Exit',
                                          style: TextStyle(
                                            color: Color(0xFF1DCFC1),
                                            fontFamily:'Lexend',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 30.0,
                                          ),
                                        ),
                                      ),

                                      Container(
                                        height: 200.0,
                                        width: 200.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            image: AssetImage('assets/images/exit-dog.png'),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),

                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          'Do You Want To Exit The App?',
                                          style: TextStyle(
                                            fontFamily: 'Lexend',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [

                                          GestureDetector(
                                            onTap: (){
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(50),
                                                border: Border.all(
                                                  width: 2,
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
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                  color: Color(0xFF1DCFC1),
                                                  fontFamily: 'Lexend',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ),


                                          GestureDetector(
                                            onTap: (){
                                              SystemNavigator.pop();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: Color(0xFF1DCFC1),
                                                borderRadius: BorderRadius.circular(50),
                                                border: Border.all(
                                                  width: 2,
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
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Lexend',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                ),
                lineCut(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget navButtons({
    required String title,
    required VoidCallback onPressed,
    required titleColor ,
    required double underlineWidth,
    required Color underlineColor,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontFamily:'Lexend',
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
            ),
            Container(
              height: 4.0,
              width: underlineWidth,
              decoration: BoxDecoration(
                color: underlineColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget lineCut() {
    return Container(
      height: 1.0,
      width: 225,
      margin: EdgeInsets.symmetric(vertical: 4.0),
      color: Color(0x11000000),
    );
  }
}
