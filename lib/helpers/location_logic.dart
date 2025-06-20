import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationHelper {
  static Future<String> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return "Location permission denied.";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return "Location permission permanently denied.";
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.name}, ${place.locality}, ${place.administrativeArea}";
      } else {
        return "Lat: ${position.latitude}, Long: ${position.longitude}";
      }
    } catch (e) {
      return "Error getting location: $e";
    }
  }
}
