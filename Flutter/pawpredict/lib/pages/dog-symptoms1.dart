import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawpredict/services/global.dart';
import 'package:pawpredict/utils/appbar.dart';
import 'package:pawpredict/utils/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart' as lottie;
import 'package:url_launcher/url_launcher.dart';

class DogSymptoms1 extends StatefulWidget {
  const DogSymptoms1({super.key});

  @override
  State<DogSymptoms1> createState() => _DogSymptoms1State();
}

class _DogSymptoms1State extends State<DogSymptoms1> {


  String? selectedValue = 'Common';
  List<String> options = ['Common', 'All'];


  String? selectSymptoms;
  List<Map<String, dynamic>>dogSymptomsList = [];
  List<String> selectedDogSymptomsList = [];

  List<int> finalLineUp = [];


  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredSymptoms = [];


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    loadSymptomsList();
    finalSelection = [];
    resetDataset();


    setState(() {
      currentPage = 'Dog Symptoms';
      currentPageTitle = 'Dog Symptoms';

      filteredSymptoms = List.from(dogSymptomsList);

    });


  }


  void _filterSymptoms(String query) {
    setState(() {
      if (query.isEmpty && selectedValue == 'All') {
        filteredSymptoms = List.from(dogSymptomsList);
      } else {
        filteredSymptoms = dogSymptomsList.where((symptom) {
          final name = symptom['name']?.toString().toLowerCase() ?? '';
          final isCommon = symptom['common'] ?? false;

          if (selectedValue == 'Common') {
            return name.contains(query.toLowerCase()) && isCommon;
          } else {
            return name.contains(query.toLowerCase());
          }
        }).toList();
      }
    });
  }


  Future<void> loadSymptomsList() async {
    try {
      String uri = '$serverUri/api/getsymptoms/';
      var res = await http.get(
          Uri.parse(uri),
          headers: {"Content-Type": "application/json"}
      );

      var response = jsonDecode(res.body);
      //print(response);

      if (response["success"] == true) {
        setState(() {
          dogSymptomsList = List<Map<String, dynamic>>.from(response["symptoms"]);
          filteredSymptoms = List.from(dogSymptomsList);
        });
        _filterSymptoms("");
      }
    } catch (e) {
      print("Error fetching symptoms: $e");
    }
  }

  Future<void> getLineupQuestions() async {
    lineupQuestion = [];
    finalSelection = [];
    finalLineUp = [];


    await Future.forEach<String>(selectedDogSymptomsList, (symptom) async {
      try {
        String uri = '$serverUri/api/getquestionlineup/';
        var res = await http.post(
          Uri.parse(uri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"SymptomsName": symptom}),
        );

        var response = jsonDecode(res.body);
        //print(res.body);

        if (response["success"] == true) {
          finalSelection.add(response["sypmtomsId"]);
          List<dynamic> cleanArray = response["connectedIds"];
          cleanArray = cleanArray.toSet().toList();

          if (finalLineUp.isEmpty) {
            finalLineUp = List<int>.from(cleanArray);
          } else {
            //finalLineUp = finalLineUp.toSet().cast<int>().union(cleanArray.toSet().cast<int>()).toList();
            finalLineUp.retainWhere((element) => cleanArray.contains(element));//Intersection //
          }
        }
      } catch (e) {
        print("Error: $e");
      }
    });


    finalSelection = finalSelection.toSet().toList();
    finalLineUp = finalLineUp.toSet().toList();

    lineupQuestion = finalLineUp.toSet().difference(finalSelection.toSet()).toList();

    //print(lineupQuestion);

    Navigator.pushNamed(context, '/dog-symptoms2');

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      drawer: Navbar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1DCFC1),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
            child: Appbar(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: dogSymptomsList.isNotEmpty
        ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
            // Container(
            //   padding: const EdgeInsets.all(15.0),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFFCAFFFB),
            //     borderRadius: BorderRadius.circular(15.0),
            //   ),
            //   child: const Text(
            //     "Select specific symptoms from the dropdown or tap all symptoms your dog might have before proceeding to the next step",
            //     style: TextStyle(
            //       color: Color(0xFF344C9E),
            //       fontFamily: 'Lexend',
            //       fontWeight: FontWeight.w400,
            //       fontSize: 15.0,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10),

          // Search and Dropdown
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _filterSymptoms,
                  style: const TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Filter your dog symptoms',
                    hintStyle: const TextStyle(
                      color: Color(0x881E1E1E),
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(color: Color(0xFF4A6FD7), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(color: Color(0xFF4A6FD7), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),


                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 130,
                    child: DropdownButtonFormField<String>(
                      isDense: true, // reduces height
                      value: selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                        _filterSymptoms(_searchController.text);
                      },
                      decoration: InputDecoration(
                        fillColor: Color(0xFFDBF7FF),
                        filled: true,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // smaller padding
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color(0xFFDBF7FF), width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color(0xFFDBF7FF), width: 0),
                        ),
                      ),
                      dropdownColor: Colors.white,
                      style: const TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.0, // smaller font
                      ),
                      items: options.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(fontSize: 13)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Select all applicable common symptoms',
            style: TextStyle(
              color: Color(0xFF344C9E),
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          ),

          const SizedBox(height: 10),


              Flexible( // or use Expanded depending on context
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBF7FF),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: filteredSymptoms.map((symptom) {
                        final symptomName = symptom['name'] ?? ''; // Extract the name
                        final isSelected = selectedDogSymptomsList.contains(symptomName);
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedDogSymptomsList.remove(symptomName);
                                } else {
                                  selectedDogSymptomsList.add(symptomName);
                                }
                                print(selectedDogSymptomsList);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF1DCFC1) : const Color(0xFF4A6FD7),
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                symptomName, // Display the name
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),


          if (selectSymptoms == null && selectedDogSymptomsList.isEmpty)
            Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse("mailto:support@pawpredict.com?subject=Can't find symptoms&body="));
                  },
                  child: const Text(
                    "Can't find the symptoms?",
                    style: TextStyle(
                      color: Color(0xFF344C9E),
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

              AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: (selectSymptoms != null || selectedDogSymptomsList.isNotEmpty)
                      ?Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectSymptoms = null;
                                  selectedDogSymptomsList.clear();
                                });
                              },
                              child: Container(
                                width: 100,
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
                                    'Cancel',
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


                            GestureDetector(
                              onTap: (){
                                getLineupQuestions();
                              },
                              child: Container(
                                width: 100,
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
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                      : SizedBox()
              ),
                  ],
                ),
        )
          : Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: lottie.Lottie.asset("assets/animations/loading-running.json"),
              ),
              SizedBox(
                width: 500,
                child: lottie.Lottie.asset("assets/animations/loading-text.json"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
