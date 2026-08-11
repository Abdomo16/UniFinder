import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper around the Supabase client.
class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;

  static String? get currentUserId => client.auth.currentUser?.id;
}
