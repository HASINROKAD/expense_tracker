import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth {
  static SupabaseClient? instance;

  static SupabaseClient client() {
    final supabase = Supabase.instance.client;

    return supabase;
  }
}
