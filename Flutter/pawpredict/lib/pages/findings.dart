import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawpredict/services/global.dart';
import 'package:pawpredict/utils/appbar.dart';
import 'package:pawpredict/utils/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart' as lottie;
class Findings extends StatefulWidget {
  const Findings({super.key});

  @override
  State<Findings> createState() => _FindingsState();
}

class _FindingsState extends State<Findings> {

  String finalFindings = "";

  String diseaseDescription = "";
  String diseaseSeverity = "";

  List<String> firstAid = [];

  bool loadingComplete = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    diseasePrediction();

    setState(() {
      currentPage = 'Dog Findings';
      currentPageTitle = 'Dog Findings';
    });

  }

  Future<void> diseasePrediction() async {
    try {
      String uri = '$serverUri/api/predictdisease/';

      var res = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "symptoms": finalDatasetAnswer
        }),
      );

      var response = jsonDecode(res.body);
      print(res.body);

      if (response["success"] == true) {
        setState(() {
          finalFindings = response["prediction"];
        });
        loadDescription().then((_) => {
          loadingComplete = true
        });
      } else {
        return;
      }
    } catch(e) {
      print(e);
    }
  }

  Future<void> loadDescription() async {
    try {
      String uri = '$serverUri/api/predictdescription/';
      var res = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": finalFindings
        }),
      );

      var response = jsonDecode(res.body);
      print(res.body);

      if (response["success"] == true) {
        setState(() {
          diseaseDescription = response["description"];
          diseaseSeverity = response["severity"];
          firstAid = List<String>.from(response["firstaid"]);

          firstAid = firstAid.isEmpty
              ? [ "No First Aid Given Yet" ]
              : firstAid;
        });

      } else {

      }
    } catch (e) {
      print(e);
    }
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                if (diseaseSeverity == 'Resuscitation')
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFBEBEB),
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: Color(0xFFCC122D),
                                        width: 3,
                                      ),
                                    ),
                                    child: Text(
                                      'Critical Condition!\nRush to the vet NOW!',
                                      style: TextStyle(
                                        color: Color(0xFFCC122D),
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                if (diseaseSeverity == 'Emergent')
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFBEFEB),
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: Color(0xFFFD8200),
                                        width: 3,
                                      ),
                                    ),
                                    child: Text(
                                      'Severe Condition!\nSeek urgent veterinary care!',
                                      style: TextStyle(
                                        color: Color(0xFFFD8200),
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                if (diseaseSeverity == 'Urgent')
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFBF5EB),
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: Color(0xFFE6AE00),
                                        width: 3,
                                      ),
                                    ),
                                    child: Text(
                                      'Needs Immediate Attention!\nVisit the vet as soon as possible!',
                                      style: TextStyle(
                                        color: Color(0xFFE6AE00),
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                if (diseaseSeverity == 'Stable')
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEBF0FB),
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: Color(0xFF006FCD),
                                        width: 3,
                                      ),
                                    ),
                                    child: Text(
                                      'Monitor Closely!\nVet visit is recommended.',
                                      style: TextStyle(
                                        color: Color(0xFF006FCD),
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),
                          Text(
                            finalFindings,
                            style: TextStyle(
                              color: Color(0xFF01B1A3),
                              fontFamily:'Lexend',
                              fontWeight: FontWeight.w700,
                              height: 1,
                              fontSize: 35.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          titleText(text: 'is the condition affecting your dog health.'),

                          SizedBox(height: 10),

                          normalText(text: diseaseDescription ),

                          SizedBox(height: 30),

                          titleText(text: 'First Aid Recomendation'),

                          SizedBox(height: 10),

                          Column(
                            children: firstAid.isNotEmpty
                                ? firstAid.map((aid) => Column(
                              children: [
                                recommendationList(text: aid),
                                SizedBox(height: 10),
                              ],
                            )).toList()
                                : [recommendationList(text: "No First Aid Given Yet")], // Fallback if empty
                          ),

                          SizedBox(height: 20),

                          titleText(text: 'Disclaimer'),

                          SizedBox(height: 10),

                          Container(
                            width: double.infinity,
                            child: RichText(
                              text: TextSpan(
                                text: 'Important Note: ',
                                style: TextStyle(
                                  color: Color(0xFF4A6FD7),
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'This system is a tool for informational purposes only and does not replace professional veterinary diagnosis and treatment. Always consult with a qualified veterinarian for any health concerns your dog may have. The information provided here should not be used for self-diagnosis or treatment decisions.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 30),

                          titleText(text: 'Recommended Vet'),

                          SizedBox(height: 10),

                          Text(
                            'Veterinary clinics for this type of case:',
                            style: TextStyle(
                              color: Color(0xFF4A6FD7),
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),

                          SizedBox(height: 10),

                          Text(
                            'Other Veterinary clinics we recommend:',
                            style: TextStyle(
                              color: Color(0xFF4A6FD7),
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),

                          SizedBox(height: 10),

                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, '/all-vet-map' );
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Color(0xFF4A6FD7),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                        Colors.white.withOpacity(1.0), // Set to full white
                                        BlendMode.srcIn, // Blend mode for applying white color
                                      ),
                                      child: Image.asset(
                                        'assets/images/icons/location.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 5),
                                  Text(
                                    'Nearest Veterinary Clinic',
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(context, '/home');
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
                                      'Home',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          (!loadingComplete)
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
      ),
    );
  }

  Widget titleText({
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

  Widget normalText({
    required String text,
  }){
    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget recommendationList({
    required String text
  }){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20.0,
          width: 20.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: AssetImage('assets/images/paw-list.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(width: 5.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        )
      ],
    );
  }
}
