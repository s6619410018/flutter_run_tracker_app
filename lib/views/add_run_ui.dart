// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddRunUi extends StatefulWidget {
  const AddRunUi({super.key});

  @override
  State<AddRunUi> createState() => _AddRunUiState();
}

class _AddRunUiState extends State<AddRunUi> {
  final _formKey = GlobalKey<FormState>();

  // Controller สำหรับรับค่าจาก TextField
  final TextEditingController _whereController = TextEditingController();
  final TextEditingController _whoController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();

  File? _image;

  // ฟังก์ชันสำหรับเปิดกล้องถ่ายภาพ
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // ฟังก์ชันบันทึกข้อมูลลง Supabase
  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // แก้ไข: เปลี่ยนชื่อตารางจาก 'run_db' เป็น 'run_tb' ให้ตรงกับ Database
        await Supabase.instance.client.from('run_tb').insert({
          'runWhere': _whereController.text,
          'runPerson': _whoController.text,
          'runDistence':
              _distanceController.text, // ตรวจสอบชื่อคอลัมน์ให้ตรงเป๊ะ
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('บันทึกข้อมูลสำเร็จ!'),
              backgroundColor: Colors.green,
            ),
          );
          // แก้ไข: ส่งค่า true กลับไปเพื่อให้หน้าหลักอัปเดตข้อมูลทันที
          Navigator.pop(context, true);
        }
      } catch (e) {
        // แสดง Error ที่เกิดขึ้นจริงเพื่อให้แก้ไขได้ง่าย
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // เพิ่มสีพื้นหลังตามที่ต้องการตรงนี้ครับ
      backgroundColor: const Color.fromARGB(255, 141, 141, 143),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 50, 50),
        title: const Text(
          'Run Tracker (เพิ่มข้อมูล)',
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
              // ส่วนของการถ่ายภาพ (แก้ไขขนาดรูปให้เหมือนกับหน้า Show)
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: AspectRatio(
                    aspectRatio: 2 / 1, // ปรับสัดส่วนให้เหมือนหน้า Show
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: _image == null
                            ? Image.asset(
                                'assets/images/runn.png', // เปลี่ยนเป็นรูปวิ่งให้เหมือนหน้า Show
                                fit: BoxFit.contain,
                              )
                            : Image.file(_image!, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'วิ่งที่ไหน',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 15, 15, 15),
                ),
              ),
              TextFormField(
                controller: _whereController,
                style: const TextStyle(color: Color.fromARGB(255, 11, 11, 11)),
                decoration: const InputDecoration(
                  hintText: 'เช่น สวนสาธารณะ, สนามกีฬา หรือ อื่นๆ',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 14, 14, 14)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
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
                  color: Color.fromARGB(255, 9, 9, 9),
                ),
              ),
              TextFormField(
                controller: _whoController,
                style: const TextStyle(color: Color.fromARGB(255, 13, 13, 13)),
                decoration: const InputDecoration(
                  hintText: 'เช่น เพื่อน 3 คน, แฟน หรือ อื่นๆ',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
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
                  color: Color.fromARGB(255, 16, 15, 15),
                ),
              ),
              TextFormField(
                controller: _distanceController,
                style: const TextStyle(color: Color.fromARGB(255, 5, 5, 5)),
                keyboardType: TextInputType.number, // บังคับคีย์บอร์ดตัวเลข
                decoration: const InputDecoration(
                  hintText: 'เช่น 1, 5, 11 หรือ อื่นๆ',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 14, 14, 14)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกระยะทาง' : null,
              ),
              const SizedBox(height: 30),

              // ปุ่มบันทึกข้อมูล
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'บันทึกข้อมูล',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ปุ่มยกเลิก
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF44336),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ยกเลิก',
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
