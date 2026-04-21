import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_run_tracker_app/views/splash_screen_ui.dart';

Future<void> main() async {
  // 1. ตรวจสอบการเชื่อมต่อ Binding ของ Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. เริ่มต้น Supabase (แนะนำให้ใส่ไว้ใน try-catch เพื่อป้องกันแอปค้างถ้าเน็ตมีปัญหา)
  try {
    await Supabase.initialize(
      url: 'https://eamtktlxbddenrrvwzmw.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVhbXRrdGx4YmRkZW5ycnZ3em13Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY2NjkwMTAsImV4cCI6MjA5MjI0NTAxMH0.xWxw6jxJbWxOPFfotnUN-Omvb1I8Yx4XrcQ0ZgANeD0',
    );
  } catch (e) {
    debugPrint('Supabase Initialization Error: $e');
  }

  runApp(const FlutterRunTrackerApp());
}

class FlutterRunTrackerApp extends StatelessWidget {
  const FlutterRunTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Run Tracker App',

      // Theme Configuration
      theme: ThemeData(
        useMaterial3: true,
        // ใช้โทนสีน้ำเงินเข้มตามรูป UI ที่ส่งมา
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D1B2A),
          brightness: Brightness.light,
        ),
        // ตั้งค่าฟอนต์ Prompt เป็น Default ของแอป
        textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme),
      ),

      // หน้าแรกของแอป
      home: const SplashScreenUi(),
    );
  }
}
