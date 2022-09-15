class Student {
  late int rollNo;
  late String name;
  late double fee;

  static const String tableName = 'Student';
  static const String keyRollNo = 'rollNo';
  static const String keyName = 'name';
  static const String keyFee = 'fee';
  static const String createTable =
      'CREATE TABLE $tableName($keyRollNo INTEGER PRIMARY KEY,$keyName TEXT,$keyFee REAL)';

  Student({
    required this.rollNo,
    required this.name,
    required this.fee,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
        rollNo: map[keyRollNo], name: map[keyName], fee: map[keyFee]);
  }
  Map<String, dynamic> toMap() {
    return {
      keyRollNo: rollNo,
      keyName: name,
      keyFee: fee,
    };
  }
}
