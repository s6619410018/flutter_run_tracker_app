import 'package:flutter/material.dart';
import 'package:flutter_run_tracker_app/views/show_all_run_ui.dart'; // เปลี่ยนตามชื่อไฟล์หน้าหลักของคุณ

class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  void initState() {
    // หน่วงเวลา 3 วินาทีแล้วเปลี่ยนหน้าไปที่ ShowAllRunUi
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ShowAllRunUi()),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ใช้สีน้ำเงินเข้มตามธีมของ Run Tracker ในรูปภาพ
      backgroundColor: const Color.fromARGB(255, 84, 86, 87),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // แสดงโลโก้ของแอป
            Image.asset(
              'assets/images/logo.png', // ตรวจสอบว่าชื่อไฟล์ตรงกับใน assets
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            // ชื่อแอป (ถ้าในรูปมีข้อความใต้โลโก้)
            const Text(
              'RUN TRACKER',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 30),
            // ตัวโหลดวงกลมสีขาวเพื่อให้เข้ากับพื้นหลังเข้ม
            const CircularProgressIndicator(
              color: Color.fromARGB(255, 11, 11, 11),
            ),
            const SizedBox(height: 20),
            const Text(
              'Created by: Panisara',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
