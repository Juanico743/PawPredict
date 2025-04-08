import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:pawpredict/services/global.dart';
import 'package:pawpredict/services/osrm.dart';

class AllVetClinic extends StatefulWidget {
  const AllVetClinic({super.key});

  @override
  State<AllVetClinic> createState() => _AllVetClinicState();
}

class _AllVetClinicState extends State<AllVetClinic> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  LatLng? lastUserPosition;
  List<dynamic>? vetClinics;
  List<LatLng> locations = [];
  Set<Polyline> _polylines = {};
  Set<Marker> markers = {};

  BitmapDescriptor? userPinIcon;
  BitmapDescriptor? vetPinIcon;

  LatLng? currentUserPosition;
  bool _routeFetched = false;

  bool shortcutVisible = false;
  bool polylineVisible = true;
  bool pinInfoVisible = false;

  String selectedVetLogo = '';
  List<String> vetNameList = [];
  String selectedVetName = '';

  String _availability = "";
  String _regularHours = "";
  String _emergencyHours = "";




  @override
  void initState() {
    super.initState();
    loadVetsList();
    loadCustomMarkers().then((_) {
      _loadData();
    });
  }


  Future<void> _loadData() async {
    await loadVeterinaryClinics();
    await getAllPinLocation(vetClinics!);

    while (currentUserPosition == null) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setMarkers();
  }

  Future<void> loadVetsList() async {
    try {
      String uri = '$serverUri/api/getvetnames/';

      var res = await http.get(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
      );

      var response = jsonDecode(res.body);

      if (response["success"] == true) {
        setState(() {
          vetNameList = List<String>.from(response["vetlist"]);
        });
      } else {
      }
    } catch(e) {
      print(e);
    }

  }


  Future<void> loadCustomMarkers() async {
    userPinIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      "assets/images/markers/user-location-pin.png",
    );

    vetPinIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      "assets/images/markers/vet-location-pin.png",
    );

    setState(() {});
  }

  Future<void> loadVeterinaryClinics() async {
    try {
      String uri = '$serverUri/api/requestVeterinarianData/';
      var res = await http.get(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
      );

      var response = jsonDecode(res.body);

      if (response["success"] == true) {
        setState(() {
          vetClinics = response["vet_clinics"];
        });
      }
    } catch (e) {
      print("Error loading vet clinics: $e");
    }
  }

  Future<void> getAllPinLocation(List<dynamic> vetClinics) async {
    locations.clear();
    for (var clinic in vetClinics) {
      LatLng pinLocation = LatLng(
        clinic['info'][0]['latitude'],
        clinic['info'][0]['longitude'],
      );
      locations.add(pinLocation);
    }
    getLocationUpdates();
  }

  Future<void> setMarkers() async {
    if (userPinIcon == null || vetPinIcon == null || currentUserPosition == null) {
      print("Markers or user position not ready yet");
      return;
    }

    setState(() {
      markers.clear();

      markers.add(
        Marker(
          markerId: const MarkerId("userlocation"),
          icon: userPinIcon!,
          position: currentUserPosition!,
          onTap: () {
            print('Its Me');
          },
        ),
      );

      for (var i = 0; i < locations.length; i++) {
        markers.add(
          Marker(
            markerId: MarkerId("vet$i"),
            position: locations[i],
            icon: vetPinIcon!,
            onTap: () {
              setState(() {
                _getPolylines(currentUserPosition!, locations[i]);
                pinInfoVisible = false;
              });

              Future.delayed(Duration(milliseconds: 250), () {
                setState(() {
                  _availability = vetClinics?[i]['info'][0]['availability'];
                  _regularHours = vetClinics?[i]['info'][0]['regular_hours'];
                  _emergencyHours = vetClinics?[i]['info'][0]['emergency_hours'];
                  selectedVetLogo = 'assets/images/vets/vet${i + 1}.png';
                  selectedVetName = vetNameList[i];
                  pinInfoVisible = true;
                });
              });
            },
          ),
        );
      }
    });
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        LatLng newPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);

        if (lastUserPosition != null) {
          double distance = Geolocator.distanceBetween(
              lastUserPosition!.latitude, lastUserPosition!.longitude,
              newPosition.latitude, newPosition.longitude);
          if (distance >= 100) {
            if (mounted) {
              setState(() {
                currentUserPosition = newPosition;
                _cameraToPosition(currentUserPosition!);
              });
            }
            if (!_routeFetched) {
              _getRoute().then((_) => {
                _routeFetched = true,
              });
            }
            lastUserPosition = newPosition;
          }
        } else {
          lastUserPosition = newPosition;
          if (mounted) {
            setState(() {
              currentUserPosition = newPosition;
              _cameraToPosition(currentUserPosition!);
            });
          }
          if (!_routeFetched) {
            _getRoute().then((_) => {
              _routeFetched = true,
            });
          }
        }
      }
    });
  }

  Future<void> _getRoute() async {
    if (currentUserPosition == null) return;

    double shortestDistance = double.infinity;
    LatLng nearestDestination = locations[0];


    for (LatLng locations in locations) {
      double distance = await OSRMService.getTravelDistance(currentUserPosition!, locations);
      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestDestination = locations;
      }
    }

    _getPolylines(currentUserPosition!, nearestDestination);
  }

  Future<void> _getPolylines(LatLng location1, LatLng location2) async {
    try {
      List<LatLng> routePoints = await OSRMService.getRouteCoordinates(location1, location2);

      if (mounted) {
        setState(() {
          _polylines.clear();
          _polylines.add(Polyline(
            polylineId: PolylineId("route"),
            points: routePoints,
            color: Colors.black54,
            width: 5,
          ));
        });
      }
    } catch (e) {
      debugPrint("Error fetching polylines: $e");
    }
  }


  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 14,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(14.585834572680904, 121.17598455464173),
              zoom: 13,
            ),
            markers: markers,
            polylines: (polylineVisible) ? _polylines : {},
            onTap: (LatLng position) {
              setState(() {
                pinInfoVisible = false;
              });
            },
          ),

          Positioned(
            bottom: 40,
            left: 20,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      shortcutVisible = !shortcutVisible;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Color(0xFF1DCFC1),
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
                      child: AnimatedRotation(
                        duration: Duration(milliseconds: 300),
                        turns: shortcutVisible ? 0.5 : 0,
                        child: Image.asset(
                          'assets/images/icons/arrow-map.png',
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: shortcutVisible
                      ? Column(
                    children: [
                      SizedBox(height: 5),
                      buildShortcutButton(
                          imagePath: 'assets/images/icons/target-p.png',
                          onTap: (){
                            _cameraToPosition(currentUserPosition!);
                          }
                      ),
                      SizedBox(height: 5),
                      buildShortcutButton(
                          imagePath: 'assets/images/icons/route-p.png',
                          onTap: (){
                            setState(() {
                              polylineVisible = !polylineVisible;
                            });
                          }
                      ),
                      SizedBox(height: 5),
                      buildShortcutButton(
                          imagePath: 'assets/images/icons/logout-p.png',
                          onTap: (){
                            Navigator.pop(context);
                          }
                      ),
                    ],
                  )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            top: pinInfoVisible ? 0 : -300,
            right: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
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
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
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
                      child: Column(
                        children: [
                          Row(
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
                                    _availability,
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
                          Row(
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
                                _regularHours,
                                style: TextStyle(
                                  color: Color(0xFF4A6FD7),
                                  fontFamily:'Lexend',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
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
                                _emergencyHours,
                                style: TextStyle(
                                  color: Color(0xFF4A6FD7),
                                  fontFamily:'Lexend',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF1DCFC1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        selectedVetName,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),



          (!_routeFetched)
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
                        "assets/animations/loading-map.json",
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

  Widget buildShortcutButton({
    required String imagePath,
    required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
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
          child: Image.asset(
            imagePath,
            height: 25,
            width: 25,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
