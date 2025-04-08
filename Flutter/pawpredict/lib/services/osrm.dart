import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OSRMService {
  static Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng end) async {
    String url = "https://router.project-osrm.org/route/v1/driving/"
        "${start.longitude},${start.latitude};"
        "${end.longitude},${end.latitude}"
        "?overview=full&geometries=geojson";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List coordinates = data['routes'][0]['geometry']['coordinates'];

      return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
    } else {
      throw Exception("Failed to load route");
    }
  }


  static Future<double> getTravelDistance(LatLng start, LatLng end) async {
    final response = await http.get(Uri.parse(
        "http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=false"
    ));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      double distance = data["routes"][0]["distance"] / 1000; // Convert meters to km
      return distance;
    } else {
      throw Exception("Failed to fetch route distance");
    }
  }
}
