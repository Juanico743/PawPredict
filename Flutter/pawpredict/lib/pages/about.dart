import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawpredict/services/global.dart';
import 'package:pawpredict/utils/appbar.dart';
import 'package:pawpredict/utils/navbar.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    setState(() {
      currentPage = 'about';
      currentPageTitle = 'About';
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

                    aboutImage(
                      image: 'assets/images/banner1.png',
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 25,
                            left: 10,
                            child: Container(
                              height: 110.0,
                              width: 160.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/PawPredict-logo.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.0),


                    aboutText(
                      text: 'Our team is dedicated to developing a system that predicts possible dog diseases based on the information provided by dog owners. The primary goal is to assist pet owners, particularly those with Shih Tzus, Pomeranians, and Philippine native dogs, in identifying potential health issues early. By leveraging machine learning technology and data sourced from partnered veterinarians, the system aims to provide accurate, timely suggestions. Key features include symptom input analysis, disease prediction, and First Aid recommendations tailored to the specific needs of these dog breeds.'
                    ),

                    Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage('assets/images/dog-design1.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    aboutText(
                      text: 'Our team is dedicated to developing a system that predicts possible dog diseases based on the information provided by dog owners. The primary goal is to assist pet owners, particularly those with Shih Tzus, Pomeranians, and Philippine native dogs, in identifying potential health issues early. By leveraging machine learning technology and data sourced from partnered veterinarians, the system aims to provide accurate, timely suggestions. Key features include symptom input analysis, disease prediction, and First Aid recommendations tailored to the specific needs of these dog breeds.'
                    ),

                    SizedBox(height: 20.0),

                    aboutImage(
                      image: 'assets/images/banner2.png',
                        child: Container()
                    ),

                    SizedBox(height: 20.0),

                    aboutText(
                        text: 'Our target users are dog owners who seek a reliable, easy-to-use tool to monitor their pets\' health. The development team consists of skilled developers, researchers, and other contributors working collaboratively to ensure the system’s effectiveness. Our veterinary partners play a crucial role by providing expert data, which enhances the accuracy of our predictions. Data privacy is a top priority, with robust measures in place to protect user and pet information, ensuring compliance with data protection standards.'
                    ),

                    Container(
                      height: 240.0,
                      width: 240.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage('assets/images/dog-design2.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    aboutText(
                        text: 'While our system offers valuable support, it is currently limited to serving dog owners within our area (Upper Antipolo) and focuses only on Shih Tzus, Pomeranians, and Philippine native dogs. Additionally, our veterinary partnerships cover a range of specialties to address diverse client needs. We encourage dog owners to engage with our system, provide feedback, and collaborate with us as we continue to improve and expand. By working together, we can promote responsible pet care and enhance the well-being of our beloved canine companions.'
                    ),

                    SizedBox(height: 20.0),

                    aboutImage(
                      image: 'assets/images/banner3.png',
                      child: Container()
                    ),

                    SizedBox(height: 20.0),

                    aboutText(
                        text: 'This is our partnered veterinarians, with expertise in various fields, provide essential data and insights to enhance the accuracy of our system :'
                    ),

                    aboutList(text: 'Assumpta Dog & Cat Clinic'),
                    aboutList(text: 'Bethlehem Animal Clinic'),
                    aboutList(text: 'Home East Veterinary Clinic'),
                    aboutList(text: 'Margavet Animal Clinic'),
                    aboutList(text: 'PetLife Veterinary Clinic'),
                    aboutList(text: 'Prime PetS Veterinary Clinic'),
                    aboutList(text: 'Serbisyo Beterinaryo Animal Hospital'),
                    aboutList(text: 'Valenzuela Veterinary Clinic'),
                    aboutList(text: 'VetCare Animal Clinic and Grooming \nCenter'),

                    SizedBox(height: 20.0),

                    imageRow(
                      children: [
                        imageContainer(image: 'assets/images/vets/vet1.png'),
                        imageContainer(image: 'assets/images/vets/vet2.png'),
                        imageContainer(image: 'assets/images/vets/vet6.png'),
                      ],
                    ),

                    SizedBox(height: 20.0),

                    imageRow(
                      children: [
                        imageContainer(image: 'assets/images/vets/vet7.png'),
                        imageContainer(image: 'assets/images/vets/vet9.png'),
                        imageContainer(image: 'assets/images/vets/vet10.png'),
                      ],
                    ),

                    SizedBox(height: 20.0),

                    imageRow(
                      children: [
                        imageContainer(image: 'assets/images/vets/vet11.png'),
                        imageContainer(image: 'assets/images/vets/vet12.png'),
                        imageContainer(image: 'assets/images/vets/vet14.png'),
                      ],
                    ),

                    SizedBox(height: 40.0),

                    aboutText(
                        text: 'Our dedicated team of developers, researchers, and contributors work collaboratively to ensure the system delivers reliable support for responsible pet care : '
                    ),

                    aboutList(text: 'Acquiatan, Benjie'),
                    aboutList(text: 'Camila, Claire Ann C.'),
                    aboutList(text: 'Galsim, Christian D.'),
                    aboutList(text: 'Juanico, Vincent Jerry V.'),
                    aboutList(text: 'Nolasco, Criziel May N.'),

                    SizedBox(height: 20.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        imageTeam(image: 'assets/images/team/b.png'),
                        SizedBox(width: 30.0),
                        imageTeam(image: 'assets/images/team/a.png'),
                        SizedBox(width: 30.0),
                        imageTeam(image: 'assets/images/team/c.png'),
                      ],
                    ),

                    SizedBox(height: 20.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        imageTeam(image: 'assets/images/team/v.png'),
                        SizedBox(width: 30.0),
                        imageTeam(image: 'assets/images/team/n.png'),
                      ],
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
          ]
        ),
      ),
    );
  }
  Widget aboutImage({
    required String image,
    required Widget child
  }){
    return Stack(
      children: [
        Container(
          height: 210,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,),
          ),
          child: child,
        ),

        Container(
          height: 210,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0x00FFFFFF),
                Color(0x00FFFFFF),
                Color(0xFFFFFFFF),
              ],
              stops: [0.0, 0.2, 0.7, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget aboutText({
    required String text,
  }){
    return Container(
      padding: EdgeInsets.all(15.0),
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

  Widget aboutList({
    required String text
  }){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 20.0),
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
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
        )
      ],
    );
  }

  Widget imageRow({
    required List<Widget> children,
  }){
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children
    );
  }

  Widget imageContainer({
    required String image,
  }){
    return Container(
      height: 60.0,
      width: 60.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,),
      ),
    );
  }

  Widget imageTeam({
    required String image,
  }){
    return Container(
      height: 60.0,
      width: 60.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,),
      ),
    );
  }
}
