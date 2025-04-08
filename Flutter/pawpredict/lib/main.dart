import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawpredict/pages/about.dart';
import 'package:pawpredict/pages/all-vet-map.dart';
import 'package:pawpredict/pages/dog-information.dart';
import 'package:pawpredict/pages/dog-symptoms1.dart';
import 'package:pawpredict/pages/dog-symptoms2.dart';
import 'package:pawpredict/pages/findings.dart';
import 'package:pawpredict/pages/help-center.dart';
import 'package:pawpredict/pages/home.dart';
import 'package:pawpredict/pages/landing.dart';
import 'package:pawpredict/pages/loading.dart';
import 'package:pawpredict/pages/map.dart';
import 'package:pawpredict/pages/tutorials-guides.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/' : (context) => Landing(),
      '/home' : (context) => Home(),
      '/about' : (context) => About(),
      '/help' : (context) => HelpCenter(),
      '/tutorials-guides' : (context) => TutorialsGuides(),

      '/loading' : (context) => Loading(),

      '/dog-information' : (context) => DogInformation(),
      '/dog-symptoms1' : (context) => DogSymptoms1(),
      '/dog-symptoms2' : (context) => DogSymptoms2(),
      '/findings' : (context) => Findings(),

      '/vet-map' : (context) => VetMap(),
      '/all-vet-map' : (context) => AllVetClinic(),


    },
  ));
}
