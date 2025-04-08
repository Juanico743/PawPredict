import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawpredict/services/global.dart';
import 'package:pawpredict/utils/appbar.dart';
import 'package:pawpredict/utils/navbar.dart';
import 'package:http/http.dart' as http;

class DogSymptoms2 extends StatefulWidget {
  const DogSymptoms2({super.key});

  @override
  State<DogSymptoms2> createState() => _DogSymptoms2State();
}

class _DogSymptoms2State extends State<DogSymptoms2> {

  ///
  Map<String, Map<String, dynamic>> questionsCollected = {};
  ///
  List<dynamic>? allQuestionOrder;
  List<dynamic>? questionWithAnswer;

  List<dynamic> questionOrder = [];

  int currentDatasetPosition = 0;

  int answer = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    loadAllQuestion();

    setState(() {
      currentPage = 'Dog Symptoms';
      currentPageTitle = 'Dog Symptoms';
    });
  }

  Future<void> loadQuestion(int questionId, int symptomsId) async {
    Map<String, dynamic> questionTemp = {};
    try {
      String uri = '$serverUri/api/getquestion/';
      var res = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nextQuestion": symptomsId}),
      );

      var response = jsonDecode(res.body);
      //print(res.body);
      if (response["success"] == true) {
        questionTemp['id'] = symptomsId;
        questionTemp['question'] = response["question"];
        questionTemp['description'] = response["question_description"];
        questionTemp['answer'] = 0;
        questionTemp['display description'] = false;

        questionsCollected['Q$questionId'] = questionTemp;



      }
    } catch (e) {
      print(e);
    }
  }


  void loadAllQuestion() async{

    for (int i = 0; i < lineupQuestion.length; i++) {
      int questionId = i + 1;
      int symptomsId = lineupQuestion[i];

      await loadQuestion(questionId, symptomsId);
    }

    setState(() {
      questionsCollected = {
        for (var key in (questionsCollected.keys.toList()
          ..sort((a, b) => int.parse(a.substring(1)).compareTo(int.parse(b.substring(1)))))
        ) key: questionsCollected[key]!
      };
    });



    print(questionsCollected);
    print(questionsCollected.keys);
    print('Total Questions: ${questionsCollected.length}');

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
          elevation: 0,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),





                      // Container(
                      //   width: double.infinity,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     children: [
                      //       SizedBox(height: 20),
                      //       GestureDetector(
                      //         onTap: (){
                      //           loadAllQuestion();
                      //         },
                      //         child: Container(
                      //           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      //           decoration: BoxDecoration(
                      //             color: Color(0xFF1DCFC1),
                      //             borderRadius: BorderRadius.circular(50),
                      //             border: Border.all(
                      //               width: 2,
                      //               color: Color(0xFF1DCFC1),
                      //             ),
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.black.withOpacity(0.2),
                      //                 spreadRadius: 2,
                      //                 blurRadius: 2,
                      //                 offset: Offset(0, 2),
                      //               ),
                      //             ],
                      //           ),
                      //           child: Text(
                      //             'Show',
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //               fontFamily: 'Lexend',
                      //               fontWeight: FontWeight.w700,
                      //               fontSize: 16.0,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 20),
                      //     ],
                      //   ),
                      // ),



                      Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: questionsCollected.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if ('Q${index + 1}' == 'Q1' || questionsCollected['Q$index']!['answer'] != 0)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),

                                        Container(
                                          height: 50,
                                          width: 65,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                right: 0,
                                                child: Container(
                                                  height: 50.0,
                                                  width: 60.0,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage('assets/images/numbering.png'),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                child: Text(
                                                  'Q${index + 1}',
                                                  style: TextStyle(
                                                      color: Color(0xFF1DCFC1),
                                                      fontFamily: 'Lexend',
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 24.0,
                                                      shadows: [
                                                        Shadow( // bottomLeft
                                                            offset: Offset(-2, -2),
                                                            color: Colors.white
                                                        ),
                                                        Shadow( // bottomRight
                                                            offset: Offset(2, -2),
                                                            color: Colors.white
                                                        ),
                                                        Shadow( // topRight
                                                            offset: Offset(2, 2),
                                                            color: Colors.white
                                                        ),
                                                        Shadow( // topLeft
                                                            offset: Offset(-2, 2),
                                                            color: Colors.white
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap:(){
                                            setState(() {
                                              questionsCollected['Q${index + 1}']!['display description'] = !questionsCollected['Q${index + 1}']!['display description'];
                                            });
                                          },
                                          child: Text(
                                            questionsCollected['Q${index + 1}']!['question'],
                                            style: TextStyle(
                                              color: Color(0xFF091F5C),
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 10),
                                        AnimatedSize(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          child: Visibility(
                                            visible: questionsCollected['Q${index + 1}']!['display description'],
                                            child: Container(
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFCAFFFB),
                                                borderRadius: BorderRadius.circular(15.0),
                                              ),
                                              child: Text(
                                                questionsCollected['Q${index + 1}']!['description'],
                                                style: TextStyle(
                                                  color: Color(0xFF344C9E),
                                                  fontFamily: 'Lexend',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),



                                        SizedBox(height: 10),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            buildRadio(
                                              title: "Yes",
                                              value: 1,
                                              groupValue: questionsCollected['Q${index + 1}']!['answer'],
                                              onChanged: (int newValue) {
                                                setState(() {
                                                  questionsCollected['Q${index + 1}']!['answer'] = newValue;
                                                });
                                              },
                                            ),
                                            buildRadio(
                                              title: "No",
                                              value: 2,
                                              groupValue: questionsCollected['Q${index + 1}']!['answer'],
                                              onChanged: (int newValue) {
                                                setState(() {
                                                  questionsCollected['Q${index + 1}']!['answer'] = newValue;
                                                });
                                              },
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 30),
                                      ],

                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildText({
    required String text,
  }) {
    return Container(
      width: double.infinity,
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF091F5C),
          fontFamily:'Lexend',
          fontWeight: FontWeight.w700,
          fontSize: 20.0,
        ),
      ),
    );
  }
  Widget expandableDescription({
    required String title,
    required String description,
    required double height,
    required ValueChanged<bool> onExpansionChanged,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          expansionTileTheme: ExpansionTileThemeData(
            iconColor: Colors.transparent,
            collapsedIconColor: Colors.transparent,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
          ),
        ),
        child: SizedBox(
          child: ExpansionTile(
            title: Text(
              ' ',
              style: TextStyle(
                  color: Colors.green,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w700,
                  fontSize: 1.0,
                  height: height
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
                  borderRadius: BorderRadius.circular(15.0),
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
      ),
    );
  }

  Widget buildRadio({
    required String title,
    required int value,
    required int groupValue,
    required ValueChanged<int> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        width: 100,
        height: 45,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: groupValue == value ? Color(0xFF4A6FD7) : Color(0xFFEBEFFB),
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            color: groupValue == value ? Color(0xFF4A6FD7) : Color(0xFF4A6FD7),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Lexend',
              color: groupValue == value ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
