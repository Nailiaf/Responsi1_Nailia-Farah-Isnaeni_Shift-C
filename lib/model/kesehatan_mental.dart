class KesehatanMental {
  int? id;
  String? mentalState; // Menggunakan camel case untuk konsistensi penamaan
  int? therapySessions;
  String? medication;

  KesehatanMental({
    this.id,
    this.mentalState,
    this.therapySessions,
    this.medication,
  });

  factory KesehatanMental.fromJson(Map<String, dynamic> obj) {
    return KesehatanMental(
      id: obj['id'] is String ? int.tryParse(obj['id']) : obj['id'],
      mentalState: obj['mental_state'],
      therapySessions: obj['therapy_sessions'],
      medication: obj['medication'],
    );
  }

  // Menyediakan metode untuk mengubah objek ke dalam format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mental_state': mentalState,
      'therapy_sessions': therapySessions,
      'medication': medication,
    };
  }
}
