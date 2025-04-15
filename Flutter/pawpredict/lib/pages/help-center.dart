import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawpredict/services/global.dart';
import 'package:pawpredict/utils/appbar.dart';
import 'package:pawpredict/utils/navbar.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {

  late bool _faq1 = false;
  late bool _faq2 = false;
  late bool _faq3 = false;
  late bool _faq4 = false;
  late bool _faq5 = false;
  late bool _faq6 = false;

  TextEditingController _feedback = TextEditingController();


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    setState(() {
      currentPage = 'help';
      currentPageTitle = 'Help Center';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Navbar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1DCFC1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Appbar(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0, // Removes the shadow
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      width: double.infinity,
                      child: Text(
                        'We\'re here to help you get the most out of our system Here.',
                        style: TextStyle(
                          color: Color(0xFF091F5C),
                          fontFamily:'Podkova',
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          height: 1.2
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      width: double.infinity,
                      child: Text(
                        'Find answers to your questions, learn how to use our app, and troubleshoot any issues you might encounter.',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontFamily:'Lexend',
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              'FAQ',
                              style: TextStyle(
                                color: Color(0xFF091F5C),
                                fontFamily:'Lexend',
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          expandableFAQ(
                            title: 'How does the system work?',
                            description: 'The system collects symptom inputs from users and analyzes them against a database of canine diseases. It can using Logistic Regression Algorithm to predict potential illnesses.',
                            isExpanded: _faq1,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _faq1 = expanded;
                              });
                            },
                          ),
                          SizedBox(height: 8.0),
                          expandableFAQ(
                            title: 'How to input my dog\'s info?',
                            description: 'You can input your information into our system by providing essential details about your dog, such as age, breed, weight and specific symptoms they are experiencing.',
                            isExpanded: _faq2,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _faq2 = expanded;
                              });
                            },
                          ),
                          SizedBox(height: 8.0),
                          expandableFAQ(
                            title: 'What symptoms can I enter?',
                            description: 'You can enter any visible symptoms your dog is experiencing, such as changes in behavior, coughing, vomiting, diarrhea, skin issues, or appetite changes. Be sure to include details on duration and severity for more accurate tracking. ',
                            isExpanded: _faq3,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _faq3 = expanded;
                              });
                            },
                          ),
                          SizedBox(height: 8.0),
                          expandableFAQ(
                            title: 'What do the findings mean?',
                            description: 'The findings provide insights into your dog’s symptoms, helping predict potential health issues. Based on these, the system offers first aid suggestions and guidance on when to seek professional veterinary care.',
                            isExpanded: _faq4,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _faq4 = expanded;
                              });
                            },
                          ),
                          SizedBox(height: 8.0),
                          expandableFAQ(
                            title: 'How do you protect my data?',
                            description: 'The system ensures user data privacy and follows security protocols to protect sensitive information.',
                            isExpanded: _faq5,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _faq5 = expanded;
                              });
                            },
                          ),
                          SizedBox(height: 8.0),
                          expandableFAQ(
                            title: 'What to do if the system fails?',
                            description: 'If the system doesn’t work, check for input errors, refresh or restart the application, ensure a stable internet connection, try a different device or browser, look for updates, report the issue to support, and consult a veterinarian if needed.',
                            isExpanded: _faq6,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _faq6 = expanded;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              'Tutorial & Guides',
                              style: TextStyle(
                                color: Color(0xFF091F5C),
                                fontFamily:'Lexend',
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/tutorials-guides' );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                border: Border.all(
                                  color: Color(0xFF091F5C),
                                  width: 2.0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'How to Use Paw Predict App?',
                                    style: TextStyle(
                                      color: Color(0xFF091F5C),
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 8.0),
                                    child: Image(
                                      image: AssetImage('assets/images/icons/next2.png'),
                                      color: Color(0xFF091F5C),
                                      width: 15,
                                      height: 15,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                      )
                    ),
                    SizedBox(height: 20.0),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              'Feedback & Suggestions',
                              style: TextStyle(
                                color: Color(0xFF091F5C),
                                fontFamily:'Lexend',
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),

                          TextField(
                            controller: _feedback,
                            onChanged: (value) {
                            },
                            maxLines: null,
                            minLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Enter your concern here...',
                              fillColor: Color(0xFFEBEFFB),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Color(0xFF4A6FD7),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Color(0xFF4A6FD7),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                          ),

                          SizedBox(height: 8.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  String email = _feedback.text;
                                  launchUrl(Uri.parse('mailto:pawpredict@gmail.com?subject=Feedback%20%26%20Suggestions&body=$email'));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF091F5C),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)), // Rounded corners
                                  ),
                                  child: Text(
                                    'Send',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]
                      )
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            height: 100.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: AssetImage('assets/images/PawPredict-minimal-logo.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Text(
                            "© 2025 NJCGA || SCAS - BSCS",
                            style: TextStyle(
                                color: Color(0XFF1E1E1E),
                                fontFamily: 'lexend'
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
  Widget expandableFAQ({
    required String title,
    required String description,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF9BFFF2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: TextStyle(
              color: Color(0xFF091F5C),
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          ),
          trailing: Transform.rotate(
            angle: isExpanded ? 45 * math.pi / 180 : 0,
            child: Image(
              image: AssetImage('assets/images/icons/add.png'),
              color: Color(0xFF091F5C),
              width: 13,
              height: 13,
              fit: BoxFit.fill,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          onExpansionChanged: onExpansionChanged,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xFFCAFFFB),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                description,
                style: TextStyle(
                  color: Color(0xFF344C9E),
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
