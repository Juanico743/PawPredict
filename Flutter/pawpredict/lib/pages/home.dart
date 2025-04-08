import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:pawpredict/services/global.dart';
import 'package:pawpredict/utils/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic>? vetClinics;

  int imagePage = 1;
  int counter = 0;
  late Timer timer;


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    setState(() {
      currentPage = 'home';
    });

    loadVeterinaryClinics();
    resetDataset();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      counter++;
      if (counter == 5) {
        setState(() {
          counter = 0;
          imagePage == 10? imagePage = 1 : imagePage++;
        });
      }
    });
  }

  Future<void> loadVeterinaryClinics() async {
    try {
      String uri = '$serverUri/api/requestVeterinarianData/';

      var res = await http.get(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"}
      );

      var response = jsonDecode(res.body);
      //print(res.body);

      if (response["success"] == true) {
        setState(() {
          vetClinics = response["vet_clinics"];
        });

      } else {

      }


    } catch(e) {
      print(e);
    }
  }

  Future<void> setVetLocation(double lat, double lon) async {
    setState(() {
      vetPinLocationLat = lat;
      vetPinLocationLon = lon;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF1DCFC1),
      drawer: Navbar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1DCFC1),
              Color(0xFF9EFFF8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
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
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: 70,
                                  width: 240,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: -5,
                                        left: 5,
                                        child: Opacity(
                                          opacity: 0.7,
                                          child: Image(
                                            image: AssetImage('assets/images/background/paw.png'),
                                            width: 65,
                                            height: 65,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        bottom: -5,
                                        right: 0,
                                        left: 0,
                                        child: Center(
                                          child: Text(
                                            'WELCOME',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily:'Lexend',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 30.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                        Scaffold.of(context).openDrawer();
                                      },
                                      child: Image(
                                        image: AssetImage('assets/images/icons/menu.png'),
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.fill,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, '/dog-information');
                          },
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 0.0, bottom:10.0, left: 0.0, right: 0.0,),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 4,
                                  right: 15,
                                  left: 15,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(50.0),
                                        topLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                        bottomLeft: Radius.circular(15.0),
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
                                    padding: EdgeInsets.only(top: 20.0, bottom:20.0, left: 100.0, right: 5.0,),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Check Your Dog\'s Symptoms Now',
                                            style: TextStyle(
                                              color: Color(0XFF1E1E1E),
                                              fontFamily:'Lexend',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          width: 50,
                                          margin: EdgeInsets.only(bottom: 0),
                                          child: Lottie.asset(
                                            "assets/animations/forward.json",
                                            repeat: true,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 5,
                                  child: Image(
                                    image: AssetImage('assets/images/background/dogb1.png'),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.fill,
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 0.0, bottom:14.0, left: 15.0, right: 15.0,),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              shortcutButton(
                                  title: 'About',
                                  image: 'assets/images/icons/info-p.png',
                                  onPressed: (){
                                    Navigator.pushNamed(context, '/about');
                                  }
                              ),

                              Container(
                                height: 50,
                                width: 1,
                                color: Colors.black12,
                              ),

                              shortcutButton(
                                  title: 'Help',
                                  image: 'assets/images/icons/faq-p.png',
                                  onPressed: (){
                                    Navigator.pushNamed(context, '/help');
                                  }
                              ),

                              Container(
                                height: 50,
                                width: 1,
                                color: Colors.black12,
                              ),


                              shortcutButton(
                                title: 'Map',
                                image: 'assets/images/icons/pin-p.png',
                                onPressed: (){
                                  Navigator.pushNamed(context, '/all-vet-map' );
                                }
                              ),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity! < 0) {
                              setState(() {
                                counter = 0;
                                imagePage == 10? imagePage = 1 : imagePage++;
                              });
                            }
                            else if (details.primaryVelocity! > 0) {
                              setState(() {
                                counter = 0;
                                imagePage == 1? imagePage = 10 : imagePage--;
                              });
                            }
                          },
                          child: mainContainer(
                            child: Column(
                              children: [
                                AnimatedSwitcher(
                                  duration: Duration(seconds: 1),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  child: imagePage == 1
                                  ? cardsTemplate(
                                    key: ValueKey<int>(1),
                                    image: 'assets/images/dogs/dog1.png',
                                    title: 'Feed dogs nutritious food.',
                                    description: 'Dog diets and foods are designed to meet dogs\' dietary and nutritional needs, ensuring proper health'
                                  )
                                  : imagePage == 2
                                  ? cardsTemplate(
                                    key: ValueKey<int>(2),
                                    image: 'assets/images/dogs/dog2.png',
                                    title: 'Provide fresh water daily',
                                    description: 'Keep your pets hydrated! Always provide fresh water in a clean bowl. Refill it at least twice daily.'
                                  )
                                  : imagePage == 3
                                  ? cardsTemplate(
                                    key: ValueKey<int>(3),
                                    image: 'assets/images/dogs/dog3.png',
                                    title: 'Provide comfortable shelter',
                                    description: 'Pets need protection from extreme weather and should not stay outside for long periods in heat or cold.'
                                  )
                                  : imagePage == 4
                                  ? cardsTemplate(
                                    key: ValueKey<int>(4),
                                    image: 'assets/images/dogs/dog4.png',
                                    title: 'Make your dogs stay fit',
                                    description: 'Playtime is crucial for your dog\'s physical and mental health, and proper socialization is beneficial.'
                                  )
                                  : imagePage == 5
                                  ? cardsTemplate(
                                    key: ValueKey<int>(5),
                                    image: 'assets/images/dogs/dog5.png',
                                    title: 'Take regular vet checkups',
                                    description: 'Regular vet visits once or twice yearly are essential for your pet’s health due to their shorter lifespan.'
                                  )
                                  : imagePage == 6
                                  ? cardsTemplate(
                                    key: ValueKey<int>(6),
                                    image: 'assets/images/dogs/dog6.png',
                                    title: 'Spay or neuter your pets',
                                    description: 'Spaying/neutering prevents health issues, reduces stray animals, and prevents difficult pregnancies.'
                                  )
                                  : imagePage == 7
                                  ? cardsTemplate(
                                    key: ValueKey<int>(7),
                                    image: 'assets/images/dogs/dog7.png',
                                    title: 'Brush your dog\'s teeth',
                                    description: 'Brushing your dog\'s teeth daily helps reduce bacteria, promote healthy gums, and prevent diseases.'
                                  )
                                  : imagePage == 8
                                  ? cardsTemplate(
                                    key: ValueKey<int>(8),
                                    image: 'assets/images/dogs/dog8.png',
                                    title: 'Groom them regularly',
                                    description: 'Groom your dog regularly by brushing, trimming nails, and cleaning ears to prevent infections.'
                                  )
                                  : imagePage == 9
                                  ? cardsTemplate(
                                    key: ValueKey<int>(9),
                                    image: 'assets/images/dogs/dog9.png',
                                    title: 'Monitor dogs behavior',
                                    description: 'Watch for behavioral changes (e.g., barking, lethargy, aggression) as they may indicate health issues.'
                                  )
                                  : cardsTemplate(
                                    key: ValueKey<int>(10),
                                    image: 'assets/images/dogs/dog10.png',
                                    title: 'Avoid toxic foods',
                                    description: 'Keep harmful foods like chocolate, grapes, onions, and alcohol away from dogs as they can be toxic.'
                                  )
                                ),

                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  margin: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1DCFC1),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),

                                  child: IntrinsicWidth(
                                    child: IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(10, (index) {
                                          double indicatorWidth = (imagePage == index + 1) ? 28.0 : 7.0;
                                          return pageIndicator(width: indicatorWidth);
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        mainContainer(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5.0),
                                width: double.infinity,
                                child: Text(
                                  'Recomended vets:',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily:'Lexend',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Column(
                                children: vetClinics == null
                                  ? [
                                    Column(
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 30.0),
                                      ],
                                    )
                                  ]
                                  : List.generate(
                                  (vetClinics!.length / 2).ceil(),
                                      (index) {
                                    int firstIndex = index * 2;
                                    int secondIndex = firstIndex + 1;

                                    var firstClinic = vetClinics![firstIndex];
                                    var secondClinic = secondIndex < vetClinics!.length ? vetClinics![secondIndex] : null;

                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        vetsRow(
                                          children: [
                                            vetIcon(
                                              title: firstClinic['name'],
                                              image: 'assets/images/vets/vet${firstIndex + 1}.png',
                                              location: firstClinic['info'][0]['address'] ?? '',
                                              weekDays: firstClinic['info'][0]['availability'] ?? '',
                                              regularTime: firstClinic['info'][0]['regular_hours'] ?? '',
                                              emergencyTime: firstClinic['info'][0]['emergency_hours'] ?? '',
                                              pinLocationLat: firstClinic['info'][0]['latitude'] ?? '',
                                              pinLocationLon: firstClinic['info'][0]['longitude'] ?? '',
                                              children: [
                                                if (firstClinic['contacts'][0]['facebook'] != '')
                                                  contactsList(
                                                      title: 'Facebook',
                                                      image: 'assets/images/icons/facebook.png',
                                                      color: Color(0xFF0866FD),
                                                      url: firstClinic['contacts'][0]['facebook']
                                                  ),

                                                if (firstClinic['contacts'][0]['instagram'] != '')
                                                  contactsList(
                                                      title: 'Instagram',
                                                      image: 'assets/images/icons/instagram.png',
                                                      color: Color(0xFFCE2871),
                                                      url: firstClinic['contacts'][0]['instagram']
                                                  ),


                                                if (firstClinic['contacts'][0]['gmail'] != '')
                                                  contactsList(
                                                      title: 'Gmail',
                                                      image: 'assets/images/icons/email.png',
                                                      color: Color(0xFFE24133),
                                                      url: 'mailto:${firstClinic['contacts'][0]['gmail']}?subject=News&body='
                                                  ),

                                                if (firstClinic['contacts'][0]['contact_number'] != '')
                                                  contactsList(
                                                      title: firstClinic['contacts'][0]['contact_number'],
                                                      image: 'assets/images/icons/phone-call.png',
                                                      color: Color(0xFF5EBE3A),
                                                      url: 'sms:${firstClinic['contacts'][0]['contact_number']}'
                                                  ),

                                                if (firstClinic['contacts'][0]['viber'] != '')
                                                  contactsList(
                                                      title: 'Viber',
                                                      image: 'assets/images/icons/viber.png',
                                                      color: Color(0xFF6E5DE9),
                                                      url: ''
                                                  ),

                                                if (firstClinic['contacts'][0]['website'] != '')
                                                  contactsList(
                                                      title: 'Website',
                                                      image: 'assets/images/icons/web.png',
                                                      color: Color(0xFF1E1E1E),
                                                      url: firstClinic['contacts'][0]['website']
                                                  ),
                                              ],
                                            ),
                                            if (secondClinic != null)
                                              vetIcon(
                                                title: secondClinic['name'],
                                                image: 'assets/images/vets/vet${secondIndex + 1}.png',
                                                location: secondClinic['info'][0]['address'] ?? '',
                                                weekDays: secondClinic['info'][0]['availability'] ?? '',
                                                regularTime: secondClinic['info'][0]['regular_hours'] ?? '',
                                                emergencyTime: secondClinic['info'][0]['emergency_hours'] ?? '',
                                                pinLocationLat: secondClinic['info'][0]['latitude'] ?? '',
                                                pinLocationLon: secondClinic['info'][0]['longitude'] ?? '',
                                                children: [
                                                  if (secondClinic['contacts'][0]['facebook'] != '')
                                                    contactsList(
                                                      title: 'Facebook',
                                                      image: 'assets/images/icons/facebook.png',
                                                      color: Color(0xFF0866FD),
                                                      url: secondClinic['contacts'][0]['facebook']
                                                    ),

                                                  if (secondClinic['contacts'][0]['instagram'] != '')
                                                    contactsList(
                                                      title: 'Instagram',
                                                      image: 'assets/images/icons/instagram.png',
                                                      color: Color(0xFFCE2871),
                                                      url: secondClinic['contacts'][0]['instagram']
                                                    ),


                                                  if (secondClinic['contacts'][0]['gmail'] != '')
                                                    contactsList(
                                                      title: 'Gmail',
                                                      image: 'assets/images/icons/email.png',
                                                      color: Color(0xFFE24133),
                                                      url: 'mailto:${secondClinic['contacts'][0]['gmail']}?subject=News&body='
                                                    ),

                                                  if (secondClinic['contacts'][0]['contact_number'] != '')
                                                    contactsList(
                                                      title: secondClinic['contacts'][0]['contact_number'],
                                                      image: 'assets/images/icons/phone-call.png',
                                                      color: Color(0xFF5EBE3A),
                                                      url: 'sms:${secondClinic['contacts'][0]['contact_number']}'
                                                    ),

                                                  if (secondClinic['contacts'][0]['viber'] != '')
                                                    contactsList(
                                                      title: 'Viber',
                                                      image: 'assets/images/icons/viber.png',
                                                      color: Color(0xFF6E5DE9),
                                                      url: ''
                                                    ),

                                                  if (secondClinic['contacts'][0]['website'] != '')
                                                    contactsList(
                                                      title: 'Website',
                                                      image: 'assets/images/icons/web.png',
                                                      color: Color(0xFF1E1E1E),
                                                      url: secondClinic['contacts'][0]['website']
                                                    ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

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
                                '© SCAS-BSCS-2025',
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
              ],
            ),
          ],
        ),
      ),
    );
  }
// MAIN CONTAINERS
  Widget mainContainer({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(top: 0.0, bottom:14.0, left: 15.0, right: 15.0,),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget pageIndicator({
    required double width,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 7.0,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
      ),
    );
  }

// VETS ROW
  Widget vetsRow({
    required List<Widget> children,
  }){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
    );
  }

// VETS
  Widget vetIcon({
    required String title,
    required String image,
    required String location,
    required String weekDays,
    required String regularTime,
    required String emergencyTime,
    required double pinLocationLat,
    required double pinLocationLon,
    required List<Widget> children,
  }){
    return InkWell(
      onTap: () {
        setState(() {
          singleVetImage = image;
          singleVetName = title;
        });

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Wrap(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(0.0),
                      bottomLeft: Radius.circular(0.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFF1DCFC1),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            topLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(15.0),
                            bottomLeft: Radius.circular(50.0),
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
                        child: Column(
                          children: [
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                SizedBox(width: 10.0),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  height: 70.0,
                                  width: 70.0,
                                  decoration:BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: AssetImage(image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Container(
                                  width: 230.0,
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                      ),


                      GestureDetector(
                        onTap: (){
                          setVetLocation(pinLocationLat, pinLocationLon).then((_) => {
                            setState(() {
                              singleVetAvailability = weekDays;
                              singleVetRegularHours = regularTime;
                              singleVetEmergencyHours = emergencyTime;
                            }),
                            Navigator.pushNamed(context, '/vet-map')
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 30.0,
                                width: 30.0,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Image.asset(
                                  'assets/images/icons/gps-p.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    location,
                                    style: TextStyle(
                                      color: Color(0xFF4A6FD7),
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Container(
                              height: 30.0,
                              width: 30.0,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Image.asset(
                                'assets/images/icons/calendar-p.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  weekDays,
                                  style: TextStyle(
                                    color: Color(0xFF4A6FD7),
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Text(
                              'Open Hours:',
                              style: TextStyle(
                                color: Color(0xFF091F5C),
                                fontFamily:'Lexend',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              regularTime,
                              style: TextStyle(
                                color: Color(0xFF4A6FD7),
                                fontFamily:'Lexend',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Text(
                              'Emergency Hours:',
                              style: TextStyle(
                                color: Color(0xFF091F5C),
                                fontFamily:'Lexend',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              emergencyTime,
                              style: TextStyle(
                                color: Color(0xFF4A6FD7),
                                fontFamily:'Lexend',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30.0),

                      Column(
                        children: children
                      ),


                      SizedBox(height: 20.0),

                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 120,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
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
                              'Close',
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

                      SizedBox(height: 30.0),

                    ],
                  )
                ),
              ],
            );
          },
        );
      },
      child: Container(
        height: 185,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: 120.0,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily:'Lexend',
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget contactsList({
    required String title,
    required String image,
    required Color color,
    required String url,
  }){
  return Column(
    children: [
      GestureDetector(
        onTap: (){
          launchUrl(Uri.parse(url));
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
              Container(
                height: 20.0,
                width: 20.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                      color,
                      BlendMode.srcATop,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontFamily:'Lexend',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 10.0),
    ],
  );
}

// SHORTCUT BUTTON
  Widget shortcutButton({
    required String title,
    required String image,
    required VoidCallback onPressed,
  }){
    return TextButton(
      onPressed: onPressed,
      child: Column(
        children: [
          Image(
            image: AssetImage(image),
            width: 30,
            height: 30,
            fit: BoxFit.fill,
          ),
          Text(
            title,
            style: TextStyle(
              color: Color(0XFF1E1E1E),
              fontFamily:'Lexend',
              fontWeight: FontWeight.w400,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget cardsTemplate({
  required String image,
  required String title,
  required String description,
  required ValueKey<int> key,
  }){
    return Container(
      key: key,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.all(5.0),
              height: 190.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x001DCFC1),
                    Color(0xFF1DCFC1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 5.0, bottom: 0.0, left: 5.0, right: 5.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFFFED801),
                        fontFamily:'Podkova',
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                        shadows: [
                          Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(0, 0),
                          blurRadius: 15,
                          ),
                        ]
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                    width: double.infinity,
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily:'Lexend',
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.4),
                              offset: Offset(0, 0),
                              blurRadius: 10,
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
