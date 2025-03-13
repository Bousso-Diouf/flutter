import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CityDetailScreen extends StatelessWidget {
  final String city;
  final double temperature;
  final String cloudCoverage;
  final double? latitude;
  final double? longitude;

  CityDetailScreen({
    required this.city,
    required this.temperature,
    required this.cloudCoverage,
    this.latitude,
    this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    // Valeurs par défaut pour latitude et longitude
    double finalLatitude = latitude ?? 14.6928; // Dakar par défaut
    double finalLongitude = longitude ?? -17.4467; // Dakar par défaut

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de $city'),
      ),
      body: Column(
        children: [
          // Affichage des infos météo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🌆 Ville: $city',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '🌡️ Température: $temperature°C',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '☁️ Couverture nuageuse: $cloudCoverage',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Affichage de la carte Google Maps
          Expanded(
            child: buildMap(finalLatitude, finalLongitude, city),
          ),
        ],
      ),
    );
  }

  Widget buildMap(double latitude, double longitude, String city) {
    try {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 12,
        ),
        markers: {
          Marker(
            markerId: MarkerId(city),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: city),
          ),
        },
      );
    } catch (e) {
      // En cas d'erreur, affichez un message à l'utilisateur
      return Center(
        child: Text(
          "Erreur lors du chargement de la carte.",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
    }
  }
}