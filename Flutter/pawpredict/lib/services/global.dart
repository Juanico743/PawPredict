library globals;

String serverUri = "http://192.168.1.7:8000";
const String googleMapAPI = "AIzaSyC4O5JIbDyCnarQiUc0eQmhbQwel186NHw";

String? currentPage = '';
String? currentPageTitle= '';

double vetPinLocationLat = 0;
double vetPinLocationLon = 0;

String singleVetImage = '';
String singleVetName = '';

String singleVetAvailability = '';
String singleVetRegularHours = '';
String singleVetEmergencyHours = '';


List<int> lineupQuestion = [];
List<int> finalSelection = [];

//93 symptoms
List<int> finalDatasetAnswer = List.filled(193, 0);

Future<void> resetDataset() async {
  finalDatasetAnswer = List.filled(193, 0);
}