/// Placeholder location service.
///
/// Add `geolocator` to pubspec.yaml and replace the method body
/// when you're ready to use real device location.
class LocationService {
  LocationService._();

  /// Returns the current location as a `"lat,lon"` string,
  /// or null if permission is denied or the plugin is not yet configured.
  static Future<String?> getCurrentLocationString() async {
    // TODO: add geolocator to pubspec.yaml and implement
    return null;
  }
}
