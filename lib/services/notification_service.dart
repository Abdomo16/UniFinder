/// Placeholder notification service.
///
/// Replace the body of each method with your preferred push-notification
/// implementation (e.g. firebase_messaging or supabase realtime).
class NotificationService {
  NotificationService._();

  static Future<void> initialize() async {
    // TODO: initialize push notification plugin
  }

  static Future<void> scheduleDeadlineReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    // TODO: schedule local notification
  }

  static Future<void> cancelAll() async {
    // TODO: cancel all scheduled notifications
  }
}
