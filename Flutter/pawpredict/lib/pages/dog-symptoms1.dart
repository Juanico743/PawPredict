import 'dart:convert';
import 'dart:math';
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
  List<String> options = [
    'Common', 'All', 'Gastrointestinal', 'Respiratory', 'Neurological', 'Skin & Coat', 'Behavioral', 'Urinary',
    'Ocular (Eyes)', 'Auditory (Ears)', 'Oral & Dental', 'Reproductive', 'Musculoskeletal', 'General Symptoms'
  ];
  //I added 'Gastrointestinal', 'Respiratory', 'Neurological', 'Skin & Coat', 'Behavioral', 'Urinary', 'Ocular (Eyes)', 'Auditory (Ears)', 'Oral & Dental', 'Reproductive', 'Musculoskeletal', 'General Symptoms'
  final List<String> _Gastrointestinal = [
    'Abdominal Pain', 'Bloated Abdomen', 'Bloody Diarrhea', 'Bloody Poop',
    'Constipation', 'Damage to the Colon', 'Diarrhea', 'Difficulty Bowel Movements',
    'Difficulty Swallowing', 'Dry Stool', 'Foul Stool', 'Frequent Vomiting', 'Retching',
    'Straining', 'Watery-yellowish poop', 'Worms in Stool'
  ];

  final List<String> _Respiratory = [
    'Bloody Nose', 'Coughing', 'Difficulty Breathing', 'Dry Coughing', 'Gagging',
    'Grunting Noises', 'Honking Cough', 'Noisy Breathing', 'Nose Discharge',
    'Rapid Breathing', 'Repeated Snorting Sounds', 'Shortness of Breath', 'Sneezing',
    'Trouble Breathing'
  ];

  final List<String> _Neurological = [
    'Bone Cracking', 'Disorientation', 'Dizziness', 'Dragging Back Legs', 'Drooping Jaw',
    'Fainting', 'Head Tilting', 'Jerking', 'Loss of Balance', 'Paralysis',
    'Seizures', 'Twitching', 'Wobbling'
  ];

  final List<String> _SkinCoat = [
    'Alopecia', 'Bad Odor', 'Bleeding Skin', 'Bleeding Sores', 'Blisters', 'Bruising',
    'Crusting', 'Dandruff', 'Darkened Skin', 'Dry Skin', 'Excessive Excitability',
    'Excessive Licking', 'Greasy Skin', 'Hair Loss', 'Intense Itchiness', 'Lesions',
    'Multiple Wounds', 'Nail Discharge', 'Poor Coat Condition', 'Scabs'
  ];

  final List<String> _Behavioral = [
    'Apprehension', 'Attacking', 'Behavioral Changes', 'Biting Animals', 'Biting Humans',
    'Biting Objects', 'Biting the Skin', 'Chewing', 'Depression', 'Excessive Irritability',
    'Excessive Scratching', 'Hypersensitivity', 'Overgrooming', 'Pawing at Face', 'Pawing or Digging',
    'Restlessness', 'Rubbing', 'Shyness', 'Snapping', 'Startled', 'Whimpering or Yelling'
  ];

  final List<String> _Urinary = [
    'Bloody Urine', 'Dark Urine', 'Difficulty Urinating', 'Excessive Urination',
    'Foul-Smelling Urine', 'Painful Urination'
  ];

  final List<String> _OcularEyes = [
    'Blue Eyes', 'Bulging Eye', 'Change in Pupil Size', 'Changes of Eye Color', 'Cloudy Eyes',
    'Difficulty Seeing', 'Dry Eye', 'Excessive Tear', 'Eye Discharge', 'Eye Redness',
    'Irritated Bump in the Corner of Eye', 'Irritated Eyes', 'Sensitive to Light', 'Squinting',
    'Swollen Third Eyelid', 'Tear Staining', 'Thick in the Corner of the Eye', 'Tumors in the Iris',
    'Yellow Eyes'
  ];

  final List<String> _AuditoryEars = [
    'Ear Discharge', 'Ear Inflammation', 'Ear Rubbing', 'Head Shaking'
  ];

  final List<String> _OralDental = [
    'Bad Breath', 'Bleeding Gums', 'Dribbling', 'Enlarged Tonsils', 'Excessive Drooling',
    'Missing Teeth', 'Mouth Ulcers', 'Pale Gums', 'Ulceration'
  ];

  final List<String> _Reproductive = [
    'Bloody Nipple Discharge', 'Creamy Discharge in Vulva', 'Resistance to Mating',
    'Swollen Breasts', 'Vaginal Discharge'
  ];

  final List<String> _Musculoskeletal = [
    'Bowlegged Stance', 'Difficulty Sitting', 'Difficulty Standing', 'Difficulty Walking',
    'Hunched Lower Back', 'Limping', 'Muscle Loss', 'Muscle Spasms', 'Muscle Weakness',
    'Neck Pain', 'Scuffed Toenails', 'Skipping', 'Stiffness', 'Swollen Joints'
  ];

  final List<String> _GeneralSymptoms = [
    'Cold Intolerance', 'Coldness', 'Collapse', 'Consistent Painful', 'Continues Bleeding',
    'Dehydration', 'Discomfort', 'Excessive Thirst', 'Facial Swelling', 'Fever', 'Increased Appetite',
    'Inflammation', 'Jaundice', 'Lack of Appetite', 'Lack of Energy', 'Low Body Temperature',
    'Lumps', 'Painful', 'Painful When Touched', 'Poor Growth', 'Pus', 'Reduced Exercise Tolerance',
    'Shaking', 'Swelling', 'Swelling Feet', 'Swollen Lymph', 'Weakness', 'Weight Gain', 'Weight Loss',
    'Yellow Discharge'
  ];


  List<Map<String, dynamic>>dogSymptomsList = [];
  List<String> selectedDogSymptomsList = [];

  List<int> finalLineUp = [];


  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredSymptoms = [];


  bool _canTap = true;
  bool _loading = false;


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    loadSymptomsList();
    finalSelection = [];



    setState(() {
      currentPage = 'Dog Symptoms';
      currentPageTitle = 'Dog Symptoms';

      filteredSymptoms = List.from(dogSymptomsList);

    });


  }


  void _filterSymptoms(String query) {
    setState(() {
      // Reset the filtered list based on the selected category
      if (query.isEmpty && selectedValue == 'All') {
        filteredSymptoms = List.from(dogSymptomsList);
      } else {
        // Filter based on the selected category (e.g., _Gastrointestinal, etc.)
        filteredSymptoms = dogSymptomsList.where((symptom) {
          final name = symptom['name']?.toString().toLowerCase() ?? '';
          final isCommon = symptom['common'] ?? false;

          // Handle 'Common' filter
          if (selectedValue == 'Common') {
            return name.contains(query.toLowerCase()) && isCommon;
          }
          // Handle filtering for each specific category
          else if (selectedValue == 'Gastrointestinal') {
            // Make sure _Gastrointestinal items are matched properly (case-insensitive)
            return _Gastrointestinal.any((item) => item.toLowerCase() == name) &&
                name.contains(query.toLowerCase());
          } else if (selectedValue == 'Respiratory') {
            return _Respiratory.any((item) => item.toLowerCase() == name) &&
                name.contains(query.toLowerCase());
          } else if (selectedValue == 'Neurological') {
            return _Neurological.any((item) => item.toLowerCase() == name) &&
                name.contains(query.toLowerCase());
          } else if (selectedValue == 'Skin & Coat') {
            return _SkinCoat.any((item) => item.toLowerCase() == name) &&
                name.contains(query.toLowerCase());
          }else if (selectedValue == 'Behavioral') {
            return _Behavioral.any((item) => item.toLowerCase() == name) &&
                name.contains(query.toLowerCase());
          } else if (selectedValue == 'Urinary') {
            return _Urinary.any((item) => item.toLowerCase() == name) &&
                name.contains(query.toLowerCase());
          } else if (selectedValue == 'Ocular (Eyes)') {
            return _OcularEyes.any((item) => item.toLowerCase() == name) &&
                name.contains(query.toLowerCase());
          } else if (selectedValue == 'Auditory (Ears)') {
            return _AuditoryEars.any((item) => item.toLowerCase() == name) &&
                name.contains(query.toLowerCase());
          } else if (selectedValue == 'Oral & Dental') {
            return _OralDental.any((item) => item.toLowerCase() == name) &&
                name.contains(query.toLowerCase());
          } else if (selectedValue == 'Reproductive') {
            return _Reproductive.any((item) => item.toLowerCase() == name) &&
                name.contains(query.toLowerCase());
          } else if (selectedValue == 'Musculoskeletal') {
            return _Musculoskeletal.any((item) => item.toLowerCase() == name) &&
                name.contains(query.toLowerCase());
          } else if (selectedValue == 'General Symptoms') {
            return _GeneralSymptoms.any((item) => item.toLowerCase() == name) &&
                name.contains(query.toLowerCase());
          } else {
            return name.contains(query.toLowerCase());
          }
        }).toList();
      }

      // Exclude specific symptoms from the filtered list
      filteredSymptoms = filteredSymptoms.where((symptom) {
        final name = symptom['name']?.toString() ?? '';
        return name != 'Lack of Appetite' && name != 'Weakness';
      }).toList();
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

    for (var id in [101, 177]) {
      if (!lineupQuestion.contains(id)) {
        lineupQuestion.add(id);
      }
    }


    lineupQuestion.shuffle(Random());

    //print(lineupQuestion);
    setState(() {
      _loading = false;
    });


    Navigator.pushNamed(context, '/dog-symptoms2');

  }

  void displaySelectedSymptoms() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 500,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20),

                        Text(
                          'Review Selected Symptoms',
                          style: TextStyle(
                            color: Color(0xFF344C9E),
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 5),

                        Text(
                          '(Tap to remove selected symptoms)',
                          style: TextStyle(
                            color: Colors.red,
                            fontStyle: FontStyle.italic,
                            fontSize: 10,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),

                        SizedBox(height: 10),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5.0),
                            // decoration: BoxDecoration(
                            //   color: Color(0xFFDBF7FF),
                            //   borderRadius: BorderRadius.circular(10.0),
                            // ),
                            child: SingleChildScrollView(
                              child: selectedDogSymptomsList.isEmpty
                                  ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'No symptoms selected.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4A6FD7),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto',
                                      decoration: TextDecoration.none,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                                  : Wrap(
                                alignment: WrapAlignment.center,
                                children: selectedDogSymptomsList.map((symptom) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedDogSymptomsList.remove(symptom);
                                        });
                                        print(selectedDogSymptomsList);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 7.0),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF1DCFC1),
                                          borderRadius: BorderRadius.circular(5.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 1,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          symptom,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                            decoration: TextDecoration.none,
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

                        SizedBox(height: 10),

                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
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
                                'Back',
                                style: TextStyle(
                                  color: Color(0xFF1DCFC1),
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {

      });
    });
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
      body:
        Stack(
          children: [
            Padding(
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
                    Stack(
                      children: [
                        TextField(
                          controller: _searchController,
                          onChanged: _filterSymptoms,
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Filter your dog symptoms',
                            hintStyle: TextStyle(
                              color: Color(0x881E1E1E),
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                              fontSize: 15.0,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 50, 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(color: Color(0xFF4A6FD7), width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(color: Color(0xFF4A6FD7), width: 2),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 15,
                          child: Icon(
                            Icons.search,
                            size: 30,
                            color: Color(0xFF1DCFC1),
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 180,
                          child: DropdownButtonFormField<String>(
                            isDense: true,
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Color(0xFFDBF7FF), width: 0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Color(0xFFDBF7FF), width: 0),
                              ),
                            ),
                            dropdownColor: Colors.white,
                            style: TextStyle(
                              color: Color(0xFF4A6FD7),
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0,
                            ),
                            items: options.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(fontSize: 13)),
                              );
                            }).toList(),
                          ),
                        ),

                        AnimatedOpacity(
                          opacity: selectedDogSymptomsList.isNotEmpty ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 200),
                          child: AnimatedScale(
                            scale: selectedDogSymptomsList.isNotEmpty ? 1.0 : 0.8,
                            duration: Duration(milliseconds: 200),
                            child: selectedDogSymptomsList.isNotEmpty
                                ? GestureDetector(
                              onTap: () {
                                displaySelectedSymptoms();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                                decoration: BoxDecoration(
                                  color: Color(0xFFDBF7FF),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "Selected",
                                  style: TextStyle(
                                    color: Color(0xFF4A6FD7),
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            )
                                : SizedBox.shrink(),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              Text(
                'Select all applicable symptoms',
                style: TextStyle(
                  color: Color(0xFF344C9E),
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 5),

              Text(
                '(Required to select at least 2 symptoms)',
                style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                    fontSize: 10
                ),
              ),

              SizedBox(height: 10),



              Flexible(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBF7FF),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SingleChildScrollView(
                    child: filteredSymptoms.isEmpty
                        ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Nothing matches your search.\nTry a different keyword.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A6FD7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : Wrap(
                      alignment: WrapAlignment.center,
                      children: filteredSymptoms.map((symptom) {
                        final symptomName = symptom['name'] ?? '';
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
                                symptomName,
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



              if (selectedDogSymptomsList.isEmpty && selectedDogSymptomsList.length >= 2)
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
                      child: (selectedDogSymptomsList.isNotEmpty && selectedDogSymptomsList.length >= 2)
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
                                  onTap: _canTap
                                      ? () {
                                    setState(() {
                                      _loading = true;
                                      _canTap = false;
                                    });
                                    getLineupQuestions();
                                    Future.delayed(Duration(seconds: 10), () {
                                      setState(() {
                                        _canTap = true;
                                      });
                                    });
                                  }
                                      : null,
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
            ),
            if (dogSymptomsList.isEmpty || _loading == true)
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Colors.white.withOpacity(0.7),
                    ),
                    BackdropFilter(
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
                  ],
                ),
              ),
          ],
        )

    );
  }
}
