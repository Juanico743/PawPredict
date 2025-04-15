import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawpredict/services/global.dart';
import 'package:pawpredict/utils/appbar.dart';
import 'package:pawpredict/utils/navbar.dart';

class TutorialsGuides extends StatefulWidget {
  const TutorialsGuides({super.key});

  @override
  State<TutorialsGuides> createState() => _TutorialsGuidesState();
}

class _TutorialsGuidesState extends State<TutorialsGuides> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    setState(() {
      currentPage = 'tutorialsGuides';
      currentPageTitle = 'Tutorials & Guides';
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
                    buildTitle(text: 'Introduction'),
                    SizedBox(height: 10.0),
                    buildText(text: "Paw Predict is a user-friendly mobile application designed to help dog owners analyze their pet's symptoms and receive guidance on potential health issues. This manual provides an overview of the app’s features and navigation flow to ensure a seamless user experience."),
                    SizedBox(height: 20.0),
                    buildTitle(text: 'Main Flow'),
                    SizedBox(height: 10.0),
                    buildRow(
                      children: [
                        buildImage(image: 'assets/images/manuals/intro.png'),
                      ]
                    ),
                    SizedBox(height: 20.0),
                    buildText(text: "Upon launching the application, users will be greeted with the landing page, which features the app’s logo and a \"Start\" button. Clicking this button directs the user to the Home Page, where they can begin checking their dog's symptoms."),
                    SizedBox(height: 20.0),
                    buildRow(
                      children: [
                        buildImage(image: 'assets/images/manuals/home-1.png'),
                        buildImage(image: 'assets/images/manuals/dog-information.png'),
                      ]
                    ),
                    SizedBox(height: 20.0),
                    buildText(text: "On the Home Page, users will find a prominent button labeled \"Check Your Dog's Symptoms Now.\" Clicking this button leads to the Dog Information Page. Here, users must provide details about their dog, including breed selection (Shih Tzu, Pomeranian, or Aspin), gender (Male or Female), and age (Puppy, Adult, or Senior). The dog’s name is optional."),
                    SizedBox(height: 20.0),
                    buildRow(
                        children: [
                          buildImage(image: 'assets/images/manuals/symptoms-1.png'),
                        ]
                    ),
                    SizedBox(height: 20.0),
                    buildText(text: "Once the dog’s details are entered, users proceed to Dog Symptoms Page 1, where they can select one or multiple common symptoms their pet is experiencing."),
                    SizedBox(height: 20.0),
                    buildRow(
                        children: [
                          buildImage(image: 'assets/images/manuals/symptoms-2-1.png'),
                          buildImage(image: 'assets/images/manuals/symptoms-2-3.png'),
                        ]
                    ),
                    SizedBox(height: 20.0),
                    buildText(text: "Based on the symptoms chosen, Dog Symptoms Page 2 presents a series of relevant questions. Users can select answers in a Yes or No format. Each question has an optional help description that appears when clicked. A progress bar at the bottom of the page visually indicates the user's progress. After answering all the questions, users can click the \"Predict\" button, which directs them to the Findings Page."),
                    SizedBox(height: 20.0),
                    buildRow(
                        children: [
                          buildImage(image: 'assets/images/manuals/findings-1.png'),
                          buildImage(image: 'assets/images/manuals/findings-2.png'),
                        ]
                    ),
                    SizedBox(height: 20.0),
                    buildText(text: "On the Findings Page, a notification at the top of the screen indicates the severity of the predicted disease. This page displays the likely illness, its description, first-aid recommendations from a veterinarian, and suggested veterinary clinics specializing in treating such conditions. A list of additional recommended veterinarians is also provided. At the bottom of the page, a button labeled \"Nearest Vet\" allows users to navigate to the Maps Page. Additionally, a \"Back Home\" button is available to return to the Home Page."),
                    SizedBox(height: 20.0),
                    buildRow(
                        children: [
                          buildImage(image: 'assets/images/manuals/maps-1.png'),
                          buildImage(image: 'assets/images/manuals/maps-2.png'),
                        ]
                    ),
                    SizedBox(height: 20.0),
                    buildText(text: "The Maps Page displays the locations of veterinary clinics on an interactive map. The user's current position is marked, and a polyline highlights the path to the nearest veterinary clinic. When a clinic’s pin is clicked, its name and logo appear at the top of the screen."),
                    SizedBox(height: 20.0),
                    buildTitle(text: 'Other Features'),
                    SizedBox(height: 10.0),
                    buildRow(
                        children: [
                          buildImage(image: 'assets/images/manuals/home-1.png'),
                          buildImage(image: 'assets/images/manuals/home-2.png'),
                        ]
                    ),
                    SizedBox(height: 20.0),
                    buildRow(
                        children: [
                          buildImage(image: 'assets/images/manuals/home-3.png'),
                        ]
                    ),
                    SizedBox(height: 20.0),
                    buildText(text: "The Home Page includes a welcome tag and shortcut buttons for the About, Help Center, and Maps pages. It also features a \"Tips and Tricks\" section with helpful information on improving a dog's health and well-being. A list of partnered veterinary clinics is displayed, and clicking on any clinic opens a bottom modal sheet with detailed information, including location (which links to the Maps Page), available regular and emergency hours, and a list of contact options, which can either direct users to their webpage or dial their phone number."),
                    SizedBox(height: 20.0),
                    buildRow(
                        children: [
                          buildImage(image: 'assets/images/manuals/navbar.png'),
                        ]
                    ),
                    SizedBox(height: 20.0),
                    buildText(text: "A burger menu button is available, allowing users to access the navigation drawer by clicking it or swiping from the right. The navigation drawer contains the app’s logo and a list of pages (Home, About, Help Center, Maps, and Exit). An indicator highlights the currently active page."),
                    SizedBox(height: 20.0),
                    buildRow(
                        children: [
                          buildImage(image: 'assets/images/manuals/exit.png'),
                        ]
                    ),
                    SizedBox(height: 20.0),
                    buildText(text: "When the Exit button is clicked, a pop-up modal appears, prompting the user to confirm their decision. Selecting \"Yes\" exits the app, while choosing \"No\" closes the modal and returns the user to the previous screen."),
                    SizedBox(height: 20.0),
                    buildText(text: "This user manual provides a comprehensive guide to navigating and utilizing Paw Predict efficiently. With its intuitive interface and helpful features, dog owners can make informed decisions regarding their pet’s health with ease."),
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
          ],
        ),
      ),
    );
  }
  Widget buildTitle({
    required String text
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
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

  Widget buildText({
    required String text,
  }){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
      ),
    );
  }
  Widget buildRow({
    required List<Widget> children
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  Widget buildImage({
    required String image
  }){
    return Container(
      height: 270.0,
      width: 150.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
