// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_run_tracker_app/views/add_run_ui.dart';
import 'package:flutter_run_tracker_app/views/update_delete_run_ui.dart';

class ShowAllRunUi extends StatefulWidget {
  const ShowAllRunUi({super.key});

  @override
  State<ShowAllRunUi> createState() => _ShowAllRunUiState();
}

class _ShowAllRunUiState extends State<ShowAllRunUi> {
  // ย้าย Stream ออกจากตรงนี้ (เพื่อความชัวร์)

  @override
  Widget build(BuildContext context) {
    // --- จุดสำคัญ: ให้สร้าง Stream ตรงนี้ เพื่อให้มันเริ่มฟังข้อมูลใหม่ทุกครั้งที่เรียก build ---
    final runStream = Supabase.instance.client
        .from('run_tb')
        .stream(primaryKey: ['id'])
        .order('id', ascending: false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 141, 141, 143),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 50, 50),
        title: const Text(
          'Run Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRunUi()),
          );
          // เมื่อกลับมา ให้สั่ง setState เพื่อให้ build() ทำงานใหม่และสร้าง Stream ใหม่
          if (res == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: AspectRatio(
              aspectRatio: 2 / 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/runn.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: runStream, // ใช้ stream ตัวใหม่ที่สร้างใน build
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(
                    child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                  );

                // ลองเช็คสถานะการเชื่อมต่อ
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());

                final data = snapshot.data ?? [];
                if (data.isEmpty)
                  return const Center(child: Text('ยังไม่มีข้อมูลการวิ่ง'));

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      color: const Color.fromARGB(255, 128, 130, 132),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          'วิ่งที่ไหน: ${item['runWhere']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'วิ่งกับใคร: ${item['runPerson']}\nระยะทาง: ${item['runDistence'] ?? '0'} กม.',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.info, color: Colors.red),
                          onPressed: () async {
                            final res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UpdateDeleteRunUi(runData: item),
                              ),
                            );
                            // เมื่อกลับมาจากการแก้ไข/ลบ ให้สั่ง setState
                            if (res == true) {
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
