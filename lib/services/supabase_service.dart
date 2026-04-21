import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final _client = Supabase.instance.client;

  // ดึงข้อมูล (Read)
  static Stream<List<Map<String, dynamic>>> getRunStream() {
    return _client.from('run_tb').stream(primaryKey: ['id']).order('id');
  }

  // เพิ่มข้อมูล (Create)
  static Future<void> insertRun(Map<String, dynamic> data) async {
    await _client.from('run_tb').insert(data);
  }

  // แก้ไขข้อมูล (Update)
  static Future<void> updateRun(int id, Map<String, dynamic> data) async {
    await _client.from('run_tb').update(data).eq('id', id);
  }

  // ลบข้อมูล (Delete)
  static Future<void> deleteRun(int id) async {
    await _client.from('run_tb').delete().eq('id', id);
  }
}
