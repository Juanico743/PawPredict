import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:pawpredict/services/global.dart';
import 'package:pawpredict/services/osrm.dart';

class VetMap extends StatefulWidget {
  const VetMap({super.key});

  @override
  State<VetMap> createState() => _VetMapState();
}

class _VetMapState extends State<VetMap> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  LatLng? lastUserPosition;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  BitmapDescriptor? userPinIcon;
  BitmapDescriptor? vetPinIcon;

  LatLng selectedVet = LatLng(vetPinLocationLat, vetPinLocationLon);
  LatLng? currentUserPosition;
  bool _routeFetched = false;

  bool shortcutVisible = false;
  bool polylineVisible = true;

  @override
  void initState() {
    super.initState();
    loadCustomMarkers();
    getLocationUpdates();
  }

  Future<void> loadCustomMarkers() async {
    userPinIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      "assets/images/markers/user-location-pin.png",
    );
    vetPinIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      "assets/images/markers/vet-location-pin.png",
    );
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
                _routeFetched = true
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
              _routeFetched = true
            });
          }
        }
      }
    });
  }

  Future<void> _getRoute() async {
    if (currentUserPosition == null) return;

    List<LatLng> destinations = [
      selectedVet
    ];

    double shortestDistance = double.infinity;
    LatLng nearestDestination = destinations[0];

    for (LatLng destination in destinations) {
      double distance = await OSRMService.getTravelDistance(currentUserPosition!, destination);
      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestDestination = destination;
      }
    }

    List<LatLng> routePoints = await OSRMService.getRouteCoordinates(currentUserPosition!, nearestDestination);

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
              target: selectedVet ?? LatLng(0, 0),
              zoom: 16,
            ),
            polylines: (polylineVisible) ? _polylines : {},
            markers: {
              if (vetPinIcon != null)
                Marker(
                  markerId: MarkerId("selectedVet"),
                  icon: vetPinIcon!,
                  position: selectedVet,
                ),
              if (currentUserPosition != null)
                Marker(
                  markerId: MarkerId("userlocation"),
                  icon: userPinIcon ?? BitmapDescriptor.defaultMarker,
                  position: currentUserPosition!,
                ),
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


          Positioned(
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

                  if (singleVetAvailability.isNotEmpty || singleVetRegularHours.isNotEmpty || singleVetEmergencyHours.isNotEmpty)
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
                          if (singleVetAvailability.isNotEmpty)
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
                                      singleVetAvailability,
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

                          if (singleVetRegularHours.isNotEmpty)
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
                                  singleVetRegularHours,
                                  style: TextStyle(
                                    color: Color(0xFF4A6FD7),
                                    fontFamily:'Lexend',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),

                          if (singleVetEmergencyHours.isNotEmpty)
                            SizedBox(height: 5.0),
                          if (singleVetEmergencyHours.isNotEmpty)
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
                                  singleVetEmergencyHours,
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
                        singleVetName,
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

            // child: Container(
            //   height: 100,
            //   width: 300,
            //   decoration: BoxDecoration(
            //     color: Color(0xFF1DCFC1),
            //     borderRadius: BorderRadius.only(
            //       topRight: Radius.circular(0.0),
            //       topLeft: Radius.circular(50.0),
            //       bottomRight: Radius.circular(0.0),
            //       bottomLeft: Radius.circular(50.0),
            //     ),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.2),
            //         spreadRadius: 2,
            //         blurRadius: 2,
            //         offset: Offset(0, 2),
            //       ),
            //     ],
            //   ),
            //   child: Row(
            //     children: [
            //       Container(
            //         margin: EdgeInsets.all(10),
            //         height: 70.0,
            //         width: 70.0,
            //         decoration:BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(100.0),
            //         ),
            //         child: Container(
            //           margin: EdgeInsets.all(10),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(10.0),
            //             image: DecorationImage(
            //               image: AssetImage(singleVetImage.isNotEmpty ? singleVetImage : "assets/images/vets/vet-no-logo.png",),
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 10.0),
            //       Expanded(
            //         child: Container(
            //           child: Text(
            //             singleVetName,
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontFamily: 'Lexend',
            //               fontWeight: FontWeight.w700,
            //               fontSize: 18.0,
            //             ),
            //             softWrap: true,
            //             overflow: TextOverflow.visible,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
