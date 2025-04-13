import 'dart:convert';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart' as lottie;
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

  final ScrollController _scrollController = ScrollController();
  Map<String, Map<String, dynamic>> questionsCollected = {};
  double progressBarWidth = 0;
  bool answeredAll = false;
  bool questionLoaded = false;

  List<int> allYes = [];


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    loadAllQuestion().then((_) => {
      questionLoaded = true
    });

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

      var response = json.decode(utf8.decode(res.bodyBytes));
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


  Future<void> loadAllQuestion() async{
    if (lineupQuestion.isNotEmpty){
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
    else {
      getAllYes().then((_) => {Navigator.pushNamed(context, '/findings')});
    }
  }

  void progressBar() {
    setState(() {
      progressBarWidth = 200 * (questionsCollected.values.where((q) => q['answer'] != 0).length / questionsCollected.length);
    });

    if (questionsCollected.values.where((q) => q['answer'] != 0).length == questionsCollected.length){
      setState(() {
        answeredAll = true;
      });
    } else {
      return;
    }
  }

  Future<void> getAllYes() async {
    allYes = [];
    finalDatasetAnswer = List.from(datasetCopy);

    allYes = questionsCollected.entries
        .where((entry) => entry.value['answer'] == 1)
        .map((entry) => entry.value['id'] as int)
        .toList();


    for (int id in allYes) {
      finalDatasetAnswer[id - 1] = 1;
    }

    for (int id in finalSelection) {
      finalDatasetAnswer[id - 1] = 1;
    }

    print("YOW");
    print(datasetCopy);
    print("Aye");

    print(finalDatasetAnswer);
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Color(0xFFCAFFFB),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 70.0,
                                  width: 60.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/dog-description.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    'For more information or a detailed guide about a question, simply tap on it to reveal additional details.',
                                    style: TextStyle(
                                      color: Color(0xFF344C9E),
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 30),

                          Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: questionsCollected.length,
                                itemBuilder: (context, index) {
                                  return AnimatedSize(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: Visibility(
                                      visible: ('Q${index + 1}' == 'Q1' || questionsCollected['Q$index']!['answer'] != 0),
                                      child: Column(
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
                                              visible: (questionsCollected['Q${index + 1}']!['display description'] == true),
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
                                                  progressBar();

                                                  Future.delayed(Duration(milliseconds: 300), () {
                                                    _scrollController.animateTo(
                                                      _scrollController.position.maxScrollExtent,
                                                      duration: Duration(milliseconds: 500),
                                                      curve: Curves.easeOut,
                                                    );
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
                                                  progressBar();

                                                  Future.delayed(Duration(milliseconds: 300), () {
                                                    _scrollController.animateTo(
                                                      _scrollController.position.maxScrollExtent,
                                                      duration: Duration(milliseconds: 500),
                                                      curve: Curves.easeOut,
                                                    );
                                                  });
                                                },
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 30),
                                        ],

                                      ),
                                    ),
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



          Positioned(
            bottom: 70,
            left: (MediaQuery.of(context).size.width - 120) / 2,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: answeredAll
                ? GestureDetector(
                key: ValueKey('predictButton'),
                onTap: () {
                  getAllYes().then((_) => {Navigator.pushNamed(context, '/findings')});
                },
                child: Container(
                  width: 120,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Color(0xFF1DCFC1),
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
                      'Predict',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              )
              : SizedBox(),
            ),
          ),

          Positioned(
            bottom: 20,
            left: (MediaQuery.of(context).size.width - 213) / 2,
            child: Container(
              height: 23,
              width: 213,
              decoration: BoxDecoration(
                color: Color(0xFFCAFFFB),
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
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
                child: Container(
                  height: 10,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFF091F5C),
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width: progressBarWidth,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Color(0xFF1DCFC1),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          (!questionLoaded)
              ? Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        margin: EdgeInsets.only(bottom: 0),
                        child: lottie.Lottie.asset(
                          "assets/animations/loading-running.json",
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Container(
                        width: 500,
                        child: lottie.Lottie.asset(
                          "assets/animations/loading-text.json",
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              : SizedBox()
        ],
      )
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
        width: 80,
        padding: EdgeInsets.symmetric(vertical: 5),
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
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Lexend',
              color: groupValue == value ? Colors.white : Color(0xFF4A6FD7),
            ),
          ),
        ),
      ),
    );
  }
}
