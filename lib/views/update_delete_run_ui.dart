// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateDeleteRunUi extends StatefulWidget {
  final Map<String, dynamic> runData;

  const UpdateDeleteRunUi({super.key, required this.runData});

  @override
  State<UpdateDeleteRunUi> createState() => _UpdateDeleteRunUiState();
}

class _UpdateDeleteRunUiState extends State<UpdateDeleteRunUi> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _whereController;
  late TextEditingController _whoController;
  late TextEditingController _distanceController;

  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลมาแสดงผลใน TextField
    _whereController = TextEditingController(
      text: widget.runData['runWhere']?.toString() ?? '',
    );
    _whoController = TextEditingController(
      text: widget.runData['runPerson']?.toString() ?? '',
    );

    // แก้ไข: ดึงค่า runDistence ให้ตรงกับชื่อคอลัมน์ในฐานข้อมูล (ตามที่คุณระบุ)
    _distanceController = TextEditingController(
      text: widget.runData['runDistence']?.toString() ?? '',
    );
  }

  // ฟังก์ชันแก้ไขข้อมูล (Update)
  Future<void> _updateData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // แก้ไข: เปลี่ยนชื่อตารางเป็น 'run_tb'
        await Supabase.instance.client
            .from('run_tb')
            .update({
              'runWhere': _whereController.text,
              'runPerson': _whoController.text,
              'runDistence': _distanceController.text,
            })
            .eq('id', widget.runData['id']);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('แก้ไขข้อมูลสำเร็จ!'),
              backgroundColor: Colors.green,
            ),
          );
          // ส่งค่า true กลับไปเพื่อให้หน้าหลักอัปเดตข้อมูลทันที
          Navigator.pop(context, true);
        }
      } catch (e) {
        debugPrint('Error updating: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ฟังก์ชันลบข้อมูล (Delete)
  Future<void> _deleteData() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณต้องการลบข้อมูลการวิ่งนี้ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // แก้ไข: เปลี่ยนชื่อตารางเป็น 'run_tb'
                await Supabase.instance.client
                    .from('run_tb')
                    .delete()
                    .eq('id', widget.runData['id']);

                if (mounted) {
                  Navigator.pop(context); // ปิด Dialog
                  // ส่งค่า true กลับไปเพื่อให้หน้าหลักอัปเดตข้อมูลทันที
                  Navigator.pop(context, true);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                debugPrint('Error deleting: $e');
              }
            },
            child: const Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. ปรับสีพื้นหลังของหน้าจอเป็นสีเทาเข้ม
      backgroundColor: const Color.fromARGB(255, 141, 141, 143),
      appBar: AppBar(
        // ปรับสี App Bar ให้เข้ากับพื้นหลังใหม่
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
        title: const Text(
          'Run Tracker (แก้ไข/ลบ)',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. ปรับแก้ไขรูปภาพให้เหมือนกับหน้า Show (ใช้ AspectRatio และ contain)
              Center(
                child: AspectRatio(
                  aspectRatio: 2 / 1, // ปรับสัดส่วนให้เหมือนหน้า Show
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // พื้นหลังสีขาวเผื่อรูปไม่เต็มขอบ
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/runn.png',
                        ), // เปลี่ยนเป็นรูปวิ่ง
                        fit: BoxFit
                            .contain, // ใช้ contain เพื่อให้เห็นรูปทั้งหมดครบถ้วน
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ปรับสีหัวข้อ (Text) และช่องกรอก (TextField) ให้เข้ากับพื้นหลังสีเข้ม
              const Text(
                'วิ่งที่ไหน',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextFormField(
                controller: _whereController,
                style: const TextStyle(
                  color: Colors.white,
                ), // สีตัวหนังสือด้านใน
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54), // สีขอบปกติ
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ), // สีขอบตอนกดเลือก
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกสถานที่' : null,
              ),
              const SizedBox(height: 15),
              const Text(
                'วิ่งกับใคร',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextFormField(
                controller: _whoController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกข้อมูล' : null,
              ),
              const SizedBox(height: 15),
              const Text(
                'ระยะทาง (กม.)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextFormField(
                controller: _distanceController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกระยะทาง' : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'บันทึกการแก้ไขข้อมูล',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _deleteData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF44336),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ลบข้อมูล',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
