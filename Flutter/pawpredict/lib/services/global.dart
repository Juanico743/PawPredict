library globals;

String serverUri = "http://192.168.87.133:8000";
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

List<int> finalDatasetAnswer = List.filled(193, 0);
List<int> datasetCopy = List.filled(193, 0);

Future<void> resetDataset() async {
  finalDatasetAnswer = List.filled(193, 0);
}


String theDogsName = '';