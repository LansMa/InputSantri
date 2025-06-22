class Izin {
  final int? id;
  final String nama;
  final String kamar;
  final String tujuan;
  final String tanggal;
  final String status;

  Izin({
    this.id,
    required this.nama,
    required this.kamar,
    required this.tujuan,
    required this.tanggal,
    required this.status,
  });

  factory Izin.fromMap(Map<String, dynamic> map) {
    return Izin(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      kamar: map['kamar'] as String,
      tujuan: map['tujuan'] as String,
      tanggal: map['tanggal'] as String,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'kamar': kamar,
      'tujuan': tujuan,
      'tanggal': tanggal,
      'status': status,
    };
  }

  /// ⬇️ Tambahan: khusus untuk insert ke Supabase (tanpa `id`)
  Map<String, dynamic> toInsertMap() {
    return {
      'nama': nama,
      'kamar': kamar,
      'tujuan': tujuan,
      'tanggal': tanggal,
      'status': status,
    };
  }
}
