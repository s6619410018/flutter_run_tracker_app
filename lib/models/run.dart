class Run {
  int? id;
  String? createdAt;
  String runWhere;
  String runPerson;
  String runDistance;

  Run({
    this.id,
    this.createdAt,
    required this.runWhere,
    required this.runPerson,
    required this.runDistance,
  });

  // 1. ฟังก์ชันแปลงจาก JSON (Map) ที่ได้จาก Supabase มาเป็น Object ของ Run
  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      id: json['id'],
      createdAt:
          json['created_at'], // ตรวจสอบชื่อคอลัมน์ใน Supabase ว่าเป็น created_at หรือ created_id
      runWhere: json['runWhere'] ?? '',
      runPerson: json['runPerson'] ?? '',
      runDistance: json['runDistance']?.toString() ?? '0',
    );
  }

  // 2. ฟังก์ชันแปลงจาก Object ของ Run กลับไปเป็น JSON (Map) เพื่อส่งไปเก็บใน Supabase
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'runWhere': runWhere,
      'runPerson': runPerson,
      'runDistance': runDistance,
    };
  }
}
