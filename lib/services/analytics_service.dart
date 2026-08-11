/// Placeholder analytics service.
///
/// Wire up your analytics provider (e.g. Firebase Analytics,
/// Mixpanel, Supabase custom event table) inside each method.
class AnalyticsService {
  AnalyticsService._();

  static Future<void> logEvent(
    String name, {
    Map<String, Object>? params,
  }) async {
    // TODO: forward to analytics provider
    assert(() {
      // ignore: avoid_print
      print('[Analytics] $name | $params');
      return true;
    }());
  }

  static Future<void> setUserId(String userId) async {
    // TODO: set user id on analytics provider
  }
}
